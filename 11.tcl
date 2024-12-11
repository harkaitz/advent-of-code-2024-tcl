#!/usr/bin/env tclsh
proc aoc_11 { } {
    set r [list]
    set d [aoc_read "11.data"]
    set count1 0
    set count2 0
    foreach stone $d {
        incr count1 [count_stones 25 $stone]
        incr count2 [count_stones 75 $stone]
    }
    return [list $count1 $count2]
}

proc count_stones { { steps 1} number } {
    global cache
    
    if {[info exists cache($steps.$number)]} {
        return $cache($steps.$number)
    }

    set stones [list]
    set number_l [split $number ""]
    set number_sz [llength $number_l]
    if {$number eq "0"} {
        lappend stones 1
    } elseif {($number_sz % 2) == 0} {
        lappend stones [join0 {*}[lrange $number_l 0 [expr $number_sz/2-1]] ""]
        lappend stones [join0 {*}[lrange $number_l [expr $number_sz/2] end] ""]
    } else {
        lappend stones [expr {$number * 2024}]
    }

    set count  0
    set nsteps [expr $steps - 1]
    foreach stone $stones {
        if {$nsteps} {
            incr count [count_stones $nsteps $stone]
        } else {
            incr count [llength $stone]
        }
    }

    set cache($steps.$number) $count
    return $count
}


proc join0 { args } {
    set r ""
    foreach e $args {
        if {$r eq "" && $e eq "0"} {
            continue
        }
        set r "$r$e"
    }
    if {$r eq ""} {
        set r "0"
    }
    return $r
}

if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 55312, X
    # My results: 209412, 
    puts [aoc_11]
}
