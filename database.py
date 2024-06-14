import psycopg2


class PostgreSQLManager:
    def __init__(self, dbname, user, password, host):
        self.dbname = dbname
        self.user = user
        self.password = password
        self.host = host
        try:
            self.conn = psycopg2.connect(
                dbname=dbname, user=user, password=password, host=host
            )
            self.conn.autocommit = True
            self.cur = self.conn.cursor()
        except Exception as e:
            print(f"Произошла ошибка: {e}")
            raise

    def close_connection(self):
        try:
            self.cur.close()
            self.conn.close()
            print("Соединение с базой данных закрыто.")
        except Exception as e:
            print(f"Произошла ошибка при закрытии соединения: {e}")
            raise
