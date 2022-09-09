{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, libjpeg
, libpng
, libtiff
, zlib
, opencv
, magma
, openexr
, openimageio2
, geogram
, eigen
, ceres-solver
, alembic
, cctag
, uncertainty-te
, popsift
, opengv
, cudatoolkit
, xorg
}:

stdenv.mkDerivation rec {
  pname = "alicevision";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "AliceVision";
    rev = "v${version}";
    sha256 = "sha256-9RkLkAUCnlP9w70k0QEjFmmSLTdyS1slbkZbnoz//n0=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/alicevision/AliceVision/issues/1216
    ./missing-includes.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    zlib
    libjpeg
    libpng
    libtiff
    opencv
    magma
    openexr
    openimageio2
    geogram
    eigen
    ceres-solver
    alembic
    cctag
    uncertainty-te
    popsift
    opengv
    cudatoolkit
  ] ++ (with xorg; [
    libXxf86vm
    libXi
    libXrandr
  ]);

  cmakeFlags = [
    "-DMAGMA_ROOT=${magma}"
    "-DALICEVISION_USE_CCTAG=ON"
    "-DALICEVISION_USE_ALEMBIC=ON"
    "-DALICEVISION_USE_OPENCV=ON"
    "-DALICEVISION_USE_UNCERTAINTYTE=ON"
    "-DALICEVISION_USE_POPSIFT=ON"
    "-DALICEVISION_USE_OPENMP=ON"
    # https://github.com/alicevision/AliceVision/issues/1216
    "-DCMAKE_CXX_FLAGS=-Wno-format-security"
  ];

  meta = with lib; {
    description = "Photogrammetric Computer Vision Framework";
    homepage = "https://alicevision.org/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
