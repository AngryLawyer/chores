set path [lindex $argv 0]

package require sqlite3
sqlite3 db $path

db eval {CREATE TABLE chores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT NOT NULL
);}

db eval {CREATE TABLE chore_for_day (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    chore_id INTEGER NOT NULL,
    week CHAR(1) NOT NULL,
    day INT NOT NULL
);}

db close
