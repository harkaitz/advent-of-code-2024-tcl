## Common functions for reading data.
proc aoc_read { filename } {
    set fp [open $filename r]
    set numbers [string trim [read $fp]]
    close $fp
    return $numbers
}
proc aoc_get_column { data pat var } {
    set l [list]
    foreach $pat $data {
        lappend l [set $var]
    }
    return $l
}
