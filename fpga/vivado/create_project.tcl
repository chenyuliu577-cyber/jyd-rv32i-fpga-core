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

set rtl_include_dirs [list [file join $repo_root rtl/common]]
set_property include_dirs $rtl_include_dirs [current_fileset]
set_property include_dirs $rtl_include_dirs [get_filesets sim_1]
puts "Configured RTL include directories:"
foreach d $rtl_include_dirs {
  puts "  $d"
}

add_files -fileset constrs_1 -norecurse [file join $repo_root fpga/constraints/digital_twin.xdc]

set ip_files [list \
  fpga/ip/IROM/IROM.xci \
  fpga/ip/DRAM/DRAM.xci \
  fpga/ip-optional/pll_1/pll.xci \
]

foreach f $ip_files {
  import_ip -files [file join $repo_root $f]
}

set private_irom_coe [file join $repo_root mem/irom.coe]
set private_dram_coe [file join $repo_root mem/dram.coe]
set public_irom_coe [file join $repo_root tests/public-memory/irom.coe]
set public_dram_coe [file join $repo_root tests/public-memory/dram.coe]
set branch_irom_coe [file join $repo_root tests/branch-memory/irom.coe]
set branch_dram_coe [file join $repo_root tests/branch-memory/dram.coe]
set load_store_irom_coe [file join $repo_root tests/load-store-memory/irom.coe]
set load_store_dram_coe [file join $repo_root tests/load-store-memory/dram.coe]
set selected_irom_coe ""
set selected_dram_coe ""
set memory_profile "smoke"

if {[info exists ::env(JYD_MEMORY_PROFILE)]} {
  set memory_profile [string tolower $::env(JYD_MEMORY_PROFILE)]
}

if {[file exists $private_irom_coe] && [file exists $private_dram_coe]} {
  puts "Using private memory images from mem/"
  set selected_irom_coe $private_irom_coe
  set selected_dram_coe $private_dram_coe
} elseif {$memory_profile eq "branch"} {
  if {[file exists $branch_irom_coe] && [file exists $branch_dram_coe]} {
    puts "Using branch directed memory images from tests/branch-memory/ because JYD_MEMORY_PROFILE=branch"
    set selected_irom_coe $branch_irom_coe
    set selected_dram_coe $branch_dram_coe
  } else {
    puts "WARNING: JYD_MEMORY_PROFILE=branch was requested, but tests/branch-memory/irom.coe and/or tests/branch-memory/dram.coe are not present."
    puts "WARNING: Vivado project can be created, but simulation may not run meaningful branch-directed CPU code."
  }
} elseif {$memory_profile eq "load-store"} {
  if {[file exists $load_store_irom_coe] && [file exists $load_store_dram_coe]} {
    puts "Using load/store directed memory images from tests/load-store-memory/ because JYD_MEMORY_PROFILE=load-store"
    set selected_irom_coe $load_store_irom_coe
    set selected_dram_coe $load_store_dram_coe
  } else {
    puts "WARNING: JYD_MEMORY_PROFILE=load-store was requested, but tests/load-store-memory/irom.coe and/or tests/load-store-memory/dram.coe are not present."
    puts "WARNING: Vivado project can be created, but simulation may not run meaningful load/store-directed CPU code."
  }
} elseif {[file exists $public_irom_coe] && [file exists $public_dram_coe]} {
  puts "Using public smoke memory images from tests/public-memory/"
  set selected_irom_coe $public_irom_coe
  set selected_dram_coe $public_dram_coe
} elseif {$memory_profile ne "smoke"} {
  puts "WARNING: Unknown JYD_MEMORY_PROFILE=$memory_profile. Supported profiles: smoke, branch, load-store."
  puts "WARNING: No matching memory initialization files found. Vivado project can be created, but simulation may not run meaningful CPU code."
} else {
  puts "WARNING: No memory initialization files found. Vivado project can be created, but simulation may not run meaningful CPU code."
}

if {$selected_irom_coe ne "" && $selected_dram_coe ne ""} {
  foreach {ip_name coe_file} [list IROM $selected_irom_coe DRAM $selected_dram_coe] {
    set ip_obj [get_ips $ip_name]
    if {[llength $ip_obj] == 0} {
      puts "WARNING: IP $ip_name was not found; cannot bind memory file."
      continue
    }

    set ip_props [list_property $ip_obj]
    if {[lsearch -exact $ip_props CONFIG.coefficient_file] >= 0} {
      set_property CONFIG.coefficient_file [file normalize $coe_file] $ip_obj
      puts "NOTE: Bound $ip_name CONFIG.coefficient_file to [file normalize $coe_file]"
    } else {
      puts "WARNING: IP $ip_name does not expose CONFIG.coefficient_file."
      puts "WARNING: Available file/init related properties for $ip_name:"
      foreach prop $ip_props {
        set prop_lc [string tolower $prop]
        if {[string match *file* $prop_lc] || [string match *init* $prop_lc] || [string match *coeff* $prop_lc]} {
          puts "  $prop = [get_property $prop $ip_obj]"
        }
      }
    }
  }
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
# `pll`, `IROM`, and `DRAM`, but does not instantiate `counter_0` or
# `counter_1`. The default flow imports fpga/ip-optional/pll_1/pll.xci as the
# single `pll` IP because it provides both clk_out1 and clk_out2, matching
# rtl/soc/top.sv. Do not also import fpga/ip/pll/pll.xci by default because that
# one-output PLL conflicts with the top-level port list.
#
# The `counter_*` XCI files reference a custom IP definition named `counter
# (1.0)` that is not present in the standard catalog.
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
# The script prefers private mem/irom.coe and mem/dram.coe when present. If
# they are absent, it uses the repository-owned public smoke memory images under
# tests/public-memory/ by default. Set JYD_MEMORY_PROFILE=branch to explicitly
# use tests/branch-memory/, or JYD_MEMORY_PROFILE=load-store to explicitly use
# tests/load-store-memory/. After project reconstruction, confirm the selected
# IP properties in Vivado before publishing verification claims.
#
# TODO: If the XCI files cannot regenerate cleanly in a fresh Vivado install,
# replace them with explicit Tcl IP creation commands and documented parameters.

puts "Created Vivado project at $build_dir"
puts "Top module: top"
puts "Simulation top: tb_top"
puts "Imported default IP: IROM, DRAM, pll"
puts "Default PLL source: fpga/ip-optional/pll_1/pll.xci"
