{ lib
, symlinkJoin
, fetchFromGitHub
, buildBazelPackage
, bazel_5
, buildPythonPackage
, python39
, setuptools
, wheel
, cudaPackages
, gtest
}:

let
  python = python39;

  tensorrt = symlinkJoin {
    name = "tensorrt";
    paths = [
      cudaPackages.tensorrt
      cudaPackages.tensorrt.dev
    ];
  };

  libtorch = symlinkJoin {
    name = "libtorch";
    paths = [
      python.pkgs.pytorch
      python.pkgs.pytorch.lib
      python.pkgs.pytorch.dev
    ];
    # Create symlinks for the filenames that the bazel build expects.
    postBuild = ''
      ln -s $out/lib/libc10.so $out/lib/libc10_cuda.so
      ln -s $out/lib/libtorch.so $out/lib/libtorch_cuda.so
    '';
  };

  cudatoolkit = symlinkJoin {
    name = "cudatoolkit";
    paths = [
      cudaPackages.cudatoolkit
      cudaPackages.cudatoolkit.lib
    ];
  };

  pname = "torch-tensorrt";
  version = "1.1.0";

  # first build all binaries and generate setup.py using bazel
  bazel-wheel = buildBazelPackage {
    name = "${pname}-${version}-py3-none-linux_x86_64.whl";
    src = fetchFromGitHub {
      owner = "pytorch";
      repo = "TensorRT";
      rev = "v" + version;
      sha256 = "sha256-cAeZ5tVejkZziDPHdax5xhhaXdq6sPeFHDNH6l/HxlU=";
    };

    nativeBuildInputs = [
      # needed to create the output wheel in installPhase
      python
      setuptools
      wheel
    ];

    patches = [
      ./workspace-local-deps.patch
    ];

    postPatch = ''
      sed --in-place 's,##gtest-path##,${gtest.dev},g' WORKSPACE
      sed --in-place 's,##cuda-path##,${cudatoolkit},g' WORKSPACE
      sed --in-place 's,##cublas-path##,${cudatoolkit},g' WORKSPACE
      sed --in-place 's,##cudnn-path##,${cudaPackages.cudnn},g' WORKSPACE
      sed --in-place 's,##tensorrt-path##,${tensorrt},g' WORKSPACE
      sed --in-place 's,##libtorch-path##,${libtorch}/lib/python3.9/site-packages/torch,g' WORKSPACE

      sed --in-place 's,include/x86_64-linux-gnu/,include/,g' third_party/tensorrt/local/BUILD
      sed --in-place 's,lib/x86_64-linux-gnu/,lib/,g' third_party/{tensorrt,cudnn}/local/BUILD
    '';

    bazel = bazel_5;
    bazelTarget = "//:libtorchtrt";
    bazelFlags = "--verbose_failures";

    fetchAttrs = {
      sha256 = "sha256-iKx282vTjmmj3IBHNOZdfkpeNqjsGJaRoWuDksAQK9E=";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';
    };
  };
in
buildPythonPackage {
  inherit version pname;
  format = "wheel";

  src = bazel-wheel;

  pythonCheckImports = [
    "torch_tensorrt"
  ];

  meta = with lib; {
    # Upstream supports only specific version of its main dependencies.  The
    # package _may_ work with other versions, but it is not guaranteed, so we
    # mark the package as broken if the versions do not match.
    broken = !(
      python.pkgs.pytorch.version == "1.11.0" &&
      cudaPackages.cudaVersion == "11.3" &&
      cudaPackages.cudnn.version == "8.2.1" &&
      cudaPackages.tensorrt.version == "8.2.4.2"
    );
    description = "Ahead of Time (AOT) compiling for PyTorch JIT";
    homepage = "https://pytorch.org/TensorRT";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
