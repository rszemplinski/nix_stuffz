{ config, pkgs, libs, ... }:
{
  home.stateVersion = "21.05";

  programs.home-manager.enable = true;
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];

  home.sessionVariables = {
    # LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    NIX_PATH = "nixpkgs=$HOME/Repositories/nix/nix-dotfiles/home-manager/compat";
  };
}