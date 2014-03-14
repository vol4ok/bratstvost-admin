grunt rebuild
cd dist
git add .
git ci -a -m "up "`date +"%d.%m.%Y-%H:%M:%S"`
git push origin master
ssh root@vol4ok.com << 'ENDSSH'
cd /var/www/admin.bratstvost.by
git pull origin master
forever restartall
ENDSSH%
cd ..