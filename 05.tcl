#!/usr/bin/env tclsh
proc aoc_05 { } {
    set d [aoc_read "05.data"]
    
    ## Parse input updates and write comparator with the rules.
    set updates [list]
    set code ""
    foreach line [split $d "\n"] {
        switch -glob $line {
            "*|*" {
                set rule [split $line "|"]
                set a [lindex $rule 0]
                set b [lindex $rule 1]
                set code "$code
                    if {\$n1 eq \"$a\" && \$n2 eq \"$b\"} {
                        return -1
                    } elseif {\$n1 eq \"$b\" && \$n2 eq \"$a\"} {
                        return 1
                    }
                "
            }
            "*,*" {
                lappend updates [split $line ","]
            }
        }
    }
    set code "$code
        return 0
    "
    proc cmp { n1 n2 } $code
    
    ## Sort updates.
    set count1 0
    set count2 0
    foreach update $updates {
        set update_s [lsort -command cmp $update]
        if {$update eq $update_s} {
            incr count1 [lmiddle $update]
        } else {
            incr count2 [lmiddle $update_s]
        }
    }

    return [list $count1 $count2]
}
proc lmiddle { lst } {
    set l [llength $lst]
    set m [expr {int($l/2)}]
    return [lindex $lst $m]
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source cc.tcl
    # Example results: 143, 123
    # My results: 5329, 5833
    puts [aoc_05]
}
