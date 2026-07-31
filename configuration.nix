{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network Manager ( For WIFI )
  networking.hostName = "nixos-btw"; # Hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Karachi"; # CHange time for your secific zone

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable the X11 windowing system.

  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    displayManager.sessionCommands = ''
      	xset r rate 200 35 &
      	'';
  };

  # OXWN
  services.xserver.windowManager.oxwm.enable = true;

  # Version Control Builds
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.coffee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" "plugdev" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "*";


  programs.firefox.enable = true;

  # Required services for USB mounting and volume management
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gvfs ];
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true; # thumbnail support (optional but nice)

  # Ensure Thunar and its volume manager plugin are enabled
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    pkgs.thunar-archive-plugin
    pkgs.thunar-volman
  ];

  #Notification - daemon

  services.dunst.enable = true;
  services.atd.enable = true;

  programs.slock.enable = true;
  # List packages installed in system profile.
  # To search for packages , run ,  nix search wget
  # You can use https://search.nixos.org/ to find more packages (and options).

  #==========  PACKAGES ARE ADDED HERE BUT I'VE PUT THEM IN packages.nix AND IMPORTED INTO home.nix =====================
  environment.systemPackages = with pkgs; [
    nano
    vim-full
    neovim
  ];

  # Add Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  #Set FZF as Reverse search in terminal
  programs.bash.interactiveShellInit = ''
    source ${pkgs.fzf}/share/fzf/completion.bash
    source ${pkgs.fzf}/share/fzf/key-bindings.bash
  '';

  # So that sudo vim also yanks properly 
  security.sudo.extraConfig = ''
    Defaults env_keep += "DISPLAY XAUTHORITY"
  ''; # I also put vim to yank in sudo , in home.nix . I dunno which one works but 
  # If something is working , don't disturb it.  >>> '. .' <<< HEHE

  #Enable Picom for transparency 
  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };

  # ============ Pushing all the things i dont need for the moment at bottom . It'll be a hassle to write them again. ==============

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;


  # ===============================================================          ================================================================== 

  # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment? Probably :)

}

