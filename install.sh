#!/bin/bash

set -e

clear

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'

if [[ $(uname -m) == "aarch64" ]]; then
 IsTermux=1
fi
if [[ $EUID -ne 0 && $IsTermux == 0 ]]; then
   echo -e "${RED}This script must be run as root"
   exit 1
   rm check.txt
fi

COLOR_NUM=$((RANDOM % 7))
# Assign a color variable based on the random number
case $COLOR_NUM in
    0) COLOR=$RED;;
    1) COLOR=$GREEN;;
    2) COLOR=$YELLOW;;
    3) COLOR=$BLUE;;
    4) COLOR=$CYAN;;
    5) COLOR=$ORANGE;;
    *) COLOR=$WHITE;;
esac
if [[ $IsTermux == 0 ]]; then
 echo -e "${COLOR}"
 echo ""
 echo "   ▄█    █▄       ▄████████  ▄████████    ▄█   ▄█▄  ▄█  ███▄▄▄▄      ▄██████▄           ███      ▄██████▄   ▄██████▄   ▄█       ";
 echo "  ███    ███     ███    ███ ███    ███   ███ ▄███▀ ███  ███▀▀▀██▄   ███    ███      ▀█████████▄ ███    ███ ███    ███ ███       ";
 echo "  ███    ███     ███    ███ ███    █▀    ███▐██▀   ███▌ ███   ███   ███    █▀          ▀███▀▀██ ███    ███ ███    ███ ███       ";
 echo " ▄███▄▄▄▄███▄▄   ███    ███ ███         ▄█████▀    ███▌ ███   ███  ▄███                 ███   ▀ ███    ███ ███    ███ ███       ";
 echo "▀▀███▀▀▀▀███▀  ▀███████████ ███        ▀▀█████▄    ███▌ ███   ███ ▀▀███ ████▄           ███     ███    ███ ███    ███ ███       ";
 echo "  ███    ███     ███    ███ ███    █▄    ███▐██▄   ███  ███   ███   ███    ███          ███     ███    ███ ███    ███ ███       ";
 echo "  ███    ███     ███    ███ ███    ███   ███ ▀███▄ ███  ███   ███   ███    ███          ███     ███    ███ ███    ███ ███▌    ▄ ";
 echo "  ███    █▀      ███    █▀  ████████▀    ███   ▀█▀ █▀    ▀█   █▀    ████████▀          ▄████▀    ▀██████▀   ▀██████▀  █████▄▄██ ";
 echo "                                         ▀                                                                            ▀         ";

 echo -e "${BLUE}                                    https://github.com/Z4nzu/hackingtool ${NC}"
 echo -e "${RED}                                     [!] This Tool Must Run As ROOT [!]${NC}\n"
 echo -e "${CYAN}              Select Best Option : \n"
 echo -e "${WHITE}              [1] Kali Linux / Parrot-Os (apt)"
 echo -e "${WHITE}              [2] Arch Linux (pacman)" # added arch linux support because of feature request #231
#echo -e "${WHITE}              [3] Termux "
 echo -e "${WHITE}              [0] Exit "

 echo -e "${COLOR}┌──($USER㉿$HOST)-[$(pwd)]"

 choice=$1
 if [[ ! $choice =~ ^[1-3]+$ ]]; then
     read -p "└─$>>" choice
 fi

# Define installation directories
 install_dir="/usr/share/hackingtool"
 bin_dir="/usr/bin"

# Check if the user chose a valid option and perform the installation steps
 if [[ $choice =~ ^[1-3]+$ ]]; then
     echo -e "${YELLOW}[*] Checking Internet Connection ..${NC}"
     echo "";
     if curl -s -m 10 https://www.google.com > /dev/null || curl -s -m 10 https://www.github.com > /dev/null; then
        echo -e "${GREEN}[✔] Internet connection is OK [✔]${NC}"
        echo "";
        echo -e "${YELLOW}[*] Updating package list ..."
        # Perform installation steps based on the user's choice
        if [[ $choice == 1 ]]; then
            sudo apt update -y && sudo apt upgrade -y
            sudo apt-get install -y git python3-pip figlet boxes php curl xdotool wget -y ;
        elif [[ $choice == 2 ]]; then
            sudo pacman -Suy -y
            sudo pacman -S python-pip -y
        #elif [[ $choice == 3 ]]; then
            #apt update -y && apt upgrade -y
            #apt-get install -y git python-pip python figlet boxes php curl wget -y;
        else
            exit
        fi
        echo "";
        echo -e "${YELLOW}[*] Checking directories...${NC}"
        if [[ -d "$install_dir" ]]; then
            echo -e -n "${RED}[!] The directory $install_dir already exists. Do you want to replace it? [y/n]: ${NC}"
            read input
            if [[ $input == "y" ]] || [[ $input == "Y" ]]; then
                echo -e "${YELLOW}[*]Removing existing module.. ${NC}"
                sudo rm -rf "$install_dir"
            else
                echo -e "${RED}[✘]Installation Not Required[✘] ${NC}"
                exit
            fi
        fi
        echo "";
        echo -e "${YELLOW}[✔] Downloading hackingtool...${NC}"
        if sudo git clone https://github.com/Z4nzu/hackingtool.git $install_dir; then
            # Install virtual environment
            echo -e "${YELLOW}[*] Installing Virtual Environment...${NC}"
            if [[ $choice == 1 ]]; then
              sudo apt install python3-venv -y
            elif [[ $choice == 2 ]]; then
              echo "Python 3.3+ comes with a module called venv.";
            fi
             echo "";
            # Create a virtual environment for the tool
             echo -e "${YELLOW}[*] Creating virtual environment..."
             sudo python3 -m venv $install_dir/venv
             source $install_dir/venv/bin/activate
            # Install requirements
             echo -e "${GREEN}[✔] Virtual Environment successfully [✔]${NC}";
             echo "";
             echo -e "${YELLOW}[*] Installing requirements...${NC}"
             if [[ $choice == 1 ]]; then
                 pip3 install -r $install_dir/requirements.txt
                 sudo apt install figlet -y
             elif [[ $choice == 2 ]]; then
                 pip3 install -r $install_dir/requirements.txt
                 sudo -u $SUDO_USER git clone https://aur.archlinux.org/boxes.git && cd boxes
                 sudo -u $SUDO_USER makepkg -si
                 sudo pacman -S figlet -y
             fi
            # Create a shell script to launch the tool
             echo -e "${YELLOW}[*] Creating a shell script to launch the tool..."
             echo '#!/bin/bash' > hackingtool.sh
             echo '#!/bin/bash' > $install_dir/hackingtool.sh
             echo "source $install_dir/venv/bin/activate" >> $install_dir/hackingtool.sh
             echo "python3 $install_dir/hackingtool.py \$@" >> $install_dir/hackingtool.sh
             chmod +x $install_dir/hackingtool.sh
             sudo mv $install_dir/hackingtool.sh $bin_dir/hackingtool
             echo -e "${GREEN}[✔] Script created successfully [✔]"
         else
             echo -e "${RED}[✘] Failed to download Hackingtool [✘]"
             exit 1
         fi

     else
       echo -e "${RED}[✘] Internet connection is not available [✘]${NC}"
        exit 1
     fi

     if [ -d $install_dir ]; then
         echo "";
         echo -e "${GREEN}[✔] Successfully Installed [✔]";
         echo "";
         echo "";
         echo -e  "${ORANGE}[+]+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++[+]"
         echo     "[+]                                                             [+]"
         echo -e  "${ORANGE}[+]     ✔✔✔ Now Just Type In Terminal (hackingtool) ✔✔✔      [+]"
         echo     "[+]                                                             [+]"
         echo -e  "${ORANGE}[+]+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++[+]"
     else
         echo -e "${RED}[✘] Installation Failed !!! [✘]";
         exit 1
     fi

 elif [[ $choice == 0 ]]; then
     echo -e "${RED}[✘] Exiting tool [✘]"
     exit 1
 else
     echo -e "${RED}[!] Select Valid Option [!]"
 fi
else
 echo "${BLUE} Termux discovered!"
 sleep 2
 clear
 echo -e "${COLOR}"
 echo ""
 echo "   ▄█    █▄       ▄████████  ▄████████    ▄█   ▄█▄  ▄█  ███▄▄▄▄      ▄██████▄           ███      ▄██████▄   ▄██████▄   ▄█       ";
 echo "  ███    ███     ███    ███ ███    ███   ███ ▄███▀ ███  ███▀▀▀██▄   ███    ███      ▀█████████▄ ███    ███ ███    ███ ███       ";
 echo "  ███    ███     ███    ███ ███    █▀    ███▐██▀   ███▌ ███   ███   ███    █▀          ▀███▀▀██ ███    ███ ███    ███ ███       ";
 echo " ▄███▄▄▄▄███▄▄   ███    ███ ███         ▄█████▀    ███▌ ███   ███  ▄███                 ███   ▀ ███    ███ ███    ███ ███       ";
 echo "▀▀███▀▀▀▀███▀  ▀███████████ ███        ▀▀█████▄    ███▌ ███   ███ ▀▀███ ████▄           ███     ███    ███ ███    ███ ███       ";
 echo "  ███    ███     ███    ███ ███    █▄    ███▐██▄   ███  ███   ███   ███    ███          ███     ███    ███ ███    ███ ███       ";
 echo "  ███    ███     ███    ███ ███    ███   ███ ▀███▄ ███  ███   ███   ███    ███          ███     ███    ███ ███    ███ ███▌    ▄ ";
 echo "  ███    █▀      ███    █▀  ████████▀    ███   ▀█▀ █▀    ▀█   █▀    ████████▀          ▄████▀    ▀██████▀   ▀██████▀  █████▄▄██ ";
 echo "                                         ▀                                                                            ▀         ";
 echo -e "${BLUE}                                    https://github.com/Z4nzu/hackingtool ${NC}"
 echo -e "${WHITE}              [1] Install "
 echo -e "${WHITE}              [0] Exit "




 choice=$1
 read -p "└─$>>" choice


# Define installation directories
 install_dir="/$PREFIX/share/hackingtool"
 bin_dir="/$PREFIX/bin"

# Check if the user chose a valid option and perform the installation steps
 if [[ $choice == 1 ]]; then
     echo -e "${YELLOW}[*] Checking Internet Connection ..${NC}"
     echo "";
     if curl -s -m 10 https://www.google.com > /dev/null || curl -s -m 10 https://www.github.com > /dev/null; then
        echo -e "${GREEN}[✔] Internet connection is OK [✔]${NC}"                                                              echo "";
        echo -e "${YELLOW}[*] Updating package list ..."
        apt update -y && apt upgrade -y
        apt-get install -y git python-pip python figlet boxes php curl wget -y; pkg install tsu;
        echo "";
        echo -e "${YELLOW}[*] Checking directories...${NC}"
        if [[ -d "$install_dir" ]]; then
            echo -e -n "${RED}[!] The directory $install_dir already existed. Do you want replace it?(Y/n)"
            read input
            if [[ $input == "y" ]] || [[ $input == "Y" ]]; then
                echo -e "${YELLOW}[*]Removing existing module.. ${NC}"
                rm -rf "$install_dir"
            else
                echo -e "${RED}[✘]Installation Not Required[✘] ${NC}"
                exit
            fi
        fi
        echo "";
        echo -e "${YELLOW}[✔] Downloading hackingtool...${NC}"
        if git clone https://github.com/Z4nzu/hackingtool.git $install_dir; then                       # Install virtual environment
             #echo -e "${YELLOW}[*] Installing Virtual Environment...${NC}"
             echo "";
            # Create a virtual environment for the tool
             echo -e "${YELLOW}[*] Creating virtual environment..."
             python3 -m venv $install_dir/venv
             source $install_dir/venv/bin/activate                                                          # Install requirements
             echo -e "${GREEN}[✔] Virtual Environment successfully [✔]${NC}";                                echo "";
             echo -e "${YELLOW}[*] Installing requirements...${NC}"

             pip3 install -r $install_dir/requirements.txt
             apt install figlet -y                                                                                             # Create a shell script to launch the tool                                                       echo -e "${YELLOW}[*] Creating a shell script to launch the tool..."
             echo '#!/bin/bash' > hackingtool.sh                                                             echo '#!/bin/bash' > $install_dir/hackingtool.sh
             echo "source $install_dir/venv/bin/activate" >> $install_dir/hackingtool.sh
             echo "python3 $install_dir/hackingtool.py \$@" >> $install_dir/hackingtool.sh
             chmod +x $install_dir/hackingtool.sh
             mv $install_dir/hackingtool.sh $bin_dir/hackingtool
             echo -e "${GREEN}[✔] Script created successfully [✔]"
         else
             echo -e "${RED}[✘] Failed to download Hackingtool [✘]"                                          exit 1
         fi
     else
        echo -e "${RED}[×] Internet connection not found...[×]${NC}"
     fi
elif [[ $choice == 0 ]]; then
     echo "Exit..."
     exit 0
 fi
fi
