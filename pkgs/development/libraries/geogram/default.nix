{ lib
, stdenv
, fetchFromGitHub
, cmake
, xorg
, libglvnd
}:

stdenv.mkDerivation rec {
  pname = "geogram";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "geogram";
    rev = "v${version}";
    sha256 = "sha256-gUutYWWg0qjDOMbCRFuh52Mi4GxG4y6r50aeAHX6RSQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libglvnd
  ] ++ (with xorg; [
    libX11
    libxcb
    libXcursor
    libXdmcp
    libXext
    libXi
    libXinerama
    libXrandr
  ]);

  meta = with lib; {
    description = "A programming library with geometric algorithms.";
    homepage = "https://github.com/alicevision/geogram";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
