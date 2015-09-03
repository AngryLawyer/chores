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

    proc base {current_page_url} {
        return [::chores::templater::template "./templates/base.tmpl" [dict create \
            sidebar [sidebar $current_page_url]\
        ]]
    }

    proc landing {} {
        return [base "/"]
    }
}
