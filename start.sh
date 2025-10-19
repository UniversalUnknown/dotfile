#!/bin/bash

# Hide cursor and clear screen
tput civis
clear

# Display ASCII art banner
tput cup 0 0

cat << 'EOF'
                                ██████╗ ███████╗██████╗
                                ██╔══██╗██╔════╝██╔══██╗
                                ██████╔╝█████╗  ██║  ██║             __  _______
|\/|  _.  _|  _     |_          ██╔══██╗██╔══╝  ██║  ██║            /  |/  / __/
|  | (_| (_| (/_    |_) \/      ██║  ██║███████╗██████╔╝           / /|_/ /\ \
                        /       ╚═╝  ╚═╝╚══════╝╚═════╝a.k.a      /_/  /_/___/
EOF

# Move cursor below banner
tput cup 6 0
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
echo "Operating System Found to be: $OS_NAME"

# Define color options
colors=("Latte" "Frappé" "Macchiato" "Mocha")
num_colors=${#colors[@]}
selected=0

# Function to display the menu
display_menu() {
    tput cup 8 0
    echo -e "Use ↑ ↓ to navigate, \e[1;33mSpace\e[0m to select a color."

    # Clear previous menu lines
    for ((i = 0; i < num_colors; i++)); do
        tput cup $((6 + i)) 0
        echo -e "\033[K"
    done

    # Draw menu
    for i in "${!colors[@]}"; do
        tput cup $((6 + i)) 0
        if [ "$i" -eq "$selected" ]; then
            echo -e "> \e[1;33m${colors[$i]}\e[0m <"
        else
            echo "  ${colors[$i]}"
        fi
    done
}

# Main loop
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

# Final output
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
