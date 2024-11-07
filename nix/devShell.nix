{
  lib,
  mkShell,
  alejandra,
  cacert,
  cocogitto,
  git,
  helix,
  niv,
  statix,
  deadnix,
  protobuf,
  rust,
  rust-analyzer,
} @ args: let
  packages =
    lib.attrsets.attrValues (
      builtins.removeAttrs args ["mkShell" "lib" "rust"]
    )
    ++ [rust.bin];
in
  mkShell {
    inherit packages;
    name = "starpls-shell";

    shellHook = ''
      export CARGO_HOME="''${PWD}/.cache/.cargo"
      mkdir -p ''${CARGO_HOME}
    '';
  }
