namespace eval ::chores::pages {

    proc landing {} {
        return [::chores::templater::template "./templates/index.html" {}]
    }
}
