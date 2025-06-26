#!/bin/sh

# You could probably do this fancier and have an array of extensions
# to create, but this is mostly an illustration of what can be done

if test -f '/var/lib/postgresql/data/pg_hba.conf'; then

  if ! grep -q "hostssl $POSTGRES_DB" /var/lib/postgresql/data/pg_hba.conf; then
    # clientcert=verify-ca | verify-full
    echo "hostssl $POSTGRES_DB all all scram-sha-256" >> /var/lib/postgresql/data/pg_hba.conf
  fi
else
  # https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
  cat > /var/lib/postgresql/data/pg_hba.conf << EOL
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     trust
host    replication     all             127.0.0.1/32            trust
host    replication     all             ::1/128                 trust

hostssl $POSTGRES_DB all all scram-sha-256
EOL

  chown postgres:postgres /var/lib/postgresql/data;
  chmod 750 /var/lib/postgresql/data
  chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf;
  chmod 600 /var/lib/postgresql/data/pg_hba.conf;
fi

if !(psql -U $POSTGRES_USER -tAc "select 1 from pg_user where usename='${tilt_USER}'" | grep -q 1); then
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -tAc "create user ${tilt_USER} with password '${tilt_PASSWORD}';"
fi

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -c 'create extension if not exists "pg_stat_statements";' $POSTGRES_DB

# Install uuid support if required.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c 'create extension if not exists "uuid-ossp";' $POSTGRES_DB

# Install tablefunc support if required.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c 'create extension if not exists "tablefunc";' $POSTGRES_DB

# Install unaccent support if required.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c 'create extension if not exists "unaccent";' $POSTGRES_DB

# Install pg_trgm support if required.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c 'create extension if not exists "pg_trgm";' $POSTGRES_DB

# Create data schema if required.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "create schema if not exists ${DB_SCHEMA} authorization ${tilt_USER};" $POSTGRES_DB
