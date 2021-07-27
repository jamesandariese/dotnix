{pkgs, ...}:
{
  programs.aria2.enable = true;
  programs.aria2.settings = {
    max-connection-per-server = 5;
  };
}
