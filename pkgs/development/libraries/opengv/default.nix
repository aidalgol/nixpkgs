{ lib
, stdenv
, fetchFromGitHub
, cmake
, eigen
}:

stdenv.mkDerivation rec {
  pname = "opengv";
  version = "unstable-2020-08-07";

  src = fetchFromGitHub {
    owner = "laurentkneip";
    repo = "opengv";
    rev = "91f4b19c73450833a40e463ad3648aae80b3a7f3";
    sha256 = "sha256-LfnylJ9NCHlqjT76Tgku4NwxULJ+WDAcJQ2lDKGWSI4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
  ];

  meta = with lib; {
    description = "A collection of computer vision methods for solving geometric vision problems.";
    homepage = "https://laurentkneip.github.io/opengv/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
