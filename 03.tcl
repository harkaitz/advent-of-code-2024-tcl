#!/usr/bin/env tclsh
proc aoc_03 { } {
    set d1 [aoc_read "03.data" 1 =]
    set d2 [aoc_read "03.data" 2 =]
    return [list [aoc_int1 $d1] [aoc_int2 $d2]]
}
proc aoc_int2 { d } {
    set re_all {[a-z']+\([0-9,]*\)}
    set re_mul {mul\(([0-9][0-9]*),([0-9][0-9]*)\)$}
    set re_don {don't\(\)$}
    set re_do  {do\(\)$}
    set sum 0
    set do 1
    foreach tot [regexp -all -inline -- $re_all  $d] {
        if {[regexp -- $re_mul $tot mul a b]} {
            if {$do} {
                incr sum [expr "$a * $b"]
            }
        } elseif {[regexp -- $re_don $tot]} {
            set do 0
        } elseif {[regexp -- $re_do $tot]} {
            set do 1
        }
    }
    return $sum
}
proc aoc_int1 { d } {
    set re {mul\(([0-9][0-9]*),([0-9][0-9]*)\)}
    set sum 0
    foreach { t a b } [regexp -all -inline -- $re $d] {
        incr sum [expr "$a * $b"]
    }
    return $sum
}
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 161, 48
    # My results: 173529487, 99532691
    puts [aoc_03]
}
