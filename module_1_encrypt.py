from database import PostgreSQLManager
from cryptography.fernet import Fernet


class Encrypt(PostgreSQLManager):
    def __init__(self, dbname, user, password, host, key_file="encryption_key.key"):
        super().__init__(dbname, user, password, host)
        self.key_file = key_file
        self.key = self.load_or_generate_key()
        self.cipher_suite = Fernet(self.key)

    def load_or_generate_key(self):
        try:
            with open(self.key_file, "rb") as file:
                key = file.read()
                print("Ключ шифрования загружен.")
        except FileNotFoundError:
            key = Fernet.generate_key()
            with open(self.key_file, "wb") as file:
                file.write(key)
                print("Ключ шифрования создан и сохранен.")
        return key

    def encrypt_passwords(self):
        try:
            self.cur.execute('SELECT id, password FROM "UsersAll"')
            rows = self.cur.fetchall()
            for row in rows:
                encrypted_password = self.cipher_suite.encrypt(row[1].encode()).decode()
                self.cur.execute(
                    'UPDATE "UsersAll" SET password = %s WHERE id = %s',
                    (encrypted_password, row[0]),
                )
            self.conn.commit()
            print("Пароли всех пользователей зашифрованы.")
        except Exception as e:
            print(f"Произошла ошибка при шифровании паролей: {e}")
            raise


def main():
    manager = Encrypt(
        dbname="BaseAll",
        user="sa",
        password="D_01",
        host="localhost",
    )

    manager.encrypt_passwords()
    manager.close_connection()


if __name__ == "__main__":
    main()