set usr=postgres
set pwd=postgres
set pgd=/var/lib/postgresql/data/pgdata
set vol=<usr>\postgres-test\:/var/lib/postgresql/data
set img=postgres:16.11-alpine
set port=5432:5432
set name=basic-postgres

docker run --name %name% --rm -e POSTGRES_USER=%usr% -e POSTGRES_PASSWORD=%pwd% -e PGDATA=%pgd% -v %vol% -p %port% -it %img% && ( pause ) || ( pause )
