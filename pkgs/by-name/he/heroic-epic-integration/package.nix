{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkgsCross,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "heroic-epic-integration";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Etaash-mathamsetty";
    repo = "heroic-epic-integration";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zn0MsaQd8Ro6eu8IQkMcLNGLVTUukwajkn8PRLfB+Yw=";
  };

  nativeBuildInputs = [
    cmake
    pkgsCross.mingwW64.buildPackages.gcc
  ];

  cmakeFlags = [ "-DCMAKE_TOOLCHAIN_FILE=../windows.cmake" ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp heroic-epic-integration.exe $out/EpicGamesLauncher.exe

    runHook postInstall
  '';

  meta = with lib; {
    description = "Wrapper process for games launched through Heroic Games Launcher";
    longDescription = ''
      This is a Windows executable that pretends to be EpicGamesLauncher.exe for
      games that expect it to be their parent process.
    '';
    homepage = "https://github.com/Etaash-mathamsetty/heroic-epic-integration";
    changelog = "https://github.com/Etaash-mathamsetty/heroic-epic-integration/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aidalgol ];
  };
})
