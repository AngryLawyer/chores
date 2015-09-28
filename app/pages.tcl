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
                    label "All Weeks"\
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
        return [::chores::templater::template "./templates/chore_table.tmpl" [dict create \
            chore_list [::chores::database::chores_for_day $week_number $day_of_week_number]
        ]]
    }

    proc base {current_page_url main_content} {
        return [::chores::templater::template "./templates/base.tmpl" [dict create \
            sidebar [sidebar $current_page_url ]\
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

    proc all {} {
        set all_chores [::chores::database::all_weeks]
        set days_of_week [list Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

        set chores [dict create \
            week_a [_::zip $days_of_week [dict get $all_chores week_a]] \
            week_b [_::zip $days_of_week [dict get $all_chores week_b]] \
            week_c [_::zip $days_of_week [dict get $all_chores week_c]] \
            week_d [_::zip $days_of_week [dict get $all_chores week_d]] \
        ]

        set content [::chores::templater::template "./templates/all_weeks.tmpl" $chores]
        return [base "/all/" $content]
    }

    proc chores {message} {
        set context [dict create \
            chores [::chores::database::all_chores] \
            message $message
        ]
        set content [::chores::templater::template "./templates/chores.tmpl" $context]
        return [base "/new/" $content]
    }

    proc chores_POST {post_params} {
        # Validate
        if {[dict exists $post_params title] eq 0 || [dict get $post_params title] eq {}} {
            return [dict create status 400 message "Title is required"]
        }

        if {[dict exists $post_params description] eq 0 || [dict get $post_params description] eq {}} {
            return [dict create status 400 message "Description is required"]
        }
        # TODO: Actually save stuff
        #
        return [dict create status 201 message ""]
    }
}
