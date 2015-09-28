namespace eval ::chores::database {

    variable dummy 0
    variable impl

    proc init {} {
        variable dummy
        variable impl
        if {$dummy eq 0} {
            set impl ::chores::database::sqlite
        } else {
            set impl ::chores::database::dummy
        }
        [join [list $impl ::init] ""]
    }

    proc shutdown {} {
        variable impl
        [join [list $impl ::shutdown] ""]
    }

    proc all_chores {} {
        variable impl
        [join [list $impl ::all_chores] ""]
    }

    proc chores_for_day {week day} {
        variable impl
        [join [list $impl ::chores_for_day] ""] $week $day
    }

    proc chores_for_week {week} {
        variable impl
        [join [list $impl ::chores_for_week] ""] $week
    }

    proc all_weeks {} {
        variable impl
        [join [list $impl ::all_weeks]]
    }

    proc new_chore {title description} {
        variable impl
        [join [list $impl ::all_weeks]] $title $description
    }
}
