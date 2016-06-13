#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Michael Conigliaro <mike [at] conigliaro [dot] org>
#
# -u wordpress owner
# -g wordpress owner group
# -s webserver group
# -p Production mode of permision
# -f Fucking mode of permission for fucking server settings. If you cannt set serve group.

WP_OWNER=eugen # <-- wordpress owner
WP_GROUP=eugen # <-- wordpress group
WP_ROOT=$1 # <-- wordpress root directory
WS_GROUP=www-data # <-- webserver group

MODE="Standart"
SERV_SETINGS="with normal set."

CONTENT_DIR=${WP_ROOT}/wp-content
CHMOD_DIR=775
CHMOD_FILE=664
CHMOD_CONFIG=660

shift 1
while getopts ": u: g: s: p f" opt; do
    case $opt in
        #WP_OWNER
        u)
        WP_OWNER=$OPTARG
        ;;
        #WP_GROUP
        g)
        WP_GROUP=$OPTARG
        ;;
        #WS_GROUP
        s)
        WS_GROUP=$OPTARG
        ;;
        #MODE
        p)
        MODE="Production mode"
        CONTENT_DIR=${WP_ROOT}/wp-content/uploads
        ;;
        #MODE
        f)
        SERV_SETINGS="with fucking set."
        CHMOD_DIR=777
        CHMOD_FILE=666
        CHMOD_CONFIG=666
        ;;
        \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
        :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done
echo "--------------------------------------------"
echo "Wodpress Root directory: $WP_ROOT"
echo "Wodpress owner user:     $WP_OWNER"
echo "Wodpress owner group:    $WP_GROUP"
echo "Web server group:        $WS_GROUP"
echo "Permission mode:         $MODE"
echo "                         $SERV_SETINGS"
echo "--------------------------------------------"

if [ ! -f ${WP_ROOT}/wp-config.php ]; then
    echo "File wp-config.php not exists.\nCurrent directory is not a wp root directory.\nInsert a right path or install WordPress first."
    exit 2
fi

# reset to safe defaults
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec chmod 755 {} \;
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
chmod ${CHMOD_CONFIG} ${WP_ROOT}/wp-config.php

# allow wordpress to manage wp-content
find ${CONTENT_DIR} -exec chgrp ${WS_GROUP} {} \;
find ${CONTENT_DIR} -type d -exec chmod ${CHMOD_DIR} {} \;
find ${CONTENT_DIR} -type f -exec chmod ${CHMOD_FILE} {} \;