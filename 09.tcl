#!/usr/bin/env tclsh8.7
proc aoc_09 { } {
    global blocks blocksz
    set r [list]
    set d [aoc_read "09.data"]
    ## Defrag 1
    puts "Defragmenting 1"
    lappend r FAIL
    ## Defrag 2
    puts "Defragmenting 2"
    parse $d
    defrag 2
    set ck [checksum]
    puts $ck
    lappend r $ck
}
## -------------------------------------------------------------------
proc defrag { phase } {
    global blocks blocksz
    set sp_pos 0
    set da_pos [expr $blocksz - 1]
    while {1} {
        set da [get_data_$phase $da_pos 0]
        set sp [get_space_$phase $sp_pos $da_pos [len_block $da]]
        set da_pos [nxt_block $da -1]
        if {$da_pos < 0} {
            break
        }
        if {![llength $da]} {
            break
        }
        if {![llength $sp]} {
            puts -nonewline "."
            flush stdout
            continue
        }
        if {$phase eq "1"} {
            set sp_pos [nxt_block $sp 1]
        }
        puts -nonewline "+"
        flush stdout
        move_block $sp $da
    }
    puts ""
}
## -------------------------------------------------------------------
proc get_space_1 { start {pmax -1} {bmin 0}} {
    global blocks blocksz
    if {$pmax < 0} {
        set pmax $blocksz
    }
    set l [list "."]
    set lsz 0
    for {set i $start} {$i < $pmax} {incr i} {
        set c [lindex $blocks $i]
        if {$c eq "."} {
            lappend l $i
            incr lsz
            if {$lsz >= $bmin} {
                break
            }
        }
    }
    if {$lsz} {
        return $l
    } else {
        return {}
    }
}
proc get_data_1 { start {pmin 0} {bmax 100000}} {
    return [get_data_2 $start $pmin $bmax]
}


proc get_space_2 { start {pmax -1} {bmin 1} } {
    global blocks blocksz
    if {$pmax < 0} {
        set pmax $blocksz
    }
    set i $start
    while {1} {
        set b -1
        set b_l [list]
        for {} {$i < $pmax} {incr i} {
            set c [lindex $blocks $i]
            if {$c eq "."} {
                if {$b eq "-1"} {
                    set b $c
                }
                lappend b_l $i
            } elseif {$b ne "-1"} {
                break
            }
        }
        if {$b ne "-1" && [llength $b_l] < $bmin} {
            continue
        }
        break
    }
    if {$b ne "-1"} {
        return [list "." {*}$b_l]
    } else {
        return {}
    }
}
proc get_data_2 { {start -1} {pmin 0} {bmax 100000} } {
    global blocks blocksz
    if {$start < 0} {
        set start [expr $blocksz - 1]
    }
    set i $start
    while {1} {
        set b -1
        set b_l [list]
        for {} {$i >= $pmin} {incr i -1} {
            set c [lindex $blocks $i]
            if {$c ne "."} {
                if {$b eq "-1"} {
                    set b $c
                }
                if {$b eq $c} {
                    lappend b_l $i
                } else {
                    break
                }
            } elseif {$b ne "-1"} {
                break
            }
        }
        if {$b ne "-1" && [llength $b_l] > $bmax} {
            continue
        }
        break
    }
    if {$b ne "-1"} {
        return [list $b {*}$b_l]
    } else {
        return {}
    }
}
proc nxt_block { block dif } {
    expr {[lindex $block end] + $dif}
}
proc move_block { to fr } {
    global blocks
    set to_id [lindex $to 0]
    set fr_id [lindex $fr 0]
    foreach f [lrange $fr 1 end] t [lrange $to 1 end] {
        if {$f eq ""} {
            return $t
        }
        if {$t eq ""} {
            break
        }
        lset blocks $f "."
        lset blocks $t $fr_id
    }
    return [expr [lindex $to end] + 1]
}
proc len_block { block } {
    return [llength [lrange $block 1 end]]
}
## -------------------------------------------------------------------
proc parse { d } {
    global blocks blocksz
    set is_data 1
    set id 0
    set blocks [list]
    foreach c [split $d ""] {
        if {$is_data} {
            set b $id
            incr id
            set is_data 0
        } else {
            set b "."
            set is_data 1
        }
        for {set i 0} {$i < $c} {incr i} {
            lappend blocks $b
        }
    }
    set blocksz [llength $blocks]
}
proc print { } {
    global blocks
    puts [join $blocks ""]
}
proc checksum { } {
    global blocks
    set i 0
    set s 0
    foreach e $blocks {
        if {$e ne "."} {
            incr s [expr $e * $i]
        }
        incr i
    }
    return $s
}
## -------------------------------------------------------------------
if {[file tail $argv0] eq [file tail [info script]]} {
    source "rd.tcl"
    # Example results: 1928, 2858
    # My results: 6331212425418, 6363268339304
    puts [aoc_09]
}
