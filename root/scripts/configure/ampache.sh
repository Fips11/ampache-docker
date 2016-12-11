#!/usr/bin/env sh

# setup folder
mkdir -p ${AMPACHE_DIR}
echo "=> Unzip ampache archive"
unzip -q /ampache-${AMPACHE_VER}_all.zip -d ${AMPACHE_DIR}
mkdir -p /var/log/ampache/ && chown -R apache:www-data /var/log/ampache/

# convert line ending from dos2unix
# ignoring all binary files
echo "=> Convert line ending with dos2unix in ampache files"
echo -e ""
find "${AMPACHE_DIR}" -type f -exec sh -c "file -i {} | grep -v binary >/dev/null" \; -exec echo -en "\e[1A\033[K" \; -exec sh -c 'echo $(echo {} | sed "s@${AMPACHE_DIR}/@@g")|cut -c0-75' \; -exec dos2unix {} \;
echo -e "\e[1A\033[K=> Done."

# set parameters
sed -i 's/#\(.*rewrite_module.*\)/\1/g' /etc/apache2/httpd.conf

# cron update
(crontab -l ; echo "0 3 * * * su -s /bin/sh apache -c \"/scripts/catalog_update.sh\"")| crontab -

sed -i 's/\(post_max_size\).*/\1 = 50M/g' /etc/php5/php.ini
sed -i 's/\(upload_max_filesize\).*/\1 = 30M/g' /etc/php5/php.ini

# ampache.cfg.php.dist configuration
# local_web_path
#   if not set, subsonic won't function from local ip
sed -i "s/;local_web_path/local_web_path/g" ${AMPACHE_DIR}/config/ampache.cfg.php.dist

# waveform
sed -i "s/;waveform = \"false\"/waveform = \"true\"/g" ${AMPACHE_DIR}/config/ampache.cfg.php.dist

# tmp_dir_path
sed -i "s/;tmp_dir_path = \"false\"/tmp_dir_path = \"\/tmp\/ampache\"/g" ${AMPACHE_DIR}/config/ampache.cfg.php.dist

# debug
# path
sed -i "s/;log_path/log_path/g" ${AMPACHE_DIR}/config/ampache.cfg.php.dist

# set correct permissions
chown -R apache:www-data ${AMPACHE_DIR}
