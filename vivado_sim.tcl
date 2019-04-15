set project_dir    "./buffet.prj"
set project_name   "buffet"
set project_target "xc7z020clg400-1"
set source_files { \
			./buffet_defines.v \
			./dut/fifo.v \
			./dut/buffet.v \
			./dut/buffet_control.v \
			./dut/utils/dpram.v \
			./dut/utils/leadingZero.v \
			./dut/utils/priorityEncoder.v \
			./dut/utils/reverse.v \
			./buffet_defines.v \
		   }
set testbench_files { \
			./testbench/tb_buffet_update.v \
		   }

#set constraint_files {./zybo_z7_20_audio_test.xdc}

create_project -force $project_name $project_dir -part $project_target
add_files -norecurse $source_files
#add_files -fileset constrs_1 -norecurse $constraint_files
#import_ip -files $ipcore_files
update_compile_order -fileset sources_1
set_property top qbit [current_fileset]
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse $testbench_files
update_compile_order -fileset sim_1

set_property top qbit_sim [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

reset_project

set_property top tb_buffet_update [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property top_file ./testbench/tb_buffet_update.v [get_filesets sim_1]
update_compile_order -fileset sim_1

set_property include_dirs /home/miyo/src/buffets [current_fileset]

launch_simulation
run all

#launch_runs synth_1 -jobs 4
#wait_on_run synth_1

#launch_runs impl_1 -jobs 4
#wait_on_run impl_1
#
#open_run impl_1
#report_utilization -file [file join $project_dir "project.rpt"]
#report_timing -file [file join $project_dir "project.rpt"] -append
#
#launch_runs impl_1 -to_step write_bitstream -jobs 4
#wait_on_run impl_1
#
#close_project
#
#quit
