#!/usr/bin/env tclsh8.7
proc aoc_09 { } {
    global blocks blocksz
    set r [list]
    set d [aoc_read "09.data"]
    ## Defrag 1
    parse $d
    defrag1
    lappend r [checksum]
    ## Defrag 2
    parse $d
    defrag2
    lappend r [checksum]
}
## -------------------------------------------------------------------
proc defrag1 { } {
    global data space disksz
    set fl [lsort -real [array names space]]
    set dl [lreverse [lsort -real [array names data]]]
    puts "Defragmenting 1"
    foreach d $dl f $fl {
        if {$d eq "" || $f eq "" || $d < $f} {
            return
        }
        set data($f) $data($d)
        set space($d) "."
        unset data($d)
    }
}
## -------------------------------------------------------------------
## There must be a better way.
proc defrag2 { } {
    global data disksz
    set sp_pos 0
    set da_pos [expr $disksz - 1]
    puts "Defragmenting 2"
    while {1} {
        set da [get_data_2 $da_pos 0]
        set sp [get_space_2 $sp_pos $da_pos [len_block $da]]
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
        puts -nonewline "+"
        flush stdout
        move_block $sp $da
    }
    puts ""
}
proc get_space_2 { start {pmax -1} {bmin 1} } {
    global data space disksz
    if {$pmax < 0} {
        set pmax $disksz
    }
    set i $start
    while {1} {
        set b -1
        set b_l [list]
        for {} {$i < $pmax} {incr i} {
            if {[info exists space($i)]} {
                if {$b eq "-1"} {
                    set b "."
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
proc get_data_2 { {start -1} {pmin 0} {bmax 1000000} } {
    global data space disksz
    if {$start < 0} {
        set start [expr $disksz - 1]
    }
    set i $start
    while {1} {
        set b -1
        set b_l [list]
        for {} {$i >= $pmin} {incr i -1} {
            if {[info exists data($i)]} {
                set c $data($i)
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
    global data space
    set to_id [lindex $to 0]
    set fr_id [lindex $fr 0]
    foreach f [lrange $fr 1 end] t [lrange $to 1 end] {
        if {$f eq ""} {
            return $t
        }
        if {$t eq ""} {
            break
        }
        set space($f) "."
        set data($t) $fr_id
        unset data($f)
        unset space($t)
    }
    return [expr [lindex $to end] + 1]
}
proc len_block { block } {
    return [llength [lrange $block 1 end]]
}
## -------------------------------------------------------------------
proc parse { dd } {
    global data space disksz
    unset -nocomplain data space disksz
    set id 0
    set disksz 0
    foreach {d f} [split $dd ""] {
        for {set i 0} {$i < $d} {incr i} {
            set data($disksz) $id
            incr disksz
        }
        if {$f ne ""} {
            for {set i 0} {$i < $f} {incr i} {
                set space($disksz) "."
                incr disksz
            }
        }
        incr id
    }
}
proc get_blocks { } {
    global disksz
    set l {}
    for {set i 0} {$i < $disksz} {incr i} {
        lappend l $i
    }
    return $l
}
proc print { } {
    global data
    foreach p [get_blocks] {
        if {[info exists data($p)]} {
            puts -nonewline $data($p)
        } else {
            puts -nonewline "."
        }
    }
    puts ""
}
proc checksum { } {
    global data
    set s 0
    foreach p [get_blocks] {
        if {[info exists data($p)]} {
            incr s [expr $data($p) * $p]
        }
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
