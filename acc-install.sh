#!/bin/bash

echo "Installing libraries"
sudo apt-get install aptitude apache2 libapache2-mod-php5 php5-cli php5-mysql php5-mcrypt php5-curl php5-gd mysql-client

cd /srv

echo "Cloning production instance"
sudo git clone http://github.com/enwikipedia-acc/waca production
cd /srv/production
sudo git submodule init
sudo git submodule update
sudo ln -s /srv/config/production config.local.inc.php
sudo mkdir templates_c
sudo chown www-data templates_c

cd /srv

echo "Creating dev directory"
sudo mkdir dev

echo "Initialising config directory. Please setup git remote manually."
sudo mkdir config
cd /srv/config
sudo git init

cd /srv/dev

echo "Cloning sandbox instance"
sudo git clone http://github.com/enwikipedia-acc/waca
cd /srv/dev/waca
sudo git submodule init
sudo git submodule update
sudo ln -s /srv/config/sandbox config.local.inc.php
sudo mkdir templates_c
sudo chown www-data templates_c

cd /srv/dev

echo "Cloning deployment scripts"
sudo git clone http://github.com/enwikipedia-acc/deploy
cd /srv/dev/deploy
sudo ln -s /srv/config/production config.local.inc.php

echo "Setting up phpinfo"
cd /srv/dev
sudo touch info.php
sudo chmod a+w info.php
sudo echo "<?php phpinfo();" > info.php
sudo chown -R www-data .

echo "Setting up vhosts"
cd /etc/apache2/sites-enabled
sudo ln -s /srv/config/production.vhost production.conf
sudo ln -s /srv/config/dev.vhost dev.conf
sudo rm 000-default.conf
cd /etc/apache2/
sudo rm ports.conf
sudo ln -s /srv/config/ports.conf ports.conf

echo "Done. Please restart apache." 
