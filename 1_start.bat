
set usr=postgres
set pwd=postgres
set pgd=/var/lib/postgresql/data/pgdata
set vol=C:\Users\xxx\postgres-test\data:/var/lib/postgresql/data
set img=postgres:14.1-alpine
set port=5432:5432
set name=basic-postgres

docker run --name %name% --rm -e POSTGRES_USER=%usr% -e POSTGRES_PASSWORD=%pwd% -e PGDATA=%pgd% -v %vol% -p %port% -it %img% && ( pause ) || ( pause )
