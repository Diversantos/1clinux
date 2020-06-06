apt-get update -y
apt-get install -y wget gnupg2 || apt-get install -y gnupg
wget -O - http://repo.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO | apt-key add -
echo deb http://repo.postgrespro.ru/pg1c-archive/pg1c-12.2/debian/ buster main > /etc/apt/sources.list.d/postgrespro-1c.list
apt-get update -y
apt-get install -y postgrespro-1c-12-server postgrespro-1c-12-contrib
/opt/pgpro/1c-12/bin/pg-setup initdb
/opt/pgpro/1c-12/bin/pg-setup service enable
service postgrespro-1c-12 start

