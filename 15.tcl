#!/usr/bin/env tclsh
## Day 15, no tricks, implement the game described and iterate.
proc aoc_15 { } {
    set result [list]
    set data [aoc_read "15.data"]
    ## Part 1
    parse $data 1
    iterate 0
    lappend result [sum_of_all_boxes]
    ## Part 2
    parse $data 2
    iterate 0
    lappend result [sum_of_all_boxes]
}
proc sum_of_all_boxes { } {
    global map
    set count 0
    foreach {pos char} [array get map] {
        if {$char eq "O" || $char eq "("} {
            incr count [expr { 100 * [lindex $pos 0] + [lindex $pos 1] }]
        }
    }
    return $count
}
proc iterate { {draw 0} } {
    global map moves pos_y pos_x
    foreach move $moves {
        if {$draw} {
            draw
        }
        move "@" {} $move 0
    }
}
proc move { character pos direction {dry 0} } {
    global map pos_y pos_x
    if {$character eq "@"} {
        set pos [pos $pos_y $pos_x]
    }
    switch $direction {
        "^" { set npos [pos [expr {[y $pos] - 1}] [x $pos]] }
        "v" { set npos [pos [expr {[y $pos] + 1}] [x $pos]] }
        ">" { set npos [pos [y $pos] [expr {[x $pos] + 1}]] }
        "<" { set npos [pos [y $pos] [expr {[x $pos] - 1}]] }
        default { error "Unknown move: $move" }
    }
    set frontview $map($npos)
    switch $frontview {
        "#" {
            return 0
        }
        "." {
        }
        "O" {
            if {![move $frontview $npos $direction 1]} {
                return 0
            }
            if {!$dry} {
                move $frontview $npos $direction 0
            }
        }
        "(" - ")" {
            if {$direction eq ">" || $direction eq "<"} {
                if {![move $frontview $npos $direction 1]} {
                    return 0
                }
                if {!$dry} {
                    move $frontview $npos $direction 0
                }
            } else {
                if {$frontview eq "("} {
                    set npos_left  $npos
                    set npos_right [pos [y $npos] [expr [x $npos] + 1]]
                } elseif {$frontview eq ")"} {
                    set npos_left  [pos [y $npos] [expr [x $npos] - 1]]
                    set npos_right $npos
                }
                if {![move "(" $npos_left $direction 1]} {
                    return 0
                }
                if {![move ")" $npos_right $direction 1]} {
                    return 0
                }
                if {!$dry} {
                    move "(" $npos_left $direction
                    move ")" $npos_right $direction
                }
            }
        }
        default {
            error "Unknown map element: $direction.$frontview"
        }
    }
    if {!$dry} {
        set map($npos) $character
        set map($pos) "."
        if {$character eq "@"} {
            set pos_y [y $npos]
            set pos_x [x $npos]
        }
    }
    return 1
}
## -------------------------------------------------------------------
proc draw { } {
    global map map_y map_x pos_y pos_x moves
    exec clear >@ stdout 2>@ stderr
    for {set y 0} {$y < $map_y} {incr y} {
        for {set x 0} {$x < $map_x} {incr x} {
            if {$y eq $pos_y && $x eq $pos_x} {
                puts -nonewline "@"
            } else {
                puts -nonewline $map([pos $y $x])
            }
        }
        puts ""
    }
    puts $moves
    gets stdin
}
proc parse { data {part 1} } {
    global map map_y map_x moves pos_y pos_x
    unset -nocomplain map map_y map_x moves pos_y pos_x
    set map_y 0
    set map_x 0
    set section 0
    foreach line [split $data "\n"] {
        if {$line eq ""} {
            incr section
        } elseif {$section eq 0} {
            set x 0
            foreach char [split $line ""] {
                if {$char eq "@"} {
                    set pos_y $map_y
                    set pos_x $x
                    set char "."
                }
                switch $part {
                    "1" {
                        set map([pos $map_y $x]) $char
                        incr x
                    }
                    "2" {
                        if {$char eq "O"} {
                            set map([pos $map_y $x]) "("
                            incr x
                            set map([pos $map_y $x]) ")"
                            incr x
                        } else {
                            set map([pos $map_y $x]) $char
                            incr x
                            set map([pos $map_y $x]) $char
                            incr x
                        }
                    }
                }
            }
            if {$map_x < $x} {
                set map_x $x
            }
            incr map_y
        } elseif {$section eq 1} {
            lappend moves {*}[split $line ""]
        }
    }
}
## -------------------------------------------------------------------
proc x { l } { lindex $l 1 }
proc y { l } { lindex $l 0 }
proc pos { y x } { list $y $x }
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results 10092, 9021
    # My results: 1426855, 1404917
    puts [aoc_15]
}
