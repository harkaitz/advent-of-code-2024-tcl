#!/usr/bin/env tclsh
# How much mazes are we going to have this year? Lets make a Maze class.
package require TclOO
oo::class create Maze

proc aoc_20 { } {
    set result [list]
    set data [aoc_read "20.data"]
    if {[string length $data] < 300} {
        set picos_wanted2 50
        set print 1
    } else {
        set picos_wanted2 100
        set print 0
    }
    
    Maze create maze
    maze parse $data
    set search [maze search]
    set trail [dict get $search :trail]
    if {$print} {
        maze print $trail
    }
    lappend result [jumps1 maze $trail $print]
    lappend result [jumps2 maze $trail 20 $picos_wanted2 $print]
    
    return $result
}
# --------------------------------------------------------------------
proc jumps2 { maze trail {picos_allowed 20} {picos_wanted 100} {do_print 0}} {
    set count 0
    set trailsz [llength $trail]
    set s 0
    set e 0
    while {$s < ($trailsz-1)} {
        set s_pos [lindex $trail $s]
        set e [expr {$s + 4}]
        while {$e < $trailsz} {
            set e_pos [lindex $trail $e]
            set dist [dist $e_pos $s_pos]
            
            if {$dist <= $picos_allowed} {
                
                set v1 [$maze get_score $s_pos]
                set v2 [$maze get_score $e_pos]
                
                set di [expr {$v2-($v1+$dist)}]
                
                if {$di >= $picos_wanted} {
                    if {$do_print} {
                        incr jumps($di)
                    }
                    incr count
                }
            }
            incr e
        }
        incr s
    }
    if {$do_print} {
        puts "="
        foreach k [lsort -real [array names jumps]] {
            puts "There are $jumps($k) cheats that save $k picoseconds."
        }
    }
    return $count
}
    
proc jumps1 { maze trail {do_print 0}} {
    set count 0
    foreach {pos score} [$maze get_scores] {
        if {[$maze get $pos] ne "#"} continue
        
        set pl {}
        set pa [pos [x $pos]   [y $pos]+1 ]
        set pb [pos [x $pos]   [y $pos]-1 ]
        set pc [pos [x $pos]+1 [y $pos]   ]
        set pd [pos [x $pos]-1 [y $pos]   ]
        
        set pl [list $pa $pb $pc $pd]
        foreach p1 $pl {
            
            set v1 [$maze get_score $p1]
            if {$v1 == 1000000} continue
            if {[lsearch $trail $p1] == -1} continue
            
            foreach p2 $pl {
                set v2 [$maze get_score $p2]
                if {$v2 == 1000000} continue
                if {[lsearch $trail $p2] == -1} continue
                
                if {$v2 > $v1} {
                    
                    set di [expr {$v2-($v1+2)}]
                    if {$di > 0 && $do_print} {
                        incr jumps($di)
                    }
                    if {$di >= 100} {
                        incr count
                    }
                    
                }
            }
        }
    }
    if {$do_print} {
        puts "="
        foreach k [lsort -real [array names jumps]] {
            puts "$jumps($k) saves $k picoseconds"
        }
    }
    return $count
}

# --------------------------------------------------------------------
# --- MAZE CLASS -----------------------------------------------------
# --------------------------------------------------------------------
oo::define Maze {

    variable map_score best_trail best_trail_score
    
    method search { {cmd "start"} {trail {}} {score 0} } {
        if {$cmd eq "start"} {
            interp recursionlimit {} 100000
            unset -nocomplain map_score
            set best_trail {}
            set best_trail_score 100000
            set trail [list $pos_start]
            set map_score($pos_start) 0
        }
        set pos [lindex $trail end]
        foreach { n_pos n_char n_score } [my choices $pos $score] {
            set n_trail [list {*}$trail $n_pos]
            if {$n_char eq "E"} {
                if { $n_score < $best_trail_score} {
                    set best_trail $n_trail
                    set best_trail_score $n_score
                }
                continue
            }
            my search next $n_trail $n_score
        }
        if {$cmd eq "start"} {
            return [dict create :trail $best_trail :score $best_trail_score]
        } else {
            return {}
        }
    }
    
    method choices { pos score } {
        set result {}
        foreach pos_d { {0 1} {1 0} {0 -1} {-1 0} } {
            set n_pos [pos {[x $pos] + [x $pos_d]} {[y $pos] + [y $pos_d]}]
            set n_score [expr $score + 1]
            set n_char [my get $n_pos]
            set is_free [expr {$n_char != "#"}]
            set is_good 0
            if {$n_score <= [my get_score $n_pos]} {
                my set_score $n_pos $n_score 
                set is_good 1
            }
            if {$is_free && $is_good} {
                lappend result $n_pos $n_char $n_score
            }
        }
        return $result
    }

    method get_score { pos } {
        if {[info exists map_score($pos)]} {
            return $map_score($pos)
        } else {
            return 1000000
        }
    }

    method get_scores { } {
        return [array get map_score]
    }
    
    method set_score { pos score } {
        set map_score($pos) $score
    }
}
# --------------------------------------------------------------------
oo::define Maze {
    
    variable pos_start pos_end pos_max map_chr

    method print { {trail {}} } {
        for {set y -1} {$y <= [y $pos_max]} {incr y} {
            for {set x -1} {$x <= [x $pos_max]} {incr x} {
                set pos [pos $x $y]
                set chr [my get $pos]
                if {[lsearch $trail $pos] != -1} {
                    puts -nonewline "O"
                } else {
                    puts -nonewline $chr
                }
            }
            puts ""
        }
    }
    
    method parse { data } {
        set pos_start {}
        set pos_end {}
        set pos_max {}
        
        set max_y 0
        set max_x 0
        foreach line [split $data "\n"] {
            set x 0
            foreach chr [split $line ""] {
                set pos [::pos $x $max_y]
                switch $chr {
                    "S" { set pos_start $pos }
                    "E" { set pos_end   $pos }
                }
                set map_chr($pos) $chr
                incr x
            }
            if {$x > $max_x} {
                incr max_x
            }
            incr max_y
        }
        set pos_max [pos $max_x $max_y]
    }
    
    method get { pos } {
        if {[x $pos] < 0 || [x $pos] >= [x $pos_max]} {
            return "#"
        }
        if {[y $pos] < 0 || [y $pos] >= [y $pos_max]} {
            return "#"
        }
        return $map_chr($pos)
    }
    
}
# --------------------------------------------------------------------
proc pos { x y } { list [uplevel 1 "expr $x"] [uplevel 1 "expr $y"] }
proc y { l } {lindex $l 1 }
proc x { l } {lindex $l 0 }
proc dist { p1 p2 } { expr {abs([x $p1]-[x $p2])+abs([y $p1]-[y $p2])} }
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 0 285
    # My results: 1409 1012821
    puts [aoc_20]
}
