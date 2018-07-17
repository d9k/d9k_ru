# d9k.ru site

## Installation

    sudo apt install gcc git libssl-dev

At first install last version of sailor framework from [sailor repo](https://github.com/sailorproject/sailor):

    git clone https://github.com/sailorproject/sailor.git
    cd sailor
    luarocks install rockspecs/sailor-current-1.rockspec

at cloned sailor repo folder.

Then run `install-deps.sh` from this cloned repo.

Then install luasql-postgres manually!

`sudo apt install libpq-dev`
`luarocks PGSQL_INCDIR=/usr/include/postgresql/ install luasql-postgres`

## Database

d9k.ru uses postgresql as database management system.

At first create database and user with permissions for this database.
The login to created database with psql with superuser (!) and run the following:

    CREATE EXTENSION IF NOT EXISTS plpgsql;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

Database migrationgs are handled with

    https://bitbucket.org/d9kd9k/db_tools

## Autostart daemon

init.d script can be generated with https://gist.github.com/naholyr/4275302, provide restart-xavante-on-lua-change.sh as SCRIPT variable value to init.d script template
