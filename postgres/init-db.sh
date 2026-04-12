#!/bin/bash
set -e

function create_user_and_database() {
    local database=$1
    local user=$2
    local password=$3

    echo "  Starting creation of database '$database' and user '$user'..."

    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
        DO \$$
        BEGIN
            IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$user') THEN
                CREATE USER $user WITH ENCRYPTED PASSWORD '$password';
            END IF;
        END
        \$$;

        SELECT 'CREATE DATABASE $database'
        WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$database')\gexec

        GRANT ALL PRIVILEGES ON DATABASE $database TO $user;
        ALTER DATABASE $database OWNER TO $user;
EOSQL
}

create_user_and_database "$CUSTOMERS_DB_NAME" "$CUSTOMERS_DB_USER" "$CUSTOMERS_DB_PASS"
create_user_and_database "$INSURANCE_DB_NAME" "$INSURANCE_DB_USER" "$INSURANCE_DB_PASS"