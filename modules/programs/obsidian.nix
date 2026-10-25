{ pkgs, config, ... }:

{
  programs.obsidian = {
    enable = true;

    vaults."Documents/Obsidian/master".enable = true;

    defaultSettings = {
      app = {
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

      communityPlugins = [];

      hotkeys = {
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
