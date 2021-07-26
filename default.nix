{...}:
let
  path = ./.;
  home-manager-path = builtins.fetchGit {
      url = "https://github.com/nix-community/home-manager";
      ref = "release-21.05";
      rev = "9c0abed5228d54aad120b4bc757b6f5935aeda1c";
    };
  pkgs-path = builtins.fetchGit {
      url = "https://github.com/nixos/nixpkgs";
      ref = "nixos-unstable";
      rev = "dd14e5d78e90a2ccd6007e569820de9b4861a6c2";
    };
  pkgs = import pkgs-path {};
  home-manager = pkgs.callPackage home-manager-path {};
  home = pkgs.callPackage ./home.nix {inherit pkgs-path home-manager-path;};
in
{
  inherit home-manager pkgs home path;
} 
