namespace eval ::chores::post {
    proc utf8 {hex} {
        set hex [string map {% {}} $hex]
        encoding convertfrom utf-8 [binary decode hex $hex]
    }

    proc url_decode {str} {
        # rewrite "+" back to space
        # protect \ from quoting another '\'
        set str [string map [list + { } "\\" "\\\\"] $str]

        # Replace UTF-8 sequences with calls to the utf8 decode proc...
        regsub -all {(%[0-9A-Fa-f0-9]{2})+} $str {[utf8 \0]} str
        
        return [subst -novar -noback $str]
    }

    proc post_data_to_dict {post_data} {
        set pairs [split $post_data &]
        # TODO: Handle arrays
        set output [dict create]
        foreach item $pairs {
            set pair [split $item =]
            dict set output [lindex $pair 0] [url_decode [lindex $pair 1]]
        }
        return $output
    }
}
