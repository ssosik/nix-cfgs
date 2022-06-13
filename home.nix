{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  homedir = builtins.getEnv "HOME";
  workspace = homedir + "/workspace";

in {
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

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

  programs.command-not-found.enable = true;

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.jq.enable = true;
  programs.ssh = {
    enable = true;
  };
  programs.fzf.enable = true;
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./dot.vimrc;
    plugins = [
      pkgs.vimPlugins.molokai
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-plug
      pkgs.vimPlugins.vim-repeat
      pkgs.vimPlugins.vim-sensible
      pkgs.vimPlugins.vim-surround
      pkgs.vimPlugins.vim-unimpaired
    ];
  };

  home.file.".config/zsh/.p10k.zsh".text = builtins.readFile ./dot.p10k.zsh;
  home.file.".zshrc".text = builtins.readFile ./dot.zshrc;

  programs.zsh = {
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
    envExtra = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    oh-my-zsh = {
      enable = true;
          plugins = [ "git" "history" "taskwarrior" "virtualenv" ];
          theme = "zsh-powerlevel10k/powerlevel10k";
          custom = "${pkgs.zsh-powerlevel10k}/share/";
    };
  };

}
