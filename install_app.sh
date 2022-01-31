#!/bin/bash

echo "*****************************************************************"                                                                                             
echo "Install Web Service dan Apps : Landing Page, Wordpress dan Pesbuk"                                                                                               
echo "******************************************************************"                                                                                             
echo "         Author: M Taufiq Permana Sumarna - Januari 2022          "
echo "******************************************************************"     

$mysql='/usr/bin/mysql'
#option                                                                                                                                               
                                                                                                                                                      
echo "*** Apakah Anda Ingin Install Install Web Service dan Apps : Landing Page, Wordpress dan Pesbuk ? (Pilih y/n) ***"                                                                                     
read pilihan                                                                                                                                          
                                                                                                                                                      
if [[ $pilihan == y ]]                                                                                                                                
then                     

        echo "**************************************************"                                                                                     
        echo "*********Mulai Proses Install Web Service*********"                                                                                     
        echo "**************************************************"                                                                                     
                                                                                                                                                      
        echo "--- Update Repository ---"
	sudo apt update -y                                                                                                                            
                                                                                                                                                      
        echo "--- Menginstall apache2 ---"                                                                                                            
        sudo apt install apache2 -y                                                                                                                   
                                                                                                                                                      
        echo "--- Menginstall php dan ekstensi lainnya ---"                                                                                           
        sudo apt install php libapache2-mod-php libapache2-mod-php php-fpm php-mysql php-json php-opcache php-mbstring php-xml php-gd php-curl

        echo "-- Menginstall mysql-server dan secure installation ---"                                                                                
        sudo apt install mysql-server -y                                                                                                           
        sudo mysql_secure_installation                                                                                                                
                                               
	echo"--- Mengaktifkan webservice otomatis saat booting ---"                                                                                   
        sudo systemctl enable apache2                                                                                                                 
        sudo systemctl enable php                                                                                                                     
        sudo systemctl enable mysql-server  
        
        echo"--- Mulai webservice ---"                                                                                                                
        sudo systemctl start apache2
        sudo systemctl start mysql-server

        echo"-- Konfigurasi Firewall Apache --"                                                                                                         
        sudo ufw allow in "Apache Full"
                              
#Install Aplikasi Landing Page
echo "**Mulai Clonning Repository Aplikasi Landing Page**"
git clone https://github.com/sdcilsy/landing-page /tmp/landing

echo "**Memindahkan Aplikasi Landing Page Kedalam public html**"
sudo mv /tmp/landing /var/www/html/
sudo chown -R www-data: /var/www/html/landing

echo "**Selesai Install Aplikasi Landing Page**"

#Install Aplikasi Pesbuk
echo "**Mulai Clonning Repository Aplikasi Pesbuk**"
git clone https://github.com/sdcilsy/sosial-media /tmp/pesbuk

echo "**Memindahkan Aplikasi Pesbuk Kedalam public html**"
sudo mv /tmp/pesbuk /var/www/html/
sudo chown -R www-data: /var/www/html/pesbuk

sudo systemctl restart apache2

echo "**Selesai Install Aplikasi Pesbuk**"

#Install Aplikasi Wordpress
echo "Memulai Instalasi Worpdress"

# DB Variables
echo "Input MySQL Host:"
read dbhost
export dbhost

echo "Input Database Name:"
read dbname
export dbname

echo "Input Database User:"
read dbuser
export dbuser

echo "Input Database User Password:"
read dbpass
export dbpass

echo "Input Database Root Password:"
read dbpassroot
export dbpassroot

#wp admin variable
echo "Input Wordpress Hostname:"
read siteurl
export siteurl

echo "Input Site Title:"
read wptitle
export wptitle

echo "Input Admin Wordpress Username:"
read wpuser
export wpuser

echo "Input Admin Wordpress Password:"
read wppass
export wppass

echo "Input Admin Wordpress Email:"
read wpemail
export wpemail

#konfigurasi database wordpress

$mysql -u root -p $dbpassroot -e "CREATE USER '$dbuser'"

echo "**Mulai Konfigurasi Database Wordpress**" 
#Membuat User Database Baru
$mysql -u root -p $dbpassroot -e "CREATE USER '$dbuser'@'$dbhost' IDENTIFIED BY '$dbpass';"

#Membuat Database Wordpress
$mysql -u root -p $dbpassroot -e "CREATE DATABASE IF NOT EXISTS $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'$dbhost'; FLUSH PRIVILEGES;"

echo "**Download Aplikasi Wordpress**"
wget http://wordpress.org/latest.tar.gz
tar -zxf latest.tar.gz

#Konfigurasi wp-config.php
sed -e "s/localhost/"$dbhost"/" -e "s/database_name_here/"$dbname"/" -e "s/username_here/"$dbuser"/" -e "s/password_here/"$dbpass"/" wordpress/wp-config-sample.php > wordpress/wp-config.php

#Memindahkan Wordpress Kedalam Public HTML
echo "Memindahkan Wordpress Kedalam public html"
sudo mv wordpress /var/www/html/wordpress
sudo chown -R www-data: /var/www/html/wordpress

#Mendapatkan Salt Keys Wordpress
#SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
#STRING='put your unique phrase here'
#printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

#Konfigurasi Setup Wordpress
#curl -d "weblog_title=$wptitle&user_name=$wpuser&admin_password=$wppass&admin_password2=$wppass&admin_email=$wpemail" http://$siteurl/wp-admin/install.php?step=2


echo "**********************************************************"                                                                                     
echo "******Proses Install Web Service dan Apps Selesai*********"                                                                                     
echo "**********************************************************"

echo "=================Wordpress Setup Information==================="
echo "Database Host : '$dbhost'"
echo "Database Name : '$dbname'"
echo "Database User : '$dbuser'"
echo "Database Pass : '$dbpass'"
echo "===============Wordpress Login Information====================="
echo "Wordpress URL                   : '$siteurl'"
echo "Wordpress admin email           : '$wpemail'"
echo "Wordpress admin username        : '$wpuser'"
echo "Wordpress admin password        : '$wppass'"
echo "===============+++++++++++++++++++++++++++====================="

#membersihkan archieve wordpress
rm latest.tar.gz

else                                                                                                                                                                                                                                                                     
        echo "**********************************************************"                                                                                     
        echo "****Proses Install Web Service dan Apps Dibatalkan********"                                                                                     
        echo "**********************************************************"                                                                                   
exit 1                                                                                                                                                
fi         