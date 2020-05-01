{ pkgs, ... }:
{
    home.packages = [
      pkgs.asciidoc
      pkgs.curl
      pkgs.gcc
      pkgs.go
      pkgs.httpie
      pkgs.k6
      pkgs.pandoc
      pkgs.pv
      pkgs.python3
      pkgs.ripgrep
      pkgs.traceroute
      pkgs.unzip
      pkgs.wget
      pkgs.zsh-powerlevel10k
      pkgs.nerdfonts
      pkgs.terraform
      pkgs.vault
    ];

    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      git = {
        enable = true;
        userName = "Steve Sosik";
        userEmail = "ssosik@akamai.com";
        aliases = {
          lg = "log --graph --oneline --decorate --all";
          com = "commit -v";
          fet = "fetch -v";
          co = "!git checkout $(git branch | fzf-tmux -r 50)";
          a = "add -p";
          pu = "pull --rebase=true origin master";
          ignore = "update-index --skip-worktree";
          unignore = "update-index --no-skip-worktree";
          hide = "update-index --assume-unchanged";
          unhide = "update-index --no-assume-unchanged";
          showremote = "!git for-each-ref --format=\"%(upstream:short)\" \"$(git symbolic-ref -q HEAD)\"";
          prune-merged = "!git branch -d $(git branch --merged | grep -v '* master')";
        };
        extraConfig = {
          core = {
            editor = "vim";
            fileMode = "false";
            filemode = "false";
          };
          push = {
            default = "simple";
          };
          merge = {
            tool = "vimdiff";
            conflictstyle = "diff3";
          };
          pager = {
            branch = "false";
          };
          credential = {
            helper = "cache --timeout=43200";
          };
        };
      };

      #gpg.enable = true;

      ## Let Home Manager install and manage itself.
      #home-manager.enable = true;

      #info.enable = true;

      jq.enable = true;

      #keychain = {
      #  enable = true;
      #  enableZshIntegration = true;
      #};

      #programs.lesspipe.enable = true;

      #newsboat = {
      #  enable = true;
      #};

      #readline.enable = true;

      taskwarrior = {
        enable = true;
        colorTheme = "dark-blue-256";
        dataLocation = "$HOME/.task";
        config = {
          uda.totalactivetime.type = "duration";
          uda.totalactivetime.label = "Total active time";
          report.list.labels = [ "ID" "Active" "Age" "TimeSpent" "D" "P" "Project" "Tags" "R" "Sch" "Due" "Until" "Description" "Urg" ];
          report.list.columns = [ "id" "start.age" "entry.age" "totalactivetime" "depends.indicator" "priority" "project" "tags" "recur.indicator" "scheduled.countdown" "due" "unti  l.remaining" "description.count" "urgency" ];
        };
      };

      #tmux = {
      #  enable = true;
      #  extraConfig = ''
      #    set -g default-shell /home/ssosik/.nix-profile/bin/zsh
      #    set -g default-terminal "xterm-256color"
      #    #set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
      #    set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock
      #    set -g update-environment "SSH_AUTH_SOCK"
      #  '';
      #  keyMode = "vi";
      #};

      vim = {
        enable = true;
        extraConfig = builtins.readFile "/etc/nixos/dot.vimrc";
        #settings = {
        #   relativenumber = true;
        #   number = true;
        #};
        plugins = [
          pkgs.vimPlugins.Jenkinsfile-vim-syntax
          pkgs.vimPlugins.ale
          pkgs.vimPlugins.ansible-vim
          pkgs.vimPlugins.calendar-vim
          pkgs.vimPlugins.direnv-vim
          pkgs.vimPlugins.emmet-vim
          pkgs.vimPlugins.fzf-vim
          pkgs.vimPlugins.goyo-vim
          pkgs.vimPlugins.jedi-vim
          pkgs.vimPlugins.jq-vim
          pkgs.vimPlugins.molokai
          pkgs.vimPlugins.nerdcommenter
          pkgs.vimPlugins.nerdtree
          pkgs.vimPlugins.nerdtree-git-plugin
          pkgs.vimPlugins.rust-vim
          pkgs.vimPlugins.tabular
          pkgs.vimPlugins.vim-airline
          pkgs.vimPlugins.vim-airline-themes
          pkgs.vimPlugins.vim-devicons
          pkgs.vimPlugins.vim-eunuch
          pkgs.vimPlugins.vim-fugitive
          pkgs.vimPlugins.vim-gitgutter
          pkgs.vimPlugins.vim-go
          pkgs.vimPlugins.vim-markdown
          pkgs.vimPlugins.vim-multiple-cursors
          pkgs.vimPlugins.vim-nix
          pkgs.vimPlugins.vim-plug
          pkgs.vimPlugins.vim-repeat
          pkgs.vimPlugins.vim-sensible
          pkgs.vimPlugins.vim-speeddating
          pkgs.vimPlugins.vim-surround
          pkgs.vimPlugins.vim-terraform
          pkgs.vimPlugins.vim-unimpaired
        ];
      };

      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        autocd = true;
        dotDir = ".config/zsh";
        history = {
          extended = true;
          save = 50000;
          share = true;
          size = 50000;
        };
        #localVariables = {
        #  #ZSH_TMUX_ITERM2 = true;
        #  #POWERLEVEL9K_MODE = "nerdfont-complete";
        #  #COMPLETION_WAITING_DOTS = true;
        #  #ZSH_CUSTOM = "${pkgs.zsh-powerlevel9k}/share/";
        #  #POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
        #  #SSH_AUTH_SOCK = ".ssh/ssh_auth_sock";
        #};
        #envExtra = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "history" "taskwarrior" "virtualenv" ]; # "zsh-autosuggestions" "tmux" "tmuxinator" "ssh-agent" 
          theme = "zsh-powerlevel10k/powerlevel10k";
          custom = "${pkgs.zsh-powerlevel10k}/share/";
        };
        #initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        #initExtraBeforeCompInit = builtins.readFile ../../config/zsh/.zshrc;
        #plugins = [ {
        #  name = "powerlevel10k";

        #  #src = pkgs.fetchFromGitHub {
        #  #  owner = "romkatv";
        #  #  repo = "powerlevel10k";
        #  #  rev = "v1.5.0";
        #  #  sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        #  #};

        #  #src = builtins.fetchGit {
        #  #  url = "https://github.com/romkatv/powerlevel10k.git";
        #  #  rev = "6a0e7523b232d02854008405a3645031c848922b";
        #  #  ref = "v1.5.0";
        #  #};

        #  src = pkgs.zsh-powerlevel10k;
        #  file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
        #];
      };

    }; # End programs

    home.file.".p10k.zsh".text = builtins.readFile "/etc/nixos/dot.p10k.zsh";

  }
