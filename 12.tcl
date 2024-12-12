#!/usr/bin/env tclsh
proc aoc_12 { } {
    global plant_edges plant_area
    set d [aoc_read "12.data"]
    set r [list]
    parse $d
    lappend r [analyze_all_area 1]
    lappend r [analyze_all_area 2]
    
    return $r
}
## -------------------------------------------------------------------
proc analyze_all_area { phase  } {
    global pos2plant analyzed
    set count 0
    foreach pos [lsort [array names pos2plant]] {
        if {![info exists analyzed($pos)]} {
            incr count [analyze_area $phase $pos]
        }
    }
    unset analyzed
    return $count
}
proc analyze_area { {phase 1} {pos {0 0}} {plant ""} } {
    global pos2plant analyzed fences
    set y [lindex $pos 0]
    set x [lindex $pos 1]
    if {$plant eq ""} {
        unset -nocomplain fences
        set plant $pos2plant($pos)
        set first 1
    } else {
        set first 0
    }
    set analyzed($pos) $plant
    
    set area  1
    set edges 0
    set next_moves [list]
   
    foreach {side move} [list down [down {*}$pos] up [up {*}$pos] right [right {*}$pos] left [left {*}$pos]] {
        if {[info exists analyzed($move)]} {
            if {$analyzed($move) ne $plant} {
                add_fence $side $pos
            }
            continue
        }
        if {![info exists pos2plant($move)]} {
            add_fence $side $pos
            continue
        }
        set move_plant $pos2plant($move)
        if {$move_plant ne $plant} {
            add_fence $side $pos
            continue
        }
        lappend next_moves $move $move_plant
    }
    
    foreach {move move_plant} $next_moves {
        if {![info exists analyzed($move)]} {
            incr area [analyze_area $phase $move $move_plant]
        }
    }
    
    if {$first} {
        return [expr {$area * [count_fences $phase]}]
    } else {
        return $area
    }
}
proc add_fence { dir pos } {
    global fences
    set fences([list {*}$pos $dir]) 1
}
proc count_fences { phase } {
    global fences
    if {$phase eq "1"} {
        set count [llength [array names fences]]
        unset -nocomplain fences
    } else {
        set count 0
        while {[set fence [lindex [array names fences] 0]] ne ""} {
            del_fence {*}$fence
            incr count    
        }
    }
    return $count
}
proc del_fence { y x dir } {
    global fences
    set fun [list]
    switch $dir {
        "up"   - "down"  { set fun {left right} }
        "left" - "right" { set fun {up down}    }
    }
    unset fences([list $y $x $dir])
    foreach f $fun {
        for {set npos [$f $y $x $dir]} {[info exists fences($npos)]} {set npos [$f {*}$npos]} {
            unset fences($npos)
        }
    }
}
## -------------------------------------------------------------------
proc down { y x args } {
    return [list [expr $y + 1] $x {*}$args]
}
proc up { y x args } {
    return [list [expr $y - 1] $x {*}$args]
}
proc left { y x args } {
    return [list $y [expr $x - 1] {*}$args]
}
proc right { y x args } {
    return [list $y [expr $x + 1] {*}$args]
}
## -------------------------------------------------------------------
proc parse { d } {
    global pos2plant map_i map_j
    unset -nocomplain pos2plant map_i map_j
    set map_i 0
    foreach line [split $d "\n"] {
        set map_j 0
        foreach col [split $line ""] {
            set pos2plant([list $map_i $map_j]) $col
            incr map_j
        }
        incr map_i
    }
}
proc show { } {
    global pos2plant plant2area map_i map_j
    for {set i 0} {$i < $map_i} {incr i} {
        for {set j 0} {$j < $map_j} {incr j} {
            puts -nonewline $pos2plant([list $i $j])
        }
        puts ""
    }
    puts [array get plant2area]
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 1930, 1206
    # My results: 1437300, 849332
    puts [aoc_12]
}
