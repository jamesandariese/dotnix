{pkgs, ...}:
{
  programs.zsh.initExtra = ''
    powerbanner() {
        C=$((COLUMNS - 5))
        if [ $C -lt 20 ];then
            C=75
        fi
        (
          IN="$1"
          if [ x"$IN" = x"-" ];then
            cat
          else
            echo "$IN"
          fi | ${pkgs.gnused}/bin/sed -e 's/^/X/' | \
          (
          while read -r REPLY;do
          export XYZ="$(printf "%*s" -$C "$''+''{REPLY#X}")"
          ${pkgs.powerline-go}/bin/powerline-go -shell bare -modules=shell-var -shell-var=XYZ -theme=gruvbox "$@" ;echo
          done
          )
        )
    }
    reposummary="$(for repo in $HOME/src/github.com/jamesandariese/{dotnix,shop};do
                    (cd "$repo" && ${pkgs.powerline-go}/bin/powerline-go -shell bare -modules=host,cwd,git);echo
                   done)"
    if [ x"$reposummary" = x ];then
        powerbanner "No repos to summarize"
    else
        powerbanner REPOS
        echo "$reposummary"
    fi
    (
    echo "Welcome to $(hostname -f)"
    echo "$(uptime)"
    echo
    ${pkgs.cowsay}/bin/cowsay -e '@@' -T WW 'dragon cow says hi'
    ) | powerbanner -
  '';
}
