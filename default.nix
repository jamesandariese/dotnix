{pkgs ? import <nixpkgs> {}}:

rec {
  inherit (pkgs.callPackage ./fetchGitNew.nix {}) fetchGitGPG;
  dotnix-path = fetchGitGPG "https://github.com/jamesandariese/dotnix" "main" "DD4067DEE80475D7143D7F746BE4AD6FBF746F55";
  dotnix = pkgs.callPackage (builtins.trace "dotnix-path ${dotnix-path}" dotnix-path) {};
  path = ./.;
} 
