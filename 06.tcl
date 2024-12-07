#!/usr/bin/env tclsh
source cc.tcl

proc aoc_06 { } {
    global d map visited
    set res [list]

    set d [aoc_read "06.data"]
    aoc_parse_map $d
    aoc_save_map
    
    ## = Part 1 =
    aoc_play
    lappend res [aoc_count_pos]

    ## = Part 2 =
    set count 0
    foreach lock [array names visited] {
        aoc_load_map
        lset map $lock "O"
        if { [aoc_play] == 2 } {
            puts -nonewline "+"
            incr count
        } else {
            puts -nonewline "."
        }
        flush stdout
    }
    puts ""
    lappend res $count
    return $res
}
proc aoc_play { {i 0} } {
    while { 1 } {
        if {$i} {
            exec clear >@stdout
            aoc_show_map
            gets stdin
        }
        set reason [aoc_move_map]
        if {$reason} {
            break
        }
    }
    return $reason
}
proc aoc_count_pos { } {
    global map
    llength [regexp -all -inline {[\^><v]} $map]
}
proc aoc_parse_map { d } {
    global map pos_y pos_x state
    set map [lmap l [split [string trim $d] "\n"] {split $l ""}]
    for {set y 0} {$y < [llength $map]} {incr y} {
        for {set x 0} {$x < [llength [lindex $map $y]]} {incr x} {
            set c [lindex $map $y $x]
            if { [lsearch -exact {"<" "^" ">" "v"} $c] != -1 } {
                set pos_y $y
                set pos_x $x
                set state $c
                lset map $y $x "."
            }
        }
    }
}
proc aoc_save_map { } {
    global s_map s_pos_y s_pos_x s_state map pos_y pos_x state
    set s_map $map
    set s_pos_y $pos_y
    set s_pos_x $pos_x
    set s_state $state
}
proc aoc_load_map { } {
    global s_map s_pos_y s_pos_x s_state map pos_y pos_x state
    set map $s_map
    set pos_y $s_pos_y
    set pos_x $s_pos_x
    set state $s_state
}
proc aoc_show_map { } {
    global map pos_y pos_x state
    for {set y 0} {$y < [llength $map]} {incr y} {
        for {set x 0} {$x < [llength [lindex $map $y]]} {incr x} {
            if {$y == $pos_y && $x == $pos_x} {
                puts -nonewline $state
            } else {
                puts -nonewline [lindex $map $y $x]
            }
        }
        puts ""
    }
}
proc aoc_move_map { } {
    global map pos_y pos_x state visited
    set ny $pos_y
    set nx $pos_x
    switch $state {
        "^" { incr ny -1 }
        ">" { incr nx  1 }
        "<" { incr nx -1 }
        "v" { incr ny  1 }
    }
    if {[lindex $map $pos_y $pos_x] == $state} {
        # Loop (been here)
        return 2
    }
    set visited([list $pos_y $pos_x]) 1
    set g [lindex $map $ny $nx]
    switch $g {
        "" {
            lset map $pos_y $pos_x $state
            # Exited
            return 1
        }
        "#" - "O" {
            switch $state {
                "^" { set state ">" }
                ">" { set state "v" }
                "<" { set state "^" }
                "v" { set state "<" }
            }
        }
        default {
            lset map $pos_y $pos_x $state
            set pos_y $ny
            set pos_x $nx
        }
    }
    return 0
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    # Example results: 41, 6
    # My results: 4580, 1480
    puts [aoc_06]
}
