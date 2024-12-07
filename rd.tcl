## Common functions for reading data.
set from_gui ""
proc aoc_read { name {sel ""} {split "="} } {
    global env from_gui
    if {$from_gui ne ""} {
        set data $from_gui
    } else {
        if {[info exists env(AOC_INPUT_DIR)]} {
            set directory $env(AOC_INPUT_DIR)/2024
        } else {
            set directory [file dirname [info script]]
        }
        set filename [file join $directory $name]
        set fp [open $filename r]
        set data [string trim [read $fp]]
        close $fp
    }
    if {$sel ne "" && [string range $data 0 7] eq "Example:"} {
        set data [string trim [lindex [split $data $split] $sel]]
    }
    return $data
}


