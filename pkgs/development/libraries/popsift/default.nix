{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudatoolkit
, boost
, libdevil
}:

stdenv.mkDerivation rec {
  pname = "popsift";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "popsift";
    rev = "v${version}";
    sha256 = "sha256-yehn9pH3tQB6bIWjXg6ZldXgK+N6h5AYKNQoIm2ci3k=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cudatoolkit
    boost
    libdevil
  ];

  meta = with lib; {
    description = "An implementation of the SIFT algorithm in CUDA.";
    homepage = "https://popsift.readthedocs.io/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
