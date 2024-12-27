#!/usr/bin/env tclsh
proc aoc_21 { } {
    global KEYS DIRS
    
    set result [list]
    set data [aoc_read "21.data"]
    set remotes [split $data "\n"]
    set count 0

    # Part 1
    if {1} {
        foreach remote $remotes {
            set local [person_instructions a $remote]
            set points [complexity $local $remote]
            incr count $points
            puts "$remote: $local ($points)"
        }
        lappend result $count
    }
        
    # Part 2
    if {0} {
        foreach remote $remotes {
            set local [chain_instructions b $remote]
            set points [complexity $local $remote]
            incr count $points
            puts "$remote: $local ($points)"
        }
        lappend result $count
    }
    
    return $result
}

# --------------------------------------------------------------------

proc chain_instructions { name keys } {
    global KEYS DIRS
    interp recursionlimit {} 100000
    return [best_instructions \
                {*}[instructions $DIRS $name.p \
                {*}[instructions $DIRS $name.1 \
                {*}[instructions $DIRS $name.2 \
                {*}[instructions $DIRS $name.3 \
                {*}[instructions $DIRS $name.4 \
                {*}[instructions $DIRS $name.5 \
                {*}[instructions $DIRS $name.6 \
                {*}[instructions $DIRS $name.7 \
                {*}[instructions $DIRS $name.8 \
                {*}[instructions $DIRS $name.9 \
                {*}[instructions $DIRS $name.10 \
                {*}[instructions $DIRS $name.11 \
                {*}[instructions $DIRS $name.12 \
                {*}[instructions $DIRS $name.13 \
                {*}[instructions $DIRS $name.14 \
                {*}[instructions $DIRS $name.15 \
                {*}[instructions $DIRS $name.16 \
                {*}[instructions $DIRS $name.17 \
                {*}[instructions $DIRS $name.18 \
                {*}[instructions $DIRS $name.19 \
                {*}[instructions $DIRS $name.20 \
                {*}[instructions $DIRS $name.21 \
                {*}[instructions $DIRS $name.22 \
                {*}[instructions $DIRS $name.23 \
                {*}[instructions $DIRS $name.24 \
                {*}[instructions $DIRS $name.25 \
                {*}[instructions $KEYS $name.k $keys]]]]]]]]]]]]]]]]]]]]]]]]]]]]
}

# --------------------------------------------------------------------

proc complexity { local remote } {
    set num1 [string length $local]
    set num2 [string trimright [string trimleft $remote "0"] "A"]
    return [expr {$num1 * $num2}]
}

proc person_instructions { name keys } {
    global KEYS DIRS
    return [best_instructions \
                 {*}[instructions $DIRS $name.1 \
                 {*}[instructions $DIRS $name.2 \
                 {*}[instructions $KEYS $name.3 $keys]]]]
}

proc best_instructions { args } {
    set sel {}
    set selsz 10000000
    foreach keys $args {
        set keysz [string length $keys]
        if {$keysz < $selsz} {
            set sel $keys
            set selsz $keysz
        }
    }
    return $sel
}

proc instructions { keyboard name args } {
    global KEYS POS
    set results {}
    foreach keys $args {
        set res {""}
        if {![info exists POS($name)]} {
            set POS($name) "A"
        }
        foreach key [split $keys ""] {
            set res [type_map $keyboard $POS($name) $key $res "A"]
            set POS($name) $key
        }
        lappend results {*}$res
    }
    return [lrange $results 0 5000]
}

proc type_map { map fr to {pres {""}} {last "A"} } {
    set results [list]
    foreach pre $pres {
        foreach opt [dict get $map [list $fr $to]] {
            lappend results $pre$opt$last
        }
    }
    return $results
}

proc create_map { keyboard } {
    for {set y 0} {$y < [llength $keyboard]} {incr y} {
        for {set x 0} {$x < [llength [lindex $keyboard $y]]} {incr x} {
            set key_pos([lindex $keyboard $y $x]) [list $x $y]
        }
    }
    foreach {fr_key fr} [array get key_pos] {
        foreach {to_key to} [array get key_pos] {
            set fr_to_key [list $fr_key $to_key]
            if {$fr_key eq "n"} {
                
            } elseif {$fr_key eq $to_key} {
                set moves1($fr_to_key) ""
            } else {
                set dif_x [expr {[lindex $to 0] - [lindex $fr 0]}]
                set dif_y [expr {[lindex $to 1] - [lindex $fr 1]}]
                switch $dif_y {
                    "3"  { set v "vvv" } "2" { set v "vv" } "1" { set v "v" }
                    "0"  { set v "" }
                    "-3" { set v "^^^" } "-2" { set v "^^" } "-1" { set v "^" }
                }
                switch $dif_x {
                    "3"  { set h ">>>" } "2" { set h ">>" } "1" { set h ">" }
                    "0"  { set h "" }
                    "-3" { set h "<<<" } "-2" { set h "<<" } "-1" { set h "<" }
                }
                if {$to_key eq "n"} {
                    set delet1($fr_key) "$h$v"
                    set delet2($fr_key) "$v$h"
                } elseif {"$h$v" eq "$v$h"} {
                    set moves1($fr_to_key) "$h$v"
                } else {
                    set moves1($fr_to_key) "$h$v"
                    set moves2($fr_to_key) "$v$h"
                }
            }
        }
    }
    foreach {fr_to_key strokes} [array get moves1] {
        set del $delet1([lindex $fr_to_key 0])
        if {![string equal -length [string length $del] $del $strokes]} {
            lappend moves($fr_to_key) $strokes
        }
    }
    foreach {fr_to_key strokes} [array get moves2] {
        set del $delet2([lindex $fr_to_key 0])
        if {![string equal -length [string length $del] $del $strokes]} {
            lappend moves($fr_to_key) $strokes
        }
    }

    return [array get moves]
}

# --------------------------------------------------------------------

set KEYS_L {
    {7 8 9}
    {4 5 6}
    {1 2 3}
    {n 0 A}
}
set DIRS_L {
    {n ^ A}
    {< v >}
}
set KEYS [create_map $KEYS_L]
set DIRS [create_map $DIRS_L]

# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 126384
    # My results: 215374
    puts [aoc_21]
}
