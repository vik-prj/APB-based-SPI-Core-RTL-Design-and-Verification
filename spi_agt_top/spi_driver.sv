class spi_driver extends uvm_driver #(spi_xtn);

	`uvm_component_utils(spi_driver)
	
	virtual spi_if.SPI_DRV_MP spi_vif;

	spi_config spi_cfg;
	
	bit [7:0] ctrl;
	bit cpol;
	bit cphase;
	bit lsbfe;
	
	extern function new (string name = "spi_driver", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern task send_to_dut (spi_xtn xtn);

endclass

function spi_driver :: new (string name = "spi_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void spi_driver :: build_phase (uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(spi_config) :: get (this, "", "spi_config", spi_cfg))
		`uvm_error(get_full_name(),"Can't Get SPI Config DB");
	if(!uvm_config_db #(bit[7:0]) :: get (this, "", "bit", ctrl))
		`uvm_error(get_full_name(),"Can't Get CTRL");
endfunction

function void spi_driver :: connect_phase (uvm_phase phase);
	spi_vif = spi_cfg.spi_vif;
	cpol = ctrl[3];
	cphase = ctrl[2];
	lsbfe = ctrl[0];
endfunction

task spi_driver :: run_phase(uvm_phase phase);
	forever begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

task spi_driver :: send_to_dut (spi_xtn xtn);
	@(spi_vif.spi_drv_cb);
	wait(!spi_vif.spi_drv_cb.ss)

	if(lsbfe) begin
		if( (!cpol)&&(!cphase) ) begin
			for(int i = 1; i < 8; i++) begin
				@(negedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if ( (!cpol)&&(cphase) ) begin
			for(int i = 1; i < 8; i++) begin
				@(posedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if ( (cpol)&&(!cphase) ) begin
			for(int i = 1; i < 8; i++) begin
				@(posedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if ( (cpol)&&(cphase) ) begin
			for(int i = 1; i < 8; i++) begin
				@(negedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
	end

	else begin
		if( (!cpol)&&(!cphase) ) begin
			for(int i = 7; i >= 0; i--) begin
				@(negedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if ( (!cpol)&&(cphase) ) begin
			for(int i = 7; i >= 0; i--) begin
				@(posedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if ( (cpol)&&(!cphase) ) begin
			for(int i = 7; i >= 0; i--) begin
				@(posedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
		else if ( (cpol)&&(cphase) ) begin
			for(int i = 7; i >= 0; i--) begin
				@(negedge spi_vif.spi_drv_cb.sclk) spi_vif.spi_drv_cb.miso <= xtn.miso[i];
			end
		end
	end
endtask
		
		
	
	

