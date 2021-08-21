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


        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad HIDScrollZoomModifierMask 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHandResting 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture 1
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture 3
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad USBMouseStopsTrackpad 0
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad UserPreferences 1

	defaults write com.apple.AppleMultitouchTrackpad ActuateDetents 1
	defaults write com.apple.AppleMultitouchTrackpad Clicking 0
	defaults write com.apple.AppleMultitouchTrackpad DragLock 0
	defaults write com.apple.AppleMultitouchTrackpad Dragging 0
	defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold 1
	defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed 0
	defaults write com.apple.AppleMultitouchTrackpad HIDScrollZoomModifierMask 0
	defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture 3
	defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad 0
	defaults write com.apple.AppleMultitouchTrackpad UserPreferences 1
      '';
}
