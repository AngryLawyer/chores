namespace eval ::chores::templater {
    variable templates [dict create]

    proc load_template_from_file {template_name} {
        set fp [open $template_name r]
        set file_data [read $fp]
        close $fp
        return $file_data
    }

    proc get {template_name} {
        variable templates

        if {[dict exists $::chores::templater::templates $template_name]} {
            set template_data [dict get $templates $template_name]
        } else {
            set template_data [load_template_from_file $template_name]
            dict set templates $template_name $template_data
        }
        return $template_data
    }

    proc template {template_name data} {
        return [::mustache::mustache [get $template_name] $data]
    }
}
