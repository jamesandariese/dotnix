{
  config,
  pkgs,
  homeDirectory,
  username,
  arch,
  hostname,
  fqdn,
  serial,
  ...
}:

{
  home.username = username;
  home.homeDirectory = homeDirectory;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = [
    (pkgs.nerdfonts.override {fonts = [ "SourceCodePro" ]; })
    pkgs.tmux
    pkgs.neovim
    pkgs.coreutils-full
    pkgs.coreutils-prefixed
    pkgs.git
    pkgs.httpie
    pkgs.jq
    pkgs.unixtools.watch
  ];

  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.alacritty;
  programs.alacritty.settings = import ./alacritty.nix;
}
