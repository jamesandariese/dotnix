#!/bin/bash

cd "$HOME"

echo "BOOTSTRAPPING... one sec"

sudo yum -y install xz
curl -L https://nixos.org/nix/install | sh
. ./.nix-profile/etc/profile.d/nix.sh
# pass this AWK_CMD into nix-shell to produce the width/height to use.  perdy darn convoluted, huh?
export AWK_CMD='{printf("MAXH=%s\nMAXW=%s", $2, $3);}'
# also AWK_FS
export AWK_FS='[, ]+'

eval `nix-shell -p dialog --run 'dialog --stdout --print-maxsize' | nix-shell -p gawk --run 'awk -F "$AWK_FS" "$AWK_CMD"'`

PADDING=3
export PADW=$(( MAXW - PADDING - PADDING ))
export PADH=$(( MAXH - PADDING - PADDING ))

(
exec 2>&1
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
rm ~/.bash{rc,_profile} 

mkdir -p .config/nixpkgs
echo '{ pkgs, ... }:

{
  home.packages = with pkgs;[
    htop
    fortune
    nixops
  ];

  home.sessionVariables = {
    LC_ALL = "C";
    AWS_EXECUTION_ENV = "CloudShell";
  };

  programs.bash = {
    enable = true;
    initExtra = '"''"'
    [ -e /etc/bashrc ] && . /etc/bashrc
    complete -C '"'"'/usr/local/bin/aws_completer'"'"' aws
    '"''"';
    profileExtra = '"''"'
    if [ -e /home/cloudshell-user/.nix-profile/etc/profile.d/nix.sh ]; then . /home/cloudshell-user/.nix-profile/etc/profile.d/nix.sh; fi # added by nix installer
    '"''"';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  programs.firefox = {
    enable = true;
    profiles = {
      myprofile = {
        settings = {
          "general.smoothScroll" = false;
        };
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}' > .config/nixpkgs/home.nix

nix-shell -p home-manager --run 'home-manager switch'
echo
echo
echo -----------------------------------------------------------------------
echo
echo 'Logout and back in and everything should be good to go.'
echo 'For cloudshell, just logout and hit enter.'
echo
echo
echo "Done."
echo
echo
) | nix-shell -p dialog --run 'dialog --progressbox "Configuring nix and home manager" $PADH $PADW'
