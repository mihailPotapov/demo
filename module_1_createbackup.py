from database import PostgreSQLManager
import subprocess
import datetime
import os


class CreateBackup(PostgreSQLManager):
    def __init__(self, dbname, user, password, host, backup_path):
        super().__init__(dbname, user, password, host)
        self.backup_path = backup_path

        if not os.path.exists(backup_path):
            os.makedirs(backup_path)

    def run_backup(self):
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        backup_file = f"{self.dbname}_backup_{timestamp}.sql"
        backup_file_path = f"{self.backup_path}/{backup_file}"

        try:
            subprocess.run(
                [
                    # "C:/Program Files/PostgreSQL/16/bin/pg_dump"
                    "C:/Program Files/PostgreSQL/14/bin/pg_dump",
                    f"--dbname=postgresql://{self.user}:{self.password}@{self.host}/{self.dbname}",
                    "--format=plain",
                    "--no-owner",
                    "--no-acl",
                    "--file=" + backup_file_path,
                ],
                check=True,
            )
            print(
                f"Резервное копирование базы данных успешно завершено. Файл: {backup_file_path}"
            )
        except subprocess.CalledProcessError as e:
            print(f"Ошибка при выполнении резервного копирования: {e}")


def main():
    manager = CreateBackup(
        dbname="BaseAll",
        user="sa",
        password="D_01",
        host="localhost",
        backup_path="./backups",
    )

    manager.run_backup()
    manager.close_connection()


if __name__ == "__main__":
    main()
