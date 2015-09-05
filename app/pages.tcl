namespace eval ::chores::pages {

    proc sidebar {current_page_url} {
        return [::chores::templater::template "./templates/sidebar.tmpl" [dict create \
            pages [list \
                [dict create\
                    label "Home"\
                    url "/"\
                    active [expr {$current_page_url == "/"}]
                ]\
                [dict create\
                    label "All Chores"\
                    url "/all/"\
                    active [expr {$current_page_url == "/all/"}]
                ]\
                [dict create\
                    label "New Chores"\
                    url "/new/"\
                    active [expr {$current_page_url == "/new/"}]
                ]\
                [dict create\
                    label "Manage Days"\
                    url "/manage/"\
                    active [expr {$current_page_url == "/manage/"}]
                ]
            ]
        ]]
    }

    proc chore_table {week_number day_of_week_number} {
        set chore_list [list \
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

        return [::chores::templater::template "./templates/chore_table.tmpl" [dict create \
            chore_list $chore_list
        ]]
    }

    proc base {current_page_url main_content} {
        return [::chores::templater::template "./templates/base.tmpl" [dict create \
            sidebar [sidebar $current_page_url]\
            content $main_content
        ]]
    }

    proc landing {} {
        set now [clock seconds]
        set week_number [::chores::weeks::get_week_number $::chores::weeks::first_week $now]
        set day_of_week_number [::chores::weeks::get_day_of_week_number $now]

        set content [::chores::templater::template "./templates/landing.tmpl" [dict create \
            week_number $week_number \
            day [::chores::weeks::get_day_of_week $now] \
            chore_table [chore_table $week_number $day_of_week_number]
        ]]
        return [base "/" $content]
    }
}
