{
  description = "Example home-manager from non-nixos system";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  # inputs.nixpkgs.url = "path:/home/michael/Repositories/nix/nixpkgs";
  # inputs.nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.LS_COLORS = {
    url = "github:trapd00r/LS_COLORS";
    flake = false;
  };

  outputs = { self, ... }@inputs:
    let
      # nixos-unstable-overlay = final: prev: {
      #   nixos-unstable = import inputs.nixos-unstable {
      #     system = prev.system;
      #     # config.allowUnfree = true;
      #     overlays = [ inputs.emacs-overlay.overlay ];
      #   };
      # };
      overlays = [
        # nixos-unstable-overlay
        (self: super: {
          zsh-powerlevel10k = super.callPackage ./packages/powerlevel10k.nix {};
        })
        (final: prev: { LS_COLORS = inputs.LS_COLORS; })
      ];
    in
    # legacyPackages attribute for declarative channels (used by compat/default.nix)
    inputs.flake-utils.lib.eachDefaultSystem (system:
    {
      legacyPackages = inputs.nixpkgs.legacyPackages.${system};
    }
    ) //
    {
      homeConfigurations = {
        macbook-pro = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, config, ... }:
            {
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
              nixpkgs.config = import ./configs/nix/config.nix;
              nixpkgs.overlays = overlays;
              imports = [
                ./modules/cli.nix
                ./modules/git.nix
                ./modules/languages.nix
                ./modules/home-manager.nix
                ./modules/nix-utilities.nix
                # ./modules/ssh.nix
              ];
              programs.zsh.initExtra = builtins.readFile ./configs/zsh/macbook-pro_zshrc.zsh;
              # xdg.configFile."terminfo".source = ./configs/terminfo/terminfo_mac;
            };
          system = "x86_64-darwin";
          homeDirectory = "/Users/michael";
          username = "michael";
        };
        linux-desktop = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }:
            {
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
              nixpkgs.config = import ./configs/nix/config.nix;
              nixpkgs.overlays = overlays;
              imports = [
                ./modules/cli.nix
                ./modules/git.nix
                ./modules/home-manager.nix
                ./modules/languages.nix
                ./modules/nix-utilities.nix
                # ./modules/linux-only.nix
                # ./modules/ssh.nix
              ];

              programs.zsh.initExtra = builtins.readFile ./configs/zsh/linux-desktop_zshrc.zsh;
              xdg.configFile."alacritty/alacritty.yml".source = ./configs/terminal/alacritty.yml;
            };
          system = "x86_64-linux";
          homeDirectory = "/home/michael";
          username = "michael";
        };
        wsl = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }:
            {
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
              nixpkgs.config = import ./configs/nix/config.nix;
              nixpkgs.overlays = overlays;
              imports = [
                ./modules/cli.nix
                ./modules/git.nix
                ./modules/home-manager.nix
                ./modules/languages.nix
                ./modules/nix-utilities.nix
                # ./modules/linux-only.nix
                # ./modules/ssh.nix
              ];

              programs.zsh.initExtra = builtins.readFile ./configs/zsh/wsl_zshrc.zsh;
              xdg.configFile."alacritty/alacritty.yml".source = ./configs/terminal/alacritty.yml;
            };
          system = "x86_64-linux";
          homeDirectory = "/home/mjlbach";
          username = "mjlbach";
        };
        linux-server = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }:
            {
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
              nixpkgs.config = import ./configs/nix/config.nix;
              nixpkgs.overlays = overlays;
              imports = [
                ./modules/home-manager.nix
                ./modules/cli.nix
                ./modules/git.nix
                # ./modules/linux-only.nix
                ./modules/nix-utilities.nix
              ];
              programs.zsh.initExtra = builtins.readFile ./configs/zsh/linux-server_zshrc.zsh;
            };
          system = "x86_64-linux";
          homeDirectory = "/home/mjlbach";
          username = "mjlbach";
        };
      };
      macbook-pro = self.homeConfigurations.macbook-pro.activationPackage;
      linux-server = self.homeConfigurations.linux-server.activationPackage;
      linux-desktop = self.homeConfigurations.linux-desktop.activationPackage;
    };
}