{ config, pkgs, ... }:

{
  # Importa las configuraciones adicionales del hardware
  imports = [
    ./hardware-configuration.nix
  ];

  # Configuración del bootloader usando GRUB
  boot.loader.grub = {
    enable = true;
    device = "nodev"; # Define que GRUB no se instale en ningun disco (Sistemas EFI).
    efiInstallAsRemovable = true; # Instala la version EFI de GRUB.
    efiSupport = true; # Añade las dependencias necesarias para el soporte de EFI de GRUB.
    useOSProber = true;  # Habilita la detección de otros sistemas operativos.
  };

  # Configuración de la red.
  networking = {
    hostName = "sanctuary"; # Definimos el hostname, el nombre único que identifica a la máquina en la red.
    networkmanager.enable = true; # Habilita NetworkManager para gestionar las conexiones de red.
  };

  # Habilita openGL
  hardware.graphics = {
    enable = true;
  };

  # Configuración del sistema gráfico con X11 y GNOME
  services.xserver = {
    enable = true; # Habilita el sistema de ventanas X11.
    videoDrivers = ["nvidia"]; # Indica que quieres usar el driver de NVIDIA
    displayManager.gdm.enable = true; # Habilita GDM como gestor de sesiones.
    desktopManager.gnome.enable = true; # Habilita GNOME como entorno de escritorio.
    xkb = {
      layout = "us,es"; # Configura el teclado en inglés (US) y español.
      variant = ""; # No hay variantes específicas para el layout en español e inglés (US).
      options = "grp:win_space_toggle"; # Alterna entre los layouts usando Win+Space.
    };
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
  hardware.pulseaudio.enable = false; # Desabilita pulseaudio en caso de estar activado
  security.rtkit.enable = true; # Habilita rtkit para gestión de prioridades en procesos multimedia.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  services.displayManager.autoLogin = {
    enable = true; # Habilita el inicio de sesión automático.
    user = "gabyy"; # Usuario que se inicia automáticamente.
  };

  # Workaround para GNOME autologin
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Paquetes del sistema
  environment.systemPackages = with pkgs; [
    # Developer Packages
    neovim
    gcc
    ripgrep
    fd
    git
    go
    oh-my-zsh
    neofetch
    eza
    # Plugins for Oh My Zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    # User Packages
    brave
    obsidian
    steam
    discord
  ];

  # Instalacion de fuentes
  fonts.packages = with pkgs;
  [
    iosevka
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
    ohMyZsh.theme = "kardan"; # El tema para Oh My Zsh.
    autosuggestions.enable = true; # Habilita autosuggestions.
    syntaxHighlighting.enable = true; # Habilita syntax highlighting.
  };

  # Habilita paquetes no libres
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # Versión de NixOS
}
