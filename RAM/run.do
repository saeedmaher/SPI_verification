vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.RAM_top -classdebug -uvmcontrol=all  -cover 
add wave /RAM_top/RAM_if/*
coverage exclude -src RAM.v -line 27 
coverage save RAMTB.ucdb -onexit 
run -all
vcover report RAMTB.ucdb -details -annotate -all -output coverage_rpt_RAM.txt