namespace eval ::chores::database {
    proc all_chores {} {
        return [list \
            [dict create \
                title "Wash dishes" \
                description "Self explanatory" \
            ] \
            [dict create \
                title "Mop floor" \
                description "Self explanatory" \
            ] \
            [dict create \
                title "Cuddle kitty" \
                description "Pretty important stuff" \
            ] \
        ]
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

    }
}
