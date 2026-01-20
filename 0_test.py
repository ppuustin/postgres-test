import os
import matplotlib.pyplot as plt

import pandas as pd

# -------------------------------------------------

class DBAccess:
    def __init__(self):
        self.db_uri = os.getenv('TIMESCALE_URI', 'POSTGRESQL_URI')

# -------------------------------------------------

class DBAccessPsyco(DBAccess):
    def _get_connection(self):
        import psycopg2
        return psycopg2.connect(self.db_uri)

    def _do_query(self, query, params=None, trace=True):
        if trace: print(query)
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                return cursor.fetchall()

    def do_query(self, query, params=None, trace=True):
        if trace: print(query)
        with self._get_connection() as conn:
            return pd.read_sql_query(query, conn)

    def get_db_version(self):
        try:
            conn = self._get_connection()
            cursor = conn.cursor()
            cursor.execute('SELECT VERSION()')
            return cursor.fetchone()[0]
        except Exception as e:
            raise e
        finally:
            if 'cursor' in locals(): cursor.close()
            if 'conn' in locals(): conn.close()

# -------------------------------------------------

class DBAccessSQA(DBAccess):
    def _get_engine(self):
        from sqlalchemy import create_engine
        return create_engine(self.db_uri)

    def do_query(self, query, params=None, trace=True):
        if trace: print(query)
        return pd.read_sql_query(query, self._get_engine)
             
# -------------------------------------------------

def get_tables(db_access, schema=None):
    query, params = 'SELECT table_name FROM information_schema.tables', None
    #query, params = 'SELECT table_name FROM information_schema.tables WHERE table_schema=%s', ['public']
    #query, params = 'SELECT * FROM information_schema.columns WHERE table_name=%s', ['xyz'] # table_schema = 'schema'
    return db_access.do_query(query, params)

def main():
    #print(DBAccessPsyco().get_db_version())
    for t in get_tables(DBAccessPsyco()): print(t)

if __name__=="__main__":
   #pd.set_option('display.max_rows', 500000)
   #pd.set_option('display.max_columns', 100)
   #pd.set_option('display.width', 5000)
   os.environ['TIMESCALE_URI'] = 'postgresql://postgres:postgres@localhost:5432/tsdb' # usr:pwd@host:port/db
   main()

'''
pip install psycopg2
pip install SQLAlchemy
'''