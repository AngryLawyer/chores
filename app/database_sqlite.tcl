namespace eval ::chores::database::sqlite {
    variable db

    proc init {path} {
        variable db
        package require sqlite3
        puts $path
        sqlite3 db $path -create 0
    }

    proc shutdown {} {
        variable db
        db close
    }

    proc all_chores {} {
        variable db
        set output [list]
        db eval { SELECT id, title, description FROM chores; } {
            lappend output [dict create \
                id $id \
                title $title \
                description $description \
            ]
        }
        return $output
    }

    proc chores_for_day {week day} {
        variable db
    }

    proc chores_for_week {week} {
        variable db
    }

    proc all_weeks {} {
        variable db
    }

    proc remove_chore_from_day {link_id} {
        variable db
    }

    proc remove_chore_from_all_days {chore_id} {
        variable db
    }

    proc add_chore_to_day {day week chore_id} {
        variable db
    }

    proc new_chore {title description} {
        variable db
        db eval { INSERT INTO chores (title, description) VALUES (:title, :description);}
    }

    proc delete_chore {id} {
        variable db
    }
}
