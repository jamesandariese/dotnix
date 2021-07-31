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

        defaults write -g "com.apple.trackpad.enableSecondaryClick" -float 1
        defaults write -g "com.apple.trackpad.fiveFingerPinchSwipeGesture" -float 0
        defaults write -g "com.apple.trackpad.fourFingerHorizSwipeGesture" -float 0
        defaults write -g "com.apple.trackpad.fourFingerPinchSwipeGesture" -float 0
        defaults write -g "com.apple.trackpad.fourFingerVertSwipeGesture" -float 0
        defaults write -g "com.apple.trackpad.momentumScroll" -float 1
        defaults write -g "com.apple.trackpad.pinchGesture" -float 1
        defaults write -g "com.apple.trackpad.rotateGesture" -float 1
        defaults write -g "com.apple.trackpad.scrollBehavior" -float 2
        defaults write -g "com.apple.trackpad.threeFingerDragGesture" -float 0
        defaults write -g "com.apple.trackpad.threeFingerHorizSwipeGesture" -float 0
        defaults write -g "com.apple.trackpad.threeFingerTapGesture" -float 0
        defaults write -g "com.apple.trackpad.threeFingerVertSwipeGesture" -float 0
        defaults write -g "com.apple.trackpad.twoFingerDoubleTapGesture" -float 1
    	defaults write -g "com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture" -float 3
        defaults write -g "com.apple.trackpad.version" -float 5
      '';
}
