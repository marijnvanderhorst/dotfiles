{ pkgs, config, ... }:

{
  system.defaults = {
    # One space spans across all physical displays
    spaces.spans-displays = true;

    # Dock settings
    dock = {
      autohide = false;
      orientation = "left";
      tilesize = 36;
      magnification = false;
      show-recents = false;
      minimize-to-application = true;
      scroll-to-open = true;
      persistent-apps = [
        { app = "/System/Applications/System Settings.app"; }
        { app = "/System/Applications/Utilities/Activity Monitor.app"; }
        {
          spacer = {
            small = true;
          };
        }
        { app = "/Applications/Microsoft Teams.app"; }
        { app = "/Applications/Microsoft Outlook.app"; }
        { app = "/Applications/Google Chrome.app"; }
        { app = "/Applications/Bitwarden.app"; }
        { app = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
        {
          spacer = {
            small = true;
          };
        }
        { app = "${config.system.primaryUserHome}/Applications/IntelliJ IDEA.app"; }
        { app = "${config.system.primaryUserHome}/Applications/DataGrip.app"; }
        { app = "${config.system.primaryUserHome}/Applications/PyCharm.app"; }
        { app = "${config.system.primaryUserHome}/Applications/Rider.app"; }
        { app = "${config.system.primaryUserHome}/Applications/WebStorm.app"; }
        { app = "${config.system.primaryUserHome}/Applications/PhpStorm.app"; }
        { app = "${config.system.primaryUserHome}/Applications/CLion.app"; }
        {
          spacer = {
            small = true;
          };
        }
        { app = "/Applications/Docker.app/Contents/MacOS/Docker Desktop.app"; }
        { app = "/Applications/DBngin.app"; }
        {
          spacer = {
            small = true;
          };
        }
      ];
      persistent-others = [
        # arrangement: "name", "date-added", "date-modified", "date-created", "kind"
        # displayas:  "stack", "folder"
        # showas: "automatic", "fan", "grid", "list"
        {
          folder = {
            path = "${config.system.primaryUserHome}/dev";
            arrangement = "name";
            displayas = "folder";
            showas = "list";
          };
        }
        {
          folder = {
            path = "${config.system.primaryUserHome}/Downloads";
            arrangement = "date-added";
            displayas = "folder";
            showas = "grid";
          };
        }
      ];
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf"; # Search current folder by default
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # List view
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXEnableColumnAutoSizing = true;
      _FXSortFoldersFirst = true;
    };

    # NSGlobalDomain settings (system-wide preferences)
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    # Custom UserDefaults for additional Finder settings
    CustomUserPreferences = {
      "com.apple.finder" = {
        # Search current folder by default
        FXDefaultSearchScope = "SCcf";
        # Show info panes
        FXInfoPanesExpanded = {
          General = true;
          OpenWith = true;
          Privileges = true;
        };
      };

      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "10" = {
            enabled = false;
            value = {
              parameters = [ 65535 96 8650752 ];
              type = "standard";
            };
          };
          "11" = {
            enabled = false;
            value = {
              parameters = [ 65535 97 8650752 ];
              type = "standard";
            };
          };
          "12" = {
            enabled = false;
            value = {
              parameters = [ 65535 122 8650752 ];
              type = "standard";
            };
          };
          "13" = {
            enabled = false;
            value = {
              parameters = [ 65535 98 8650752 ];
              type = "standard";
            };
          };
          "15" = { enabled = false; };
          "159" = {
            enabled = false;
            value = {
              parameters = [ 65535 36 262144 ];
              type = "standard";
            };
          };
          "16" = { enabled = false; };
          "162" = {
            enabled = false;
            value = {
              parameters = [ 65535 96 9961472 ];
              type = "standard";
            };
          };
          "164" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "17" = { enabled = false; };
          "175" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "18" = { enabled = false; };
          "184" = {
            enabled = false;
            value = {
              parameters = [ 53 23 1179648 ];
              type = "standard";
            };
          };
          "19" = { enabled = false; };
          "190" = {
            enabled = false;
            value = {
              parameters = [ 113 12 8388608 ];
              type = "standard";
            };
          };
          "20" = { enabled = false; };
          "21" = { enabled = false; };
          "215" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "216" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "217" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "218" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "219" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "22" = { enabled = false; };
          "222" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "223" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "224" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "225" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "226" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "227" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "228" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "229" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "23" = { enabled = false; };
          "230" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "231" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "232" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "233" = {
            enabled = true;
            value = {
              parameters = [ 109 46 1048576 ];
              type = "standard";
            };
          };
          "235" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "237" = {
            enabled = false;
            value = {
              parameters = [ 102 3 8650752 ];
              type = "standard";
            };
          };
          "238" = {
            enabled = false;
            value = {
              parameters = [ 99 8 8650752 ];
              type = "standard";
            };
          };
          "239" = {
            enabled = false;
            value = {
              parameters = [ 114 15 8650752 ];
              type = "standard";
            };
          };
          "24" = { enabled = false; };
          "240" = {
            enabled = false;
            value = {
              parameters = [ 65535 123 8650752 ];
              type = "standard";
            };
          };
          "241" = {
            enabled = false;
            value = {
              parameters = [ 65535 124 8650752 ];
              type = "standard";
            };
          };
          "242" = {
            enabled = false;
            value = {
              parameters = [ 65535 126 8650752 ];
              type = "standard";
            };
          };
          "243" = {
            enabled = false;
            value = {
              parameters = [ 65535 125 8650752 ];
              type = "standard";
            };
          };
          "244" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "245" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "246" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "247" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "248" = {
            enabled = false;
            value = {
              parameters = [ 65535 123 8781824 ];
              type = "standard";
            };
          };
          "249" = {
            enabled = false;
            value = {
              parameters = [ 65535 124 8781824 ];
              type = "standard";
            };
          };
          "25" = { enabled = false; };
          "250" = {
            enabled = false;
            value = {
              parameters = [ 65535 126 8781824 ];
              type = "standard";
            };
          };
          "251" = {
            enabled = false;
            value = {
              parameters = [ 65535 125 8781824 ];
              type = "standard";
            };
          };
          "256" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "257" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "258" = {
            enabled = false;
            value = {
              parameters = [ 65535 65535 0 ];
              type = "standard";
            };
          };
          "26" = { enabled = false; };
          "260" = {
            enabled = false;
            value = {
              parameters = [ 65535 53 1048576 ];
              type = "standard";
            };
          };
          "27" = {
            enabled = false;
            value = {
              parameters = [ 96 50 1048576 ];
              type = "standard";
            };
          };
          "28" = {
            enabled = false;
            value = {
              parameters = [ 51 20 1179648 ];
              type = "standard";
            };
          };
          "29" = {
            enabled = false;
            value = {
              parameters = [ 51 20 1441792 ];
              type = "standard";
            };
          };
          "30" = {
            enabled = false;
            value = {
              parameters = [ 52 21 1179648 ];
              type = "standard";
            };
          };
          "31" = {
            enabled = false;
            value = {
              parameters = [ 52 21 1441792 ];
              type = "standard";
            };
          };
          "36" = {
            enabled = false;
            value = {
              parameters = [ 65535 103 8388608 ];
              type = "standard";
            };
          };
          "52" = {
            enabled = false;
            value = {
              parameters = [ 100 2 1572864 ];
              type = "standard";
            };
          };
          "53" = {
            enabled = false;
            value = {
              parameters = [ 65535 107 8388608 ];
              type = "standard";
            };
          };
          "54" = {
            enabled = false;
            value = {
              parameters = [ 65535 113 8388608 ];
              type = "standard";
            };
          };
          "57" = {
            enabled = false;
            value = {
              parameters = [ 65535 100 8650752 ];
              type = "standard";
            };
          };
          "59" = {
            enabled = false;
            value = {
              parameters = [ 65535 96 9437184 ];
              type = "standard";
            };
          };
          "60" = {
            enabled = false;
            value = {
              parameters = [ 32 49 262144 ];
              type = "standard";
            };
          };
          "61" = {
            enabled = false;
            value = {
              parameters = [ 32 49 786432 ];
              type = "standard";
            };
          };
          "64" = {
            enabled = false;
            value = {
              parameters = [ 32 49 1048576 ];
              type = "standard";
            };
          };
          "65" = {
            enabled = false;
            value = {
              parameters = [ 32 49 1572864 ];
              type = "standard";
            };
          };
          "7" = {
            enabled = false;
            value = {
              parameters = [ 65535 120 8650752 ];
              type = "standard";
            };
          };
          "79" = { enabled = true; };
          "8" = {
            enabled = false;
            value = {
              parameters = [ 65535 99 8650752 ];
              type = "standard";
            };
          };
          "80" = { enabled = true; };
          "81" = { enabled = true; };
          "82" = { enabled = true; };
          "9" = {
            enabled = false;
            value = {
              parameters = [ 65535 118 8650752 ];
              type = "standard";
            };
          };
          "98" = {
            enabled = false;
            value = {
              parameters = [ 4 4 1179648 ];
              type = "standard";
            };
          };
        };
      };
    };
  };

  # System keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = false;
  };
}
