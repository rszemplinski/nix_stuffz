{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    (python39.withPackages (ps: with ps; [ pip ]))
  ];
}