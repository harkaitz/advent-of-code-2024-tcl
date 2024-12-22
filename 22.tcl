#!/usr/bin/env tclsh
proc aoc_22 { } {
    set result [list]
    set data1 [aoc_read "22.data" 1 =]
    set data2 [aoc_read "22.data" 2 =]
    # Part 1
    if {1} {
        set count 0
        foreach secret [split $data1 "\n"] {
            #puts "$secret: [calculate_n $secret 2000]"
            incr count [calculate_n $secret 2000]
        }
        lappend result $count
    }
    # Part 2
    if {1} {
        set orders [buyer_orders [split $data2 "\n"] 2000]
        set bananas_pattern [best_pattern $orders]
        #puts $bananas_pattern
        lappend result [lindex $bananas_pattern 0]
    }
    return $result
}
proc best_pattern { orders } {
    set most_bananas 0
    set best_pattern {}
    foreach {pattern bananas} $orders {
        if {$bananas > $most_bananas} {
            
            set most_bananas $bananas
            set best_pattern $pattern
        }
    }
    return [list $most_bananas $best_pattern]
}

proc buyer_orders { secrets n } {
    set buyer_n 1
    foreach secret $secrets {
        set clues  [list]
        for {set i 0} {$i < $n} {incr i; set secret $secret_new} {
            set secret_new [calculate $secret]
            set order_old [string index $secret end]
            set order_new [string index $secret_new end]
            set clue      [expr { $order_new - $order_old }]
            set clues     [list {*}[lrange $clues end-2 end] $clue]

            if {[llength $clues] < 4} continue
        
            if {$order_new < 0} continue
            
            if {[info exists buyer($buyer_n.$clues)]} continue
            set buyer($buyer_n.$clues) sold
            
            incr orders_s($clues) $order_new
        }
        incr buyer_n
    }
    return [array get orders_s]
}
proc calculate_n { secret n } {
    for {set i 0} {$i < $n} {incr i} {
        set secret [calculate $secret]
    }
    return $secret
}
proc calculate { secret } {
    set step1  [expr { $secret * 64 }]     
    set secret [mix $secret $step1]
    set secret [prune $secret]
    set step2  [expr { entier($secret / 32) }]
    set secret [mix $secret $step2]
    set secret [prune $secret]
    set step3  [expr { $secret * 2048 }]
    set secret [mix $secret $step3]
    set secret [prune $secret]
    return $secret
}
proc mix { secret number } {
    expr { $number ^ $secret }
}
proc prune { secret } {
    expr { $secret % 16777216 }
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 37327623 23
    # My results: 16953639210 1863
    puts [aoc_22]
}

