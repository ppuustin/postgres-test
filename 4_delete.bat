
docker cp ./delete_tables.sql basic-postgres:delete_tables.sql
docker exec -it basic-postgres psql -U postgres -d postgres -f ./delete_tables.sql && ( pause ) || ( pause )
