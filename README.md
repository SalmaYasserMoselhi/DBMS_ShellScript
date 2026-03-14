# Bash DBMS 🚀

A clear, lightweight, and powerful Database Management System built entirely in **Bash**. It uses the Linux filesystem as its engine, where directories represent databases and files represent tables.

## ✨ Features

### 📂 Database Management
- **Create Database**: Create a new safe directory for your tables.
- **List Databases**: View all existing databases.
- **Connect to Database**: Enter a database to manage its tables and data.
- **Drop Database**: Permanently remove a database and all its contents with confirmation.

### 📊 Table Management
- **Create Table**: Define your schema with specific column names, data types (`int` or `str`), and a mandatory **Primary Key**.
- **List Tables**: View all tables within the connected database.
- **Drop Table**: Delete a table and its metadata.

### 📝 Data Operations (CRUD)
- **Insert Data**: Add new rows with real-time validation for data types and Primary Key uniqueness.
- **Select Data**: View your data in a beautiful, formatted table layout.
- **Update Data**: Modify specific column values in existing rows using the Primary Key.
- **Delete Data**: Remove specific rows securely using the Primary Key with a confirmation prompt.

## 🛠️ Built With
- **Bash Scripting**: Pure shell logic.
- **Linux Tools**: `awk` for data processing, `column` for display, `sed` and `grep` for validation.
- **System Design**: Directories for DBs, `.meta` files for schemas, and `.tbl` files for pipe-delimited data.

## 🚀 Getting Started

1. **Clone the Repo**:
   ```bash
   git clone <repo-url>
   cd DBMS_ShellScript
   ```

2. **Setup Permissions**:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. **Run the App**:
   ```bash
   ./dbms.sh
   ```
   *Note: After running setup, you can run `dbms.sh` from any directory!*

## 🎨 Professional Style
Designed with a premium terminal UI featuring:
- **Clean Colors**: Green for success, Red for errors, Yellow for prompts.
- **Robust Validation**: Protection against invalid names, duplicate keys, and wrong data types.
- **Safer Inputs**: Uses `read -r` and `extglob` for reliable user interaction.

---
**Developed by Salma & Rana — ITI**