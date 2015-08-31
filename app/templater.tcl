namespace eval ::chores::templater {
    variable templates [dict create]

    proc load_template_from_file {template_name} {
        set fp [open $template_name r]
        set file_data [read $fp]
        close $fp
        return $file_data
    }

    proc load_template {template_name} {
        if {dict exists $::chores::templater::templates $template_name} {
            set $template_data [dict get $::chores::templater::templates $template_name]
        } else {
        }
        return $template_data
    }
}
