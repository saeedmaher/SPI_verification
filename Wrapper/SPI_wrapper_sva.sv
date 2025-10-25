module SPI_wrapper_sva (MOSI,MISO,SS_n,clk,rst_n);

	input bit MOSI,MISO,SS_n,clk,rst_n;

	property reset_check;
		@(posedge clk) (!rst_n) |=> (!MISO);
	endproperty

	property MISO_stable_check;
		@(posedge clk) disable iff (!rst_n) $fell(SS_n) |=> (SS_n == 1'b0 && $stable(MISO)) [*11];
	endproperty

	assert property (reset_check);
	assert property (MISO_stable_check);

	cover property (reset_check);
	cover property (MISO_stable_check);

endmodule : SPI_wrapper_sva