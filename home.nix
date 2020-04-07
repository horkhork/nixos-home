{ config, pkgs, ... }:

#with import <nixpkgs> {};
#with builtins;
#with lib;
#with import <home-manager/modules/lib/dag.nix> { inherit lib; };

#let
#dotfiles = stdenv.mkDerivation {
#   name = "dotfiles";
#   src = fetchFromGitHub {
#      owner = "horkhork";
#      repo = "dotfiles";
#      rev = "master";
#      sha256 = "ce6d7aa7a26a6b1edf6ab5261c2f982fff2d57fd2e861fb02cc4c21d5ddd9963";
#   };
#   installPhase = ''
#     mkdir -p $out
#   '';
#};
#in {

let
  homedir = builtins.getEnv "HOME";
in {
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";

  home.packages = [
    pkgs.asciidoc
    pkgs.curl
    pkgs.gcc
    pkgs.httpie
    pkgs.k6
    pkgs.pandoc
    pkgs.pv
    pkgs.python3
    pkgs.ripgrep
    pkgs.traceroute
    pkgs.unzip
    pkgs.wget
    #pkgs.zsh
    #pkgs.zsh-powerlevel9k
    pkgs.nerdfonts
  ];

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.command-not-found.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  #programs.go = {
  #  enable = true;
  #};
  
  programs.git = {
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

  #programs.gpg.enable = true;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #programs.info.enable = true;

  programs.jq.enable = true;

  #programs.keychain = {
  #  enable = true;
  #  enableZshIntegration = true;
  #};

  #programs.lesspipe.enable = true;

  #programs.newsboat = {
  #  enable = true;
  #};

  #programs.readline.enable = true;

  #programs.starship = {
  #  enable = true;
  #  #enableZshIntegration = true;
  #  enableBashIntegration = true;
  #};

  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-blue-256";
    dataLocation = "$HOME/.task";
    config = {
      uda.totalactivetime.type = "duration";
uda.totalactivetime.label = "Total active time";
report.list.labels = [ "ID" "Active" "Age" "TimeSpent" "D" "P" "Project" "Tags" "R" "Sch" "Due" "Until" "Description" "Urg" ];
report.list.columns = [ "id" "start.age" "entry.age" "totalactivetime" "depends.indicator" "priority" "project" "tags" "recur.indicator" "scheduled.countdown" "due" "until.remaining" "description.count" "urgency" ];
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      #set -g default-shell /home/ssosik/.nix-profile/bin/zsh
      set -g default-terminal "xterm-256color"
      set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
      set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock
    '';
    keyMode = "vi";
  };
  
  programs.vim = {
    enable = true;
    #extraConfig = builtins.readFile "${dotfiles}/.vimrc";
    extraConfig = builtins.readFile "/home/ssosik/.config/nixpkgs/vimrc";
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

  #programs.zsh = {
  #  enable = true;
  #  enableAutosuggestions = true;
  #  enableCompletion = true;
  #  autocd = true;
  #  dotDir = ".config/zsh";
  #  history = {
  #    extended = true;
  #    save = 100000;
  #    share = true;
  #    size = 100000;
  #  };
  #  localVariables = {
  #    ZSH_TMUX_ITERM2 = true;
  #    POWERLEVEL9K_MODE = "nerdfont-complete";
  #    COMPLETION_WAITING_DOTS = true;
  #    ZSH_CUSTOM = "${pkgs.zsh-powerlevel9k}/share/";
  #  };
  #  oh-my-zsh = {
  #    enable = true;
  #    plugins = [ "git" "history" "taskwarrior" "tmuxinator" "virtualenv" "ssh-agent" ]; # "zsh-autosuggestions" "tmux" 
  #    #theme = "powerlevel9k/powerlevel9k";
  #    #theme = "${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k";
  #    theme = "zsh-powerlevel9k/powerlevel9k";
  #    #theme = "robbyrussell";
  #    #theme = "agnoster";
  #  };
  #};

  #services.gpg-agent = {
  #  enable = true;
  #};

  #services.lorri.enable = true;

}
