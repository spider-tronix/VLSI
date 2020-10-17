#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=C:/Xilinx/SDK/2018.2/bin;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/lib/nt64:C:/Xilinx/Vivado/2018.2/bin
else
  PATH=C:/Xilinx/SDK/2018.2/bin;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/lib/nt64:C:/Xilinx/Vivado/2018.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

<<<<<<< HEAD:RV32IM/RV32IM.runs/synth_1/runme.sh
HD_PWD='E:/Spider/VLSI/RV32IM/RV32IM.runs/synth_1'
=======
HD_PWD='F:/Spider/VLSIProjRISCV/Git/VLSI/RV32IM/RV32IM.runs/synth_2'
>>>>>>> ALU_Block:RV32IM/RV32IM.runs/synth_2/runme.sh
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

<<<<<<< HEAD:RV32IM/RV32IM.runs/synth_1/runme.sh
EAStep vivado -log controUnit_TestBench.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source controUnit_TestBench.tcl
=======
EAStep vivado -log ALU_Module.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source ALU_Module.tcl
>>>>>>> ALU_Block:RV32IM/RV32IM.runs/synth_2/runme.sh
