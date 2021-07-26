{ pkgs ? import <nixpkgs> {},
  pkgs-path,
  home-manager-path,
  ...
 }:
let
  _ = builtins.trace "generating a home with pkgs = ${pkgs}";
in
{
  home.packages = [
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

  programs.zsh.enable = true;
  programs.zsh.sessionVariables = {
    NIX_PATH = "nixpkgs=${pkgs-path}:home-manager=${home-manager-path}";
    NIX_SSL_CERT_FILE =
      let p1 = builtins.getEnv "HOME" + "/.nix-profile/etc/ssl/certs/ca-bundle.crt"; in
      if builtins.pathExists p1 then p1
      else
      let p2 = /etc/ssl/certs/ca-certificates.crt; in
      if builtins.pathExists p2 then p2
      else "";
  };
  programs.zsh.initExtra = ''
    PATH="$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:$PATH"
    git-get-ssh-origin() { git remote get-url origin | sed -e 's#https://github.com/\([^/]*\)/\(.*\)#git@github.com:\1/\2#' ; }
    git-set-ssh-origin() { git remote set-url origin `git-get-ssh-origin` ; }
  '';

  programs.bash.enable = true;
  # limit the bash options we use since macos still defaults to....... bash 3..............
  programs.bash.shellOptions = [ "histappend" "checkwinsize" "extglob" ];

  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.alacritty;
  programs.alacritty.settings = import ./alacritty.nix;

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

}
