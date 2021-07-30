{pkgs, ...}:
{
  home.packages = [
    pkgs.emacsMacport
  ];

  # this file will conflict if we include too many emacs
  # implementations in a single home dir (more than one)
  # which is great because that would be a problem.
  # nix just doing what nix does.
  home.file.ee.target = "bin/ee";
  home.file.ee.executable = true;
  home.file.ee.text = ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.emacsMacport}/Applications/Emacs.app/Contents/MacOS/Emacs -nw "$@"
  '';
  home.file.eew.target = "bin/eew";
  home.file.eew.executable = true;
  home.file.eew.text = ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.emacsMacport}/Applications/Emacs.app/Contents/MacOS/Emacs "$@"
  '';
}
