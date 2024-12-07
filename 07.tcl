#!/usr/bin/env tclsh
proc aoc_07 { } {
    set d1 [aoc_read "07.data"]
    set count1 0
    set count2 0
    foreach res_nums [lmap l [split $d1 "\n"] { split $l ":" } ] {
        set res [lindex $res_nums 0]
        set nums [lindex $res_nums 1]
        puts -nonewline "."
        flush stdout
        incr count1 [stepf [recursive_search $res {"+" "*"} {*}$nums]]
        incr count2 [stepf [recursive_search $res {"+" "*" "||"} {*}$nums]]
    }
    puts ""
    return [list $count1 $count2]
}
proc recursive_search { num ops a b args } {
    set ans_l [list]
    foreach op $ops {
        switch $op {
            "+"  { set ans [expr {$a + $b}] }
            "*"  { set ans [expr {$a * $b}] }
            "||" { set ans "$a$b" }
        }
        if {$ans <= $num} {
            lappend ans_l $ans
        }
    }
    if {[llength $args] == 0} {
        if {[lsearch $ans_l $num] != -1} {
            return $num
        } else {
            return -1
        }
    }
    foreach ans $ans_l {
        set res [recursive_search $num $ops $ans {*}$args]
        if {$res >= 0} {
            return $res
        }
    }
    return -1
}
proc stepf { n } {
    if {$n < 0} {
        return 0
    } else {
        return $n
    }
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source cc.tcl
    # Example results: 3749 11387
    # My results: 1620690235709 145397611075341
    puts [aoc_07]
}
