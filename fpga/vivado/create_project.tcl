# Recreate the Vivado project from this repository.
# Usage from Vivado Tcl shell:
#   cd <repo-root>
#   source fpga/vivado/create_project.tcl

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ../..]]
set build_dir  [file join $repo_root build/vivado]

file mkdir $build_dir
create_project jyd_rv32i_fpga_core $build_dir -part xc7k325tffg900-2 -force

set rtl_files [list \
  rtl/common/MuxKey.v \
  rtl/common/MuxKeyInternal.v \
  rtl/common/Reg.sv \
  rtl/common/Reg_Stack.sv \
  rtl/common/RegisterFile.sv \
  rtl/common/add.sv \
  rtl/common/para.sv \
  rtl/common/sext.sv \
  rtl/core/ALU.sv \
  rtl/core/CSR.sv \
  rtl/core/Control.sv \
  rtl/core/myCPU.sv \
  rtl/pipeline/Branch_Predictor.sv \
  rtl/pipeline/Data_hazard.sv \
  rtl/pipeline/EXU.sv \
  rtl/pipeline/EX_LSWB_Reg.sv \
  rtl/pipeline/IDU.sv \
  rtl/pipeline/IFU.sv \
  rtl/pipeline/IFID_EX_Reg.sv \
  rtl/pipeline/IF_ID_Reg.sv \
  rtl/pipeline/LSU.sv \
  rtl/pipeline/MEM_WB_Reg.sv \
  rtl/pipeline/WBU.sv \
  rtl/soc/dram_driver.sv \
  rtl/soc/perip_bridge.sv \
  rtl/soc/student_top.sv \
  rtl/soc/top.sv \
  rtl/peripherals/counter.sv \
  rtl/peripherals/display_seg.sv \
  rtl/peripherals/seg7.sv \
  rtl/peripherals/twin_controller.sv \
  rtl/peripherals/uart.sv \
]

foreach f $rtl_files {
  add_files -norecurse [file join $repo_root $f]
}

set tb_files [list \
  tb/tb_myCPU.sv \
  tb/tb_top.sv \
  tb/tb_uart.sv \
]

foreach f $tb_files {
  add_files -fileset sim_1 -norecurse [file join $repo_root $f]
}

add_files -fileset constrs_1 -norecurse [file join $repo_root fpga/constraints/digital_twin.xdc]

set ip_files [list \
  fpga/ip/IROM/IROM.xci \
  fpga/ip/DRAM/DRAM.xci \
  fpga/ip/pll/pll.xci \
  fpga/ip/pll_1/pll.xci \
  fpga/ip/counter_0/counter_0.xci \
  fpga/ip/counter_1/counter_1.xci \
]

foreach f $ip_files {
  add_files -norecurse [file join $repo_root $f]
}

set_property top top [current_fileset]
set_property top tb_top [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Memory initialization note:
# This repository intentionally does not include IROM.mif, DRAM.mif, irom.coe,
# or dram.coe because their redistribution rights must be confirmed first.
# Place your own files under mem/ and update the IROM/DRAM IP configuration in
# Vivado if the imported XCI files still reference missing initialization data.
#
# TODO: If the XCI files cannot regenerate cleanly in a fresh Vivado install,
# replace them with explicit Tcl IP creation commands and documented parameters.

puts "Created Vivado project at $build_dir"
puts "Top module: top"
puts "Simulation top: tb_top"

