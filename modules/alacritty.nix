{ config, pkgs, libs, ... }:
{
  # alacritty
  # we do some weird stuff with the config file in order to support the live reload.
  # all the weird is for live reload.
  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.alacritty;

  home.file.alacritty-config.target = ".config/alacritty/alacritty.yml.in";
  home.file.alacritty-config.source = ./alacritty.yml;
  home.file.alacritty-config.onChange = ''
    # send the config to a tmp file and then pipe it into the end file so that we don't have
    # impurity but also can use live reload (if we put the link in place directly, alacritty
    # will watch for changes in the symlinked file in the nix store which is not only the
    # wrong file but these files in particular are guaranteed to _never_ change -- so yeah...)
    cat "$HOME/.config/alacritty/alacritty.yml.in" > "$HOME/.config/alacritty/alacritty.yml"
  '';
}
