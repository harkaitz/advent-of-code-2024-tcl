#!/usr/bin/env tclsh
source cc.tcl
proc aoc_01 { } {
    set d [aoc_read "01.data"]
    set res {}
    set l1 [aoc_get_column $d {a b} a]
    set l2 [aoc_get_column $d {a b} b]
    lappend res [distance $l1 $l2]
    lappend res [similarity $l1 $l2]
    return $res
}
proc distance { l1 l2 } {
    set t 0
    foreach a [lsort -real $l1] b [lsort -real $l2] {
        incr t [expr { abs($a - $b) }]
    }
    return $t
}
proc similarity { l1 l2 } {
    set sim 0
    foreach e $l1 {
        set count [llength [lsearch -all $l2 $e]]
        incr sim [expr { $e * $count }]
    }
    return $sim
}
proc aoc_get_column { data pat var } {
    set l [list]
    foreach $pat $data {
        lappend l [set $var]
    }
    return $l
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    # Example results: 11, 31 
    # My results: 2367773, 21271939
    puts [aoc_01]
}
