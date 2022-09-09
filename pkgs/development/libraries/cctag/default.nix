{ lib
, stdenv
, fetchFromGitHub
, cmake
, eigen
, cudatoolkit
, boost
, tbb
, opencv
}:

stdenv.mkDerivation rec {
  pname = "cctag";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "CCTag";
    rev = "v${version}";
    sha256 = "sha256-cEH1PKLUcBeOLg+4USTVoAUUg3CHkxODCDkkUsyqcj4=";
  };

  patches = [
    # https://github.com/alicevision/CCTag/issues/142
    ./pointer-comparison-fix.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
    cudatoolkit
    boost
    tbb
    opencv
  ];

  meta = with lib; {
    description = "Detection of CCTag markers made up of concentric circles.";
    homepage = "https://cctag.readthedocs.io/";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
