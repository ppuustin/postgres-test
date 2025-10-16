
docker cp ./create_tables.sql basic-postgres:create_tables.sql
docker exec -it basic-postgres psql -U postgres -d postgres -f ./create_tables.sql && ( pause ) || ( pause )
