vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.SPI_slave_top -classdebug -uvmcontrol=all  -cover 
add wave /SPI_slave_top/slave_if/*
coverage save SLAVETB.ucdb -onexit 
run -all
vcover report SLAVETB.ucdb -details -annotate -all -output coverage_rpt_slave.txt