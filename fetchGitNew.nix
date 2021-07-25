{pkgs ? import <nixpkgs> {}}:

{
  fetchGitGPG = repo: tag: key:
    pkgs.runCommand "git" {buildInputs = [pkgs.git pkgs.gnupg pkgs.cacert];} ''
      export GNUPGHOME="$out/.gnupg"
      ${pkgs.git}/bin/git clone "${repo}" "$out"
      ${pkgs.gnupg}/bin/gpg --recv-key "${key}"
      ${pkgs.git}/bin/git -C "$out" tag -v "${tag}"
      ${pkgs.git}/bin/git -C "$out" checkout "${tag}"
      rm -rf "$GNUPGHOME"
    '';
}
