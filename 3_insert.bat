
:: docker cp ./test_data_1.json basic-postgres:test_data_1.json && ( pause ) || ( pause )
:: docker cp ./test_data_1.csv basic-postgres:test_data_1.csv && ( pause ) || ( pause )
:: docker exec -it basic-postgres ls -l && ( pause ) || ( pause )
:: docker exec -it basic-postgres psql -U postgres -d postgres  feeds -c "SELECT * FROM PERSON;"  && ( pause ) || ( pause )

:: docker exec -it basic-postgres psql -U postgres -d postgres feeds -c  "COPY PERSON (PERSON_KEY, NAME, ATTRIBUTES, CREATED, STATUS) From './test_data_1.csv' DELIMITER ',' CSV HEADER;" && ( pause ) || ( pause )
:: docker exec -it basic-postgres psql -U postgres -d postgres \copy person FROM PROGRAM 'jq -c -r .[] < /root/test_data_1.json'; && ( pause ) || ( pause )




