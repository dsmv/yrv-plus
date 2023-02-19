xvlog -sv --incr --relax  -f systemverilog.txt              -d BOOT_FROM_AUX_UART -d CLK_FREQUENCY=50000000 -d RESET_BASE_AND_INT_VECTORS_FOR_RARS
xvlog     --incr --relax  -f verilog.txt  -i ../src/src/yrv -d BOOT_FROM_AUX_UART -d CLK_FREQUENCY=50000000 -d RESET_BASE_AND_INT_VECTORS_FOR_RARS
#xvhdl --incr --relax -f vhdl.txt
