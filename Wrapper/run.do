vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover -sv_seed random
add wave /top/wrapper_if/*
add wave /top/spi_if/*
add wave /top/ram_if/*
coverage exclude -src RAM.v -line 27
coverage exclude -src SPI_slave.sv -line 37
coverage exclude -src SPI_slave.sv -line 38
coverage exclude -src SPI_slave.sv -line 69
coverage exclude -src SPI_slave.sv -line 129
coverage save top.ucdb -onexit -du WRAPPER
run -all
vcover report top.ucdb -details -annotate -all -output coverage_rpt.txt
coverage report -detail -cvg -directive -comments -output {fcover_report.txt} {}