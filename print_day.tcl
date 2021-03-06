source [file join [file dirname [info script]] mug_autoloader.tcl]

package require underscore

source [file join [file dirname [info script]] app/chores.tcl]

set SERIALPORT /dev/ttyAMA0

::chores::database::sqlite::init [lindex $argv 0]

set now [clock seconds]
set week_number [::chores::weeks::get_week_number $::chores::weeks::first_week $now]
set day_of_week_number [::chores::weeks::get_day_of_week_number $now]
set day_of_week [::chores::weeks::get_day_of_week $now]
set date [::chores::weeks::get_date $now]

set chores [::chores::database::sqlite::chores_for_day $week_number $day_of_week_number]
::chores::printer::init

::chores::printer::underline_on
::chores::printer::print_text "$date\n"
::chores::printer::print_text "Week $week_number - $day_of_week\n\n"
::chores::printer::underline_off

_::each $chores {{chore} {
    set chore_name [dict get $chore title]
    ::chores::printer::print_text "$chore_name\n" 25
}}
::chores::printer::print_text "\n\n\n\n\n"
::chores::database::sqlite::shutdown
