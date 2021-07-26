{pkgs ? import <nixpkgs> {}}:

rec {
  pkgs.callPackage ./fetchGitNew.nix {}
  path = ./.;
} 
