#!/usr/bin/env tclsh
# This solution doesn't work with all inputs. Please expand "part2" function
# to analyze all level2 outputs so that it works on yours.
proc aoc_24 { } {
    global tcl_platform
    set result [list]
    set data [aoc_read "24.data"]

    # Part1 
    parse_eval $data
    lappend result [net_zetas]

    # Part2
    if {$tcl_platform(user) eq "harkaitz"} {
        parse_struct $data
        lappend result [part2]
    }
    return $result
}
# --------------------------------------------------------------------
proc part2 { } {
    set tofix [list]
    for {set i 1} {$i < 45} {incr i} {
        set n [format "%02i" $i]
        set out z$n
        #puts "$out: [gate_view $out]"
        if {![gate_check $out {^C-XOR {C-XOR x$n y$n [^ ]+}} $n]} {
            set nout [gate_search {^C-XOR {C-XOR x$n y$n [^ ]+}} $n]
            if {$nout eq {}} {
                set g1 [lindex [lindex [gate_view $out] 1] end]
                set c1 [gate_search {^C-XOR [xy]$n [xy]$n [^ ]+} $n]
                puts "a $g1 <-> $c1"
                lappend tofix $g1 $c1
            } else {
                puts "b $out <-> $nout : [gate_view $nout]"
                lappend tofix $out $nout
            }
        }
    }
    return [join [lsort $tofix] ","]
}
proc gate_check { name regex {n {}} } {
    if {$n ne {}} {
        set regex [string map [list {$n} $n] $regex]
    }
    return [regexp -- $regex [gate_view $name]]
}
proc gate_search { regex {n {}} } {
    global GATES
    set found {}
    foreach name [array names GATES] {
        if {![gate_check $name $regex $n]} {
        } elseif {$found ne {}} {
            error "Multiple matches for: $regex"
        } else {
            set found $name
        }
    }
    return $found
}
proc gate_view { name } {
    global GATES
    return [gate_expand {*}$GATES($name) $name]
}
proc gate_expand { type a b name } {
    global GATES
    ## Level 1
    if {[info exists GATES($a)]} {
        set ad [list [lindex $GATES($a) 0] {*}[lsort [lrange $GATES($a) 1 end]] $a]
    } else {
        set ad $a
    }
    if {[info exists GATES($b)]} {
        set bd [list [lindex $GATES($b) 0] {*}[lsort [lrange $GATES($b) 1 end]] $a]
    } else {
        set bd $b
    }
    return [list $type {*}[lsort -decreasing [list $ad $bd]] $name]
}
proc parse_struct { data } {
    global GATES
    set re1 {(.*): *([01])}
    set re2 {([^ ]+) +AND +([^ ]+) +-> *([^ ]+)}
    set re3 {([^ ]+) +OR +([^ ]+) +-> *([^ ]+)}
    set re4 {([^ ]+) +XOR +([^ ]+) +-> *([^ ]+)}
    set i_gates {}
    set o_gates {}
    foreach line [split $data "\n"] {
        set gate {}
        if {[regexp -- $re1 $line ign var val]} {
        } elseif {[regexp -- $re2 $line ign i1 i2 var]} {
            set GATES($var) [list B-AND $i1 $i2]
        } elseif {[regexp -- $re3 $line ign i1 i2 var]} {
            set GATES($var) [list A-OR $i1 $i2]
        } elseif {[regexp -- $re4 $line ign i1 i2 var]} {
            set GATES($var) [list C-XOR $i1 $i2]
        } else {
            continue
        }
    }
}
# --------------------------------------------------------------------
proc parse_eval { data } {
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
    eval $code
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 2024
    # My results: 53755311654662 dkr,ggk,hhh,htp,rhv,z05,z15,z20
    puts [aoc_24]
}
