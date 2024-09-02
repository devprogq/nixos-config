{ config, pkgs, ... }:

{
  # Importa las configuraciones adicionales del hardware
  imports = [
    ./hardware-configuration.nix
  ];

  # Configuración del bootloader usando GRUB
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; # Define el disco en el que se instalará GRUB.
    useOSProber = true;  # Habilita la detección de otros sistemas operativos.
  };

  # Configuración de la red.
  networking = {
    hostName = "sanctuary"; # Definimos el hostname, el nombre único que identifica a la máquina en la red.
    networkmanager.enable = true; # Habilita NetworkManager para gestionar las conexiones de red.
  };

  # Habilita openGL
  hardware.opengl = {
    enable = true;
  };

  # Habilitar polkit
  security.polkit.enable = true;
  
  # Activacion de hyprland
  programs.hyprland = {
    # Instala los paquetes de nixpkgs
    enable = true;
    # Habilita Xwayland
    xwayland.enable = true;
  };

  # Configuraciones adicionales de Wayland
  environment.sessionVariables = {
    # Apps basadas en electron usen wayland
    NIXOS_OZONE_WL = "1";
  };

  # Portales del escritorio - xdg
  xdg.portal = {
    enable = true; 
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Portal para configurar los temas
  };

  hardware.nvidia = {
    modesetting.enable = true; # Modesetting es obligatorio para que funcione el driver
    # powerManagement.enable = false; # Activa el powerManagement si cuando la abris de suspension se corrompe los graficos
    powerManagement.finegrained = false; # Apaga los ventiladores cuando no tiene mucho uso (70º +)
    open = false; # el modulo kernel NVidia open source, no confundir con nouveau, experimental y con algunas placas especificas. revisar https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    nvidiaSettings = true; # El menu de configuracion de NVidia
    package = config.boot.kernelPackages.nvidiaPackages.production; # Version de los drivers que instala el paquete, production instala 550
  };

  # Configuración de localización e idioma
  time.timeZone = "America/Argentina/Buenos_Aires"; # Define la zona horaria.
  i18n.defaultLocale = "es_AR.UTF-8"; # Define el idioma por defecto.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };
  console.keyMap = "es"; # Configura el teclado de la consola en español.

  # Configuración de sonido usando PipeWire
  sound.enable = true;
  security.rtkit.enable = true; # Habilita rtkit para gestión de prioridades en procesos multimedia.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Configuración de Bluetooth
  hardware.bluetooth.enable = true;

  # Configuración de un usuario normal
  users.users.gabyy = {
    isNormalUser = true;
    shell = pkgs.zsh; # Usa Zsh como shell predeterminado.
    description = "gabyy"; # Descripción del usuario.
    extraGroups = [ "networkmanager" "wheel" ]; # Permite acceso a sudo y NetworkManager.
  };

  # Habilita sddm en wayland
  services.displayManager.sddm.wayland.enable = true;
 
  # autoLogin
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "gabyy";
  };

  # Workaround para GNOME autologin
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Paquetes del sistema
  environment.systemPackages = with pkgs; [
    # System Packages
    hyprland
    waybar	# Barra de estado / json - css
    wofi	# Lanzador de aplicaciones / gtk rofi version 
    grim	# Herramienta de PrintScr
    slurp	# Selector de area para grim
    swaylock	# Bloqueo de pantalla
    swww	# Fondo de pantalla
    mako	# Notificaciones
    gvfs	# Soporte de archivos virtuales
    dunst	# Notificaciones
    xdg-desktop-portal-hyprland
    dconf
    kitty 	# temporal
    sddm	# display manager
    # Nvidia specifics
    egl-wayland # Para habilitar compatibilidad con EGL API y el protocolo wayland
    # Developer Packages
    neovim
    gcc
    ripgrep
    fd
    git
    alacritty 
    go
    oh-my-zsh
    neofetch
    eza
    wget
    postman
    # Plugins for Oh My Zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    # User Packages
    brave
    obsidian
    steam
    discord
    # Dependencies
    libnotify # Para mako & dunst
  ];

  # Instalacion de fuentes para hyprland
  fonts.packages = with pkgs; 
  [
    iosevka
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
  ];

  # Habilita CUPS para imprimir documentos.
  services.printing.enable = true;

  # Habilita Neovim
  programs.neovim.enable = true;
  
  # Configuración de Zsh
  programs.zsh = {
    enable = true; # Habilita Zsh.
    ohMyZsh.enable = true; # Habilita Oh My Zsh.
    ohMyZsh.theme = "kardan";
    autosuggestions.enable = true; # Habilita autosuggestions.
    syntaxHighlighting.enable = true; # Habilita syntax highlighting.
  };

  # Habilita paquetes no libres
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # Versión de NixOS
}
