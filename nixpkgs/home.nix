{ config, pkgs, lib, ... }:
let
  inherit (pkgs.hax) fetchFromGitHub;

  personalEmail = "rszemplinski22@gmail.com";
  workEmail = "ryan.szemplinski@pieinsurance.com";
  firstName = "Ryan";
  lastName = "Szemplinski";
  home = (builtins.getEnv "HOME");
  username = (builtins.getEnv "USER");

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
      EDITOR = "vim";
      HISTCONTROL = "ignoreboth";
      PAGER = "less";
      LESS = "-iR";
    };

    packages = with lib;
      with pkgs;
      lib.flatten [
        (python3.withPackages (pkgs: with pkgs; [ black mypy bpython ipdb ]))
        atool
        bat
        bc
        bzip2
        cachix
        coreutils-full
        cowsay
        curl
        cmake
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
        zsh
        binutils
        (writeShellScriptBin "hms" ''
          git -C ~/.config/nixpkgs/ pull origin main
          home-manager switch
        '')
        (soundScript "coin" coinSound)
        (soundScript "guh" guhSound)
        (soundScript "bruh" bruhSound)
      ];
  };

  programs.zsh = {
    enable = true;
    inherit (config.home) sessionVariables;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;

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
        plugins = [ "git" "sudo" "thefuck" "systemd"];
        theme = "powerlevel10k/powerlevel10k";
    };

    plugins = [
      {
        name = "nix-shell";
        src = fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "03a1487655c96a17c00e8c81efdd8555829715f8";
          sha256 = "1avnmkjh0zh6wmm87njprna1zy4fb7cpzcp8q7y03nw3aq22q4ms";
        };
      }
      {
        name = "zsh-completions";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.27.0";
          sha256 = "1c2xx9bkkvyy0c6aq9vv3fjw7snlm0m5bjygfk5391qgjpvchd29";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "db6cac391bee957c20ff3175b2f03c4817253e60";
          sha256 = "0d9nf3aljqmpz2kjarsrb5nv4rjy8jnrkqdlalwm2299jklbsnmw";
        };
      }
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "b7d90c84671183797bdec17035fc2d36b5d12292";
          sha256 = "0nzvshv3g559mqrlf4906c9iw4jw8j83dxjax275b2wi8ix0wgmj";
        };
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = ".p10k.zsh";
      }
    ];

    initExtraFirst = ''
      set +h
      export DO_NOT_TRACK=1

      export NVM_DIR="$HOME/.nvm"
      export PNPM_HOME="/home/tendie_chef/.local/share/pnpm"
      export PATH=~/.npm-global/bin:$PATH
      export PATH="$PNPM_HOME:$PATH"
      export PATH=/home/tendie_chef/.nimble/bin:$PATH

      # checks to see if we are in a windows or linux dir
      function isWinDir {
        case $PWD/ in
            /mnt/*) return $(true);;
            *) return $(false);;
        esac
      }
      # wrap the git command to either run windows git or linux
      function git {
        if isWinDir
        then
            git.exe "$@"
        else
            /usr/bin/git "$@"
        fi
      }
    '';

    initExtra = ''
      if [[ -r "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh" ]]; then
        source "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh"
      fi

      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  programs.vim = {
    enable = true;
    settings = { ignorecase = true; };
    extraConfig = ''
      set mouse=a
      set number
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
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
        editor = "vim";
        pager = "delta --dark";
      };
    };
  };
}