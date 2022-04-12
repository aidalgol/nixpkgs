{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libsocketcan";
  version = "b464485031b6f2a4e53d3ef1b3d405f9ba159c07";

  src = fetchFromGitHub {
    owner = "lalten";
    repo = "libsocketcan";
    rev = "077def398ad303043d73339112968e5112d8d7c8";
    sha256 = "sha256-eMuChpNnIG0pUmU/rEGCGDOfdLc58gwtl2e9jr3YKls=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "SocketCAN userspace library";
    platforms = platforms.linux;
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ aidalgol ];
  };
}
