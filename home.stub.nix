{ ... }:

let
  local-dotnix-path = (builtins.getEnv "HOME") + "/src/github.com/jamesandariese/dotnix";
  dotnix-path =
    if builtins.pathExists local-dotnix-path
    then local-dotnix-path
    else builtins.fetchGit {
        url = "https://github.com/jamesandariese/dotnix/";
        rev = "654c28e08073ace218291d00c25311747fab94be";
        ref = "main";
      };
  dotnix = import (builtins.trace "loading dotnix from ${dotnix-path}" dotnix-path) { };
in dotnix.home
