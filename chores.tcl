source mug_autoloader.tcl
package require tanzer
package require sqlite3

set server [::tanzer::server new]
set ::first_week [clock scan "2015-08-10"]

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
get_week_number $first_week [clock seconds]
sqlite3 db chores.db

$server route GET /* {.*:8080} apply {
    {event session args} {
        if {$event ne "write"} {
            return
        }
        
        $session response -new [::tanzer::response new 200 {
            Content-Type "text/plain"
            X-Foo "bar"
        }]

        set output "Current week is [get_week_number $::first_week [clock seconds]]"
        
        $session response buffer $output
        $session respond
        $session nextRequest
    }
}

$server listen 8080

db close
