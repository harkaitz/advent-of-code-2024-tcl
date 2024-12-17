#!/usr/bin/env tclsh
# To solve the maze we are going to use a recursive algorithm with the
# following enhacements.
#
# 1. Positions are scored like in Dijkstra.
# 2. A grace score of 1500 to find same score paths (part 2)
# 3. Always turn right first (Vicky the Viking strategy)
proc aoc_16 { } {
    set result [list]
    set data [aoc_read "16.data"]
    parse $data
    set score_ways [search]
    set score [lindex $score_ways 0]
    set ways [lindex $score_ways 1]
    lappend result $score
    lappend result [llength [tiles $ways]]
    return $result
}
# --------------------------------------------------------------------
proc tiles { ways } {
    foreach way $ways {
        foreach step $way {
            set arr([xy $step]) 1
        }
    }
    return [array names arr]
}
proc search { {pos "start"} {steps {}} {cval 0}} {
    global start score best_steps best_value
    
    if {$pos eq "start"} {
        set pos $start
        set best_steps {}
        set best_value 1000000
        interp recursionlimit {} 100000
    }
    
    set choices [ways $pos $cval]
    lappend steps [xy $pos]
    
    foreach {choice val} $choices {
        
        if {[map_get $choice] eq "E"} {
            if {$val < $best_value} {
                puts "Found $val"
                set best_value $val
                set best_steps [list [list {*}$steps [xy $choice]]]
            } elseif {$val == $best_value} {
                puts "Found $val"
                lappend best_steps [list {*}$steps [xy $choice]]
            }
            continue
        }

        if {$val > $best_value} {
            continue
        }
        
        if {$val < $score([xy $choice])} {
            set score([xy $choice]) $val
            search $choice $steps $val
        } elseif {($val - 1500) < $score([xy $choice])} {
            search $choice $steps $val
        }
        
    }

    return [list $best_value $best_steps]
}
proc ways { pos cval } {
    global score

    set result {}
    set dirs {}
    set value $cval
    #$score([xy $pos])
    set nposl1 {}

    switch [d $pos] {
        "^" { set dirs {"^" 1 ">" 1001 "<" 1001 } }
        ">" { set dirs {">" 1 "v" 1001 "^" 1001 } }
        "<" { set dirs {"<" 1 "^" 1001 "v" 1001 } }
        "v" { set dirs {"v" 1 "<" 1001 ">" 1001 } }
    }

    foreach {d c} $dirs {
        switch $d {
            "^" { lappend nposl1 [pos [x $pos] [expr [y $pos] - 1] "^"] [expr $value + $c] }
            "v" { lappend nposl1 [pos [x $pos] [expr [y $pos] + 1] "v"] [expr $value + $c] }
            "<" { lappend nposl1 [pos [expr [x $pos] - 1] [y $pos] "<"] [expr $value + $c] }
            ">" { lappend nposl1 [pos [expr [x $pos] + 1] [y $pos] ">"] [expr $value + $c] }
        }
    }
    
    foreach {npos val} $nposl1 {
        set ch [map_get $npos]
        if {$ch ne "#" && $ch ne "@"} {
            lappend result $npos $val
        }
    }
    
    return $result
}
# --------------------------------------------------------------------
proc draw { {ways {}} } {
    global map max
    puts ""
    puts "=========================================================="
    puts ""
    for {set y 0} {$y < [y $max]} {incr y} {
        for {set x 0} {$x < [x $max]} {incr x} {
            if {[lsearch $ways [pos $x $y]] != -1} {
                puts -nonewline "x"
            } else {
                puts -nonewline [map_get [pos $x $y]]
            }
        }
        puts ""
    }
    gets stdin
}
proc parse { data } {
    global map max start score best_steps best_value
    unset -nocomplain map max start score best_steps best_value
    set y 0
    foreach line [split $data "\n"] {
        set x 0
        foreach char [split $line ""] {
            if {$char eq "S"} {
                set start [pos $x $y ">"]
                set value 0
            } else {
                set value 200000
            }
            set map([list $y $x]) $char
            set score([xy [list $y $x "^"]]) $value
            set score([xy [list $y $x ">"]]) $value
            set score([xy [list $y $x "<"]]) $value
            set score([xy [list $y $x "v"]]) $value
            incr x
        }
        incr y
    }
    set max [pos $x $y]
}
# --------------------------------------------------------------------
proc x { l } { lindex $l 1 }
proc y { l } { lindex $l 0 }
proc d { l } { lindex $l 2 }
proc xy { l } { list [lindex $l 0] [lindex $l 1] }
proc pos { x y args } { list $y $x {*}$args }
proc map_get { p } { global map; return $map([list [y $p] [x $p]]) }
proc map_set { p v } { global map; set map([list [y $p] [x $p]]) $v }
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 7036|11048
    # My results: 99448 498
    puts [aoc_16]
}
