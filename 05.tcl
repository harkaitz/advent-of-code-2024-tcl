#!/usr/bin/env tclsh
source cc.tcl

proc aoc_05 { } {
    global d
    
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

    # Results: 5329, 5833
    puts $count1
    puts $count2
}
proc lmiddle { lst } {
    set l [llength $lst]
    set m [expr {int($l/2)}]
    return [lindex $lst $m]
}
## -------------------------------------------------------------------
set d {47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
}
## -------------------------------------------------------------------
aoc_05
