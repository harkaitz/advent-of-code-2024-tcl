#!/usr/bin/env tclsh
# A breadth first search is better to find the path blockings.
# For efficiency the search starts before the blocking and can end once
# the old trail is found.
proc aoc_18 { } {
    set result [list]
    set data [aoc_read "18.data"]
    set bytes [parse $data]

    # Part 1
    set roads [search {{0 0}} $bytes]
    puts "Roads: [llength $roads]"
    set a_road [lindex $roads 0]
    #draw $bytes $a_road
    lappend result [best_road_size $roads]

    # Part 2
    lappend result [join [monitor_road $a_road $bytes] ","]
    
    return $result
}


# --------------------------------------------------------------------
proc monitor_road { road start } {
    for {set secs $start} {1} {incr secs} {
        set blockage [get_blockage $secs $road]
        if {$blockage != -1} {
            set new_start [lrange $road 0 $blockage-1]
            set old_trail [lrange $road $blockage+1 end]
            set new_roads [search $new_start $secs $old_trail]
            if {![llength $new_roads]} {
                #draw $secs
                return [lindex $road $blockage]
            }
            puts "Found a new way ..."
            set road [lindex $new_roads 0]
        }
    }
    error "Can't solve."
}
# --------------------------------------------------------------------
proc best_road_size { roads } {
    set best {}
    set best_size 100000000
    foreach road $roads {
        set size [llength $road]
        if {$size < $best_size} {
            set best $road
            set best_size $size
        }
    }
    return [expr {$best_size - 1}]
}
proc search { {start {}} {secs 0} {shortcut {}} } {

    set trails [list $start]
    
    set found {}
    
    while {1} {
        set old_trails $trails
        set trails {}
        foreach trail $old_trails {
            
            if {![valid_trail $secs $trail]} {
                continue
            }
            set pos [lindex $trail end]
            set x [x $pos]
            set y [y $pos]
            foreach {dx dy} {0 1    1 0    0 -1    -1 0} {
                #
                set npos [pos [expr {$x + $dx}] [expr {$y + $dy}]]
                
                #
                if {[info exists visited($npos)]} {
                    continue
                }
                set visited($npos) 1
                
                #
                set nchr [map_get $secs $npos $shortcut]
                switch [lindex $nchr 0] {
                    "." {
                        lappend trails [list {*}$trail $npos]
                    }
                    "E" {
                        lappend found [list {*}$trail $npos]
                    }
                    "O" {
                        set idx [lindex $nchr 1]
                        return [list [list {*}$trail {*}[lrange $shortcut $idx end]]]
                    }
                    "#" - "S" {
                        
                    }
                    "*" {
                        error "Unknown: $nchr"
                    }
                }
            }
        }

        if {![llength $trails]} {
            break
        }

    }

    return $found
}
# --------------------------------------------------------------------
proc get_blockage { secs trail } {
    set idx 0
    foreach pos $trail {
        if {[map_get $secs $pos] eq "#"} {
            return $idx
        }
        incr idx
    }
    return -1
}
proc valid_trail { secs trail } {
    foreach pos $trail {
        if {[map_get $secs $pos] eq "#"} {
            return 0
        }
    }
    return 1
}
proc draw { secs {way {}} } {
    global map_x map_y
    puts "="
    for {set y 0} {$y < $map_y} {incr y} {
        for {set x 0} {$x < $map_x} {incr x} {
            puts -nonewline [lindex [map_get $secs [pos $x $y] $way] 0]
        }
        puts ""
    }
}
proc map_get { secs pos {way {}} } {
    global falls map_x map_y
    set x [x $pos]
    set y [y $pos]
    if {$x >= $map_x || $y >= $map_y || $x < 0 || $y < 0} {
        return "#"
    } elseif {$x == 0 && $y == 0} {
        return "S"
    } elseif {$x == ($map_x - 1) && $y == ($map_y - 1)} {
        return "E"
    } elseif {[lsearch [lrange $falls 0 $secs-1] $pos] != -1} {
        return "#"
    } elseif {[set idx [lsearch $way $pos]] != -1} {
        return "O $idx"
    } else {
        return "."
    }
}
proc parse { data } {
    global falls map_x map_y
    set falls [lmap e [split $data "\n"] { split $e "," }]
    if {[llength $falls] < 100} {
        set map_x 7
        set map_y 7
        return 12
    } else {
        set map_x 71
        set map_y 71
        return 1024
    }
}
# --------------------------------------------------------------------
proc pos { x y } { list $x $y }
proc x { l } { lindex $l 0 }
proc y { l } { lindex $l 1 }
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 22 6,1
    # My results: 248 32,55
    puts [aoc_18]
}
