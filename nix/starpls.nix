{
  lib,
  protobuf,
  rust,
}: let
  cargo-toml = builtins.path {
    path = ../Cargo.toml;
    name = "starpls-cargo";
  };
  cargo-lock = builtins.path {
    path = ../Cargo.lock;
    name = "starpls-lock";
  };
  starpls-src = builtins.path {
    path = ../.;
    name = "starpls-src";
  };
  version =
    (
      builtins.fromTOML (
        builtins.readFile ../crates/starpls/Cargo.toml
      )
    )
    .package
    .version;
  crate-build-params = {
    pname = "starpls";
    inherit version;

    nativeBuildInputs = [protobuf];

    # https://github.com/AleksanderGondek/starpls-nixified/commit/baba01c4fa6642402ac7703f90e01012bdbf3fc7#diff-5c831fd09c4845b849966dae6aaf33b2a9b53deb6a43d70d36dfe1862c2ebfc5
    # introduced more reliance on how code is build via Bazel.
    # One has to provide env variable and disable 3 tests.
    REPOSITORY_NAME = "aleksandergondek_starpls_nixified";
    checkFlags = [
      "--skip=test::test_can_read_data_from_runfiles"
      "--skip=test::test_parse_repo_mapping"
      "--skip=test::test_parse_repo_mapping_invalid_file"
    ];

    cargoLock = {
      lockFile = cargo-lock;
      outputHashes = {
        "salsa-2022-0.1.0" = "j1LmpnE9OJfbfimo4qkCiImG/Y7dEr8gWB9WIFuLgDE=";
      };
    };

    src = starpls-src;

    meta = {
      description = "A language server for Starlark.";
      license = lib.licenses.asl20;
      platforms = ["x86_64-linux"];
      homepage = "https://github.com/AleksanderGondek/starpls-nixified";
      mainProgram = "starpls";
    };
  };
in {
  bin = rust.platform.buildRustPackage crate-build-params;
  bin-static =
    rust.platform-musl.buildRustPackage crate-build-params
    // {
      RUSTFLAGS = "-C target-feature=+crt-static";
    };
}
