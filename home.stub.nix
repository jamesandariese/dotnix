{ ... }:

let
  local-dotnix-path = (builtins.getEnv "HOME") + "/src/github.com/jamesandariese/dotnix";
  dotnix-path =
    if builtins.pathExists local-dotnix-path
    then local-dotnix-path
    else builtins.fetchGit {
        url = "https://github.com/jamesandariese/dotnix/";
        rev = "2528eb1ab9e147e5574b9d21bf2669f91cc454e8";
        ref = "main";
      };
  dotnix = import (builtins.trace "loading dotnix from ${dotnix-path}" dotnix-path) { };
in dotnix.home
