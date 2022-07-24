#!/bin/bash
clear

author="©Jan Kupczyk"
version="2.0.1"

fg_red=`tput setaf 1`
fg_green=`tput setaf 2`
fg_yellow=`tput setaf 3`
fg_blue=`tput setaf 4`
fg_magenta=`tput setaf 5`
fg_cyan=`tput setaf 6`
fg_white=`tput setaf 7`
fg_def_col="\033[00m"
bg_red='\033[41m'
bg_black='\033[40m'

S_KEY=$(shuf -er -n7  {A..Z} {a..z} {0..9} | tr -d '\n')
BOD=57
PVN=222
DV=264

log=$(date +"%T")

DO_NOT_SCAN_IP=("6.0.0" "7.0.0" "7.0.0" "11.0.0" "21.0.0" "22.0.0" "26.0.0" "28.0.0" "29.0.0" "30.0.0" "33.0.0" "55.0.0" "205.0.0" "214.0.0" "215.0.0" "150.207.2" "140.35.155" "163.12.0" "81.160.0" "162.45.0" "195.101.232" "92.43.123" "87.54.11" "153.31.0" "192.84.170" "192.217.228" "195.10.0" "198.190.209" "205.96.0" "205.229.233" "207.43.55" "207.60.0" "209.35.0" "209.122.130" "212.159.33" "217.6.0" "194.42.114" "195.128.0" "217.243.168" "168.175.70" "168.175.170" "168.175.171" "168.175.172" "202.108.0" "195.101.232" "153.31.0" "166.64.0" "164.112.0" "165.187.0" "198.61.8" "192.190.61" "203.25.230" "192.251.207" "162.45.0" "206.212.128")

DONT_DO_THAT_header="--18 U.S. Code § 1030 - Fraud and related activity in connection with computers"
DONT_DO_THAT_message="----DO NOT SCAN!! - What you want to do now is highly illegal and prosecutable!"

printf "${fg_red}
╔═╗╦ ╦╔═╗╔═╗╔═╗╔═╗╦═╗
╚═╗║║║║╣ ║╣ ╠═╝║╣ ╠╦╝
╚═╝╚╩╝╚═╝╚═╝╩  ╚═╝╩╚═v${version}
"

echo -e "${fg_white}\n${bg_red}DISCLAIMER: Remember that you use the script at your own risk, the author of script is not responsible for any potential damage and will not be liable!${fg_def_col}${fg_white}"

echo -e "\n${fg_red}Be aware that the program is in its alpha version, so there may be bugs!${fg_white}"
echo -e "${fg_red}Ping sweep is a method that can establish a range of IP addresses which map to live hosts.${fg_white}"
echo -e "${fg_red}Be aware that pings can be detected by protocol loggers!${fg_white}"
echo -e "${fg_green}Complete only the octets responsible for the network address, and leave the last one responsible for the host address empty!${fg_white}"
echo -e "${fg_green}Enter the ip address in this format |xxx.xxx.xxx|${fg_white}"
read -p "${fg_green}Enter network address: ${fg_white}" IP_input

if [[ ${DO_NOT_SCAN_IP[*]} =~ ${IP_input} ]];then
    echo -e "\n${bg_red}${DONT_DO_THAT_header}\n${DONT_DO_THAT_message}\n------Youre tried to ping [${IP_input}.0] address that belongs to military or gov facility!!!!!! ${fg_def_col}${fg_white}"
else
    echo -e "\n${fg_red}Running ${0} ${fg_white}" && sleep 2s
    echo -e "${fg_red}"
    sudo systemctl restart systemd-resolved && sudo systemctl stop systemd-resolved && sudo service redis-server start && sleep 2s
    echo -e "Get all services..." && sleep 2s
    service --status-all
    echo -e "\n${fg_green}---------------BEGIN SWEEPER REQUEST---------------${fg_white}"
    echo "Generated ${log}" >> sweeperip.txt
    echo "<<--Possible addresses-->>" >> sweeperip.txt

    for ip in `seq 0 254`; do
        if ping -c1 -w3 $IP_input.$ip >/dev/null 2>&1
        then
            echo -e "${fg_yellow}Pinging IPSWEEPER$IP_input.$ip with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_green}Destination host reachable; IP address is assigned${fg_white}" >&2
            locate_ip=$(curl -s ipinfo.io/$IP_input.$ip | jq .country)
            mrt=ESTABLISHED
            result_of_ping=0
            TP=$(shuf -i 13-109 -n 1)
        else
            echo -e "${fg_yellow}Pinging IPSWEEPER$IP_input.$ip with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_red}Destination host unreachable; IP address is free${fg_white}" >&2
            locate_ip=$(curl -s ipinfo.io/$IP_input.$ip | jq .country)
            mrt=UNKNOWN
            result_of_ping=1
            TP=$(shuf -i 400-9999 -n 1)
        fi
        echo -e "$IP_input.$ip -- COUNTRY:${locate_ip} -- ${TP}ms -- STATE: ${mrt}"
        ping -c 1 $IP_input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> sweeperip.txt &
    done
    echo -e "${fg_green}---------------END SWEEPER REQUEST---------------${fg_white}"
    echo -e "${fg_red}Ending session...${fg_white}" && sleep 2s
    echo -e "${fg_red}Session key: ${S_KEY}${fg_white}"
    echo -e "\n${fg_green}Read more about sweeper at${fg_green} [${fg_blue}https://github.com/jankupczyk/IP_SWEEPER${fg_green}]${fg_white}"
    echo -e "\n${fg_green}For more information head to${fg_green} [${fg_blue}sweeperip.txt${fg_green}]${fg_white}\n"
    echo -e "${fg_green}~~Made with ${fg_magenta}❤${fg_green}  by ${author}"
    echo -e "${fg_white}"
fi