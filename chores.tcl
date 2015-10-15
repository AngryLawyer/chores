source mug_autoloader.tcl

package require tanzer
package require tanzer::file::handler
package require SimpleTemplater
package require underscore

source [file join [file dirname [info script]] app/chores.tcl]

::chores::templater::init

set port 8081
set database {}

if {$argc > 0} {
    set port [lindex $argv 0]
}
if {$argc > 1} {
    set database [lindex $argv 1]
} else {
    set ::chores::database::dummy 1
}

::chores::database::init


set server [::tanzer::server new]

$server route GET / {.*} apply {
    {event session args} {
        if {$event ne "write"} {
            return
        }
        
        $session response -new [::tanzer::response new 200 {
            Content-Type "text/html"
        }]
        set output [::chores::pages::landing]
        
        $session response buffer $output
        $session respond
        $session nextRequest
    }
}

$server route GET|POST /all/ {.*} apply {
    {event session {data ""}} {
        if {$event eq "read"} {
            if {[[$session request] method] eq "POST"} {
                set result [::chores::pages::all_POST [::chores::post::post_data_to_dict $data]]
                $session store status [dict get $result status]
                $session store form [dict get $result form]
            } else {
                $session store status 200
                $session store form {}
            }
        } else {
            $session response -new [::tanzer::response new 200 {
                Content-Type "text/html"
            }]
            set output [::chores::pages::all [$session store form]]
            
            $session response buffer $output
            $session respond
            $session nextRequest
        }
    }
}

$server route GET|POST /new/ {.*} apply {
    {event session {data ""}} {
        if {$event eq "read" } {
            if {[[$session request] method] eq "POST"} {
                set result [::chores::pages::chores_POST [::chores::post::post_data_to_dict $data]]
                $session store status [dict get $result status]
                $session store form [dict get $result form]
            } else {
                $session store status 200
                $session store form {}
            }
        } else {
            $session response -new [::tanzer::response new [$session store status] {
                Content-Type "text/html"
            }]
            set output [::chores::pages::chores [$session store form]]
            
            $session response buffer $output
            $session respond
            $session nextRequest
        }
    }
}

# Static file service
$server route GET /* {.*} [::tanzer::file::handler new [list \
    root ./static \
]]

puts $port
$server listen $port
::chores::database::shutdown
