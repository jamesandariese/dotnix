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

	defaults write "com.apple.AppleMultitouchTrackpad" '{
          ActuateDetents = 1;
          Clicking = 0;
          DragLock = 0;
          Dragging = 0;
          FirstClickThreshold = 1;
          ForceSuppressed = 0;
          HIDScrollZoomModifierMask = 0;
          SecondClickThreshold = 1;
          TrackpadCornerSecondaryClick = 0;
          TrackpadFiveFingerPinchGesture = 0;
          TrackpadFourFingerHorizSwipeGesture = 0;
          TrackpadFourFingerPinchGesture = 0;
          TrackpadFourFingerVertSwipeGesture = 0;
          TrackpadHandResting = 1;
          TrackpadHorizScroll = 1;
          TrackpadMomentumScroll = 1;
          TrackpadPinch = 1;
          TrackpadRightClick = 1;
          TrackpadRotate = 1;
          TrackpadScroll = 1;
          TrackpadThreeFingerDrag = 0;
          TrackpadThreeFingerHorizSwipeGesture = 0;
          TrackpadThreeFingerTapGesture = 0;
          TrackpadThreeFingerVertSwipeGesture = 0;
          TrackpadTwoFingerDoubleTapGesture = 1;
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
          USBMouseStopsTrackpad = 0;
          UserPreferences = 1;
          version = 12;
	}'


      '';
}
