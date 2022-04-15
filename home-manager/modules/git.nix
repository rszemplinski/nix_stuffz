{ config, pkgs, libs, ... }:
let {
  email = "rszemplinski22@gmail.com";
  firstName = "Ryan";
  lastName = "Szemplinski";
}
in {
  home.packages = with pkgs; [
    gitAndTools.delta
  ];
  home.file.".config/git/ignore".text = ''
    tags
    result
    .envrc
  '';
    
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "${firstName} ${lastName}";
    userEmail = email;
    extraConfig = {
      color.ui = true;
      push.default = "simple";
      pull.ff = "only";
      core = {
        editor = "vim";
        pager = "delta --dark";
      };
    };
  };
}