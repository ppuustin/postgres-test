set usr=postgres
set pwd=postgres
set pgd=/var/lib/postgresql/data/pgdata
set vol=<usr>\postgres-test\:/var/lib/postgresql/data
set img=timescale/timescaledb-ha:pg18
set port=5432:5432
set name=timescaledb
set pgdb=tsdb

:: (1) create

docker run --name %name% --rm -e POSTGRES_USER=%usr% -e POSTGRES_PASSWORD=%pwd% -e POSTGRES_DB=%pgdb% -e PGDATA=%pgd% -v %vol% -p %port% -it %img% && ( pause ) || ( pause )

:: (2) check

::docker exec -it %name% psql -U %usr% -c \dx && ( pause ) || ( pause )
::docker exec -it %name% psql -U %usr% -d %pgdb%
::docker exec -it %name% psql -U %usr% -c "CREATE EXTENSION IF NOT EXISTS timescaledb" && ( pause ) || ( pause )
::docker exec -it %name% psql -U %usr% -c "SELECT extversion FROM pg_extension WHERE extname='timescaledb'" && ( pause ) || ( pause )

:: (3) misc commands

::docker exec -it basic-postgres psql -U postgres -c "CREATE SCHEMA IF NOT EXISTS my_schema" && ( pause ) || ( pause )
::docker exec -it basic-postgres psql -U postgres -c "CREATE USER IF NOT EXISTS xx CREATEDB PASSWORD 'xx'" && ( pause ) || ( pause )

:: (4) import dump

set dmp=xxx.dump
::docker exec -it %name% psql -U %usr% -d %pgdb% -c "SELECT timescaledb_pre_restore();" && ( pause ) || ( pause )
::docker cp %dmp% %name%:%dmp% && ( pause ) || ( pause )
::docker exec -it %name% pg_restore -h localhost -d %pgdb% -U %usr% /%dmp% && ( pause ) || ( pause )
::docker exec -it %name% psql -U %usr% -d %pgdb% -c "SELECT timescaledb_post_restore();" && ( pause ) || ( pause )


::docker exec -it %name% psql -U %usr% -d %pgdb% -c \d && ( pause ) || ( pause )
::docker exec -it %name% psql -U %usr% -d %pgdb% -c \d+ && ( pause ) || ( pause )
::docker exec -it %name% psql -U %usr% -d %pgdb% -c "SELECT COUNT(*) from xxx" && ( pause ) || ( pause )
::docker exec -it %name% psql -U %usr% -d %pgdb% -c "\d xxx" && ( pause ) || ( pause )





