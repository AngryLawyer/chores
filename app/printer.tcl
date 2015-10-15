namespace eval ::chores::printer {
    variable SERIALPORT /dev/ttyAMA0
    variable BAUDRATE 19200
    variable TIMEOUT 3

    variable _ESC [format %c 27]
    
    proc char {c} {
        format %c $c
    }

    proc write {data} {
        #DO SOMETHING
        puts $data
    }

    proc reset {} {
        variable _ESC
        write $_ESC
        write [char 64]
    }

    proc linefeed {} {
        write [char 10]
    }

    proc justify {align} {
        variable _ESC
        set pos 0
        if {$align == "L"} {
            set pos 0
        } elseif {$align == "C"} {
            set pos 1
        } elseif {$align == "R"} {
            set pos 2
        }
        write $_ESC
        write [char 97]
        write [char $pos]
    }

    proc bold_off {} {
        variable _ESC
        write [$_ESC]
        write [char 69]
        write [char 0]
    }
    
    proc bold_on {} {
        variable _ESC
        write [$_ESC]
        write [char 69]
        write [char 1]
    }

    proc font_b_off {} {
        variable _ESC
        write [$_ESC]
        write [char 33]
        write [char 0]
    }
    
    proc font_b_on {} {
        variable _ESC
        write [$_ESC]
        write [char 33]
        write [char 1]
    }

    proc underline_off {} {
        variable _ESC
        write [$_ESC]
        write [char 45]
        write [char 0]
    }
    
    proc underline_on {} {
        variable _ESC
        write [$_ESC]
        write [char 45]
        write [char 1]
    }

    proc inverse_off {} {
        write [char 29]
        write [char 69]
        write [char 0]
    }
    
    proc inverse_on {} {
        write [char 29]
        write [char 69]
        write [char 1]
    }

    proc upsidedown_off {} {
        variable _ESC
        write [$_ESC]
        write [char 123]
        write [char 0]
    }
    
    proc upsidedown_on {} {
        variable _ESC
        write [$_ESC]
        write [char 123]
        write [char 1]
    }

    proc print_text {msg {chars_per_line {}}} {
        if {$chars_per_line == {}} {
            write $msg
        } else {
            set splitstring [split $msg {}]
            set i 0
            set output {}
            foreach {c} $splitstring {
                lappend output $c
                if {$c == "\n"} {
                    set i 0
                } else {
                    incr i
                }
                if {$i == $chars_per_line} {
                    write [join $output {}]
                    set i 0
                    set output {}
                }
            }
            write [join $output {}]
        }
    }

    proc init {{heat_time 80} {heat_interval 2} {heating_dots 7}} {
        variable SERIALPORT
        variable BAUDRATE
        variable TIMEOUT
        variable _ESC

        write $_ESC
        write [char 64]
        write $_ESC
        write [char 55]
        write [char $heating_dots]
        write [char $heat_time]
        write [char $heat_interval]

        write [char 18]
        write [char 35]

        write [char 255]
    }
}
