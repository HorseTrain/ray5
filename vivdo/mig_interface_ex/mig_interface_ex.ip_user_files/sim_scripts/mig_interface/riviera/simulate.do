transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+mig_interface  -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mig_interface xil_defaultlib.glbl

do {mig_interface.udo}

run 1000ns

endsim

quit -force
