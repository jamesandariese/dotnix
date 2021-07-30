{pkgs, ...}:
{
    home.file.osx-defaults.target = ".defaultsrc.sh";
    home.file.osx-defaults.onChange = ''
        ${pkgs.bash}/bin/bash "$HOME/.defaultsrc.sh"
      '';
    home.file.osx-defaults.text = ''
        # Disable window open animations.  With a fast menu program, this enables using a
        # program as a menu in a tiling wm rather than requiring the wm itself to provide
        # menuing.
        defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

        # Disable the dock entirely.  use Cmd-Opt-D to toggle it on and off
        #  (this actually toggles hiding so the autohide delay is turned on and off, basically)
        defaults write com.apple.dock autohide-delay -float 1000
        defaults write com.apple.dock autohide -float 1

        # then this one for hiding the menu bar like all the cool kids are doing.  we don't
        # killall Dock for this one.  I'm not sure what makes it take effect.
        defaults write 'Apple Global Domain' _HIHideMenuBar -float 1

        killall Dock
      '';
}
