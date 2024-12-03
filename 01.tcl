#!/usr/bin/env tclsh
source cc.tcl
proc aoc_01 { } {
    # set l1 {3 4 2 1 3 3}
    # set l2 {4 3 5 3 9 3}
    set d [aoc_read 01.data]
    set l1 [aoc_get_column $d {a b} a]
    set l2 [aoc_get_column $d {a b} b]
    puts [distance $l1 $l2]
    puts [similarity $l1 $l2]
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
aoc_01
