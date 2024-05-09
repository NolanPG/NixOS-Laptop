# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gaming.nix
      ./network.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    # Setting latest stable Linux Kernel from kernel.org
    kernelPackages = pkgs.linuxPackages_latest;

    # ENABLING NTFS (FOR KDE PARTITION MANAGER)
    supportedFilesystems = [ "ntfs" ];

    loader = {
      grub = {
        enable =true;
        devices = [ "nodev" ];
        efiSupport = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Enabling SOUND
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  services.xserver.enable = true;
  programs.xwayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  programs.dconf.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
    # Force GTK apps to use QT FM for opening folders
    # gtkUsePortal = true;
  };

  #ENABLING FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    libsForQt5.kservice # kbuildsycoca5

    # Packages normally included in other distros by default
    lshw 

    qdirstat

    kdePackages.appstream-qt # libsForQt5 is replaced by kdePackages to keep coherence for Plasma 6 naming

    # peazip # Free Zip / Unzip software and Rar file extractor. Cross-platform file and archive manager.

    # Ark Extraction dependencies
    libarchive
    libzip
    p7zip
    unrar
    zlib
    unzip

    # Firefox dependencies
    ffmpeg_7-full
    mailcap # Helper application and MIME type associations for file types
 
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        catppuccin.catppuccin-vsc
        pkief.material-product-icons

        #CPP
        ms-vscode.cpptools
        adpyke.codesnap

        #RUST
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
      ];
    })

  ];

  environment.variables = {
    # Force GTK apps to use Dolphin for opening folders (same as gtkUseePortal = true; but for some reason that's deprecated)
    GTK_USE_PORTAL = "1";
  };

  # Configure flatpaks
  services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enabling Docker virtualization
  virtualisation.docker.enable = true;

  # Setting up fonts
  fonts = {
    packages = with pkgs; [
      ibm-plex
      meslo-lgs-nf
    ];

    fontconfig.defaultFonts = {
      serif = [ "IBM Plex Sans" ];
      sansSerif = [ "IBM Plex Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs = {
      partition-manager.enable = true;

      # Setting up oh-my-zsh
      zsh = {
        enable = true;
        enableBashCompletion = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

        ohMyZsh = {
          enable = true;
          plugins = [
            "sudo"
            "git"
          ];
        };
      };

      # Configuring FireFox
      firefox = {
        package = pkgs.firefox;
        enable = true;
        preferences = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };
    };

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # ALIASES
  environment.shellAliases = {
    ll = "ls -l";
    ls = "ls --color=tty";
    nix-search = "nix --extra-experimental-features \"nix-command flakes\" search nixpkgs";
    neofetch = "fastfetch";
    nixos-config = "codium /home/nolan/.dotfiles";
    nixos-switch = "sudo nixos-rebuild switch --flake /home/nolan/.dotfiles && home-manager switch --flake /home/nolan/.dotfiles && kbuildsycoca5";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nolan.isNormalUser = true;
  users.users.nolan.extraGroups = [ "networkmanager" "wheel" "docker" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older ` NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

