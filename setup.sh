#!/bin/bash

# Pinkhypr By f3l3p1n0 --> https://www.youtube.com/@f3l3p1n0

# PAQUETES YAY

install_packages_yay=(
    hyprland 
    wezterm 
    waybar 
    swaylock-effects 
    wl-clip-persist  
    swappy 
    grim 
    slurp 
    nemo 
    firefox
    pamixer 
    pavucontrol 
    brightnessctl  
    papirus-icon-theme
    zsh 
    lsd 
    bat 
    zsh-syntax-highlighting 
    zsh-autosuggestions 
    swayidle 
    xautolock 
    hyprpaper
    neofetch 
    megatools 
    wget 
    unzip
    jq
    gtk-layer-shell
    gtk3
    gjs
    gnome-bluetooth-3.0
    w3m
    imagemagick
    rustup
)

# VARIABLE PARA GUARDAR LOS LOGS DE CADA INSTALACIÓN

INSTLOG="install.log"

# PRESENTACIÓN

function present() {
    array=(
        "\n"
        "\040\040\040\040\040\040#####\040\040\040#\040\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#####\040\040\040#####\n"
        "\040\040\040\040\040\040#\040\040\040#\040\040\040#\040\040\040\040##\040\040#\040\040\040#\040\040#\040\040\040\040#\040\040\040#\040\040\040\040#\040#\040\040\040\040#\040\040\040#\040\040\040#\040\040\040#\n"
        "\040\040\040\040\040\040#####\040\040\040#\040\040\040\040#\040#\040#\040\040\040#\040#\040\040\040\040\040#####\040\040\040\040\040#\040\040\040\040\040#####\040\040\040#####\n"
        "\040\040\040\040\040\040#\040\040\040\040\040\040\040#\040\040\040\040#\040\040##\040\040\040#\040\040#\040\040\040\040#\040\040\040#\040\040\040\040#\040\040\040\040\040\040#\040\040\040\040\040\040\040#\040\040#\040\n"
        "\040\040\040\040\040\040#\040\040\040\040\040\040\040#\040\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040#\040\040\040\040\040\040\040#\040\040\040\040\040\040\040#\040\040\040#\n"
        "\n"
        "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040b"
        "y\040"
        "f"
        "3"
        "l"
        "3"
        "p"
        "1"
        "n"
        "0"
	"&"
	"x"
	"i"
	"r"
	"u"
	"z\n"
    )

    for letter in ${array[@]}; do
    echo -en "\e[95m$letter\e[0m"
    sleep 0.2
    done
}

# PROGRESS BAR SHOWN TO THE USER

function show_progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -n "."
        sleep 2
    done
    echo -en "\e[32mOK\e[0m"
    sleep 2
}

# FUNCTION IN CHARGE OF INSTALLING PACKAGES AND DEPENDENCIES

function install_software() {
    echo -en $1
    yay -S --noconfirm $1 &>> $INSTLOG &
    show_progress $!

    # here we check that everyting has been installed correctly
    if yay -Q $1 &>> /dev/null ; then
        echo -e ""
    else
        # if something has not been installed correct an error message will be printed
        echo -e "$1 has not been installed correctly, please check install.log"
        exit 0
    fi
}

# UPDATE SYSTEM

function update() {
    echo -en "Updating the system."
    sudo pacman -Syu --noconfirm &>> $INSTLOG &
    show_progress $!
    echo -en "\n"
}

# INSTALLING YAY PACKAGE MANAGER

function packagemanager() {
    if [ ! -f /sbin/yay ]; then  
        echo -en "Installed yay."
        git clone https://aur.archlinux.org/yay-git &>> $INSTLOG
        cd yay-git
        makepkg -si --noconfirm &>> ../$INSTLOG &
        show_progress $!
        if [ -f /sbin/yay ]; then
            :
        else
            echo -e "Yay installtion h as failed, please read the install.log file"
            exit 0
        fi
    fi
}

# SETUP

function setup() {
    echo -e "\n"
    echo -en "\e[33m[x] Installing Yay packages...\e[0m\n"
    for SOFTWR in ${install_packages_yay[@]}; do
        if [ "$SOFTWR" == 'rustup' ]; then
            sudo pacman -R --noconfirm rust > /dev/null 2>&1
            install_software $SOFTWR
        else
            install_software $SOFTWR 
        fi
    done

    echo -en "\n"
    echo -en "\e[33m[x] Installing eww bar...\e[0m\n"
    echo -en "eww."
    cd "$HOME"
    git clone https://github.com/elkowar/eww &>> $INSTLOG
    cd eww
    cargo build --release --no-default-features --features=wayland &>> ../$INSTLOG &
    show_progress $!
    cd target/release
    echo -en "\n"
    sudo ln -sf $HOME/eww/target/release/eww /usr/local/bin
}

# SE COPIAN LOS DOTFILES

function copia() {
    echo -en "\n"
    echo -en "\e[33m[x] Copying configuration...\e[0m\n"
    echo -en "dotfiles."

    mkdir "$HOME/.config" > /dev/null 2>&1

    rm -rf "$HOME/.config/neofetch" > /dev/null 2>&1
    mkdir "$HOME/.config/neofetch"
    cp -r $1/dotfiles/neofetch/* "$HOME/.config/neofetch/"

    mkdir "$HOME/.config/wezterm" > /dev/null 2>&1
    cp -r $1/dotfiles/wezterm/* "$HOME/.config/wezterm/"

    mkdir "$HOME/.config/hypr" > /dev/null 2>&1
    cp -r $1/dotfiles/hypr/* "$HOME/.config/hypr/"

    mkdir "$HOME/Images" > /dev/null 2>&1
    cp -r $1/dotfiles/wallpaper.png "$HOME/Images/"

    mkdir "$HOME/.config/waybar" > /dev/null 2>&1
    cp -r $1/dotfiles/waybar/* "$HOME/.config/waybar/"
    chmod +x "$HOME/.config/waybar/scripts/mediaplayer.py" "$HOME/.config/waybar/scripts/wlrecord.sh"
    chmod +x "$HOME/.config/waybar/scripts/playerctl/playerctl.sh"

    sudo usermod --shell /usr/bin/zsh $USER > /dev/null 2>&1
    sudo usermod --shell /usr/bin/zsh root > /dev/null 2>&1
    cp -r "$1/dotfiles/.zshrc" "$HOME/"
    sudo ln -s -f "$HOME/.zshrc" "/root/.zshrc"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k > /dev/null 2>&1
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k > /dev/null 2>&1
    cp -r $1/dotfiles/powerlevel10k/user/.p10k.zsh "$HOME/"
    sudo cp -r $1/dotfiles/powerlevel10k/root/.p10k.zsh "/root/"

    cd /usr/share
    sudo mkdir zsh-sudo
    sudo chown $USER:$USER zsh-sudo/
    cd zsh-sudo
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh > /dev/null 2>&1

    mkdir "$1/dotfiles/fonts"
    cd $1/dotfiles/fonts
    megadl --print-names https://mega.nz/file/GxFVSLLY#etuNc6QRrEl6wgl_ZatvomojDhkBTFPqlKS7ELk7KAM > /dev/null 2>&1

    sudo cp -r $1/dotfiles/fonts/* "/usr/share/fonts/"
    cd /usr/share/fonts/
    sudo unzip fonts.zip > /dev/null 2>&1
    sudo rm -rf fonts.zip  > /dev/null 2>&1

    mkdir "$HOME/.config/scripts" > /dev/null 2>&1
    cp -r $1/dotfiles/scripts/* "$HOME/.config/scripts"
    chmod +x -R $HOME/.config/scripts/

    mkdir "$HOME/.config/swappy" > /dev/null 2>&1
    cp -r $1/dotfiles/swappy/* "$HOME/.config/swappy"

    mkdir "$HOME/.config/swaylock" > /dev/null 2>&1
    cp -r $1/dotfiles/swaylock/* "$HOME/.config/swaylock"

    mkdir "$HOME/.config/eww" > /dev/null 2>&1
    cp -r $1/dotfiles/eww/* "$HOME/.config/eww"
    cd "$HOME/.config/eww/scripts"
    chmod +x -R * > /dev/null 2>&1

    echo -en "\e[32mOK\e[0m"
    echo -en "\n"
}

# END

function finalizacion() {
    echo ""
    echo "INSTALLATION COMPLETED"
    echo ""
}

# ALL FUNCTIONS ARE CALLED PROGRESSIVELY

function call() {
    ruta=$(pwd)
    update
    packagemanager
    setup "$ruta"
    copia "$ruta"
    finalizacion
}

# CHECKS IF THE INSTALLER IS RUNNING AS ROOT

if [ $(whoami) != 'root' ]; then
    present
    # confirmation to proceed with install
    echo -en '\n'
    read -rep 'Attention! The installation is ready to begin. Do you wish to continue (y,n) ' CONTINST
    if [[ $CONTINST == "Y" || $CONTINST == "y" ]]; then
        echo -en "\n"
        echo -en "\e[33m[x] Starting Setup...\e[0m\n"
        sudo touch /tmp/hyprv.tmp
        call
    else
        echo -e "Exiting the script, no changes have been made to your system."
        exit 0
    fi
else
    echo 'Error, the script should not be run as root. '
    exit 0
fi
