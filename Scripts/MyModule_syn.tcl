## Setup technology files
include ../Scripts/X-FAB_typ.tcl
#set_attribute optimize_constant_0_flops false
## Setup variables
set DESIGN Filter_test_24
set PARAMS {}
# Top module
read_hdl -v2001 ../Source/Filter_test_24.v
## Compile our code (create a technology-independent schematic)
elaborate -parameters $PARAMS $DESIGN
## Setup design constraints
read_sdc ../Source/Diff2.sdc
#set_remove_assign_options -ignore_preserve_setting -buffer BUHDX1 -design Filter_test_24
## Synthesize our schematic (create a technology-dependent schematic)
#synthesize -to_generic
synthesize -to_mapped
synthesize -incremental
## Write out area and timing reports
report area > ../Reports/RTL_Compiler/Top_synth_area_report_typ
report timing > ../Reports/RTL_Compiler/Top_synth_timing_report_typ
## Write out synthesized Verilog netlist
write_hdl -mapped > ../Outputs/RTL_Compiler/Top_synth.v
## Write out the SDC file we will take into the place n route tool
write_sdc > ../Outputs/RTL_Compiler/Top_out.sdc
gui_show

