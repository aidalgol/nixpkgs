{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtbase
, eigen
, boost
, freeimage
, glew
, gflags
, suitesparse
, ceres-solver
, glog
, magma
, cudatoolkit
}:

stdenv.mkDerivation rec {
  pname = "uncertainty-te";
  version = "dev_codeStructure-2018-03-07";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "uncertaintyTE";
    rev = "d995765f7bb105214ceef974e0a795213479f74c";
    sha256 = "sha256-otYwhBWN5KuXUAbLPYd1P5SIy3Bwu2QglA3HWl+HjPM=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DMAGMA_ROOT=${magma}"
  ];

  buildInputs = [
    eigen
    boost
    freeimage
    glew
    gflags
    suitesparse
    ceres-solver
    glog
    qtbase
    magma
    cudatoolkit
  ];

  meta = with lib; {
    description = "Uncertainty estimation";
    homepage = "https://github.com/alicevision/uncertaintyTE";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
