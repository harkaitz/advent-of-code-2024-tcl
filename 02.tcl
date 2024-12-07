#!/usr/bin/env tclsh
source cc.tcl
proc aoc_02 { } {
    set d [aoc_read "02.data"]
    set count1 0
    set count2 0
    foreach l [split $d \n] {
        incr count1 [aoc_is_save_1 $l]
        incr count2 [aoc_is_save_2 $l]
    }
    return [list $count1 $count2]
}

proc aoc_is_save_1 { l } {
    set chk "0"
    for {set i 1} {$i < [llength $l]} {incr i} {
        set a [lindex $l $i-1]
        set b [lindex $l $i]
        set d [expr {$b - $a}]
        if "!(abs(\$d) <= 0 || abs(\$d) >= 4 || $chk)" {
            if {$chk eq "0"} {
                if {$d < 0} {
                    set chk {$d > 0}
                } else {
                    set chk {$d < 0}
                }
            }
        } else {
            return 0
        }
    }
    return 1
}

proc aoc_is_save_2 { l } {
    if {[aoc_is_save_1 $l]} {
        return 1
    }
    for {set i 0} {$i < [llength $l]} {incr i} {
        if {[aoc_is_save_1 [lreplace $l $i $i]]} {
            return 1
        }
    }
    return 0
}
if {[file tail $argv0] eq [file tail [info script]]} {
    # Example results: 2, 4
    # My results: 242, 311
    puts [aoc_02]
}
