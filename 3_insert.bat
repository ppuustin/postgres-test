set usr=postgres
set dmp=xxx.dump

:: docker cp ./test_data_1.json basic-postgres:test_data_1.json && ( pause ) || ( pause )
:: docker cp ./test_data_1.csv basic-postgres:test_data_1.csv && ( pause ) || ( pause )
:: docker exec -it basic-postgres ls -l && ( pause ) || ( pause )
:: docker exec -it basic-postgres psql -U %usr% -d %usr%  feeds -c "SELECT * FROM PERSON;"  && ( pause ) || ( pause )

:: docker exec -it basic-postgres psql -U %usr% -d %usr% feeds -c  "COPY PERSON (PERSON_KEY, NAME, ATTRIBUTES, CREATED, STATUS) From './test_data_1.csv' DELIMITER ',' CSV HEADER;" && ( pause ) || ( pause )
:: docker exec -it basic-postgres psql -U %usr% -d %usr% \copy person FROM PROGRAM 'jq -c -r .[] < /root/test_data_1.json'; && ( pause ) || ( pause )

:: docker cp %dmp% basic-postgres:%dmp% && ( pause ) || ( pause )
:: docker exec -it basic-postgres pg_restore -h localhost -d %usr% -U %usr% %dmp% && ( pause ) || ( pause )



