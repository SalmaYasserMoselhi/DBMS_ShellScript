# 🗄️ BASH DBMS PROJECT
## Team Roadmap & Task Breakdown

---

| 👤 Salma | 👤 Rana |
|----------|---------|
| Team Member 1 | Team Member 2 |

**Duration: 4 Days  |  Language: Bash Shell Script**

---

## 📖 How to Read This Document

Each task card tells you:
- **What to build** in that subtask
- **Prerequisites** — what you must know or finish first
- **Search Terms** — exact phrases to Google/YouTube if you get stuck
- **Which team member** owns that task

Color coding:
- 🔵 **Blue** = Salma (Team Member 1)
- 🟢 **Green** = Rana (Team Member 2)
- 🟡 **Yellow** = Both members together

> [!WARNING]
> Do NOT start Day 2 tasks until Day 1 tasks are complete. Both members must sync at the end of each day to merge their work.

---

## 🔰 Before You Start: Bash Fundamentals

If you are new to Bash, learn these concepts **BEFORE Day 1**. Spend 2–3 hours on them.

| Concept | What is it? | Search Term |
|---------|------------|-------------|
| **Variables** | `name="Salma"` then `echo $name` | `bash variables tutorial` |
| **Read input** | `read -p "Enter name: " name` | `bash read command user input` |
| **If / Elif / Else** | `if [ condition ]; then ... fi` | `bash if else statement` |
| **While loop** | `while true; do ... done` | `bash while loop` |
| **Case statement** | Match user choice to an action (like switch) | `bash case statement menu` |
| **Functions** | `my_func() { ... }` then call `my_func` | `bash functions tutorial` |
| **Files & Directories** | `mkdir`, `ls`, `rm`, `touch`, `cat`, `echo >>` | `bash file operations tutorial` |
| **String comparison** | `[ "$var" == "hello" ]` or `[ -z "$var" ]` | `bash string comparison operators` |
| **source command** | Load another script's functions: `source file.sh` | `bash source command script` |

---

## 📁 Project File Structure

```
dbms.sh                  ← Entry point (Salma & Rana integrate here)
scripts/
  ├── main_menu.sh       ← Main DB operations menu
  ├── db_utils.sh        ← Connect, Drop, List DBs 
  ├── table_menu.sh      ← Table operations submenu 
  ├── schema_builder.sh  ← Table creation logic
  ├── table_utils.sh     ← Drop, List tables
  ├── insert.sh          ← Add row
  ├── select.sh          ← View rows
  ├── update.sh          ← Edit row
  └── delete.sh          ← Remove row
databases/               
  └── school/
        ├── students.meta   ← id:int:pk|name:str|age:int
        └── students.tbl    ← 1|Ahmed|22
```

---

## 📅 Day 1 — Database Level Management

**Goal:** Establish the main framework and handle Database creation, listing, dropping, and connecting. Each member builds an independent, end-to-end functionality.

---

### Task 1: Project Skeleton, Main Menu & Create DB  `[Day 1 — Morning]`
#### 👤 🔵 Salma (Team Member 1)

**🎯 Goal:** Build the complete project entry point, the main interactive menu, and the ability to create new databases start-to-finish.

**📋 Steps:**
1. Create `dbms.sh`, `databases/`, and `scripts/`.
2. Create `scripts/main_menu.sh` and build the `while true` loop with a `case` menu.
3. Implement `create_database()` in this script: Validate input, create the directory inside `databases/`.
4. Connect `dbms.sh` to run this menu. 

**📚 Prerequisites & Search Terms:**
- `bash while shell menu case statement`
- `bash mkdir check directory exists -d`

---

### Task 2: List DB, Drop DB & Connect DB  `[Day 1 — Afternoon]`
#### 👤 🟢 Rana (Team Member 2)

**🎯 Goal:** Build a complete utilities module for managing databases that already exist.

**📋 Steps:**
1. Create `scripts/db_utils.sh`.
2. Write `list_databases()`: use `ls` on `databases/`.
3. Write `drop_database()`: Prompt, confirm with y/n, and securely `rm -r`.
4. Write `connect_database()`: Verify DB exists, set `export CURRENT_DB="databases/$name"`, and invoke the Table Menu (placeholder).

**📚 Prerequisites & Search Terms:**
- `bash ls empty directory check`
- `bash export global variable scope`
- `bash prompt yes no confirmation`

---

## 📅 Day 2 — Table Initialization & Management

**Goal:** Provide full schema definitions and table operations inside a connected database.

---

### Task 3: Table Menu & Create Schema  `[Day 2 — Morning]`
#### 👤 🔵 Salma (Team Member 1)

**🎯 Goal:** Provide the complete table workspace menu and the complex metadata logic for defining a new table.

**📋 Steps:**
1. Create `scripts/table_menu.sh` with the second `while/case` interactive loop.
2. Create `scripts/schema_builder.sh` to handle `create_table()`.
3. Inside `create_table()`: Prompt for name, col count. Loop `for` each column to ask name/datatype. Identify the Primary Key. 
4. Pack everything into a `.meta` file string (`id:int:pk|name:str`) and create an empty `.tbl`.

**📚 Prerequisites & Search Terms:**
- `bash read inside for loop`
- `bash string concatenation`
- `bash echo write file >`

---

### Task 4: List Tables & Drop Table  `[Day 2 — Afternoon]`
#### 👤 🟢 Rana (Team Member 2)

**🎯 Goal:** Build the full table utilities functionality to let users browse schemas and wipe out existant tables safely.

**📋 Steps:**
1. Create `scripts/table_utils.sh`. 
2. Write `list_tables()`: Iterate over `.tbl` files in `$CURRENT_DB` and print their names cleanly using `basename`.
3. Write `drop_table()`: Validate table existence, warn user, then `rm` both the `.meta` and `.tbl` companion files.

**📚 Prerequisites & Search Terms:**
- `bash loop through files in directory glob`
- `bash basename omit extension`
- `bash file exists check -f`

---

## 📅 Day 3 — Core Data Operations (Create & Read)

**Goal:** Manipulate the actual `.tbl` data safely.

---

### Task 5: Insert Data & Validation  `[Day 3 — Full Day]`
#### 👤 🔵 Salma (Team Member 1)

**🎯 Goal:** Create a bulletproof insertion engine that reads the metadata schema, asks the user for values, validates datatypes, and appends to the file.

**📋 Steps:**
1. Create `scripts/insert.sh`. 
2. Read `.meta` using `IFS` to extract column types and PK rules.
3. Prompt sequentially for inputs. If type is `int`, regex validate.
4. If it's a PK column, verify the value doesn't already exist in `.tbl` via `awk` or `grep`.
5. Join values with `|` and `echo >>` to the `.tbl`.

**📚 Prerequisites & Search Terms:**
- `bash read string split by delimiter IFS`
- `bash regex number validation`
- `bash check if exact string exists in column grep cut`

---

### Task 6: Select & Formatting Engine  `[Day 3 — Full Day]`
#### 👤 🟢 Rana (Team Member 2)

**🎯 Goal:** Build the report engine that pulls raw `.tbl` data, pairs it with `.meta` headers, and presents a beautiful tabular display.

**📋 Steps:**
1. Create `scripts/select.sh`.
2. Extract the column header names from the `.meta` file.
3. Read the contents of the `.tbl` file.
4. Pipe headers and data together into `column -t -s '|'` to render an aligned grid interface. Handle empty states gracefully.

**📚 Prerequisites & Search Terms:**
- `bash column command formatting alignment`
- `bash extract values from file sed awk`
- `bash echo variable multiline pipe`

---

## 📅 Day 4 — Advanced Data Operations (Update & Delete) & Testing

---

### Task 7: Update Data Engine  `[Day 4 — Morning]`
#### 👤 🔵 Salma (Team Member 1)

**🎯 Goal:** Allow the user to edit a specific cell in an existing record securely.

**📋 Steps:**
1. Create `scripts/update.sh`.
2. Prompt for Primary Key to locate the exact record.
3. Ask which column to change and the new value. (Apply identical datatype validation from Task 5).
4. Use `awk` to replace only that field in that specific row, output to a temporary file, and `mv` overwrite the original.

**📚 Prerequisites & Search Terms:**
- `bash awk edit specific column in row matching pattern`
- `bash replace text redirect to tmp file mv`

---

### Task 8: Delete Data Engine  `[Day 4 — Morning]`
#### 👤 🟢 Rana (Team Member 2)

**🎯 Goal:** Allow the user to remove specific rows based off search criteria cleanly.

**📋 Steps:**
1. Create `scripts/delete.sh`.
2. Ask user for a value to search for (e.g., PK).
3. Use `awk` or `grep -v` to filter out records that match this value, write the remaining rows to a temporary file, and replace the `.tbl`.
4. Validate successfully removed lines counting rows before/after.

**📚 Prerequisites & Search Terms:**
- `bash awk filter out rows`
- `bash line count wc -l`
- `bash grep reverse invert match -v`

---

### Task 9: Integration Testing & Bug Fixing `[Day 4 — Afternoon]`
#### 👤 🟡 Both Members Together

**🎯 Goal:** Connect every module inside `dbms.sh`, run the system end-to-end, and test edge cases.

**📋 Checklist:**
- Combine Scripts in `dbms.sh`/menus.
- Test duplicated setups.
- Test empty database listings.
- Test Regex rules and PK violations.
- Verify Update correctly aligns columns.

---

## 📋 New Task Assignment Summary

| Day | Salma 🔵 (Data Initiation & Structuring) | Rana 🟢 (Data Management & Reporting) |
|-----|------------------------------------------|-----------------------------------------|
| **Day 1** | ✅ Project entry, Main Menu interactions, Create DB | ✅ List DBs, Connect DB, Drop DB |
| **Day 2** | ✅ Table Menu, Create Table & Metadata generation | ✅ List Tables, Drop Tables safely |
| **Day 3** | Insert Data (with DataType/PK Validation loop) | Select Data (Build the Grid viewing engine) |
| **Day 4** | Update Data (Row Field replacement) | Delete Data (Row targeting and removal) |
| **Testing** | 🟡 Integration Testing & Bug Fixing | 🟡 Integration Testing & Bug Fixing |

Good luck Salma & Rana! 🚀
