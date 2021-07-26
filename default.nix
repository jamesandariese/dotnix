{pkgs ? import <nixpkgs> {}}:

rec {
  path = ./.;
  home-manager-path = builtins.fetchGit {
      url = "https://github.com/nix-community/home-manager";
      ref = "release-21.05";
      rev = "9c0abed5228d54aad120b4bc757b6f5935aeda1c";
    };
  nixpkgs-path = builtins.fetchGit {
      url = "https://github.com/nixos/nixpkgs";
      ref = "nixos-unstable";
      rev = "dd14e5d78e90a2ccd6007e569820de9b4861a6c2";
    };
  nixpkgs = pkgs.callPackage nixpkgs-path {};
  home-manager = pkgs.callPackage home-manager-path {};
  home = pkgs.callPackage ./home.nix {};
} 
