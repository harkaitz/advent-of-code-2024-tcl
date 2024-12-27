#!/usr/bin/env tclsh
proc aoc_25 { } {
    set result [list]
    set data [aoc_read "25.data"]
    parse $data
    lappend result [part1]
    return $result
}
# --------------------------------------------------------------------
proc part1 { } {
    global keys locks
    set count 0
    foreach lock $locks {
        foreach key $keys {
            set match [compare $key $lock]
            # puts "Lock ($lock) and key ($key) do $match"
            if {$match} {
                incr count
            }
        }
    }
    return $count
}

proc compare { key lock } {
    foreach k $key l $lock {
        if {($k + $l) > 5} {
            return 0
        }
    }
    return 1
}

proc parse { data } {
    global keys locks
    set type {}
    foreach line [split "$data\n" "\n"] {
        if {$type eq ""} {
            if {$line eq "#####"} {
                set type "lock"
                set sch {-1 -1 -1 -1 -1}
                set char "."
                set yPos 0
                set yDif 1
            } elseif {$line eq "....."} {
                set type "key"
                set sch {-1 -1 -1 -1 -1}
                set char "#"
                set yPos 5
                set yDif -1
            }
        } elseif {$yPos >= 0 && $yPos <= 5} {
            set xPos 0
            foreach c [split $line ""] {
                set v [lindex $sch $xPos]
                if {$v eq "-1" && $c eq $char} {
                    lset sch $xPos $yPos
                }
                incr xPos
            }
            incr yPos $yDif
        } elseif {$type eq "lock"} {
            # puts "Lock: $sch"
            lappend locks $sch
            set type ""
        } elseif {$type eq "key"} {
            # puts "Key: $sch"
            lappend keys $sch
            set type ""
        } else {
            set type ""
        }
    }
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 3
    # My results: 3057
    puts [aoc_25]
}
