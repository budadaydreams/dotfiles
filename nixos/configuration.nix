# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
      <catppuccin/modules/nixos>
    ];

  # Bootloader.
  boot = {
	kernelPackages = pkgs.linuxPackages_latest;
  	loader = {
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/boot";
		};
		grub = {
			enable = true;
			devices = [ "nodev" ];
			efiSupport = true;
			useOSProber = true;
			configurationLimit = 5;
                        gfxmodeEfi = "1920x1080";
  		};
	timeout = 5;
	};
  };

  # Command shell
  programs.zsh = {
  	enable = true;
        enableCompletion = true;
  #	autosuggestion.enable = true;
  	syntaxHighlighting.enable = true;

  	shellAliases = {
    		ll = "ls -l";
    		update = "sudo nixos-rebuild switch";
  	};
  };  
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable OpenGL
    hardware.graphics = {
    enable = true;
    enable32Bit = true;
    };

  # XDG portals
  xdg.portal = {
  	enable = true;
  	extraPortals = [pkgs.xdg-desktop-portal-gtk];
  }; 

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    
    # Optimus PRIME
    
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
	# Make sure to use the correct Bus ID values for your system!
	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
        # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
    };    

  };

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
  	enable = true;
  	alsa.enable = true;
#  	alsa.support32bit = true;
  	pulse.enable = true;
  	jack.enable = true;
  };
  
  # Hyprland
  programs = {
  	hyprland = {
  		enable = true;
  		xwayland.enable = true;
  	};
  	waybar = {
  		enable = true;
  	};
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Touchpad
  services.libinput.enable = true; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.guto = {
    isNormalUser = true;
    description = "guto";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [

  wget
  git
  neovim
  kitty 
  fish

  vulkan-tools
  networkmanagerapplet
  brightnessctl
  rofi-wayland

  appimage-run
  pavucontrol
  qbittorrent
  pcmanfm  
  librewolf

  wineWowPackages.stable
  winetricks
  wineWowPackages.waylandFull 
];

# Flatpak
services.flatpak.enable = true;

# Steam

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  gamescopeSession.enable = true;
};

  # Fonts
  fonts.packages = with pkgs; [

  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

# USB Automounting

  services.gvfs.enable = true;

}
