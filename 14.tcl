#!/usr/bin/env tclsh
## The first part is straight forward. The second part is more difficult.
##
## The text says "very rarely ... robots arrange into a picture", so it
## happens periodically (I can search for a tree in a limited set). When
## the robots are arranged they should be next to each other, so the
## standard deviation should be low (that's my tree_score).
package require math 1.2.5

proc aoc_14 { } {
    set result [list]
    set data [aoc_read "14.data"]
    # Part 1
    parse $data
    next_frames 100
    lappend result [safety_factor]
    # Part 2
    parse $data
    set repeats [next_frames 100000]
    set tree [search_tree_in_known_maps tree_score]
    lappend result $tree
    # Show the tree.
    show
    return $result
}
## -------------------------------------------------------------------
proc tree_score { map } {
    set x_list [list]
    set y_list [list]
    foreach {pos robots} $map {
        lappend x_list [lindex $pos 0]
        lappend y_list [lindex $pos 1]
    }
    set x_stats [::math::sigma {*}$x_list]
    set y_stats [::math::sigma {*}$y_list]

    return [expr {1000000 - $x_stats - $y_stats}]
}
proc search_tree_in_known_maps { detector } {
    global known_maps
    set found_tree 0
    set found_treeness 0
    set found_map {}
    foreach {known_map seconds} [array get known_maps] {
        set treeness [$detector $known_map]
        if {$treeness > $found_treeness} {
            set found_tree $seconds
            set found_treeness $treeness
            set found_map $known_map
        }
    }
    load_map $found_map
    return $found_tree
}
## -------------------------------------------------------------------
proc safety_factor { } {
    global map
    foreach {pos robots} [array get map] {
        incr counts([quadrant {*}$pos]) [llength $robots]
    }
    set mul 1
    foreach {quadrant count} [array get counts] {
        if {$quadrant ne ""} {
            set mul [expr {$mul * $count}]
        }
    }
    return $mul
}
proc next_frames { num } {
    global map known_maps
    unset -nocomplain known_maps
    for {set i 1} {$i <= $num} {incr i} {
        next_frame
        set picture [array get map]
        if {[info exists known_maps($picture)]} {
            return $i
        } else {
            set known_maps($picture) $i
        }
    }
    return 0
}
proc next_frame { } {
    global map map_x map_y
    set old_map [array get map]
    unset map
    foreach {pos robots} $old_map {
        set pos_x [lindex $pos 0]
        set pos_y [lindex $pos 1]
        foreach speed $robots {
            set speed_x [lindex $speed 0]
            set speed_y [lindex $speed 1]
            set new_pos_x [expr { ($pos_x + $speed_x) % $map_x }]
            set new_pos_y [expr { ($pos_y + $speed_y) % $map_y }]
            lappend map([list $new_pos_x $new_pos_y]) $speed
        }
    }   
}
## -------------------------------------------------------------------
proc load_map { dmap } {
    global map
    unset -nocomplain map
    foreach {pos robots} $dmap {
        set map($pos) $robots
    }
}
proc show { } {
    global map map_x map_y
    for {set y 0} {$y < $map_y} {incr y} {
        for {set x 0} {$x < $map_x} {incr x} {
            if {[quadrant $x $y] eq ""} {
                puts -nonewline " "
                continue
            }
            set p [list $x $y]
            if {[info exists map($p)]} {
                puts -nonewline [llength $map($p)]
            } else {
                puts -nonewline "."
            }
        }
        puts ""
    }
}
proc quadrant { x y } {
    global map_x map_y

    set middle_x [expr { $map_x / 2 }]
    set middle_y [expr { $map_y / 2 }]

    if {$x < $middle_x && $y < $middle_y} {
        return "1"
    } elseif {$x > $middle_x && $y < $middle_y} {
        return "2"
    } elseif {$x < $middle_x && $y > $middle_y} {
        return "3"
    } elseif {$x > $middle_x && $y > $middle_y} {
        return "4"
    } else {
        return ""
    }
}
proc parse { data } {
    global map map_x map_y
    unset -nocomplain map
    set re {^p=(-*\d+),(-*\d+) +v=(-*\d+),(-*\d+)$}
    set lines [split $data "\n"]
    if {[llength $lines] > 30} {
        set map_x 101
        set map_y 103
    } else {
        set map_x 11
        set map_y 7
    }
    foreach line $lines {
        if {![regexp -- $re $line ign px py vx vy]} {
            error "Invalid format: $line"
        }
        lappend map([list $px $py]) [list $vx $vy]
    }
}
## -------------------------------------------------------------------
unset -nocomplain map map_x map_y known_maps
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 
    # My results: 230435667 7709
    puts [aoc_14]
}
