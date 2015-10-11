namespace eval ::chores::database::dummy {
    variable store [dict create \
        chores [list] \
        weeks [dict create \
            A [list [list] [list] [list] [list] [list] [list] [list]] \
            B [list [list] [list] [list] [list] [list] [list] [list]] \
            C [list [list] [list] [list] [list] [list] [list] [list]] \
            D [list [list] [list] [list] [list] [list] [list] [list]] \
        ] \
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
        variable store
        set week_data [dict get $store weeks $week]
        set day_data [lindex $week_data $day]
        set all_chores [dict get $store chores]

        set chores [_::map $day_data {{chore_id} {
            upvar all_chores all_chores
            _::find $all_chores {{chore} {
                upvar chore_id chore_id
                expr {[dict get $chore id] == $chore_id}
            }}
        }}]
        return $chores
    }

    proc chores_for_week {week} {
        return [list \
            [chores_for_day $week 0] \
            [chores_for_day $week 1] \
            [chores_for_day $week 2] \
            [chores_for_day $week 3] \
            [chores_for_day $week 4] \
            [chores_for_day $week 5] \
            [chores_for_day $week 6] \
        ]
    }

    proc all_weeks {} {
        return [dict create \
            week_a [chores_for_week A]\
            week_b [chores_for_week C]\
            week_c [chores_for_week C]\
            week_d [chores_for_week D]\
        ]
    }

    proc add_chore_to_day {day week chore_id} {
        variable last_id
        variable store
        set week_data [dict get $store weeks $week]
        set day_data [lindex $week_data $day]

        lappend day_data [dict create \
            id $last_id \
            chore_id $chore_id \
        ]
        dict set store weeks $week $week_data
        incr last_id
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
