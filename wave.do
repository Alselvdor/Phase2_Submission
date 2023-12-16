onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/clk_50
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/reset
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/load
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/TopWiMax_in_valid
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/TopWiMax_in_ready
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/WiInput
add wave -noupdate -expand -group {Top Module Inputs} /topwimax_tb/test_in_vector
add wave -noupdate -expand -group {Top Module Outputs} /topwimax_tb/test_out1_bit
add wave -noupdate -expand -group {Top Module Outputs} /topwimax_tb/test_out2_bit
add wave -noupdate -expand -group {Top Module Outputs} /topwimax_tb/TopWiMax_out_valid
add wave -noupdate -expand -group {Top Module Outputs} /topwimax_tb/TopWiMax_out_ready
add wave -noupdate -expand -group {Top Module Outputs} /topwimax_tb/test_pass_MODU_I
add wave -noupdate -expand -group {Top Module Outputs} /topwimax_tb/test_pass_MODU_Q
add wave -noupdate -expand -group RANDI -label Randi_Input_Ready /topwimax_tb/signal_alias_RANDI_input_ready
add wave -noupdate -expand -group RANDI -label Randi_Input_Valid /topwimax_tb/signal_alias_RANDI_input_valid
add wave -noupdate -expand -group RANDI -label Randi_Output_Ready /topwimax_tb/signal_alias_RANDI_output_ready
add wave -noupdate -expand -group RANDI -label Randi_Output_Valid /topwimax_tb/signal_alias_RANDI_output_valid
add wave -noupdate -expand -group RANDI -label Randi_Output_Data /topwimax_tb/signal_alias_RANDI_output_data
add wave -noupdate -expand -group RANDI /topwimax_tb/RANDI_Output_Vector
add wave -noupdate -expand -group RANDI /topwimax_tb/RANDI_Output_Expected
add wave -noupdate -expand -group RANDI /topwimax_tb/test_pass_RANDI
add wave -noupdate -expand -group FEC -label FEC_Input_Ready /topwimax_tb/signal_alias_fec_input_ready
add wave -noupdate -expand -group FEC -label FEC_Input_Valid /topwimax_tb/signal_alias_fec_input_valid
add wave -noupdate -expand -group FEC -label FEC_Output_Ready /topwimax_tb/signal_alias_fec_output_ready
add wave -noupdate -expand -group FEC -label FEC_Output_Valid /topwimax_tb/signal_alias_fec_output_valid
add wave -noupdate -expand -group FEC -label FEC_Output_Data /topwimax_tb/signal_alias_fec_output_data
add wave -noupdate -expand -group FEC /topwimax_tb/FEC_Output_Vector
add wave -noupdate -expand -group FEC /topwimax_tb/FEC_Expected_Output
add wave -noupdate -expand -group FEC -label test_pass_FEC /topwimax_tb/test_pass_FEC
add wave -noupdate -expand -group INTER -label INTER_Input_Ready /topwimax_tb/signal_alias_INTER_input_ready
add wave -noupdate -expand -group INTER -label INTER_Input_Valid /topwimax_tb/signal_alias_INTER_input_valid
add wave -noupdate -expand -group INTER -label INTER_Output_Ready /topwimax_tb/signal_alias_INTER_Output_ready
add wave -noupdate -expand -group INTER -label INTER_Output_Valid /topwimax_tb/signal_alias_INTER_Output_valid
add wave -noupdate -expand -group INTER -label INTER_Output_Data /topwimax_tb/signal_alias_INTER_Output_data
add wave -noupdate -expand -group INTER /topwimax_tb/INTER_Output_Vector
add wave -noupdate -expand -group INTER /topwimax_tb/INTER_Expected_Output
add wave -noupdate -expand -group INTER -label test_pass_INTER /topwimax_tb/test_pass_INTER
add wave -noupdate -expand -group MODU -label MODU_Output_Ready /topwimax_tb/signal_alias_MODU_Output_ready
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_Q
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_I
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_Q1
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_I1
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_Q2
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_I2
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_Q3
add wave -noupdate -expand -group MODU /topwimax_tb/test_out_vector_I3
add wave -noupdate -expand -group MODU /topwimax_tb/MODU_Expected_Output_Q
add wave -noupdate -expand -group MODU /topwimax_tb/MODU_Expected_Output_I

run 15 us

configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

WaveRestoreZoom {0 ns} {15 us}
