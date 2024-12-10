#!/usr/bin/env tclsh
proc aoc_10 { } {
    set r [list]
    set d [aoc_read "10.data"]
    set map [lmap e [split $d "\n"] {split $e ""}]
    set start_list [search_0 $map]
    set count1 0
    set count2 0
    foreach start $start_list {
        set trails [get_trails $map $start]
        incr count1 [llength [get_trail_endings $trails]]
        incr count2 [llength $trails]
    }
    lappend r $count1 $count2
    return $r
}
## -------------------------------------------------------------------
proc get_trail_endings { trails } {
    foreach trail $trails {
        set ending([lindex $trail end]) 1
    }
    return [array names ending]
}
proc get_trails { map coor {trail {}} } {
    set height [lindex $map $coor]
    if {$height eq "9"} {
        return [list [list {*}$trail $coor]]
    }
    set options [get_options $map $coor]
    set trails  [list]
    foreach option $options {
        lappend trails {*}[get_trails $map $option [list {*}$trail $coor]]
    }
    return $trails
}
proc search_0 { m } {
    for {set i 0} {$i < [llength $m]} {incr i} {
        for {set j 0} {$j < [llength [lindex $m $i]]} {incr j} {
            if {[lindex $m $i $j] eq "0"} {
                lappend ret [list $i $j]
            }
        }
    }
    return $ret
}
proc get_options { map coor } {
    set i [lindex $coor 0]
    set j [lindex $coor 1]
    set h [lindex $map $i $j]
    set candidates [list [expr $i+1] $j [expr $i-1] $j $i [expr $j+1] $i [expr $j-1]]
    set options [list]
    foreach {ci cj} $candidates {
        set ch [lindex $map $ci $cj]
        if {$ch ne "" && $ch ne "." && ($ch - $h) == 1} {
            lappend options [list $ci $cj]
        }
    }
    return $options
}

if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results:
    # My results: 
    puts [aoc_10]
}
