
sudo apt-get upgrade
sudo apt-get update

cd /opt
wget http://nodejs.org/dist/v0.10.2/node-v0.10.2-linux-arm-pi.tar.gz
tar -xvzf node-v0.10.2-linux-arm-pi.tar.gz

node-v0.10.2-linux-arm-pi/bin/node --version

rm -f node-v0.10.2-linux-arm-pi.tar.gz

cd /home/pi/
NODE_JS_HOME=/opt/node-v0.10.2-linux-arm-pi >> .bash_profile
PATH=$PATH:$NODE_JS_HOME/bin  >> .bash_profile

npm —version
npm install npm -g
npm install -g mqtt url request