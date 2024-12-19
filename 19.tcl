#!/usr/bin/env tclsh
proc aoc_19 { } {
    set result [list]
    set data [aoc_read "19.data"]
    parse $data
    lappend result [designs_possible 1] [designs_possible 0]
    return $result
}
# --------------------------------------------------------------------
proc designs_possible { {one 0} } {
    global towel_patterns towel_designs
    set count 0
    set acount 0
    set asz [llength $towel_designs]
    foreach design $towel_designs {
        #puts "$acount / $asz"
        incr count [design_is_possible $design $one]
        incr acount
    }
    return $count
}
proc design_is_possible { design {one 0} {pre {}}} {
    global towel_patterns towel_cache

    if {[info exists towel_cache($design.$one)]} {
        return $towel_cache($design.$one)
    }
    
    set result 0
    set designsz [string length $design]
    
    foreach pattern $towel_patterns {
        set patternsz [string length $pattern]
        set finishes  [expr {$patternsz == $designsz}]
        set next      [string range $design $patternsz end]
        
        if {![string equal -length $patternsz $pattern $design]} {
            continue
        } elseif {$finishes} {
            incr result
        } else {
            #puts "$design -> ${pattern} -> $next"
            incr result [design_is_possible $next $one [list {*}$pre $pattern]]
        }
        
        if {$one && $result} {
            break
        }
    }

    set towel_cache($design.$one) $result
    
    return $result
}
# --------------------------------------------------------------------
proc show { } {
    global towel_patterns towel_designs
    foreach pattern $towel_patterns {
        puts "P: $pattern"
    }
    foreach design $towel_designs {
        puts "D: $design"
    }
}
proc parse { data } {
    global towel_patterns towel_designs
    foreach line [split $data "\n"] {
        switch -glob $line {
            "*,*" {
                foreach word [split $line ","] {
                    lappend towel_patterns [string trim $word]
                }
            }
            "" {
                
            }
            "*" {
                lappend towel_designs $line
            }
        }
    }
    set towel_patters [lsort $towel_patterns]
    set towel_designs $towel_designs
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 6, 16
    # My results: 280, 606411968721181
    puts [aoc_19]
}
