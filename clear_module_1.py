import psycopg2
from psycopg2 import sql
from database import PostgreSQLManager


class ClearModule(PostgreSQLManager):
    def user_exists(self, username):
        self.cur.execute("SELECT 1 FROM pg_roles WHERE rolname=%s", (username,))
        return self.cur.fetchone() is not None

    def database_exists(self, dbname):
        self.cur.execute("SELECT 1 FROM pg_database WHERE datname=%s", (dbname,))
        return self.cur.fetchone() is not None

    def table_exists(self, table_name):
        self.cur.execute(
            "SELECT 1 FROM information_schema.tables WHERE table_name=%s", (table_name,)
        )
        return self.cur.fetchone() is not None

    def drop_user_and_db(self, username, dbname):
        try:
            if self.database_exists(dbname):
                self.cur.execute(
                    sql.SQL("DROP DATABASE {}").format(sql.Identifier(dbname))
                )
                print(f"База данных {dbname} удалена.")
            else:
                print(f"База данных {dbname} не существует.")

            if self.user_exists(username):
                self.cur.execute(
                    sql.SQL("DROP USER {}").format(sql.Identifier(username))
                )
                print(f"Пользователь {username} удален.")
            else:
                print(f"Пользователь {username} не существует.")
        except Exception as e:
            print(f"Произошла ошибка при удалении пользователя и базы данных: {e}")
            raise

    def drop_main_db_and_table(self):
        try:
            if self.database_exists("BaseAll"):
                self.conn.close()
                self.conn = psycopg2.connect(
                    dbname="BaseAll",
                    user="sa",
                    password="De_01",
                    host="localhost",
                )
                self.cur = self.conn.cursor()

                if self.table_exists("UsersAll"):
                    self.cur.execute('DROP TABLE "UsersAll"')
                    print('Таблица "UsersAll" удалена.')
                else:
                    print('Таблица "UsersAll" не существует.')

                self.conn.close()

                self.conn = psycopg2.connect(
                    dbname="postgres",
                    user="sa",
                    password="De_05",
                    host="localhost",
                )
                self.conn.autocommit = True
                self.cur = self.conn.cursor()

                self.cur.execute('DROP DATABASE "BaseAll"')
                print('База данных "BaseAll" удалена.')
            else:
                print('База данных "BaseAll" не существует.')
        except Exception as e:
            print(f"Произошла ошибка при удалении основной базы данных и таблицы: {e}")
            raise

    def close_connection(self):
        try:
            self.cur.close()
            self.conn.close()
        except Exception as e:
            print(f"Произошла ошибка при закрытии соединения: {e}")
            raise


def main():
    manager = ClearModule(
        dbname="postgres",
        user="sa",
        password="D_01",
        host="localhost",
    )

    for i in range(1, 10):
        username = f"b{i}"
        dbname = f"Base{i}"
        manager.drop_user_and_db(username, dbname)

    manager.drop_main_db_and_table()
    manager.close_connection()

    print("Все пользователи и базы данных удалены.")


if __name__ == "__main__":
    main()
