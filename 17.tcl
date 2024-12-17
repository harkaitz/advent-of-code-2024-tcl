#!/usr/bin/env tclsh
proc aoc_17 { } {
    global PRG RA RB RC PRG OUT
    set result [list]
    set data [aoc_read "17.data"]

    ## Part 1
    set program [load_program $data]
    puts $program
    eval $program
    lappend result [join $OUT ","]

    ## Part 2
    ## no idea
    
    return $result
}

# --------------------------------------------------------------------

proc compile { assembly {RA 0} {RB 0} {RC 0} } {
    set code ""
    set code "${code}set OUT {}\n"
    set code "${code}set RA $RA\n"
    set code "${code}set RB $RB\n"
    set code "${code}set RC $RC\n"
    set code "${code}while {1} {\n"
    set vcode {puts [format "(%i:%o)(%i:%o)(%i:%o)(%s)\n" $RA $RA $RB $RB $RC $RC $OUT]}
    foreach {opcode operand} $assembly {
        switch $opcode {
            adv - 0 { set code "${code}    set RA \[expr {entier(\$RA/(2**[combo $operand]))} \]\n" }
            bdv - 6 { set code "${code}    set RB \[expr {entier(\$RA/(2**[combo $operand]))} \]\n" }
            cdv - 7 { set code "${code}    set RC \[expr {entier(\$RA/(2**[combo $operand]))} \]\n" }
            bxl - 1 { set code "${code}    set RB \[expr {\$RB ^ $operand}\]\n"       }
            bst - 2 { set code "${code}    set RB \[expr {[combo $operand] % 8}\]\n"  }
            jnz - 3 { set code "${code}    if {\$RA != 0} { continue }\n"             }
            bxc - 4 { set code "${code}    set RB \[expr {\$RB ^ \$RC}\]\n"           }
            out - 5 { set code "${code}    lappend OUT \[expr {[combo $operand] % 8}\]\n" }
        }
        switch $opcode {
            out - 5 {
                set code "${code}    ${vcode}\n"
            }
        }
    }
    set code "${code}    break\n}\n"
    set code "${code}puts \"(\$RA)(\$RB)(\$RC)(\$OUT)\"\n"
    return $code
}
proc combo { operand } {
    switch $operand {
        0 - 1 - 2 - 3 { return "$operand" }
        4 { return "\$RA" }
        5 { return "\$RB" }
        6 { return "\$RC" }
        7 { error "Invalid program" }
    }
}
# --------------------------------------------------------------------
proc load_program { data } {
    set RA 0
    set RB 0
    set RC 0
    set PRG {}
    foreach line [split $data "\n"] {
        set re1 {^Register (.): *(\d+)$}
        set re2 {^Program: *(.*)$}
        if {[regexp -- $re1 $line ign r v]} {
            switch $r {
                "A" { set RA $v }
                "B" { set RB $v }
                "C" { set RC $v }
            }
        } elseif {[regexp -- $re2 $line ign p]} {
            set PRG [split $p ","]
        }
    }
    return [compile $PRG $RA $RB $RC]
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 4,6,3,5,6,3,5,2,1,0
    # My results: 7,0,7,3,4,1,3,0,1   (Out of my reach)
    puts [aoc_17]
}
