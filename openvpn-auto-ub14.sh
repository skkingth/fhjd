#!/bin/bash
#script by jiraphat yuenying for ubuntu 14.04

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#install openvpn

Y | apt-get purge openvpn easy-rsa;
Y | apt-get purge squid3;
apt-get update
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update
apt-get install bc -y
apt-get -y install openvpn easy-rsa;
apt-get -y install python;

wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/openvpn.tar"
wget -O /etc/openvpn/default.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/default.tar"
cd /etc/openvpn/
tar xf openvpn.tar
tar xf default.tar
cp sysctl.conf /etc/
cp before.rules /etc/ufw/
cp ufw /etc/default/
rm sysctl.conf
rm before.rules
rm ufw
service openvpn restart

#install squid3

apt-get -y install squid3;
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.bak
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

#config client
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/client.ovpn"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /root/

ufw allow ssh
ufw allow 1194/tcp
ufw allow 8080/tcp
ufw allow 3128/tcp
ufw allow 80/tcp
yes | sudo ufw enable

# download script
cd /usr/bin
wget -O /usr/local/bin/menu "https://raw.githubusercontent.com/nwqionm/OPENEXTRA/master/Menu"
	chmod +x /usr/local/bin/menu
clear

printf '###############################\n'
printf '# Script by Jiraphat Yuenying #\n'
printf '#                             #\n'

printf '#                             #\n'
printf '#    พิมพ์ menu เพื่อใช้คำสั่งต่างๆ   #\n'
printf '###############################\n\n'
echo -e "ดาวน์โหลดไฟล์  : /root/client.ovpn\n\n"
printf '\n\nเพิ่ม user โดยใช้คำสั่ง useradd'
printf '\n\nตั้งรหัสโดย ใช้คำสั่ง passwd'
printf '\n\nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi
