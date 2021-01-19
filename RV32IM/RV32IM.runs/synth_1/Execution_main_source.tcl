# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tftg256-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/project_3/project_3.cache/wt [current_project]
set_property parent.project_path D:/project_3/project_3.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part allaboutfpga.com:edgea7:part0:1.1 [current_project]
set_property ip_output_repo d:/project_3/project_3.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/defines.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/ALU_control_unit.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/ALU_module.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/BranchControl.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/ControlUnit.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/MMU.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/RAM_Module.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/ROM_Module.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/RV32Core.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/RamMemory.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/Registers_Module.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/Stage_EX.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/Stage_ID.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/Stage_IF.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/Stage_MEM.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/input_shifter.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/output_shifter.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/reg_EX_MEM.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/reg_ID_EX.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/reg_IF_ID.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/reg_MEM_WB.v
  D:/VLSI/RV32IM/RV32IM.srcs/sources_1/imports/new/reg_PC.v
  D:/project_3/project_3.srcs/sources_1/new/Execution_main_source.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/VLSI/RV32IM/RV32IM.srcs/constrs_1/new/IO_Constraints.xdc
set_property used_in_implementation false [get_files D:/VLSI/RV32IM/RV32IM.srcs/constrs_1/new/IO_Constraints.xdc]

read_xdc D:/VLSI/RV32IM/RV32IM.srcs/constrs_1/new/timing.xdc
set_property used_in_implementation false [get_files D:/VLSI/RV32IM/RV32IM.srcs/constrs_1/new/timing.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top Execution_main_source -part xc7a35tftg256-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Execution_main_source.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Execution_main_source_utilization_synth.rpt -pb Execution_main_source_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
