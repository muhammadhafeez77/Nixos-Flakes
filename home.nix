{ config, pkgs, ... }:

{
  home.username = "coffee";
  home.homeDirectory = "/home/coffee";
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos btw";
      nrs = "sudo nixos-rebuild switch";
    };

    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
  
    '';                              
  };


 programs.vim = {                       #### VIM 
   enable = true;
   extraConfig = ''
        set clipboard=unnamedplus
   '';
 };

programs.alacritty ={            #### ALACRITTY
  enable = true;
  settings = {
    window = {
      opacity = 0.96;
      padding = { y = 6; x = 6; };
    };
    font = {
      size = 8;
      normal = {
        family = "JetBrains Mono";
        style = "Regular";
      };
    };
    keyboard.bindings = [
      { key = "V"; mods = "Control"; action = "Paste"; }
      { key = "C"; mods = "Control|Shift"; action = "Copy"; }
    ];
  };
};
#  home.file.".config/qtile".source = /home/tony/home-manager-dotfiles/qtile;

  home.packages = with pkgs; [
    bat
  ];
}

