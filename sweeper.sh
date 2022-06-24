#!/bin/bash
clear

author="©Jan Kupczyk"
version="1.8.1"

fg_red=`tput setaf 1`
fg_green=`tput setaf 2`
fg_yellow=`tput setaf 3`
fg_blue=`tput setaf 4`
fg_magenta=`tput setaf 5`
fg_cyan=`tput setaf 6`
fg_white=`tput setaf 7`
fg_def_col="\033[00m"

# for sysport in `seq 0 1023`;do
#     echo "System port ${sysport}"
# done

# for port in `seq 1024 65534`;do
#     echo "Port ${port}"
# done

BOD=56

log=$(date +"%T")

printf "${fg_red}
╔═╗╦ ╦╔═╗╔═╗╔═╗╔═╗╦═╗
╚═╗║║║║╣ ║╣ ╠═╝║╣ ╠╦╝
╚═╝╚╩╝╚═╝╚═╝╩  ╚═╝╩╚═v${version}
"

echo -e "\n${fg_red}Be aware that the program is in its alpha version, so there may be bugs!${fg_white}"
echo -e "${fg_red}Ping sweep is a method that can establish a range of IP addresses which map to live hosts.${fg_white}"
echo -e "${fg_red}Be aware that pings can be detected by protocol loggers!${fg_white}"
echo -e "${fg_red}Remember that you use the script at your own risk, the author is not responsible for any potential damage!${fg_white}\n\n"
echo -e "${fg_green}Enter the ip address in this format xxx.xxx.xxx${fg_white}"
read -p "${fg_green}Provide IP: ${fg_white}" IP_input
if [[ ${IP_input} == "" ]];then
    echo -e "${fg_red}Please provide valid IP adress!${fg_white}"
else
    echo -e "${fg_red}" && sudo systemctl restart systemd-resolved && sudo systemctl stop systemd-resolved
    echo -e "\n${fg_green}-----BEGIN SWEEPER REQUEST-----${fg_white}"
    echo "Generated ${log}" >> iplist.txt
    echo "<<--Possible addresses-->>" >> iplist.txt

    for ip in `seq 1 254`; do
        if ping -c1 -w3 $IP_input.$ip >/dev/null 2>&1
        then
            echo -e "${fg_yellow}Pinging IPSWEEP$IP_input.$ip with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_green}Destination host reachable; IP address is assigned${fg_white}" >&2
            mrt=ESTABLISHED
            result_of_ping=0
            TP=$(shuf -i 15-88 -n 1)
        else
            echo -e "${fg_yellow}Pinging IPSWEEP$IP_input.$ip with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_red}Destination host unreachable; IP address is free${fg_white}" >&2
            mrt=UNKNOWN
            result_of_ping=1
            TP=$(shuf -i 2222-9999 -n 1)
        fi
        echo -e "$IP_input.$ip --- %${result_of_ping} --- ${TP}ms --- STATE: ${mrt}"
        ping -c 1 $IP_input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> iplist.txt &
    done
    echo -e "${fg_green}-----END SWEEPER REQUEST-----${fg_white}"
    echo -e "\n${fg_green}Read more about sweeper at${fg_green} [${fg_blue}https://github.com/jankupczyk${fg_green}]${fg_white}"
    echo -e "\n${fg_green}For more information head to${fg_green} [${fg_blue}iplist.txt${fg_green}]${fg_white}\n"
    echo -e "${fg_green}~~Made with ${fg_magenta}❤${fg_green}  by ${author}"
fi