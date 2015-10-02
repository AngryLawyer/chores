namespace eval ::chores::forms {
    
    proc validate { form data } {
        set any_valid 1
        set output [dict create \
            is_valid 1 \
            form_data {} \
        ]

        set form_data [dict create]
        puts $form

        set form_data [dict map {key value} $form {
            # TODO: Validate
            # lappend current_data 
            set input {}
            if {[dict exists $data $key]} {
                puts DING
                set input [dict get $data $key]
            }

            set validation [list]

            dict create \
                value $input \
                is_valid 1 \
                messages $validation
        }]

        dict set output form_data $form_data
        dict set output is_valid $any_valid
        return output
    }
}
