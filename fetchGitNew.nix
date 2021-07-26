{pkgs ? import <nixpkgs> {}}:

rec {
  buildGNUPGHOME = key:
    pkgs.runCommand "gpg" {buildInputs = [pkgs.cacert];} ''
      export GNUPGHOME="$out"
      mkdir -p "$GNUPGHOME"
      ${pkgs.gnupg}/bin/gpg --keyserver keys.openpgp.org --recv-key ${key}
      rm $out/S.*
    '';

  fetchGitGPG = repo: tag: key:
    pkgs.runCommand "git" {buildInputs = [pkgs.git pkgs.gnupg pkgs.cacert];} ''
      export GNUPGHOME="${buildGNUPGHOME key}"
      ${pkgs.git}/bin/git clone "${repo}" "$out"
      ${pkgs.git}/bin/git -C "$out" checkout "${tag}"
      ${pkgs.git}/bin/git -C "$out" verify-commit HEAD
    '';
}
