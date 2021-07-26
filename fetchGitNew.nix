{pkgs ? import <nixpkgs> {}}:

rec {
  buildGNUPGHOME = key:
    pkgs.runCommandLocal "gpg" {buildInputs = [pkgs.cacert];} ''
      export GNUPGHOME="$out"
      mkdir -p "$GNUPGHOME"
      ${pkgs.gnupg}/bin/gpg --keyserver keys.openpgp.org --recv-key ${key}
      rm $out/S.*
    '';

  fetchGitGPG = repo: tag: key:
    let
      cloned = builtins.fetchGit {url = repo;}; # just use this to signal that we need to do another clone below
    in
    pkgs.runCommandLocal "git" {buildInputs = [pkgs.git pkgs.gnupg pkgs.cacert];} ''
      export GNUPGHOME="${buildGNUPGHOME key}"
      # hello I am a dependency ${cloned}
      ${pkgs.git}/bin/git clone "${repo}" "$out"
      ${pkgs.git}/bin/git -C "$out" checkout "${tag}"
      ${pkgs.git}/bin/git -C "$out" verify-commit HEAD
    '';
}
