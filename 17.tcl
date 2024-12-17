#!/usr/bin/env tclsh
# For part1 I wrote a opcode->tcl compiler. For part 2 I after a lot
# of printing and analysis I notices that only the last number had
# effect on the last result number, this allows an incremental search
# in "get_number".
proc aoc_17 { } {
    global PRG RA RB RC PRG OUT
    set result [list]
    set data [aoc_read "17.data"]
    set prg_ra_rb_rc [load_program $data]
    set prg [lindex $prg_ra_rb_rc 0]

    ## Part 1
    set program [compile {*}$prg_ra_rb_rc]
    puts $program
    eval $program
    lappend result [join $OUT ","]

    ## Part 2
    lappend result [get_number $prg $prg]

    return $result
}
# --------------------------------------------------------------------
proc get_number { assembly result} {
    
    set output [list]
    set i_numbers [list ""]
    set o_numbers [list]
    
    foreach o [lreverse $result] {
        set output [list $o {*}$output]
        
        foreach i_number $i_numbers {
            foreach i {0 1 2 3 4 5 6 7 } {
                set number ${i_number}${i}
                
                eval [compile $assembly 0$number]
                if {$output eq $OUT} {
                    lappend o_numbers $number
                } else {
                }
            }
        }

        if {[llength $o_numbers] == 0} {
            error "Can't find a solution."
        }
        
        set i_numbers $o_numbers
        set o_numbers [list]
        
    }

    set result [list]
    foreach n $i_numbers {
        lappend result [expr 0$n]
    }
    
    return [lindex [lsort -real $result] 0]
}
# --------------------------------------------------------------------
proc compile { assembly {RA 0} {RB 0} {RC 0} } {
    set code ""
    set code "${code}set OUT {}\n"
    set code "${code}set RA $RA; # [format {%o} $RA]\n"
    set code "${code}set RB $RB\n"
    set code "${code}set RC $RC\n"
    set code "${code}while {\$RA} {\n"
    #set code "${code}    set RB 0\n"
    #set code "${code}    set RC 0\n"
    set code "${code}[compile_it $assembly]"
    set code "${code}}\n"
    #set code "${code}puts \"== (A=\$RA)(B=\$RB)(C=\$RC)(\$OUT) ==\"\n"
    return $code
}
proc compile_it { assembly } {
    set code ""
    set vcode {puts [format "(A=%i:%o)(B=%i:%o)(C=%i:%o)(%s)\n" $RA $RA $RB $RB $RC $RC $OUT]}
    foreach {opcode operand} $assembly {
        switch $opcode {
            adv - 0 { set ncode "set RA \[expr {entier(\$RA >> [combo $operand])} \]" }
            bdv - 6 { set ncode "set RB \[expr {entier(\$RA >> [combo $operand])} \]" }
            cdv - 7 { set ncode "set RC \[expr {entier(\$RA >> [combo $operand])} \]" }
            out - 5 { set ncode "lappend OUT \[expr {[combo $operand] % 8}\]" }
            bxl - 1 { set ncode "set RB \[expr {\$RB ^ $operand}\]"       }
            bst - 2 { set ncode "set RB \[expr {[combo $operand] % 8}\]"  }
            bxc - 4 { set ncode "set RB \[expr {\$RB ^ \$RC}\]"           }
            default { continue }
        }
        set code "${code}    ${ncode}; # ${opcode} ${operand}\n"
        switch x$opcode {
            out - 4 {
                set code "${code}    puts {$ncode}\n"
                set code "${code}    ${vcode}\n"
            }
        }
    }
    return $code
}
proc combo { operand {pre "\$"}} {
    switch $operand {
        0 - 1 - 2 - 3 { return "$operand" }
        4 { return "${pre}RA" }
        5 { return "${pre}RB" }
        6 { return "${pre}RC" }
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
    return [list $PRG $RA $RB $RC]
}
# --------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 4,6,3,5,6,3,5,2,1,0
    # My results: 7,0,7,3,4,1,3,0,1  156985331222018
    puts [aoc_17]
}
