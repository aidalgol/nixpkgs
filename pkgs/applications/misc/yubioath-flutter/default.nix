{ lib
, fetchFromGitHub
, flutter
, cmake
}:

flutter.mkFlutterApp rec {
  pname = "yubioath-flutter";
  version = "6.0.1";

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = version;
    hash = "sha256-6Pd0dKfUty5mWi0cMYN1QUFR6ocoa2uF+ZCy4Zfa/RY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Yubico Authenticator for Desktop and Android";
    homepage = "https://developers.yubico.com/yubioath-flutter/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aidalgol ];
  };
}
