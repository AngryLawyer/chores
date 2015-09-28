source mug_autoloader.tcl


# Fake the existence of lambda
package ifneeded lambda 0 {package provide lambda 0}

package require tanzer
package require tanzer::file::handler
#package require sqlite3
package require SimpleTemplater
package require underscore

source [file join [file dirname [info script]] app/chores.tcl]

set server [::tanzer::server new]

#sqlite3 db chores.db

$server route GET / {.*:8080} apply {
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

$server route GET /all/ {.*:8080} apply {
    {event session args} {
        if {$event ne "write"} {
            return
        }
        
        $session response -new [::tanzer::response new 200 {
            Content-Type "text/html"
        }]
        set output [::chores::pages::all]
        
        $session response buffer $output
        $session respond
        $session nextRequest
    }
}

$server route GET|POST /new/ {.*:8080} apply {
    {event session {data ""}} {
        if {$event eq "read" } {
            if {[[$session request] method] eq "POST"} {
                set result [::chores::pages::chores_POST [::chores::post::post_data_to_dict $data]]
                $session store status [dict get $result status]
                $session store message [dict get $result message]
            } else {
                $session store status 200
                $session store message ""
            }
        } else {
            $session response -new [::tanzer::response new [$session store status] {
                Content-Type "text/html"
            }]
            set output [::chores::pages::chores [$session store message]]
            
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

$server listen 8080

#db close
