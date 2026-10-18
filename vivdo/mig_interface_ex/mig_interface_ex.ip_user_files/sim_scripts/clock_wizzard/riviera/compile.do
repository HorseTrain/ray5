transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../../../../amd/2026.1/data/rsb/busdef" "+incdir+../../../../mig_interface_ex.gen/sources_1/ip/clock_wizzard" -l xpm -l xil_defaultlib \
"/home/raymond/Desktop/amd/2026.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  -incr \
"/home/raymond/Desktop/amd/2026.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../mig_interface_ex.gen/sources_1/ip/clock_wizzard/clock_wizzard_sim_netlist.vhdl" \


vlog -work xil_defaultlib \
"glbl.v"

