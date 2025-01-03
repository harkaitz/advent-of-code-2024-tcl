#!/usr/bin/env wish
package require Tk
## -------------------------------------------------------------------
set wm_title "Advent of Code 2024 Tcl/Tk solutions"
set title "AoC 2024 Tcl/Tk solutions"
set menu {
    "Day 1: Historian Hysteria"
    "Day 2: Red-Nosed Reports"
    "Day 3: Mull It Over"
    "Day 4: Ceres Search"
    "Day 5: Print Queue"
    "Day 6: Guard Gallivant"
    "Day 7: Bridge Repair"
    "Day 8: Resonant Collinearity"
    "Day 9: Disk Fragmenter"
    "Day 10: Hoof It"
    "Day 11: Plutonian Pebbles"
    "Day 12: Garden Groups"
    "Day 13: Claw Contraption"
    "Day 14: Restroom Redoubt"
    "Day 15: Warehouse Woes"
    "Day 16: Reindeer Maze"
    "Day 17: Chronospatial Computer"
    "Day 18: RAM Run"
    "Day 19: Linen Layout"
    "Day 20: Race Condition"
    "Day 21: Keypad Conundrum"
    "Day 22: Monkey Market"
    "Day 23: LAN Party"
    "Day 24: Crossed Wires"
    "Day 25: Code Chronicle"
}
set aoc_url "https://adventofcode.com/2024/"
set git_repo "https://github.com/harkaitz/advent-of-code-2024-tcl"
## -------------------------------------------------------------------
set dir [file dirname [info script]]
source "$dir/rd.tcl"
## Main window
wm title . $wm_title
wm geometry . "600x460"
## (1) Title
label .title -text $title -font "Helvetica 24 bold" -justify "center" -anchor "center" -underline 1
pack .title -fill "x" -padx "10" -pady "3"
## (2) Input text
text .input -height 16 -width 40
pack .input -fill "both" -padx "10" -pady "3"
## (3) Operations
frame .ops
## (3.1) Day selection
ttk::combobox .ops.days -state readonly -values $menu -postcommand select_example
bind .ops.days <<ComboboxSelected>> select_example
## (3.2) Run button
button .ops.run -text "Get answer" -command {
    set day [get_day]
    update_data
    source "$dir/$day.tcl"
    .ops.result configure -text Thinking...
    .ops.result configure -text [aoc_$day]
}
## (3.3) Example button
button .ops.data -text "Example data" -command select_example
## (3.4) Result display
label .ops.result -text "" -justify "left" -font "bold" -wraplength 500  -borderwidth 2 -relief "groove"
##
pack .ops        -fill "x" -padx "10" -pady "3"
pack .ops.days   -side left           -padx "2"
pack .ops.run    -side left           -padx "2"
pack .ops.data   -side left           -padx "2"
pack .ops.result -side left -fill "both" -padx "2" -expand 1
## (4) Notes.
label .notes -justify left -text [string trim "
1) This is a personal project. I am not affiliated with Advent of Code or its creator.
2) Please visit $aoc_url to participate.
3) This code in $git_repo ."]
pack .notes -side left -fill "x" -padx "10" -pady "3"
## -------------------------------------------------------------------
proc get_day { } {
    set day_text [.ops.days get]
    set day [regexp -inline {\d+} $day_text]
    return [format "%02d" $day]
}
proc update_data { } {
    global from_gui dir
    set data [string trim [.input get 1.0 end]]
    if {$data eq ""} {
        .input insert end [aoc_read $dir/[get_day].data]
        set data [.input get 1.0 end]
    }
    set from_gui $data
}
proc select_example { } {
    global from_gui
    set from_gui ""
    .input delete 1.0 end
    update_data
}
## -------------------------------------------------------------------
.ops.days current 0
select_example
