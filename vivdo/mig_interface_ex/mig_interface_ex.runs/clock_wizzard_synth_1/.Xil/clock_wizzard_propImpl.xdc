set_property SRC_FILE_INFO {cfile:/home/raymond/Desktop/ray5/vivdo/mig_interface_ex/mig_interface_ex.gen/sources_1/ip/clock_wizzard/clock_wizzard.xdc rfile:../../../mig_interface_ex.gen/sources_1/ip/clock_wizzard/clock_wizzard.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports in_100mhz]] 0.100
