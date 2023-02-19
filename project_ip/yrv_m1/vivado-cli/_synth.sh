source /tools/Xilinx/Vivado/2021.2/settings64.sh

cd synth_dir
rm -f *
cp ../../tb_0/*.mem* .
vivado -mode batch -source ../synth.tcl -log synthesis.log -nojournal 
cd ..

