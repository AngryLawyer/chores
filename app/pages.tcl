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
        set chores [dict create \
            weeks [list \
                [week A] \
                [week B] \
                [week C] \
                [week D] \
            ] \
        ]

        set content [::chores::templater::template "./templates/all_weeks.tmpl" $chores]
        return [base "/all/" $content]
    }

    proc week {letter} {
        set days_of_week [list Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
        set context [dict create \
            chores [_::zip $days_of_week [::chores::database::chores_for_week $letter]] \
            letter $letter
        ]
        return [::chores::templater::template "./templates/week.tmpl" $context]
    }

    proc chores {form} {
        set context [dict create \
            chores [::chores::database::all_chores] \
            form $form
        ]
        set content [::chores::templater::template "./templates/chores.tmpl" $context]
        return [base "/new/" $content]
    }

    proc chores_POST {post_params} {
        # Check type
        if {[dict exists $post_params type] eq 0} {
            return [dict create status 400 form {}]
        }
        set type [dict get $post_params type]
        if {$type eq "delete"} {
            set form [::chores::forms::validate [dict create \
                id required \
            ] $post_params]
            if {[dict get $form is_valid] eq 0} {
                return [dict create status 400 form $form]
            } else {
                ::chores::database::delete_chore [dict get $form form_data id value]
                return [dict create status 200 form {}]
            }
        } elseif {$type eq "create"} {
            set form [::chores::forms::validate [dict create \
                title required \
                description required \
            ] $post_params]
            if {[dict get $form is_valid] eq 0} {
                return [dict create status 400 form $form]
            } else {
                ::chores::database::new_chore [dict get $form form_data title value] [dict get $form form_data description value]
                return [dict create status 201 form {}]
            }
        } else {
            return [dict create status 400 form {}]
        }
    }
}
