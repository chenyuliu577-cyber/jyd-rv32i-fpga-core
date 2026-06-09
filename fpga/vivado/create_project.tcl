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
]

foreach f $ip_files {
  import_ip -files [file join $repo_root $f]
}

set local_irom_coe [file join $repo_root mem/irom.coe]
set local_dram_coe [file join $repo_root mem/dram.coe]

if {[file exists $local_irom_coe] && [file exists $local_dram_coe]} {
  puts "NOTE: Local private memory initialization files were found under mem/."
  puts "NOTE: Expected files: mem/irom.coe and mem/dram.coe."
  puts "NOTE: Confirm the imported IROM/DRAM IP configuration points to these files before simulation or bitstream generation."
} else {
  puts "NOTE: mem/irom.coe and/or mem/dram.coe are not present."
  puts "NOTE: This is the expected public-repository state; private memory initialization files are not redistributed."
}

foreach f [list mem/IROM.mif mem/DRAM.mif] {
  if {[file exists [file join $repo_root $f]]} {
    puts "NOTE: Local MIF file is present for private verification: $f"
  }
}

# The repository also preserves the following XCI files for audit purposes:
#   fpga/ip-optional/pll_1/pll.xci
#   fpga/ip-optional/counter_0/counter_0.xci
#   fpga/ip-optional/counter_1/counter_1.xci
#
# They are not imported by default because the copied RTL currently instantiates
# `pll`, `IROM`, and `DRAM`, but does not instantiate `pll_1`, `counter_0`, or
# `counter_1`. In Vivado 2023.2, importing `pll_1/pll.xci` conflicts with the
# existing IP name `pll`, and the `counter_*` XCI files reference a custom IP
# definition named `counter (1.0)` that is not present in the standard catalog.
# If those IPs are later confirmed necessary, add their IP repositories or
# replace them with explicit Tcl generation steps.

set_property top top [current_fileset]
set_property top tb_top [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Memory initialization note:
# This repository intentionally does not include mem/IROM.mif, mem/DRAM.mif,
# mem/irom.coe, or mem/dram.coe because their redistribution rights must be
# confirmed first. Place private files under mem/ only; do not use
# fpga/imports/test_src/ for this cleanup.
#
# The current script checks for mem/irom.coe and mem/dram.coe, but does not
# claim to rewrite the imported IROM/DRAM IP initialization properties
# automatically. After project reconstruction, manually confirm the IP
# initialization paths in Vivado before simulation or bitstream generation.
#
# TODO: If the XCI files cannot regenerate cleanly in a fresh Vivado install,
# replace them with explicit Tcl IP creation commands and documented parameters.

puts "Created Vivado project at $build_dir"
puts "Top module: top"
puts "Simulation top: tb_top"
puts "Imported default IP: IROM, DRAM, pll"
