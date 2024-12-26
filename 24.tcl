#!/usr/bin/env tclsh
proc aoc_24 { } {
    set result [list]
    set data [aoc_read "24.data"]
    parse $data
    lappend result [net_zetas]
    return $result
}
# --------------------------------------------------------------------
proc parse { data } {
    set re1 {(.*): *([01])}
    set re2 {([^ ]+) +AND +([^ ]+) +-> *([^ ]+)}
    set re3 {([^ ]+) +OR +([^ ]+) +-> *([^ ]+)}
    set re4 {([^ ]+) +XOR +([^ ]+) +-> *([^ ]+)}
    set outs {}
    set code {}
    foreach line [split $data "\n"] {
        if {[regexp -- $re1 $line ign var val]} {
            lappend code "proc net_$var {} { return $val }"
        } elseif {[regexp -- $re2 $line ign i1 i2 var]} {
            lappend code "proc net_$var {} { expr {\[net_$i1\] && \[net_$i2\] } }"
        } elseif {[regexp -- $re3 $line ign i1 i2 var]} {
            lappend code "proc net_$var {} { expr {\[net_$i1\] || \[net_$i2\] } }"
        } elseif {[regexp -- $re4 $line ign i1 i2 var]} {
            lappend code "proc net_$var {} { expr {\[net_$i1\] ^ \[net_$i2\] } }"
        } else {
            continue
        }
        switch -glob $var {
            "z*" {
                lappend outs net_$var
            }
        }
    }
    lappend code "proc net_zetas {} { expr 0b\[[join [lsort -decreasing $outs] {][}]\] }"
    
    set code [join $code "\n"]
    #puts $code
    eval $code
}

# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 2024
    # My results: 53755311654662
    puts [aoc_24]
}
