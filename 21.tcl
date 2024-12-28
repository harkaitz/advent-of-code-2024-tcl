#!/usr/bin/env tclsh
# This was hard, the key is in "select_stroke" and caching the count.
proc aoc_21 { } {
    
    set result [list]
    set data [aoc_read "21.data"]
    set remotes [split $data "\n"]
    
    # Part 1
    if {1} {
        set count 0
        foreach remote $remotes {
            set points [part1 $remote]
            incr count $points
            puts "$remote: ($points)"
        }
        lappend result $count
    }
    
        
    # Part 2
    if {1} {
        set count 0
        foreach remote $remotes {
            set points [part2 $remote]
            incr count $points
            puts "$remote: ($points)"
        }
        lappend result $count
    }
    
    return $result
}

# --------------------------------------------------------------------
proc part1 { keys } {
    set num1 [instructions_dirs_count p1.a 2 [instructions keys p1.b $keys]]
    set num2 [string trimright [string trimleft $keys "0"] "A"]
    return [expr {$num1 * $num2}]
}
proc part2 { keys } {
    set num1 [instructions_dirs_count p2.C 25 [instructions keys p2.K $keys]]
    set num2 [string trimright [string trimleft $keys "0"] "A"]
    return [expr {$num1 * $num2}]
}
proc instructions_dirs_count { name num keys } {
    global CACHE POS
    unset -nocomplain CACHE POS
    return [instructions_dirs_count_key $name $keys $num]
}
proc instructions_dirs_count_key { name keys num } {
    global CACHE POS
    set count 0
    set iname $name.l.$num
    if {$num > 1} {
        foreach key [splitA [instructions dirs $iname $keys]] {
            if {[info exists CACHE($iname.$key)]} {
                set number $CACHE($iname.$key)
            } else {
                set number [instructions_dirs_count_key $name $key [expr {$num - 1}]]
                set CACHE($iname.$key) $number
            }
            incr count $number
        }
    } else {
        incr count [string length [instructions dirs $iname $keys]]
    }
    return $count
}
proc splitA { txt } {
    set lst {}
    set str ""
    foreach t [split $txt ""] {
        if {$t eq "A"} {
            lappend lst $str$t
            set str ""
        } else {
            set str $str$t
        }
    }
    if {$str ne ""} {
        lappend lst $str
    }
    return $lst
}
# --------------------------------------------------------------------
proc complexity { local remote } {
    set num1 [string length $local]
    set num2 [string trimright [string trimleft $remote "0"] "A"]
    return [expr {$num1 * $num2}]
}
proc person_instructions { name keys } {
    return [instructions dirs $name.1 \
           [instructions dirs $name.2 \
           [instructions keys $name.3 $keys]]]
}
proc instructions { keyboard name keys } {
    global KEYS DIRS POS CACHE
    switch $keyboard {
        "keys"  { set map $KEYS }
        "dirs"  { set map $DIRS }
        default { set map $keyboard }
    }
    if {[info exists POS($name)]} {
        set pos $POS($name)
    } else {
        set pos "A"
    }
    set res ""
    foreach key [split $keys ""] {
        set res $res[dict get $map [list $pos $key]]A
        set pos $key
    }
    set POS($name) $pos
    return $res
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
    foreach {fr_to_key strokes} [array get moves] {
        set moves($fr_to_key) [select_stroke {*}$strokes]
    }
    return [array get moves]
}
proc select_stroke { {stroke1 {}} {stroke2 {}} } {
    if {[stroke_points $stroke1] > [stroke_points $stroke2]} {
        return $stroke1
    } else {
        return $stroke2
    }
}
proc stroke_points { stroke } {
    if {$stroke eq {}} {
        return 0
    }
    if {[string index $stroke end] eq "^"} {
        return 5
    }
    if {[string index $stroke end] eq ">"} {
        return 10
    }
    if {[string index $stroke end] eq "v"} {
        return 3
    }
    if {[string index $stroke end] eq "<"} {
        return 1
    }
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
    # Example results: 126384 154115708116294
    # My results: 215374 260586897262600
    puts [aoc_21]
}
