#! /bin/bash

set -e

#
# Load parameters from file
#
if [ -f config.sh ]; then
    source config.sh
else
    echo "config.sh not found"
    exit 1;
fi

# path to mysql binary
mysql_bin=/usr/bin/mysql
# path to schema file
schema_file=schema/opus4current.sql
# path to different sql locations
master_dir=masterdata/

#
# end editable part
#

mysql="${mysql_bin} --default-character-set=utf8 --user=`printf %q "${user}"` --host=`printf %q "${host}"` --port=`printf %q "${port}"`"

if [ -n "${password}" ]; then
     mysql="${mysql} --password=`printf %q "${password}"`"
fi

#Delete database
echo "Dropping database: '${dbname}'"
echo "DROP DATABASE IF EXISTS \`${dbname}\`;" | eval "${mysql}"

#Creating database
echo "Creating database: '${dbname}'"
echo "CREATE SCHEMA IF NOT EXISTS \`${dbname}\` DEFAULT CHARACTER SET = utf8 DEFAULT COLLATE = utf8_general_ci;" | eval "${mysql}"

#Import database schema
echo "Importing database schema file '${schema_file}'"
eval "${mysql}" "${dbname}" < "${schema_file}"