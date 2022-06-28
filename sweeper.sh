#!/bin/bash
clear

author="©Jan Kupczyk"
version="1.10.2"

fg_red=`tput setaf 1`
fg_green=`tput setaf 2`
fg_yellow=`tput setaf 3`
fg_blue=`tput setaf 4`
fg_magenta=`tput setaf 5`
fg_cyan=`tput setaf 6`
fg_white=`tput setaf 7`
fg_def_col="\033[00m"

BOD=56
PVN=176
DV=211

log=$(date +"%T")

printf "${fg_red}
╔═╗╦ ╦╔═╗╔═╗╔═╗╔═╗╦═╗
╚═╗║║║║╣ ║╣ ╠═╝║╣ ╠╦╝
╚═╝╚╩╝╚═╝╚═╝╩  ╚═╝╩╚═v${version}
"
echo -e "\n${fg_red}Protocol version:${PVN}\nData version:${DV}${fg_white}\n"
echo -e "\n${fg_red}Be aware that the program is in its alpha version, so there may be bugs!${fg_white}"
echo -e "${fg_red}Ping sweep is a method that can establish a range of IP addresses which map to live hosts.${fg_white}"
echo -e "${fg_red}Be aware that pings can be detected by protocol loggers!${fg_white}"
echo -e "${fg_red}Remember that you use the script at your own risk, the author is not responsible for any potential damage!${fg_white}\n\n"
echo -e "${fg_green}Complete only the octets responsible for the network address, and leave the last one responsible for the host address empty!${fg_white}"
echo -e "${fg_green}Enter the ip address in this format xxx.xxx.xxx${fg_white}"
read -p "${fg_green}Enter IP Address: ${fg_white}" IP_input
if [[ ${IP_input} == "" ]];then
    echo -e "${fg_red}Please provide valid IP adress!${fg_white}"
else
    echo -e "\n${fg_red}Running ${0} ${fg_white}" && sleep 2s
    echo -e "${fg_red}"
    sudo systemctl restart systemd-resolved && sudo systemctl stop systemd-resolved && sudo service redis-server start
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
            TP=$(shuf -i 15-88 -n 1)
        else
            echo -e "${fg_yellow}Pinging IPSWEEPER$IP_input.$ip with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_red}Destination host unreachable; IP address is free${fg_white}" >&2
            locate_ip=$(curl -s ipinfo.io/$IP_input.$ip | jq .country)
            mrt=UNKNOWN
            result_of_ping=1
            TP=$(shuf -i 2222-9999 -n 1)
        fi
        echo -e "$IP_input.$ip -- COUNTRY:${locate_ip} -- ${TP}ms -- STATE: ${mrt}"
        ping -c 1 $IP_input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> sweeperip.txt &
    done
    echo -e "${fg_green}---------------END SWEEPER REQUEST---------------${fg_white}"
    echo -e "\n${fg_green}Read more about sweeper at${fg_green} [${fg_blue}https://github.com/jankupczyk${fg_green}]${fg_white}"
    echo -e "\n${fg_green}For more information head to${fg_green} [${fg_blue}sweeperip.txt${fg_green}]${fg_white}\n"
    echo -e "${fg_green}~~Made with ${fg_magenta}❤${fg_green}  by ${author}"
    echo -e "${fg_white}"
fi