{ ... }:
let
  home-manager-path = builtins.fetchGit {
      url = "https://github.com/nix-community/home-manager";
      ref = "release-21.05";
      rev = "9c0abed5228d54aad120b4bc757b6f5935aeda1c";
    };
  pkgs-path =
    let local-pkgs = (builtins.getEnv "HOME") + "/src/github.com/jamesandariese/nixpkgs";
    in if builtins.pathExists local-pkgs then
        local-pkgs
      else
        builtins.trace "ynixpkgs from git"
        builtins.fetchGit {
            url = "https://github.com/nixos/nixpkgs";
            ref = "nixos-unstable";
            rev = "dd14e5d78e90a2ccd6007e569820de9b4861a6c2";
          };
  pkgs = import (builtins.trace "znixpkgs from ${pkgs-path}" pkgs-path) {};
  home-manager = pkgs.callPackage home-manager-path {};
  _ = builtins.trace "generating a home with pkgs = ${pkgs}";
in
{
  #my = { inherit pkgs pkgs-path home-manager home-manager-path; };
  imports = [
    ./modules/alacritty.nix
    ./modules/powercow.nix
    ./modules/aria2.nix
    ./modules/_1password.nix
  ] ++ (if pkgs.stdenv.isDarwin then [
    (builtins.trace "pkgs is at ${pkgs.path}" ./modules/yabai.nix)
    ./modules/osxtweaks.nix
  ] else []);

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    pkgs.zsh
    pkgs.yubikey-manager
    pkgs.git
    pkgs.tmux
    pkgs.eternal-terminal
    pkgs.neovim
    pkgs.coreutils-full
    pkgs.coreutils-prefixed
    pkgs.httpie
    pkgs.jq
    pkgs.unixtools.watch
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.sessionVariables = {
    MYNIXPKGS = "${pkgs-path}";
    MYNIXPKGS2 = "${pkgs.path}";
    NIXPKGS_ALLOW_UNFREE = 1;
    NIX_PATH = "nixpkgs=${pkgs-path}:home-manager=${home-manager-path}";
    NIX_SSL_CERT_FILE =
      let p1 = builtins.getEnv "HOME" + "/.nix-profile/etc/ssl/certs/ca-bundle.crt"; in
      if builtins.pathExists p1 then p1
      else
      let p2 = /etc/ssl/certs/ca-certificates.crt; in
      if builtins.pathExists p2 then p2
      else "";
  };

  programs.zsh.enable = true;
  programs.zsh.initExtra = ''
    PATH="$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:$PATH"

    # I need this pretty often since I easily remember the https address of my
    # git repos but prefer to use ssh keys.  tragic, right?
    git-get-ssh-origin() { git remote get-url origin | sed -e 's#https://github.com/\([^/]*\)/\(.*\)#git@github.com:\1/\2#' ; }
    git-set-ssh-origin() { git remote set-url origin `git-get-ssh-origin` ; }
    
    #[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session -A -s login ; exit ; }
  '';

  programs.bash.enable = true;
  # limit the bash options we use since macos still defaults to....... bash 3..............
  programs.bash.shellOptions = [ "histappend" "checkwinsize" "extglob" ];

  # help shop find our zsh
  home.file.shell.target=".shell";
  home.file.shell.source="${pkgs.zsh}/bin/zsh";

  programs.powerline-go.enable=true;

  programs.git.enable = true;
  programs.git.userName = "James Andariese";
  programs.git.userEmail = "james@strudelline.net";
  programs.git.extraConfig = {
      pull.ff = "only";
    };

  programs.man.enable = true;
}
