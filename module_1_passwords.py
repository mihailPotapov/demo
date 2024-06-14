from database import PostgreSQLManager
from cryptography.fernet import Fernet


class Decrypt(PostgreSQLManager):
    def __init__(self, dbname, user, password, host, key_file="encryption_key.key"):
        super().__init__(dbname, user, password, host)
        self.key_file = key_file
        self.key = self.load_key()
        self.cipher_suite = Fernet(self.key)

    def load_key(self):
        try:
            with open(self.key_file, "rb") as file:
                key = file.read()
                print("Ключ шифрования загружен.")
        except FileNotFoundError:
            print(
                "Файл ключа не найден. Убедитесь, что ключ существует и попробуйте снова."
            )
            raise
        return key

    def decrypt_passwords(self):
        try:
            self.cur.execute('SELECT username, password FROM "UsersAll"')
            rows = self.cur.fetchall()
            for row in rows:
                encrypted_password = row[1]
                decrypted_password = self.cipher_suite.decrypt(
                    encrypted_password.encode()
                ).decode()
                print(f"Пользователь {row[0]} имеет пароль: {decrypted_password}")
        except Exception as e:
            print(f"Произошла ошибка при расшифровке паролей: {e}")
            raise


def main():
    manager = Decrypt(
        dbname="BaseAll",
        user="sa",
        password="D_01",
        host="localhost",
    )

    manager.decrypt_passwords()
    manager.close_connection()


if __name__ == "__main__":
    main()
