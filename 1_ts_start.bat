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


:: (5) query optimization

:: CREATE TABLE telemetry (
::    time        TIMESTAMPTZ NOT NULL,
::    sensor_id   INTEGER NOT NULL,
::    value       DOUBLE PRECISION
:: );
:: SELECT create_hypertable('telemetry', 'time');
:: SELECT * FROM telemetry WHERE time >= '2026-01-01 00:00:00' AND time <= '2026-01-31 23:59:59';

:: SELECT date_trunc('day', time) as d ... OR
:: SELECT time_bucket('1 day', time) as d, sensor_id, COUNT(*) as cnt, AVG(value) as avg_val, stddev(value) as tddev_val
:: FROM telemetry WHERE time >= '..' AND time <= '..' GROUP BY d, sensor_id HAVING stddev(value) > 2 ORDER BY d, sensor_id;

:: CREATE MATERIALIZED VIEW ts_daily_stats WITH (timescaledb.continuous) AS
:: SELECT time_bucket('1 day', time) as d, sensor_id, AVG(value) as avg, MIN(value) as min, MAX(value) as max, COUNT(*) as cnt
:: FROM telemetry GROUP BY d, sensor_id; 
:: -- automatic refresh policy
:: SELECT add_continuous_aggregate_policy('ts_daily_stats', start_offset => INTERVAL '3 days', end_offset => INTERVAL '1 hour', schedule_interval => INTERVAL '1 hour');
:: SELECT * FROM ts_daily_stats WHERE day >= '..' AND day <= '..' ORDER BY day, sensor_id;

:: SELECT pg_total_relation_size('telemetry')/1024/1024 as size_mb;
:: SELECT hypertable_size('telemetry')/1024/1024 as size_mb;
:: ALTER TABLE telemetry SET (timescaledb.compress, timescaledb.compress_segmentby = 'sensor_id', timescaledb.compress_orderby='time');
:: SELECT add_compression_policy('telemetry', INTERVAL '7 days');
:: SELECT hypertable_size('telemetry')/1024/1024 as size_mb;