#!/usr/bin/env tclsh
source cc.tcl
proc aoc_04 { } {
    # Part 1
    set d {....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
        .X.X.XMASX}
    # Part 2
    set d {.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........}
    set d [aoc_read "04.data"]
    set m [lmap l [split [string trim $d] "\n"] {split $l ""}]
    ## Part 1
    if 1 {
        set c 0
        for {set i 0} {$i < [llength $m]} {incr i} {
            for {set j 0} {$j < [llength [lindex $m $i]]} {incr j} {
                incr c [search1 $m $i $j]
            }
        }
        puts $c
        # 27:35
    }
    ## Part 2
    if 1 {
        set c 0
        for {set i 0} {$i < [llength $m]} {incr i} {
            for {set j 0} {$j < [llength [lindex $m $i]]} {incr j} {
                incr c [search2 $m $i $j]
            }
        }
        puts $c
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


aoc_04
