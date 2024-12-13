#!/usr/bin/env tclsh
# In this puzzle they try to deceive us, suggesting that it is a problem
# optimization or search. However, it is an algebra problem. Instead of using
# "math::linearalgebra" from tcllib I am going to apply Cramer manually.
#
# Furthermore, in this way I will be able to detect whether the determinants
# are divisible with greater certainty.
proc aoc_13 { } {
    set result [list]
    set data [aoc_read "13.data"]
    set equations1 [parse $data 0]
    set equations2 [parse $data 10000000000000]
    set count1 0
    set count2 0
    
    foreach {coefficient constant} $equations1 {
        foreach {pushes_a pushes_b} [cramer $coefficient $constant] {
            incr count1 [expr {$pushes_a * 3 + $pushes_b * 1}]
        }
    }
    lappend result $count1

    foreach {coefficient constant} $equations2 {
        foreach {pushes_a pushes_b} [cramer $coefficient $constant] {
            incr count2 [expr {$pushes_a * 3 + $pushes_b * 1}]
        }
    }
    lappend result $count2
    
    return $result
}
proc cramer { coefficient constant } {
    set ret [list]
    
    set m1 $coefficient
    lset m1 0 0 [lindex $constant 0]
    lset m1 1 0 [lindex $constant 1]
    set d1 [determinant $m1]

    set m2 $coefficient
    lset m2 0 1 [lindex $constant 0]
    lset m2 1 1 [lindex $constant 1]
    set d2 [determinant $m2]

    set d [determinant $coefficient]
    
    if {($d1 % $d) == 0 && ($d2 % $d) == 0} {
        return [list [expr {$d1 / $d}] [expr {$d2 / $d}]]
    } else {
        return [list]
    }
    
}
proc determinant { m } {
    return [expr {[lindex $m 0 0] * [lindex $m 1 1] - [lindex $m 0 1]*[lindex $m 1 0]}]
}
                    
proc parse { d {sum 0}} {
    set re1 {^Button A: X\+(\d+), Y\+(\d+)$}
    set re2 {^Button B: X\+(\d+), Y\+(\d+)$}
    set re3 {^Prize: X=(\d+), *Y=(\d+)$}
    set chk 0
    set equations [list]
    
    foreach line [split $d "\n"] {
        if {[regexp -- $re1 $line ign a1 a2] && $chk eq 0} {
            incr chk
        } elseif {[regexp -- $re2 $line ign b1 b2] && $chk eq 1} {
            incr chk
        } elseif {[regexp -- $re3 $line ign c1 c2] && $chk eq 2} {
            lappend equations [list [list $a1 $b1] [list $a2 $b2]]
            lappend equations [list [expr $c1 + $sum] [expr $c2 + $sum]]
            incr chk
        } elseif {$line eq "" && $chk eq 3} {
            set chk 0
        } else {
            error "Invalid input: $line"
        }
    }
    return $equations
}



if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 480 875318608908
    # My results: 28887 96979582619758
    puts [aoc_13]
}
