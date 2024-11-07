{
  description = "starpls flake";

  # As personally, I am not too keen on the flake mechanism
  # this files is a simple shim, created for compatiblity.
  # All actual logic is bound to default.nix.
  inputs = {};

  outputs = {self}: let
    supportedSystems = ["x86_64-linux"];
    forSupportedSystems = f: builtins.map f supportedSystems;
    defineDevShells = system: {
      name = system;
      value = {default = (import ./default.nix {localSystem = system;}).devShell;};
    };
    definePackages = system: {
      name = system;
      value = {
        "starpls" = (import ./default.nix {localSystem = system;}).starpls.bin;
        "default" = (import ./default.nix {localSystem = system;}).starpls.bin;
      };
    };
  in {
    packages = builtins.listToAttrs (forSupportedSystems definePackages);
    devShells = builtins.listToAttrs (forSupportedSystems defineDevShells);
  };
}
