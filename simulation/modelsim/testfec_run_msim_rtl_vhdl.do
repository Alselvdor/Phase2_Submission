transcript on
if ![file isdirectory testfec_iputf_libs] {
	file mkdir testfec_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vcom "D:/AUC/ASIC/Project/Phase2_Submission/PLL_main_sim/PLL_main.vho"

vlog -vlog01compat -work work +incdir+D:/AUC/ASIC/Project/Phase2_Submission/PLL {D:/AUC/ASIC/Project/Phase2_Submission/PLL/PLL_0002.v}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/TopWiMax.vhd}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/RAMs/INTER_RAM_2port.vhd}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/RAMs/FEC_RAM_2PORTS.vhd}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/randi.vhd}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/MODU.vhd}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/INTER.vhd}
vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/FEC.vhd}

vcom -93 -work work {D:/AUC/ASIC/Project/Phase2_Submission/TopWiMax_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  TopWiMax_tb

add wave *
view structure
view signals
run -all
