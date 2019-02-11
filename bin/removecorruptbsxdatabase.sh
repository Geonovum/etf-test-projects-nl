# clean database
rm -rf /var/www/html/restart/restart.txt
rm -rf /opt/etf-data2/ds/db/data/etf-ds/*.basex
rm -rf /opt/etf-data2/ds/obj/*.xml
/etc/init.d/tomcat8 restart
