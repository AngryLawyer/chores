set path [lindex $argv 1]

package require sqlite3
sqlite3 db $path

db eval {CREATE TABLE chores (
    id INT PRIMARY KEY NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL
);}

db eval {CREATE TABLE chore_for_day (
    id INT PRIMARY KEY NOT NULL,
    chore_id INT NOT NULL,
    week CHAR(1) NOT NULL,
    DAY INT NOT NULL
);}

db close
