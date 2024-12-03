#!/usr/bin/env tclsh
source cc.tcl
proc aoc_03 { } {
    set d [aoc_read "03.data"]
    #set d {xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))}
    #set d {xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))}
    puts [aoc_int1 $d]
    puts [aoc_int2 $d]
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
aoc_03
