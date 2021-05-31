## Setup technology files
include ../Scripts/X-FAB_slow.tcl
## Setup variables
set DESIGN Filter_test_24
set PARAMS {}
## Read in Verilog HDL files
# Top module
read_hdl -v2001 ../Source/Filter_test_24.v
## Compile our code (create a technology-independent schematic)
elaborate -parameters $PARAMS $DESIGN
## Setup design constraints
read_sdc ../Source/Diff2.sdc
## Synthesize our schematic (create a technology-dependent schematic)
#synthesize -to_generic
synthesize -to_mapped
synthesize -incremental
## Write out area and timing reports
report area > ../Reports/RTL-Compiler/Top_synth_area_report_slow
report timing > ../Reports/RTL_Compiler/Top_synth_timing_report_slow
## Write out synthesized Verilog netlist
write_hdl -mapped > ../Outputs/RTL_Compiler/Synthesis/Top_synth_slow.v
## Write out the SDC file we will take into the place n route tool
write_sdc > ../Outputs/RTL_Compiler/Top_out_slow.sdc
gui_show

