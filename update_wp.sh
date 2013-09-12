#!/bin/bash

# With help from these resources:
#     http://blog.teamtreehouse.com/tame-wordpress-from-the-command-line-with-wp-cli
#     https://github.com/tekapo/inst-wp-with-wp-cli 

# License:
# Released under the GPL license
# http://www.gnu.org/copyleft/gpl.html
#
# Copyright 2013 (email : info@eyedarts.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

WP_SITES_LOCAL="wp_sites_local.txt"
WP_SITES_SSH="ssh_sites.txt"

if [ -e "${WP_SITES_LOCAL}" ]
  then
    for site in $(cat ${WP_SITES_LOCAL});
      do
        echo -e "\n\033[33mUpdating $site...\033[0m"
        #wp --path=$site db export $site/db-backup.sql
        wp --path=$site plugin list
        wp --path=$site plugin update-all version=latest
        wp --path=$site core update
        wp --path=$site theme list
      done
fi

if [ -e "${WP_SITES_SSH}" ]
  then
    SITES=`cat ${WP_SITES_SSH}`
    for site in $SITES; do
      host=$(echo $site | cut -d, -f1)
      wp_path=$(echo $site | cut -d, -f2)
      echo -e "\n\033[33mUpdating $host...\033[0m"
      ssh $host \
          "wp --path=$wp_path plugin update-all version=latest; \
           wp --path=$wp_path core update; \
           wp --path=$wp_path theme list | cut -f1,3"
    done
fi

echo -e '\n \033[32m*** SUCCESS - All Sites Updated ***\033[0m'
