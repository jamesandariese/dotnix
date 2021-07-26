{pkgs ? import <nixpkgs> {}}:

rec {
  path = ./.;
  home = pkgs.callPackage ./home.nix {};
} 
