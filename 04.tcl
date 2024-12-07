#!/usr/bin/env tclsh
proc aoc_04 { } {
    set res [list]
    set d1 [aoc_read "04.data" 1 "="]
    set d2 [aoc_read "04.data" 2 "="]
    ## Part 1
    if 1 {
        set m [lmap l [split [string trim $d1] "\n"] {split $l ""}]
        set c 0
        for {set i 0} {$i < [llength $m]} {incr i} {
            for {set j 0} {$j < [llength [lindex $m $i]]} {incr j} {
                incr c [search1 $m $i $j]
            }
        }
        lappend res $c
        # 27:35
    }
    ## Part 2
    if 1 {
        set m [lmap l [split [string trim $d2] "\n"] {split $l ""}]
        set c 0
        for {set i 0} {$i < [llength $m]} {incr i} {
            for {set j 0} {$j < [llength [lindex $m $i]]} {incr j} {
                incr c [search2 $m $i $j]
            }
        }
        lappend res $c
        # 13:38
    }
}

proc search2 { m i j } {
    
    set da1 [lindex $m $i+0 $j+0]
    set da2 [lindex $m $i+1 $j+1]
    set da3 [lindex $m $i+2 $j+2]

    set db1 [lindex $m $i+0 $j+2]
    set db2 [lindex $m $i+1 $j+1]
    set db3 [lindex $m $i+2 $j+0]

    set da "$da1$da2$da3"
    set db "$db1$db2$db3"

    if {$da ne "MAS" && $da ne "SAM"} {
        return 0
    }
    if {$db ne "MAS" && $db ne "SAM"} {
        return 0
    }
    return 1
}


proc search1 { m i j } {
    
    set h1 [lindex $m $i+0 $j+0]
    set h2 [lindex $m $i+0 $j+1]
    set h3 [lindex $m $i+0 $j+2]
    set h4 [lindex $m $i+0 $j+3]
    
    set v1 [lindex $m $i+0 $j+0]
    set v2 [lindex $m $i+1 $j+0]
    set v3 [lindex $m $i+2 $j+0]
    set v4 [lindex $m $i+3 $j+0]
    
    set da1 [lindex $m $i+0 $j+0]
    set da2 [lindex $m $i+1 $j+1]
    set da3 [lindex $m $i+2 $j+2]
    set da4 [lindex $m $i+3 $j+3]

    set db1 [lindex $m $i+0 $j+3]
    set db2 [lindex $m $i+1 $j+2]
    set db3 [lindex $m $i+2 $j+1]
    set db4 [lindex $m $i+3 $j+0]
    
    set h "$h1$h2$h3$h4"
    set v "$v1$v2$v3$v4"
    set da "$da1$da2$da3$da4"
    set db "$db1$db2$db3$db4"

    set count 0
    foreach s {"XMAS" "SAMX"} {
        foreach c [list $h $v $da $db] {
            if {$s eq $c} {
                incr count
            }
        }
    }
    return $count
}

if {[file tail $argv0] eq [file tail [info script]]} {
    source cc.tcl
    # Example results: 18, 9
    # My results: 2560, 1910
    puts [aoc_04]
}
