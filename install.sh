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
    sha="$(echo -n "$content" | shasum -a 512 | awk '{print $1}')"
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

stage1() {
    installer="$(vcurl https://nixos.org/nix/install 9561203759898da1ac8817b6d4296593af2b36471eb0055d3eb9673055fbfcdc029a102ac28a24e90d3182a429eec17f911bffcab8d958e891135bd169b0fffb)"
    ensure_not_exist $HOME/src/github.com/jamesandariese/dotnix
    ensure_not_exist $HOME/.config/nixpkgs
    ensure_not_exist $HOME/.nixpkgs
    mkdir -p .config
    
    cd "$HOME"
    bash <(echo "$installer") --darwin-use-unencrypted-nix-store-volume --daemon
    source /etc/bashrc
    stage2
}

stage2() {
    echo stage2
    echo $$ hi
    echo returning from stage2
    mkdir -p $HOME/src/github.com/jamesandariese/dotnix
    nix-shell -p git --run "git clone https://github.com/jamesandariese/dotnix $HOME/src/github.com/jamesandariese/dotnix"
    ln -sf $HOME/src/github.com/jamesandariese/dotnix/_config $HOME/.config/nixpkgs $HOME/.config/nixpkgs
    ln -sf $HOME/src/github.com/jamesandariese/dotnix/_nixpkgs $HOME/.config/nixpkgs $HOME/_nixpkgs
}

if [ x"$1" != x ];then
    "$1"
else
    stage1
fi
