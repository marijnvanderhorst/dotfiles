{ pkgs, config, ... }:

{
  programs.obsidian = {
    enable = true;

    vaults."Documents/Obsidian/master".enable = true;

    defaultSettings = {
      app = {
        #        defaultViewMode = "preview";
        #        livePreview = false;
        readableLineLength = true;
        showLineNumber = true;
        tabSize = 4;
      };

      corePlugins = [
        "bookmarks"
        {
          name = "canvas";
          settings = {
            newFileLocation = "folder";
            newFileFolderPath = "Inbox";
            defaultWheelBehavior = "zoom";
          };
        }
      ];

      communityPlugins = [
        #        {
        #          pkg = pkgs.callPackage ./config/plugins/custom-sort { };
        #          options = {
        #            suspended = false;
        #            statusBarEntryEnabled = false;
        #            notificationsEnabled = false;
        #            customSortContextSubmenu = false;
        #            bookmarksGroupToConsumeAsOrderingReference = "Sort";
        #            bookmarksContextMenus = false;
        #          };
        #        }
      ];

      #      cssSnippets = [ ./config/snippets/file-explorer-separators.css ];

      #      themes = [ (pkgs.callPackage ./config/themes/minimal { }) ];

      hotkeys = {
        #        "command-palette:open" = [{ key = "F1"; }];
        #        "app:open-help" = [ ];
        "editor:swap-line-down" = [
          {
            modifiers = [
              "Alt"
              "Shift"
            ];
            key = "ArrowDown";
          }
        ];
      };
    };
  };
}
