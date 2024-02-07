# ITI-DataBase-Bash-Shell-Project

This project aims to develop a simple Database Management System (DBMS) using Bash shell scripting, allowing users to store and retrieve data from a hard disk. The system will operate through a command-line interface (CLI) menu, providing various options for managing databases and tables.

## Project Features

### Main Menu

The application's main menu offers the following options:

- **Create Database**: Allows users to create a new database.
- **List Databases**: Lists all existing databases.
- **Connect To Database**: Enables users to connect to a specific database.
- **Drop Database**: Allows users to delete a database.

### Database Menu

Once connected to a specific database, users are presented with a new menu offering the following options:

- **Create Table**: Allows users to define a new table within the connected database.
- **List Tables**: Lists all tables existing within the connected database.
- **Drop Table**: Enables users to delete a table from the connected database.
- **Insert into Table**: Allows users to insert new records into a specified table.
- **Select From Table**: Retrieves and displays records from a specified table.
- **Delete From Table**: Deletes records from a specified table based on specified criteria.
- **Update Table**: Allows users to update existing records in a specified table.

## Implementation Hints

- Databases are stored as directories within the same directory as the script file under the directory of `/DataBases`.
- Row selection output is formatted for easy readability in the terminal.
- The script prompts users for column datatypes during table creation and ensures data integrity during insertion and updating.
- Users are prompted for primary key information during table creation, and the script enforces primary key constraints during record insertion.

## Usage

1. Clone the repository to your local machine.
2. Navigate to the directory containing the script.
3. Make the script executable if necessary (`chmod +x script_name.sh`).
4. Run the script (`./script_name.sh`).
5. Follow the on-screen instructions to interact with the DBMS.

## Example
```
$ ./dbms.sh
Welcome to Bash DBMS!

Main Menu:
1. Create Database
2. List Databases
3. Connect To Database
4. Drop Database
5. Exit

Please enter your choice: 1

Enter database name: my_database
Database 'my_database' created successfully!

Main Menu:
1. Create Database
2. List Databases
3. Connect To Database
4. Drop Database
5. Exit

Please enter your choice: 3

Enter database name: my_database
Connected to database 'my_database' successfully!

Database Menu:
1. Create Table
2. List Tables
3. Drop Table
4. Insert into Table
5. Select From Table
6. Delete From Table
7. Update Table
8. Return to Main Menu

Please enter your choice: 1

Enter table name: employees
Enter column names and datatypes (e.g., id int, name varchar): id int, name varchar, age int
Enter primary key (leave empty for none): id
Table 'employees' created successfully!

Database Menu:
1. Create Table
2. List Tables
3. Drop Table
4. Insert into Table
5. Select From Table
6. Delete From Table
7. Update Table
8. Return to Main Menu

Please enter your choice: 4

Enter table name: employees
Enter values for columns (e.g., 1, 'John', 30): 1, 'John', 30
Record inserted successfully!

...

```
