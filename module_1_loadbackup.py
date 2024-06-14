from database import PostgreSQLManager
import subprocess
import os


class LoadBackup(PostgreSQLManager):
    def __init__(self, dbname, user, password, host, backup_file):
        super().__init__(dbname, user, password, host)
        self.backup_file = backup_file

    def run_restore(self):
        try:
            if not os.path.isfile(self.backup_file):
                raise FileNotFoundError(f"Бэкап '{self.backup_file}' не найден.")

            subprocess.run(
                [
                    "C:/Program Files/PostgreSQL/16/bin/pg_restore",
                    f"--dbname=postgresql://{self.user}:{self.password}@{self.host}/{self.dbname}",
                    "--clean",
                    "--no-owner",
                    "--no-acl",
                    self.backup_file,
                ],
                check=True,
            )
            print("Восстановление базы данных успешно завершено.")
        except subprocess.CalledProcessError as e:
            print(f"Ошибка при выполнении восстановления базы данных: {e}")


def main():
    manager = LoadBackup(
        dbname="BaseAll",
        user="sa",
        password="D_01",
        host="localhost",
        backup_file="./backups/BaseAll_backup_2024-06-13_21-59-07.sql",
    )

    manager.run_restore()
    manager.close_connection()


if __name__ == "__main__":
    main()
