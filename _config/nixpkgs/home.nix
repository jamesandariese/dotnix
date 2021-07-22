with import <nixpkgs> { };

import ((toString ./.) + "/x86_64-darwin.nix")
