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
    NIX_SSL_CERT_FILE = builtins.getEnv "HOME" + "/.nix-profile/etc/ssl/certs/ca-bundle.crt";
  };
  programs.zsh.initExtra = ''
    PATH="$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:$PATH"
  '';

  programs.bash.enable = true;
  programs.bash.shellOptions = [ "histappend" "checkwinsize" "extglob" ];
  programs.bash.initExtra = ''
    [ -x "${pkgs.zsh}/bin/zsh" ] && exec ${pkgs.zsh}/bin/zsh
  '';
}
