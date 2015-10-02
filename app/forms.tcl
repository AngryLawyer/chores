namespace eval ::chores::forms {
    
    proc validate { form data } {
        set all_valid 1
        set output [dict create \
            is_valid 1 \
            form_data {} \
        ]

        set form_data [dict create]

        set form_data [dict map {key validators} $form {
            # Pull out defined value
            set input {}
            if {[dict exists $data $key]} {
                set input [dict get $data $key]
            }

            # Get a list of validation errors
            set validation [_::reject [_::map $validators {{validator} {
                upvar input input
                upvar key key
                return [[join [list ::chores::forms::validators:: $validator] ""] $key $input]
            }}] {{result} {
                expr {$result eq {}}
            }}]

            set is_valid [expr {[llength $validation] eq 0}]

            if {$is_valid ne 1} {
                set all_valid 0
            }

            dict create \
                value $input \
                is_valid $is_valid \
                messages $validation
        }]

        dict set output form_data $form_data
        dict set output is_valid $all_valid
        return $output
    }
}

namespace eval ::chores::forms::validators {

    proc required {key data} {
        if {$data eq {}} {
            return "$key is required"
        }
    }
}
