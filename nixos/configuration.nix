
{
  config, pkgs, sources, ...
}:
let
  glide-bin-unwrapped = pkgs.callPackage ./glide.nix {};
  glide = pkgs.wrapFirefox glide-bin-unwrapped {};

  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-26.05.tar.gz";
    sha256 = "0x126xqaw6vqz27sp0w1vl58a90whrs9y7nsa1hkvr150y8j2m0w";
  }) { system = "x86_64-linux"; };

  hjem = import sources.hjem { };
in
  {

  imports =
    [
      ./hardware-configuration.nix
      hjem.nixosModules.default
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x450"
  ];

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = false;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Flatpak
  services.flatpak.enable = true;
  
  # Niri
  programs.niri.enable = true;
  programs.dux-shell.enable = true;

  programs.fish.enable = true;
  services.upower.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.programs.niri.package}/bin/niri-session";
        user = "greeter";
      };
    };
  };

  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [ 41641 ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.jack = {
    jackd.enable = true;
  };

  users.users."mysko" = {
    isNormalUser = true;
    description = "mysko";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  hjem.users.mysko = {
    enable = true;
    directory = "/home/mysko";
  };

  users.users.mysko.shell = pkgs.fish;

  programs.firefox.enable = true;
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.gamemode.enable = true;

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    npins

	# editor
    neovim
    vscode
    emacs-pgtk

    direnv
    nix-direnv

    ripgrep
    coreutils
    zsh-autosuggestions

  # niri
    alacritty
    fuzzel
    xwayland-satellite
    papirus-icon-theme
    bibata-cursors
    hyprlock

    kitty
    yazi
    sshfs
    cheese
    nwg-look
    pavucontrol
    wl-clipboard
    brightnessctl
    bluetui
    fastfetch

    unzip

    glide

	# social
    discord
    vesktop

	# notes
    obsidian
    libreoffice

	# gaming
    prismlauncher

  # gamedev
    godot

  # editing
    gimp

  #music
    nicotine-plus
    kew
    feishin

	# etc
    texliveSmall

  # school
    kicad
  ];

  fonts.packages = with pkgs; [
     nerd-fonts.fira-code
     nerd-fonts.symbols-only
     nerd-fonts.space-mono
     font-awesome
     julia-mono
];

  system.stateVersion = "26.05";
}
