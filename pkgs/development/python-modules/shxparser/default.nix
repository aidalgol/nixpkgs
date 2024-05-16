{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, svgelements
}:

buildPythonPackage rec {
  pname = "shxparser";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hUHkvOYodoIsk/OVnn9pCe8b+DUmkbNDus2qqbkv8nA=";
  };

  dependencies = [
    setuptools
    svgelements
  ];

  meta = {
    description = "Pure Python Parser for SHX Hershey font files";
    homepage = "https://github.com/tatarize/shxparser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aidalgol ];
  };
}

