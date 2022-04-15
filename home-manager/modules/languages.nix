{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    cmake
    (with dotnetCorePackages; combinePackages [
      sdk_3_1
      sdk_5_0
      sdk_6_0
    ])
    nodePackages.pyright
  ];
}