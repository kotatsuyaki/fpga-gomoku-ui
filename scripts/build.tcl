set outputDir build/
set topModuleName top
file mkdir $outputDir

set_param general.maxThreads 16

read_verilog [ glob src/*.v ]
read_verilog -sv [ glob src/*.sv ]
read_xdc [ glob constraints/*.xdc ]


# Synth & report
synth_design -top $topModuleName -part xc7a35tcpg236-1
write_checkpoint -force $outputDir/post_synth.dcp

report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization -file $outputDir/post_synth_util.rpt

# Opt & place
opt_design
place_design
report_clock_utilization -file $outputDir/clock_util.rpt

# Maybe opt
if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
puts "Found setup timing violations => running physical optimization"
phys_opt_design
}
write_checkpoint -force $outputDir/post_place.dcp
report_utilization -file $outputDir/post_place_util.rpt
report_timing_summary -file $outputDir/post_place_timing_summary.rpt

# Route & netlist
route_design
write_checkpoint -force $outputDir/post_route.dcp
report_route_status -file $outputDir/post_route_status.rpt
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/cpu_impl_netlist.v -mode timesim -sdf_anno true

# Gen bitstream
write_bitstream -force $outputDir/$topModuleName.bit
