#!/bin/bash

tput civis
clear


tput cup 0 0

cat << 'EOF'
                                ██████╗ ███████╗██████╗
                                ██╔══██╗██╔════╝██╔══██╗
                                ██████╔╝█████╗  ██║  ██║             __  _______
|\/|  _.  _|  _     |_          ██╔══██╗██╔══╝  ██║  ██║            /  |/  / __/
|  | (_| (_| (/_    |_) \/      ██║  ██║███████╗██████╔╝           / /|_/ /\ \
                        /       ╚═╝  ╚═╝╚══════╝╚═════╝a.k.a      /_/  /_/___/
EOF


tput cup 6 0
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
echo "Operating System Found to be: $OS_NAME"


colors=("Latte" "Frappé" "Macchiato" "Mocha")
num_colors=${#colors[@]}
selected=0


display_menu() {
    tput cup 8 0
    echo -e "Use ↑ ↓ to navigate, \e[1;33mSpace\e[0m to select a color."

    for ((i = 0; i < num_colors; i++)); do
        tput cup $((6 + i)) 0
        echo -e "\033[K"
    done


    for i in "${!colors[@]}"; do
        tput cup $((6 + i)) 0
        if [ "$i" -eq "$selected" ]; then
            echo -e "> \e[1;33m${colors[$i]}\e[0m <"
        else
            echo "  ${colors[$i]}"
        fi
    done
}


while true; do
    display_menu
    IFS= read -rsn1 input
    if [[ "$input" == $'\e' ]]; then
        read -rsn2 -t 0.1 input
        if [[ "$input" == "[A" ]]; then
            ((selected--))
            ((selected < 0)) && selected=$((num_colors - 1))
        elif [[ "$input" == "[B" ]]; then
            ((selected++))
            ((selected >= num_colors)) && selected=0
        fi
    elif [[ "$input" == " " ]]; then
        break
    fi
done

clear
cat << 'EOF'
                                ██████╗ ███████╗██████╗
                                ██╔══██╗██╔════╝██╔══██╗
                                ██████╔╝█████╗  ██║  ██║             __  _______
|\/|  _.  _|  _     |_          ██╔══██╗██╔══╝  ██║  ██║            /  |/  / __/
|  | (_| (_| (/_    |_) \/      ██║  ██║███████╗██████╔╝           / /|_/ /\ \
                        /       ╚═╝  ╚═╝╚══════╝╚═════╝a.k.a      /_/  /_/___/
EOF
tput cnorm
echo -e "You chose: \e[1;33m${colors[$selected]}\e[0m"


if [[ "$OS_NAME" == *"openSUSE"* || "$OS_NAME" == *"SUSE"* ]]; then
    PACKAGE_MANAGER="sudo zypper"
elif [[ "$OS_NAME" == *"Ubuntu"* || "$OS_NAME" == *"Debian"* ]]; then
    PACKAGE_MANAGER="sudo apt"
elif [[ "$OS_NAME" == *"Arch"* || "$OS_NAME" == *"Manjaro"* ]]; then
    PACKAGE_MANAGER="pacman -S"
    sudo pacman -S zsh
    yay -S --noconfirm zsh-theme-powerlevel10k-git
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    p10k configure
elif [[ "$OS_NAME" == *"Fedora"* || "$OS_NAME" == *"Red Hat"* || "$OS_NAME" == *"CentOS"* ]]; then
    PACKAGE_MANAGER="sudo dnf install"
elif [[ "$OS_NAME" == *"Alpine"* ]]; then
    PACKAGE_MANAGER="sudo apk add"
elif [[ "$OS_NAME" == *"Void"* ]]; then
    PACKAGE_MANAGER="sudo xbps-install -S"
elif [[ "$OS_NAME" == *"Gentoo"* ]]; then
    PACKAGE_MANAGER="sudo emerge"
else
    echo "Unsupported OS: $OS_NAME"
    exit 1
fi
    $PACKAGE_MANAGER install zsh kitty rofi cava nvim

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
git clone https://github.com/LazyVim/starter ~/.config/nvim && rm -rf ~/.config/nvim/.git
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
exec zsh
git clone https://github.com/catppuccin/konsole.git && mv ~/konsole/theme/* ~/.local/share/konsole/
git clone https://github.com/catppuccin/yakuake.git &&
sudo cat <<EOF > ~/yakuake/make-archives.sh
#!/usr/bin/env bash

FLAVORS=(latte frappe macchiato mocha)

for flavor in "${colors[$i]}"; do
  tar -zcf "catppuccin-$flavor.tar.gz" "$flavor/"
done

EOF
~/yakuake/make-archives.sh
git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde && chmod +x ~/catppuccin-kde/install.sh && ~/catppuccin-kde/./install.sh
rm -rf konsole
mkdir -p ~/.local/share/konsole

touch ~/.local/share/konsole/red-profile.profile &&
cat <<EOF > ~/.local/share/konsole/red-profile.profile
[Appearance]
ColorScheme=${colors[$selected]}
Font=DepartureMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[Cursor Options]
CursorShape=1

[General]
Command=/usr/bin/zsh
Icon=utilities-terminal_su
Name=Profile 1
Parent=FALLBACK/
EOF
#git clone https://github.com/Murzchnvok/rofi-collection
