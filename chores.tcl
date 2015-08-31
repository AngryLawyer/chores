source mug_autoloader.tcl


# Fake the existence of lambda
package ifneeded lambda 0 {package provide lambda 0}

package require tanzer
package require tanzer::file::handler
#package require sqlite3
package require mustache

source [file join [file dirname [info script]] app/chores.tcl]

set server [::tanzer::server new]

#sqlite3 db chores.db

set fp [open "./templates/index.html" r]
set ::file_data [read $fp]
close $fp

$server route GET / {.*:8080} apply {
    {event session args} {
        if {$event ne "write"} {
            return
        }
        
        $session response -new [::tanzer::response new 200 {
            Content-Type "text/html"
        }]
        set output $::file_data
        #set output "Current week is [::chores::weeks::get_week_number $::chores::weeks::first_week [clock seconds]]"
        
        $session response buffer $output
        $session respond
        $session nextRequest
    }
}

# Static file service
$server route GET /* {.*} [::tanzer::file::handler new [list \
    root ./static \
]]

$server listen 8080

#db close
