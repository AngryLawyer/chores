namespace eval ::chores::database::sqlite {
    variable db

    proc init {} {
        variable db
        package require sqlite3
        sqlite3 db chores.db
    }

    proc shutdown {} {
        variable db
        db close
    }

    proc all_chores {} {
    }

    proc chores_for_day {week day} {
    }

    proc chores_for_week {week} {
    }

    proc all_weeks {} {
    }

    proc new_chore {title description} {
    }
}
