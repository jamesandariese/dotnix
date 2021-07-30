{pkgs,...}:
let
  yabai = pkgs.yabai;
  skhd = pkgs.skhd;
  alacritty = pkgs.alacritty;
  spacebar = pkgs.spacebar;
  qes = pkgs.qes;
  jq = pkgs.jq;
  bash = pkgs.bash;
  flock = pkgs.flock;
  tmux = pkgs.tmux;
  imagemagick = pkgs.imagemagick;
  _123background = ./123background.png;
in {
  home.packages = [
      yabai
      skhd
      jq
    ];

  # YABAI
  home.file.yabai-background-fix.target = ".fix-background.sh";
  home.file.yabai-background-fix.onChange = "bash $HOME/.fix-background.sh";
  home.file.yabai-background-fix.executable = true;
  home.file.yabai-background-fix.text = ''
      /usr/bin/osascript -e 'tell application "Finder" to set desktop picture to POSIX file "${_123background}"'
  '';
  home.file.yabai-config.target = ".yabairc";
  home.file.yabai-config.onChange = ''
      F="$HOME/Library/LaunchAgents/yabai.plist"
      if [ -f "$F" ];then
          launchctl unload "$F"
          launchctl load "$F"
      fi
    '';
  home.file.yabai-config.text = ''
      echo "yabai reconfiguring $(date)"
      # this layout bsp without a space doesn't appear in the docs but it
      # _does_ appear to work.
      ${yabai}/bin/yabai -m config layout bsp

      ${yabai}/bin/yabai -m config top_padding 12
      ${yabai}/bin/yabai -m config bottom_padding 12
      ${yabai}/bin/yabai -m config left_padding 12
      ${yabai}/bin/yabai -m config right_padding 12
      ${yabai}/bin/yabai -m config window_gap 12
      ${yabai}/bin/yabai -m config external_bar all:0:26
      
      ${yabai}/bin/yabai -m config focus_follows_mouse autofocus
      ${yabai}/bin/yabai -m config mouse_follows_focus on
      ${yabai}/bin/yabai -m config mouse_action1 resize
      ${yabai}/bin/yabai -m config mouse_action2 move
      ${yabai}/bin/yabai -m config window_shadow off
      ${yabai}/bin/yabai -m config window_border on
      ${yabai}/bin/yabai -m config normal_window_border_color 0xff303030
      ${yabai}/bin/yabai -m config active_window_border_color 0xff006600

      ${yabai}/bin/yabai -m signal --add label=dock-restart-rule event=dock_did_restart action="sudo /Users/james/.nix-profile/bin/yabai --load-sa"
      ${yabai}/bin/yabai -m signal --add label=space_background_fix event=space_changed action="${bash}/bin/bash $HOME/.fix-background.sh;${yabai}/bin/yabai -m window --focus mouse"
      ${bash}/bin/bash $HOME/.fix-background.sh
    '';
  home.file.yabai-launchcfg.target = "Library/LaunchAgents/yabai.plist";
  home.file.yabai-launchcfg.onChange = ''
      launchctl load $HOME/Library/LaunchAgents/yabai.plist
    '';
  home.file.yabai-launchcfg.text = ''
      <!-- It's not advisable to edit this plist, it may be overwritten -->
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>yabai</string>
        <key>ProgramArguments</key>
        <array>
          <string>${yabai}/bin/yabai</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/Users/james/Library/Logs/yabai.log</string>
        <key>StandardOutPath</key>
        <string>/Users/james/Library/Logs/yabai.log</string>
      </dict>
      </plist>
    '';

  # SKHD
  home.file.skhd-config.target = ".skhdrc";
  home.file.skhd-config.onChange = ''
      F="$HOME/Library/LaunchAgents/skhd.plist"
      if [ -f "$F" ];then
          launchctl unload "$F"
          launchctl load "$F"
      fi
    '';

  home.file.skhd-config.text = let
    yabai_lock_off = ''${yabai}/bin/yabai -m config active_window_border_color 0xFF006600'';
    yabai_lock_on = ''${yabai}/bin/yabai -m config active_window_border_color 0xFF00FF00'';
    yabai_tmux_off = ''echo tmux off;${flock}/bin/flock ${spacebar}/bin/spacebar ${spacebar}/bin/spacebar -m config background_color 0xff202020'';
    yabai_tmux_on =  ''echo tmux on; ${flock}/bin/flock ${spacebar}/bin/spacebar ${spacebar}/bin/spacebar -m config background_color 0xff902020'';
    press = key: ''${qes}/bin/qes -k '${key}' '';
    # screen prefix
    prefix = "ctrl - b";
    # and we'll use xoff to replicate locking
    # and if we configure this inside tmux, we can nest tmuxes using these keys
    # to go in and out of scopes.  woo.
    lock = "ctrl - s";
    unlock = "ctrl - q";
  in ''
      :: default : echo default mode;${yabai_tmux_off};${yabai_lock_off}
      :: tmux  @ : ${yabai_tmux_on};${yabai_lock_off}
      :: lock    : ${yabai_tmux_off};echo locked;${yabai_lock_on}
      
      default < ${prefix}    ;tmux
      tmux    < ${lock}      ;lock
      lock    < ${unlock}    ;default
      tmux    < ${prefix} -> ;default
      tmux    < n            : ${press "escape"};${yabai}/bin/yabai -m space --focus next || ${yabai}/bin/yabai -m space --focus first
      tmux    < p            : ${press "escape"};${yabai}/bin/yabai -m space --focus prev || ${yabai}/bin/yabai -m space --focus last
      tmux    < left         : ${press "escape"};${yabai}/bin/yabai -m window --focus west
      tmux    < right        : ${press "escape"};${yabai}/bin/yabai -m window --focus east
      tmux    < down         : ${press "escape"};${yabai}/bin/yabai -m window --focus south
      tmux    < up           : ${press "escape"};${yabai}/bin/yabai -m window --focus north
      tmux    < shift - 0x27 : ${press "escape"};${yabai}/bin/yabai -m window --insert south ; nohup ${alacritty}/bin/alacritty -o window.startup_mode=Windowed &
      tmux    < shift - 5    : ${press "escape"};${yabai}/bin/yabai -m window --insert east ; nohup ${alacritty}/bin/alacritty -o window.startup_mode=Windowed &
      tmux    < l            : ${press "escape"};${yabai}/bin/yabai -m space --focus recent
      tmux    < z            : ${yabai}/bin/yabai -m window --focus "$(${yabai}/bin/yabai -m query --windows --window | ${jq}/bin/jq -er .id)";${yabai}/bin/yabai -m window --toggle zoom-fullscreen;${press "escape"}
      tmux    < o            : ${press "escape"};${yabai}/bin/yabai -m window --focus next
      tmux    < shift - 7    : ${press "escape"};${yabai}/bin/yabai -m space --layout bsp
      tmux    < escape       ;default
    '';
  home.file.skhd-launchcfg.target = "Library/LaunchAgents/skhd.plist";
  home.file.skhd-launchcfg.onChange = ''
      launchctl load $HOME/Library/LaunchAgents/skhd.plist
    '';
  home.file.skhd-launchcfg.text = ''
      <!-- It's not advisable to edit this plist, it may be overwritten -->
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>skhd</string>
        <key>ProgramArguments</key>
        <array>
          <string>${skhd}/bin/skhd</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/Users/james/Library/Logs/skhd.log</string>
        <key>StandardOutPath</key>
        <string>/Users/james/Library/Logs/skhd.log</string>
      </dict>
      </plist>
    '';

  #SPACEBAR
  home.file.spacebar-config.target = ".spacebarrc";
  home.file.spacebar-config.onChange = ''
      F="$HOME/Library/LaunchAgents/spacebar.plist"
      if [ -f "$F" ];then
          launchctl unload "$F"
          launchctl load "$F"
      fi
    '';

  home.file.spacebar-config.text = let
    
  in ''
    #!${bash}/bin/bash
    # seems to be some sort of race condition if I run too many spacebar -ms at once.
    spacebar() { ${flock}/bin/flock ${spacebar}/bin/spacebar ${spacebar}/bin/spacebar "$@" ;}
    spacebar -m config position                    bottom
    spacebar -m config display                     all
    spacebar -m config height                      26
    spacebar -m config title                       on
    spacebar -m config spaces                      on
    spacebar -m config clock                       on
    spacebar -m config power                       on
    spacebar -m config padding_left                20
    spacebar -m config padding_right               20
    spacebar -m config spacing_left                25
    spacebar -m config spacing_right               15
    spacebar -m config text_font                   "SauceCodePro Nerd Font Mono:Regular:18.0"
    spacebar -m config icon_font                   "SauceCodePro Nerd Font Mono:Regular:18.0"
    spacebar -m config background_color            0xff202020
    spacebar -m config foreground_color            0xffa8a8a8
    spacebar -m config power_icon_color            0xffcd950c
    spacebar -m config battery_icon_color          0xffd75f5f
    spacebar -m config dnd_icon_color              0xffa8a8a8
    spacebar -m config clock_icon_color            0xffa8a8a8
    spacebar -m config power_icon_strip             
    spacebar -m config space_icon                  •
    spacebar -m config space_icon_color            0xffffab91
    spacebar -m config space_icon_color_secondary  0xff78c4d4
    spacebar -m config space_icon_color_tertiary   0xfffff9b0
    spacebar -m config space_icon_strip            1 2 3 4 5 6 7 8 9 10
    spacebar -m config spaces_for_all_displays     on
    spacebar -m config clock_icon                  
    spacebar -m config dnd_icon                    
    spacebar -m config clock_format                "%d/%m/%y %R"
    spacebar -m config right_shell                 on
    spacebar -m config right_shell_icon            
    spacebar -m config right_shell_command         "whoami"
    
    echo "spacebar configuration loaded.."

  '';

  home.file.spacebar-launchcfg.target = "Library/LaunchAgents/spacebar.plist";
  home.file.spacebar-launchcfg.onChange = ''
      launchctl load $HOME/Library/LaunchAgents/spacebar.plist
    '';
  home.file.spacebar-launchcfg.text = ''
      <!-- It's not advisable to edit this plist, it may be overwritten -->
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>spacebar</string>
        <key>ProgramArguments</key>
        <array>
          <string>${spacebar}/bin/spacebar</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/Users/james/Library/Logs/spacebar.log</string>
        <key>StandardOutPath</key>
        <string>/Users/james/Library/Logs/spacebar.log</string>
      </dict>
      </plist>
    '';
}
