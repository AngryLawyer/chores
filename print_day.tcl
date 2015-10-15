source mug_autoloader.tcl

source [file join [file dirname [info script]] app/chores.tcl]

set SERIALPORT /dev/ttyAMA0

::chores::database::sqlite::init [lindex $argv 0]

set now [clock seconds]
set week_number [::chores::weeks::get_week_number $::chores::weeks::first_week $now]
set day_of_week_number [::chores::weeks::get_day_of_week_number $now]

set chores [::chores::database::sqlite::chores_for_day $week_number $day_of_week_number]
::chores::printer::init

::chores::printer::print_text a\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 5

::chores::database::sqlite::shutdown
