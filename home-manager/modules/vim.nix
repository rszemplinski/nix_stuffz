{ config, pkgs, libs, ... }:
{
    programs.vim = {
    enable = true;
    settings = { ignorecase = true; };
    extraConfig = ''
      set mouse=a
      set number
    '';
  };
}