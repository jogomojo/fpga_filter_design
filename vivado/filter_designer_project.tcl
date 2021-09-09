# Vivado 2019.1

set origin_dir "."
set iprepo_dir $origin_dir/../sysgen/iprepo

create_project filter_designer $origin_dir/filter_designer -part xc7z020clg400-1
set_property board_part tul.com.tw:pynq-z2:part0:1.0 [current_project]

set_property  ip_repo_paths $iprepo_dir [current_project]
set_property target_language VHDL [current_project]
update_ip_catalog

source $origin_dir/filter_designer_bd.tcl
make_wrapper -files [get_files $origin_dir/filter_designer/filter_designer.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $origin_dir/filter_designer/filter_designer.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd

update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

file copy -force $origin_dir/filter_designer/filter_designer.runs/impl_1/design_1_wrapper.bit $origin_dir/../overlay/filter_designer.bit
file copy -force $origin_dir/filter_designer/filter_designer.srcs/sources_1/bd/design_1/hw_handoff/design_1.hwh $origin_dir/../overlay/filter_designer.hwh
