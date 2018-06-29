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
