namespace eval ::chores::database::sqlite {
    variable db

    proc init {path} {
        variable db
        package require sqlite3
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
        set output [list]
        db eval { SELECT c.title, c.description FROM chore_for_day AS cd INNER JOIN chores AS c ON cd.chore_id = c.id WHERE cd.week = :week AND cd.day = :day; } {
            lappend output [dict create \
                title $title \
                description $description \
            ]
        }
        return $output
    }

    proc chores_for_week {week} {
        variable db
        # Unused
    }

    proc all_weeks {} {
        variable db
        set output [dict create \
            A [list [list] [list] [list] [list] [list] [list] [list]] \
            B [list [list] [list] [list] [list] [list] [list] [list]] \
            C [list [list] [list] [list] [list] [list] [list] [list]] \
            D [list [list] [list] [list] [list] [list] [list] [list]] \
        ]

        db eval { SELECT c.title, c.description, cd.week, cd.day, cd.id AS link_id FROM chore_for_day AS cd INNER JOIN chores AS c ON cd.chore_id = c.id; } {
            set week_data [dict get $output $week]
            set day_data [lindex $week_data $day]

            lappend day_data [dict create \
                title $title \
                description $description \
                link_id $link_id
            ]

            lset week_data $day $day_data
            dict set output $week $week_data
        }
        return $output
    }

    proc remove_chore_from_day {link_id} {
        variable db
        db eval { DELETE FROM chore_for_day WHERE id = :link_id; }
    }

    proc remove_chore_from_all_days {chore_id} {
        variable db
        db eval { DELETE FROM chore_for_day WHERE chore_id = :chore_id; }
    }

    proc add_chore_to_day {day week chore_id} {
        variable db
        db eval { INSERT INTO chore_for_day (chore_id, week, day) VALUES (:chore_id, :week, :day); }
    }

    proc new_chore {title description} {
        variable db
        db eval { INSERT INTO chores (title, description) VALUES (:title, :description); }
    }

    proc delete_chore {id} {
        variable db
        remove_chore_from_all_days $id
        db eval { DELETE FROM chores WHERE id = :id; }
    }
}
