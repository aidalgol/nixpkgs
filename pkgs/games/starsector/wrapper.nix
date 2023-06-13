{ lib
, stdenv
, starsector-unwrapped
, bubblewrap
, runCommandLocal
, writeShellScriptBin
, makeWrapper
, openjdk
, xorg
, openal

, enableBubblewrap ? lib.meta.availableOn stdenv.hostPlatform bubblewrap
}:

let
  buildInputs = [ xorg.libXxf86vm openal ];
in
if enableBubblewrap then
  writeShellScriptBin "starsector" ''
    # Passthrough
    # Ref: https://github.com/NixOS/nixpkgs/blob/5e871d8aa6f57cc8e0dc087d1c5013f6e212b4ce/pkgs/build-support/build-fhsenv-bubblewrap/default.nix#L170
    args=()
    if [[ "$DISPLAY" == :* ]]; then
        local_socket="/tmp/.X11-unix/X''${DISPLAY#?}"
        args+=(--ro-bind-try "$local_socket" "$local_socket")
    fi
    if [[ "$WAYLAND_DISPLAY" = /* ]]; then
        args+=(--ro-bind-try "$WAYLAND_DISPLAY" "$WAYLAND_DISPLAY")
    elif [[ -n "$WAYLAND_DISPLAY" ]]; then
        args+=(--ro-bind-try "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "/tmp/$WAYLAND_DISPLAY")
    fi

    args+=(
      --setenv PATH ${lib.makeBinPath [ openjdk ]}
      --setenv LD_LIBRARY_PATH ${lib.makeLibraryPath buildInputs}
      --chdir "${starsector-unwrapped}/share/starsector"
      --tmpfs /tmp/.X11-unix

      --unshare-user
      --unshare-ipc
      --unshare-pid
      --unshare-uts
      --unshare-cgroup
      --die-with-parent

      --dev /dev
      --proc /proc
      --ro-bind /nix /nix
      --ro-bind /etc /etc
      --tmpfs /tmp

      # Mesa & OpenGL
      --ro-bind /run/opengl-driver /run/opengl-driver
      --dev-bind-try /dev/dri /dev/dri
      --ro-bind-try /sys/class /sys/class
      --ro-bind-try /sys/dev/char /sys/dev/char
      --ro-bind-try /sys/devices/pci0000:00 /sys/devices/pci0000:00
      --ro-bind-try /sys/devices/system/cpu /sys/devices/system/cpu

      # Audio
      --setenv XDG_RUNTIME_DIR /tmp
      --ro-bind-try "$XDG_RUNTIME_DIR/pulse" /tmp/pulse
      --ro-bind-try "$XDG_RUNTIME_DIR/pipewire-0" /tmp/pipewire-0

      # Data storage
      --bind "''${XDG_DATA_HOME:-$HOME/.local/share}/starsector" "$HOME/.local/share/starsector"
      --unsetenv XDG_DATA_HOME

      # Block dangerous D-Bus
      --unsetenv DBUS_SESSION_BUS_ADDRESS

      --)

      mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector

      ${bubblewrap}/bin/bwrap "''${args[@]}" ${starsector-unwrapped}/share/starsector/starsector.sh
  ''
else
  runCommandLocal "starsector"
  {
    inherit (starsector-unwrapped) version meta;

    nativeBuildInputs = [ makeWrapper ];

    inherit buildInputs;
  } ''
    makeWrapper ${starsector-unwrapped}/share/starsector/starsector.sh $out/bin/starsector \
      --prefix PATH : ${lib.makeBinPath [ openjdk ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run 'mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector' \
      --chdir "${starsector-unwrapped}/share/starsector"
  ''
