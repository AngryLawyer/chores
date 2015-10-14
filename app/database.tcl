namespace eval ::chores::database {

    variable dummy 0
    variable impl

    proc delegate {impl method} {
        return [join [list $impl :: $method] ""]
    }

    proc init {} {
        variable dummy
        variable impl
        if {$dummy eq 0} {
            set impl ::chores::database::sqlite
        } else {
            set impl ::chores::database::dummy
        }
        [delegate $impl init]
    }

    proc shutdown {} {
        variable impl
        [delegate $impl shutdown]
    }

    proc all_chores {} {
        variable impl
        [delegate $impl all_chores]
    }

    proc chores_for_day {week day} {
        variable impl
        [delegate $impl chores_for_day] $week $day
    }

    proc chores_for_week {week} {
        variable impl
        [delegate $impl chores_for_week] $week
    }

    proc all_weeks {} {
        variable impl
        [delegate $impl all_weeks]
    }

    proc delete_chore {id} {
        variable impl
        [delegate $impl delete_chore] $id
    }

    proc add_chore_to_day {day week chore_id} {
        variable impl
        [delegate $impl add_chore_to_day] $day $week $chore_id
    }

    proc remove_chore_from_day {link_id} {
        variable impl
        [delegate $impl remove_chore_from_day] $link_id
    }

    proc remove_chore_from_all_days {chore_id} {
        variable impl
        [delegate $impl remove_chore_from_all_days $chore_id
    }

    proc new_chore {title description} {
        variable impl
        [delegate $impl new_chore] $title $description
    }
}
