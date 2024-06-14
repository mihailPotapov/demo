import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2
from psycopg2 import sql

# Конфигурация базы данных
DB_CONFIG = {
    'dbname': 'hotel',
    'user': 'sa',
    'password': 'D_01',
    'host': 'localhost',
}


# Подключение к базе данных
def connect_db():
    try:
        connection = psycopg2.connect(**DB_CONFIG)
        return connection
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return None


def fetch_data(query, params=None):
    connection = connect_db()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(query, params)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
            return []
    return []


# Функция для фильтрации данных по клиенту
def filter_data():
    selected_client = client_var.get()
    if selected_client:
        query = """
        SELECT CONCAT_WS(' ', g.last_name, g.first_name, COALESCE(g.patronymic, '')) AS client,
               g.phone_number, g.email, rc.check_in_date, rc.check_out_date
        FROM guest g
        JOIN registrationcard rc ON g.guest_id = rc.guest_id
        WHERE CONCAT_WS(' ', g.last_name, g.first_name, COALESCE(g.patronymic, '')) = %s
        ORDER BY g.last_name
        """
        data = fetch_data(query, (selected_client,))
        update_table(data)


# Функция для поиска данных по ключевому слову
def search_data():
    keyword = search_var.get()
    if keyword:
        query = """
        SELECT g.client, g.phone_number, g.email, rc.check_in_date, rc.check_out_date
        FROM guest g
        JOIN registrationcard rc ON g.guest_id = rc.guest_id
        WHERE LOWER(g.last_name) LIKE LOWER(%s)
        ORDER BY g.last_name
        """
        data = fetch_data(query, (f'%{keyword}%',))
        update_table(data)


# Функция для отображения всех гостей
def show_all_clients():
    query = """
    SELECT CONCAT_WS(' ', g.last_name, g.first_name, COALESCE(g.patronymic, '')) AS client,
           g.phone_number, g.email, rc.check_in_date, rc.check_out_date
    FROM guest g
    JOIN registrationcard rc ON g.guest_id = rc.guest_id
    ORDER BY g.last_name
    """
    data = fetch_data(query)
    update_table(data)


# Функция для обновления таблицы
def update_table(data):
    for row in table.get_children():
        table.delete(row)
    for row in data:
        table.insert('', tk.END, values=row)


# Основная программа
root = tk.Tk()
root.title("Работа с регистрационными картами клиентов")

# Строка для выбора клиента
client_var = tk.StringVar()
client_combobox = ttk.Combobox(root, textvariable=client_var)
client_combobox.grid(row=0, column=1, padx=5, pady=5)

# Заполнение комбобокса данными клиентов (только фамилия)
query = """
SELECT client FROM guest
"""
client_combobox['values'] = [row[0] for row in fetch_data(query)]

# Кнопка для фильтрации данных по клиенту
filter_button = ttk.Button(root, text="Фильтровать", command=filter_data)
filter_button.grid(row=0, column=2, padx=5, pady=5)

# Кнопка и поле для поиска по фамилии
search_var = tk.StringVar()
search_entry = ttk.Entry(root, textvariable=search_var)
search_entry.grid(row=0, column=3, padx=5, pady=5)
search_button = ttk.Button(root, text="Поиск", command=search_data)
search_button.grid(row=0, column=4, padx=5, pady=5)

# Кнопка для отображения всех гостей
show_all_button = ttk.Button(root, text="Показать всех гостей", command=show_all_clients)
show_all_button.grid(row=0, column=5, padx=5, pady=5)

# Таблица для отображения данных
columns = ("ФИО", "Телефон", "Электронная почта", "Дата заселения", "Дата выселения")
table = ttk.Treeview(root, columns=columns, show='headings')
for col in columns:
    table.heading(col, text=col)
table.grid(row=1, column=0, columnspan=6, padx=5, pady=5)

# Запуск основного цикла обработки событий
root.mainloop()
