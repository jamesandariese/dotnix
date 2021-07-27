{pkgs,...}:
let
  yabai = pkgs.yabai;
in {
  home.packages = [
      yabai
    ];
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
      ${yabai}/bin/yabai -m config focus_follows_mouse autofocus
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
}
