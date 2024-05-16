{ lib
, buildPythonApplication
, fetchPypi
, setuptools
, numpy
, svgelements
, shxparser
, pillow
, opencv
, pyserial
, tkinter
, copyDesktopItems
, nix-update-script
}:

let
  version = "0.9.15";
  pname = "bCNC";
  description = "GRBL CNC command sender, autoleveler, and g-code editor";
in
buildPythonApplication {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fKd/iRTS2lG0or9dsf5I9SA35Z6XJ2m/SMky++4tX/M=";
  };

  dependencies = [
    setuptools
    numpy
    svgelements
    shxparser
    pillow
    opencv
    pyserial
    tkinter
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  postInstall = ''
    install -Dt $out/share/icons/hicolor/204x204/ bCNC/bCNC.png
  '';

  # All tests require an X server because they run the GUI.
  doCheck = false;

  desktopItems = [
    "bCNC/bCNC.desktop"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit description;
    homepage = "https://github.com/vlachoudis/bCNC";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ aidalgol ];
  };
}
