namespace eval ::chores::weeks {

    variable first_week [clock scan "2015-08-10"]

    proc get_week_number {first_week current_date} {
        # Work out the number of years since first week
        set first_year [clock format $first_week -format "%Y"]
        set current_year [clock format $current_date -format "%Y"]

        set year_difference [expr $current_year - $first_year]
        set first_week_no [clock format $first_week -format "%V"]
        set current_week_no [expr [clock format $current_date -format "%V"] + ($year_difference * 52)]
        set current_week_index [expr ($current_week_no - $first_week_no) % 4]
        return [lindex {A B C D} $current_week_index]
    }

    proc get_day_of_week {current_date} {
        return [clock format $current_date -format "%A"]
    }

    proc get_day_of_week_number {current_date} {
        expr {[clock format $current_date -format "%u"] - 1}
    }

    proc get_date {current_date} {
        clock format $current_date -format "%d/%m/%Y"
    }
}
