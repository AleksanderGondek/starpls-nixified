{localSystem ? builtins.currentSystem, ...}: let
  nixpkgs = let
    sources = import ./nix/sources.nix;
  in
    import sources.nixpkgs {
      inherit localSystem;
      config = {};
      overlays = [
        (import sources.rust-overlay)
      ];
    };
in
  import ./nix {inherit nixpkgs;}
