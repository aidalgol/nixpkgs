{ lib
, buildFHSUserEnv
, heroic-unwrapped
}:

buildFHSUserEnv {
  name = "heroic";

  runScript = "heroic";

  targetPkgs = pkgs: with pkgs; [
    heroic-unwrapped

    gnugrep
    gnused
    gnutar
    zstd
    opencl-headers
    p7zip
    perl
    psmisc
    which
    xorg.xrandr
  ];

  multiPkgs = pkgs: with pkgs; [
    alsa-lib
    bash
    cairo
    coreutils
    cups
    dbus
    freetype
    fribidi
    giflib
    glib
    gnutls
    gtk3
    lcms2
    libevdev
    libGLU
    libglvnd
    libjpeg
    libkrb5
    libmpeg2
    libogg
    libopus
    libpng
    libpulseaudio
    libselinux
    libsndfile
    libsndfile
    libtheora
    libtiff
    libusb1
    libv4l
    libva
    libvorbis
    libxkbcommon
    libxml2
    mpg123
    ocl-icd
    openldap
    samba4
    sane-backends
    SDL2
    udev
    udev
    unixODBC
    util-linux
    vulkan-loader
    wayland
    zlib
  ];

  meta = {
    inherit (heroic-unwrapped.meta)
      homepage
      description
      platforms
      license
      maintainers
      broken;

    mainProgram = "heroic";
  };

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${heroic-unwrapped}/share/applications $out/share
    ln -s ${heroic-unwrapped}/share/icons $out/share
  '';
}
