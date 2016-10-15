grunt rebuild
cd dist
sudo rm -rf /var/www/bratstvost-admin/*
sudo cp * /var/www/bratstvost-admin -R

# First time commands:
sudo cp ../node_modules /var/www/bratstvost-admin -R
cd /var/www/bratstvost-admin;NODE_ENV=production pm2 start web.js -n bratstvost-admin

pm2 restart bratstvost-admin
cd ..
