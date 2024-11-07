{nixpkgs}: let
  customCallPackage = extraPkgs:
    nixpkgs.lib.callPackageWith (
      nixpkgs
      // extraPkgs
      // {
        callPackage = nixpkgs.lib.callPackageWith (
          nixpkgs // extraPkgs
        );
      }
    );
in rec {
  rust = (customCallPackage {}) ./rust.nix {};
  starpls = (customCallPackage {inherit rust;}) ./starpls.nix {};
  devShell = (customCallPackage {inherit rust;}) ./devShell.nix {};
}
