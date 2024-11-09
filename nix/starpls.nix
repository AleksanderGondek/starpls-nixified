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

    cargoLock = {
      lockFile = cargo-lock;
      outputHashes = {
        "salsa-2022-0.1.0" = "j1LmpnE9OJfbfimo4qkCiImG/Y7dEr8gWB9WIFuLgDE=";
      };
    };

    src = starpls-src;

    meta = {
      description = "A language server for STarlark.";
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
