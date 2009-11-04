#!/bin/sh
CWD=$(pwd)
PSQL_USER=${PSQL_USER:-postgres}
XTUPLE_USER=${XTUPLE_USER:-admin}
XTUPLE_PWD=${XTUPLE_PWD:-admin}
XTUPLE_DB=${XTUPLE_DB:-xtupleDB}
XTUPLE_DIR=${XTUPLE_DIR:-/usr/share/xtuple}

# alternative values are "empty" and "demo"
XTUPLE_DB_BACKUP=${XTUPLE_DB_BACKUP:-quickstart}

if [ -e "$XTUPLE_DIR/postbooks_$XTUPLE_DB_BACKUP.backup" ]; then
  cp -f $XTUPLE_DIR/init.sql $CWD/init.sql

# Some .backup scripts fail if we do not use the 'admin' user, so be careful when
# using it
  ORIG="CREATE USER admin WITH PASSWORD 'admin'"
  sed -i "s/$ORIG/CREATE USER $XTUPLE_USER WITH PASSWORD '$XTUPLE_PWD'/" \
    $CWD/init.sql

  psql -U $PSQL_USER -f $CWD/init.sql
  createdb -U $XTUPLE_USER $XTUPLE_DB
  pg_restore -U $XTUPLE_USER -d $XTUPLE_DB $XTUPLE_DIR/postbooks_$XTUPLE_DB_BACKUP.backup -v

  rm -f $CWD/init.sql
else
  echo "You do not appear to have the xtuple database backups in $XTUPLE_DIR"
  echo "Please download them from http://www.sourceforge.net/projects/postbooks"
fi

