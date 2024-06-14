import psycopg2
from psycopg2 import sql
from database import PostgreSQLManager
from faker import Faker

class AutoCreate(PostgreSQLManager):
    def __init__(self, dbname, user, password, host):
        super().__init__(dbname, user, password, host)
        self.fake = Faker()

    def generate_password(self):
        password = self.fake.word()
        return password

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

    def create_user_and_db(self, username, password, dbname):
        try:
            if not self.user_exists(username):
                self.cur.execute(
                    sql.SQL("CREATE USER {} WITH PASSWORD %s").format(
                        sql.Identifier(username)
                    ),
                    [password],
                )
                print(f"Пользователь {username} создан.")
            else:
                print(f"Пользователь {username} уже существует, пропуск создания.")

            if not self.database_exists(dbname):
                self.cur.execute(
                    sql.SQL("CREATE DATABASE {}").format(sql.Identifier(dbname))
                )
                print(f"База данных {dbname} создана.")
                self.cur.execute(
                    sql.SQL("GRANT ALL PRIVILEGES ON DATABASE {} TO {}").format(
                        sql.Identifier(dbname), sql.Identifier(username)
                    )
                )
            else:
                print(f"База данных {dbname} уже существует, пропуск создания.")
        except Exception as e:
            print(f"Произошла ошибка при создании пользователя и базы данных: {e}")
            raise

    def create_main_db_and_table(self):
        try:
            if not self.database_exists("BaseAll"):
                self.cur.execute('CREATE DATABASE "BaseAll"')
                print("База данных BaseAll создана.")
            else:
                print("База данных BaseAll уже существует, пропуск создания.")

            self.conn.close()
            self.conn = psycopg2.connect(
                dbname="BaseAll",
                user="sa",
                password="D_01",
                host="localhost",
            )
            self.cur = self.conn.cursor()

            if not self.table_exists("UsersAll"):
                self.cur.execute(
                    """
                CREATE TABLE "UsersAll" (
                    id SERIAL PRIMARY KEY,
                    username VARCHAR(50) NOT NULL,
                    password VARCHAR(255) NOT NULL
                )
                """
                )
                self.conn.commit()
                print('Таблица "UsersAll" создана.')
            else:
                print('Таблица "UsersAll" уже существует, пропуск создания.')
        except Exception as e:
            print(f"Произошла ошибка при создании основной базы данных и таблицы: {e}")
            raise

    def insert_user_into_table(self, username, password):
        try:
            self.cur.execute(
                'INSERT INTO "UsersAll" (username, password) VALUES (%s, %s)',
                (username, password),
            )
            self.conn.commit()
            print(f'Пользователь {username} вставлен в таблицу "UsersAll".')
        except Exception as e:
            print(f"Произошла ошибка при вставке пользователя в таблицу: {e}")
            raise

def main():
    manager = AutoCreate(
        dbname="postgres",
        user="sa",
        password="D_01",
        host="localhost",
    )

    users = []
    for i in range(1, 11):
        username = f"b{i}"
        password = manager.generate_password()
        dbname = f"Base{i}"
        users.append((username, password, dbname))
        manager.create_user_and_db(username, password, dbname)

    manager.create_main_db_and_table()

    for user in users:
        manager.insert_user_into_table(user[0], user[1])

    manager.close_connection()

    print("Все пользователи и базы данных созданы.")


if __name__ == "__main__":
    main()
