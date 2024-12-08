#!/usr/bin/env tclsh
proc aoc_08 { } {
    global a08_antinodes
    set d [aoc_read "08.data"]
    a08_parse_map $d 1 1
    #a08_print_map
    set count1 [llength $a08_antinodes]
    a08_parse_map $d 0 1000
    #a08_print_map
    set count2 [llength $a08_antinodes]
    return [list $count1 $count2]
}
proc a08_parse_map { d {arm0 1} {arm1 1 } } {
    global a08_map a08_antenna a08_antinodes
    unset -nocomplain a08_map a08_antenna a08_antinodes
    set a08_map [lmap e [split $d "\n"] {split $e ""}]
    set a08_antinodes {}
    matrix_yx $a08_map {
        set c [lindex $a08_map $y $x]
        if {$c eq "."} {
            continue
        }
        if {[info exists a08_antenna($c)]} {
            foreach ant $a08_antenna($c) {
                set ay  [lindex $ant 0]
                set ax  [lindex $ant 1]
                set dy  [expr {$y - $ay}]
                set dx  [expr {$x - $ax}]
                for {set arm $arm0} {$arm <= $arm1} {incr arm} {
                    set ay1 [expr {$y + $arm*$dy}]
                    set ax1 [expr {$x + $arm*$dx}]
                    if {[lindex $a08_map $ay1 $ax1] eq ""} {
                        break
                    }
                    if {[lsearch $a08_antinodes [list $ay1 $ax1]] < 0} {
                        lappend a08_antinodes [list $ay1 $ax1]
                    }
                }
                for {set arm $arm0} {$arm <= $arm1} {incr arm} {
                    set ay2 [expr {$ay - $arm*$dy}]
                    set ax2 [expr {$ax - $arm*$dx}]
                    if {[lindex $a08_map $ay2 $ax2] eq ""} {
                        break
                    }
                    if {[lsearch $a08_antinodes [list $ay2 $ax2]] < 0} {
                        lappend a08_antinodes [list $ay2 $ax2]
                    }
                }
                
            }
        }
        lappend a08_antenna($c) $yx
    }
}
proc a08_print_map { } {
    global a08_map a08_antinodes
    matrix_yx $a08_map {
        if {[lsearch $a08_antinodes $yx] >= 0} {
            set c "#"
        } else {
            set c [lindex $a08_map $y $x]
        }
        puts -nonewline $c
    } {
        puts ""
    }
}
## -------------------------------------------------------------------
proc matrix_yx { map code_x {code_y ""} } {
    upvar 1 y y
    upvar 1 x x
    upvar 1 yx yx
    for {set y 0} {$y < [llength $map]} {incr y} {
        for {set x 0} {$x < [llength [lindex $map $y]]} {incr x} {
            set yx [list $y $x]
            uplevel 1 $code_x
        }
        uplevel 1 $code_y
    }
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results:
    # My results: 
    puts [aoc_08]
}
