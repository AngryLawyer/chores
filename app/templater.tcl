namespace eval ::chores::templater {
    variable templates [dict create]

    proc filter_subtract {context args} {
        expr { $context - [lindex $args 0] }
    }

    proc init {} {
        ::SimpleTemplater::registerFilter -filter subtract -proc ::chores::templater::filter_subtract
    }

    proc load_template_from_file {template_name} {
        set fp [open $template_name r]
        set file_data [read $fp]
        close $fp
        return $file_data
    }

    proc get {template_name} {
        variable templates

        if {[dict exists $templates $template_name]} {
            set template_data [dict get $templates $template_name]
        } else {
            set template_data [::SimpleTemplater::compile $template_name]
            dict set templates $template_name $template_data
        }
        return $template_data
    }

    proc template {template_name data} {
        return [[get $template_name] execute $data]
    }
}
