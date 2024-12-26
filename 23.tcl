#!/usr/bin/env tclsh
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
    if {1} {
        lappend result [password [biggest_lan]]
    }
    
    return $result
}
# --------------------------------------------------------------------
proc password { lan } {
    return [join [lsort -unique $lan] ","]
}
proc biggest_lan { } {
    global nets
    set biggest {}
    foreach {name net} [array get nets] {
        set lan [lan {*}$net]
        if {[llength $biggest] < [llength $lan]} {
            set biggest $lan
        }
    }
    return $biggest
}
proc lan { {pc {}} args } {
    global connected
    if {$pc eq {}} {
        return {}
    }
    set is_connected 1
    foreach arg $args {
        if {![info exists connected($pc-$arg)]} {
            set is_connected 0
        }
    }
    if {$is_connected} {
        return [list $pc {*}[lan {*}$args]]
    } else {
        return [lan {*}$args]
    }
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
    # Example results: 7 co,de,ka,ta
    # My results: 1437 da,do,gx,ly,mb,ns,nt,pz,sc,si,tp,ul,vl
    puts [aoc_23]
}
