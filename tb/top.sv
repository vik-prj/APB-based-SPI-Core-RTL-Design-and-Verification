module top;
	
	import uvm_pkg ::*;
	import spi_apb_pkg ::*;
	bit clock;

	always #5 clock = ~clock;
	
	apb_if apb_if0(clock);
	spi_if spi_if0(clock);
	
	spi_core CORE(.PCLK(apb_if0.PCLK),.PRESETn(apb_if0.PRESETn),.PADDR(apb_if0.PADDR),.PWRITE(apb_if0.PWRITE),.PSEL(apb_if0.PSEL),.PENABLE(apb_if0.PENABLE),.PWDATA(apb_if0.PWDATA),.PRDATA(apb_if0.PRDATA),.PREADY(apb_if0.PREADY),.PSLVERR(apb_if0.PSLVERR),.miso(spi_if0.miso),.ss(spi_if0.ss),.sclk(spi_if0.sclk),.spi_interrupt_request(spi_if0.spi_inpt_req),.mosi(spi_if0.mosi));

	
	initial begin
		uvm_config_db #(virtual apb_if) :: set (null,"*","apb_if",apb_if0);
		uvm_config_db #(virtual spi_if) :: set (null,"*","spi_if",spi_if0);
		
		run_test();
	end

endmodule
	
