namespace eval ::chores::database::dummy {
    variable store [dict create \
        chores [list] \
    ]
    variable last_id 0

    proc init {} {
    }

    proc shutdown {} {
    }

    proc all_chores {} {
        variable store
        dict get $store chores
    }

    proc chores_for_day {week day} {
        return [all_chores]
    }

    proc chores_for_week {week} {
        return [list \
            [chores_for_day 0 $week] \
            [chores_for_day 1 $week] \
            [chores_for_day 2 $week] \
            [chores_for_day 3 $week] \
            [chores_for_day 4 $week] \
            [chores_for_day 5 $week] \
            [chores_for_day 6 $week] \
        ]
    }

    proc all_weeks {} {
        return [dict create \
            week_a [chores_for_week a]\
            week_b [chores_for_week b]\
            week_c [chores_for_week c]\
            week_d [chores_for_week d]\
        ]
    }

    proc new_chore {title description} {
        variable last_id
        variable store
        dict lappend store chores [dict create \
            id $last_id \
            title $title \
            description $description \
        ]

        puts "$title and $description $last_id"
        incr last_id
    }

    proc delete_chore {id} {
        variable store
        set chores [dict get $store chores]
        set chores [_::reject $chores {{chore} {
            upvar id id
            return [expr [dict get $chore id] == $id]
        }}]
        dict set store chores $chores
    }
}
