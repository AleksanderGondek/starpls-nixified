{
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
in
  rust.platform-musl.buildRustPackage {
    pname = "starpls";
    inherit version;

    RUSTFLAGS = "-C target-feature=+crt-static";

    nativeBuildInputs = [protobuf];

    cargoLock = {
      lockFile = cargo-lock;
      outputHashes = {
        "salsa-2022-0.1.0" = "j1LmpnE9OJfbfimo4qkCiImG/Y7dEr8gWB9WIFuLgDE=";
      };
    };

    src = starpls-src;

    meta = {
      description = "To be described.";
      homepage = "https://github.com/AleksanderGondek/starpls-nixified";
    };
  }
