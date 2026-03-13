{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      directory = {
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
        truncation_symbol = "…/";
      };
    };
  };
}
