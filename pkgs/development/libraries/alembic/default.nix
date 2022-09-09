{ lib, stdenv, fetchFromGitHub, unzip, cmake, openexr, hdf5-threadsafe }:

stdenv.mkDerivation rec
{
  pname = "alembic";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "alembic";
    repo = "alembic";
    rev = version;
    sha256 = "sha256-QnqUD8KmMDmEZ1REoKN70SwVICOdyGPZsB/lU9nojj4=";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [ unzip cmake ];
  buildInputs = [ openexr hdf5-threadsafe ];

  cmakeFlags = [
    "-DUSE_HDF5=ON"
    "-DUSE_TESTS=OFF"
    "-DALEMBIC_LIB_INSTALL_DIR=${placeholder "out"}/lib"
  ];

  postInstall = ''
    moveToOutput bin $bin
  '';

  meta = with lib; {
    description = "An open framework for storing and sharing scene data";
    homepage = "http://alembic.io/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
