{ ... }:

let
  local-dotnix-path = (builtins.getEnv "HOME") + "/src/github.com/jamesandariese/dotnix";
  dotnix-path =
    if builtins.pathExists local-dotnix-path
    then local-dotnix-path
    else builtins.fetchGit {
        url = "https://github.com/jamesandariese/dotnix/";
        rev = "c98bd7e200da75fbadb810954b0c9a8da8aa8561";
        ref = "main";
      };
  dotnix = import (builtins.trace "loading dotnix from ${dotnix-path}" dotnix-path) { };
in dotnix.home
