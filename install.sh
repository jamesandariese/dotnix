#!/bin/bash

fail() {
    echo "$@"
    exit 1
}

vcurl() {
    # the easiest way to use this is to vcurl the thing with the wrong
    # sha then update it.
    URL="$1"
    content="$(curl -sL "$URL")"
    sha="$(echo -n "$content" | sha512sum | awk '{print $1}')"
    if [ x"$sha" != x"$2" ];then
        (exec 1>&2
        echo "$1 sha512 does not match"
        echo "      given: $2"
        echo " downloaded: $sha"
        )
        return 1
    fi
    echo "$content"
}

ensure_not_exist() {
    test -e "$1" && fail "$1 already exists"
}

installer="$(vcurl https://nixos.org/nix/install 9561203759898da1ac8817b6d4296593af2b36471eb0055d3eb9673055fbfcdc029a102ac28a24e90d3182a429eec17f911bffcab8d958e891135bd169b0fffb)"
ensure_not_exist $HOME/src/github.com/jamesandariese/dotnix
ensure_not_exist $HOME/.config/nixpkgs
ensure_not_exist $HOME/.nixpkgs
mkdir -p .config

cd "$HOME"
mkdir -p src/github.com/jamesandariese/dotnix
git clone git@github.com:jamesandariese/dotnix.git src/github.com/jamesandariese/dotnix
ln -sf src/github.com/jamesandariese/dotnix/_nixpkgs .nixpkgs
ln -sf ../src/github.com/jamesandariese/dotnix/_config/nixpkgs .config/nixpkgs
bash <(echo "$installer") --darwin-use-unencrypted-nix-store-volume --daemon
