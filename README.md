# dotnix
nix configs.

# bootstrap

At some point, a machine must start using this setup.  To do this, home-manager must
be configured.  It would be nice if there were a tool for configuring home directories.
As it happens, there's this tool called home-manager.  In order for it to work though,
it needs to be installed so we have this other tool called home-manager.

A couple tools let us break the cycle and find a place to start working on this tail-eater:

 - `fetchGithub` to seed the config directly in the nix store until there is a local copy to use
 - `nix-shell -p home-manager` to run home-manager before it's installed into the home profile

And to tell home-manager where to find it, there is a config file to link into `~/.config` and
that file references this repo to get the ball rolling.

## Prerequisites

You will need nix.  You may use nix on anything where home-manager runs (which is anywhere nix
runs, afaik?)

## Bootstrap Options

You have a few options to bootstrap this depending on your long term plans:

1. bootstrap by copypasta -- if you are trying to get setup quickly, this way avoids installing git during bootstrap.
2. bootstrap by git -- if you will definitely be working on your home-manager config on this box, bootstrap with git.

Both ways are good but if you ever need to change your home.stub.nix fragment, that may only be done once bootstrapping
with git.  This file is intended to change infrequently.

### Bootstrap by Copypasta (pick me)

1. `mkdir -p "$HOME/.config/nixpkgs"`
2. `nano "$HOME/.config/nixpkgs/home.nix"`
3. paste home.stub.nix from this repo
4. `nix-shell -p home-manager --run 'home-manager switch'`

### Bootstrap by Git

This method will not include a guide on using git.  Please check this repo out using whatever
means and continue along.

The true first step is to open a terminal and cd to this folder.  So do that then follow along.

1. `ln -sf $PWD/home.stub.nix $HOME/.config/nixpkgs/home.nix`
2. `nix-shell -p home-manager --run 'home-manager switch'`

## Shells

`chsh` stinks real bad.  To get around that, I use [shop][1].  See the file link named "shell" in home.nix.
Set it up system-wide to enable users of that system to bring their own provided shell (including through nix).

[1]: https://github.com/jamesandariese/shop
