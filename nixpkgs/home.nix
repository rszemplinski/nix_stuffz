{ config, pkgs, lib, ... }:
let
  inherit (pkgs.hax) fetchFromGitHub;

  personalEmail = "rszemplinski22@gmail.com";
  workEmail = "ryan.szemplinski@pieinsurance.com";
  firstName = "Ryan";
  lastName = "Szemplinski";
  home = (builtins.getEnv "HOME");
  username = (builtins.getEnv "USER");
  symbol = "ᛥ";

  # chief keefs stuff
  kwbauson-cfg = import <kwbauson-cfg>;

  coinSound = pkgs.fetchurl {
    url = "https://hexa.dev/static/sounds/coin.wav";
    sha256 = "18c7dfhkaz9ybp3m52n1is9nmmkq18b1i82g6vgzy7cbr2y07h93";
  };
  guhSound = pkgs.fetchurl {
    url = "https://hexa.dev/static/sounds/guh.wav";
    sha256 = "1chr6fagj6sgwqphrgbg1bpmyfmcd94p39d34imq5n9ik674z9sa";
  };
  bruhSound = pkgs.fetchurl {
    url = "https://hexa.dev/static/sounds/bruh.mp3";
    sha256 = "11n1a20a7fj80xgynfwiq3jaq1bhmpsdxyzbnmnvlsqfnsa30vy3";
  };

in
with pkgs.hax; {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = home;

    stateVersion = "21.05";

    sessionVariables = {
      EDITOR = "nano";
      HISTCONTROL = "ignoreboth";
      PAGER = "less";
      LESS = "-iR";
      BASH_SILENCE_DEPRECATION_WARNING = "1";
    };

    packages = with lib;
      with pkgs;
      lib.flatten [
        (python3.withPackages (pkgs: with pkgs; [ black mypy bpython ipdb ]))
        atool
        bash-completion
        bashInteractive_5
        bat
        bc
        bzip2
        cachix
        coreutils-full
        cowsay
        curl
        deno
        diffutils
        ed
        exa
        fd
        file
        figlet
        gawk
        gcc
        gitAndTools.delta
        gnumake
        gnugrep
        gnused
        gnutar
        gron
        gzip
        jq
        less
        libarchive
        libnotify
        lolcat
        loop
        lsof
        man-pages
        moreutils
        nano
        ncdu
        netcat-gnu
        nix-direnv
        nix-bash-completions
        nix-index
        nix-info
        nix-prefetch-github
        nix-prefetch-scripts
        nix-tree
        nixpkgs-fmt
        nmap
        openssh
        p7zip
        patch
        perl
        php
        pigz
        pssh
        procps
        pv
        ranger
        re2c
        ripgrep
        ripgrep-all
        rlwrap
        rnix-lsp
        rsync
        scc
        sd
        shellcheck
        shfmt
        socat
        sox
        swaks
        tealdeer
        time
        unzip
        vim
        wget
        which
        xxd
        xz
        zip
        binutils
        (writeShellScriptBin "hms" ''
          git -C ~/.config/nixpkgs/ pull origin main
          home-manager switch
        '')
        (soundScript "coin" coinSound)
        (soundScript "guh" guhSound)
        (soundScript "bruh" bruhSound)
      ];

    file.sqliterc = {
      target = ".sqliterc";
      text = ''
        .output /dev/null
        .headers on
        .mode column
        .prompt "> " ". "
        .separator ROW "\n"
        .nullvalue NULL
        .output stdout
      '';
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
        mkdir = "mkdir -pv";
        hm = "home-manager";

        # misc
        space = "du -Sh | sort -rh | head -10";
        now = "date +%s";
        fzfp = "fzf --preview 'bat --style=numbers --color=always {}'";
    };
    history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" "systemd" ];
        theme = "robbyrussell";
    };
  };

  programs.direnv = {
    enable = true;
  };

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = rec {
        success_symbol = "[${symbol}](bright-green)";
        error_symbol = "[${symbol}](bright-red)";
      };
      directory.style = "fg:#d442f5";
      nix_shell = {
        pure_msg = "";
        impure_msg = "";
        format = "via [$symbol$state]($style) ";
      };

      # disabled plugins
      aws.disabled = true;
      cmd_duration.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
    };
  };

  programs.htop.enable = true;
  programs.dircolors.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "${firstName} ${lastName}";
    userEmail = personalEmail;
    extraConfig = {
      color.ui = true;
      push.default = "simple";
      pull.ff = "only";
      core = {
        editor = "nano";
        pager = "delta --dark";
      };
    };
  };
}