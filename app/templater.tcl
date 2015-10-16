namespace eval ::chores::templater {
    variable templates [dict create]
    variable path

    proc filter_subtract {context args} {
        expr { $context - [lindex $args 0] }
    }

    proc init {new_path} {
        variable path
        set path $new_path
        ::SimpleTemplater::registerFilter -filter subtract -proc ::chores::templater::filter_subtract
    }

    proc get {template_name} {
        variable templates
        variable path

        if {[dict exists $templates $template_name]} {
            set template_data [dict get $templates $template_name]
        } else {
            set template_data [::SimpleTemplater::compile [file join $path $template_name]]
            dict set templates $template_name $template_data
        }
        return $template_data
    }

    proc template {template_name data} {
        return [[get $template_name] execute $data]
    }
}
