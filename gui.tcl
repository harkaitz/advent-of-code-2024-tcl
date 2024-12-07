#!/usr/bin/env wish
package require Tk
## -------------------------------------------------------------------
set wm_title "Advent of Code 2024 Tcl/Tk solutions"
set title "AoC 2024 Tcl/Tk solutions"
set days {01 02 03 04 05 06 07}
set menu {
    "Day 1: Historian Hysteria"
    "Day 2: Red-Nosed Reports"
    "Day 3: Mull It Over"
    "Day 4: Ceres Search"
    "Day 5: Print Queue"
    "Day 6: Guard Gallivant"
    "Day 7: Bridge Repair"
}
set aoc_url "https://adventofcode.com/2024/"
set git_repo "https://github.com/harkaitz/advent-of-code-2024-tcl"
## -------------------------------------------------------------------
set dir [file dirname [info script]]
source [file join $dir "cc.tcl"]
foreach day $days {
    source [file join $dir "$day.tcl"]
}
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
    update_data
    .ops.result configure -text Thinking...
    .ops.result configure -text [aoc_[get_day]]
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
    global from_gui
    set data [string trim [.input get 1.0 end]]
    if {$data eq ""} {
        .input insert end [aoc_read [get_day].data]
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
