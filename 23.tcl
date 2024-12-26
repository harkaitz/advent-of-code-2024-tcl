#!/usr/bin/env tclsh
package require Tcl 8.0
package require struct::set 2.2.3
proc aoc_23 { } {
    
    set result [list]
    set data [aoc_read "23.data"]
    parse $data
    
    # Part1
    if {1} {
        set count 0
        foreach friends [friends {*}[pc_lists]] {
            # puts $friends
            incr count
        }
        lappend result $count
    }
    # Part2
    # TODO
    
    
    return $result
}
# --------------------------------------------------------------------
proc password { lan } {
    return [join [lsort -unique $lan] ","]
}
# --------------------------------------------------------------------
proc friends { set1 set2 } {
    foreach pc $set1 {
        foreach fr1 $set2 {
            foreach fr2 $set2 {
                if {[connected $pc $fr1 $fr2]} {
                    set ret([lsort [list $pc $fr1 $fr2]]) 1
                }
            }
        }
    }
    return [array names ret]
}
proc pc_lists { } {
    global pcs
    set ret {}
    foreach pc [array names pcs] {
        switch -glob $pc {
            "t*" { lappend ret1 $pc; lappend ret2 $pc }
            "*"  { lappend ret2 $pc }
        }
    }
    return [list $ret1 $ret2]
}
proc connected { pc1 pc2 pc3 } {
    global connected
    if {![info exists connected($pc1-$pc2)]} { return 0 }
    if {![info exists connected($pc1-$pc3)]} { return 0 }
    if {![info exists connected($pc2-$pc3)]} { return 0 }
    return 1
}
# --------------------------------------------------------------------
proc parse { data } {
    global pcs nets connected
    foreach line [split $data "\n"] {
        set pc_pc [split $line "-"]
        set a [lindex $pc_pc 0]
        set b [lindex $pc_pc 1]
        incr pcs($a)
        incr pcs($b)
        set connected($a-$b) 1
        set connected($b-$a) 1
        if {![info exists nets($a)]} {
            set nets($a) [list $a]
        }
        if {![info exists nets($b)]} {
            set nets($b) [list $b]
        }
        lappend nets($a) $b
        lappend nets($b) $a
    }
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 7
    # My results: 1437
    puts [aoc_23]
}
