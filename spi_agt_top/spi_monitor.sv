class spi_monitor extends uvm_monitor;

	`uvm_component_utils(spi_monitor)

	uvm_analysis_port #(spi_xtn) monitor_port;

	virtual spi_if.SPI_MON_MP spi_vif;

	spi_config spi_cfg;

	bit [7:0] ctrl;
	bit cpol;
	bit cphase;
	bit lsbfe;

	extern function new (string name = "spi_monitor", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern task collect ();

endclass

function spi_monitor :: new (string name = "spi_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port = new ("monitor_port",this);
endfunction

function void spi_monitor :: build_phase (uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(spi_config) :: get (this, "","spi_config", spi_cfg))
		`uvm_error(get_full_name(), "Can't Get SPI Config DB");
	if(!uvm_config_db #(bit[7:0]) :: get (this, "", "bit", ctrl))
		`uvm_error(get_full_name(), "Can't Get CTRL");
endfunction

function void spi_monitor :: connect_phase (uvm_phase phase);
	spi_vif = spi_cfg.spi_vif;
	cpol = ctrl[3];
	cphase = ctrl[2];
	lsbfe = ctrl[0];
endfunction

task spi_monitor :: run_phase (uvm_phase phase);
	forever begin
		collect();
	end
endtask

task spi_monitor :: collect();
	spi_xtn xtn;
	xtn = spi_xtn :: type_id :: create ("xtn");

	@(spi_vif.spi_mon_cb)

	wait(!spi_vif.spi_mon_cb.ss);
	if(lsbfe) begin
		for(int i = 0; i < 8; i++) begin
			if( (!cpol) && (!cphase) || (cphase) && (cpol) ) begin
				@(posedge spi_vif.spi_mon_cb.sclk);
				xtn.mosi[i] = spi_vif.spi_mon_cb.mosi;
				xtn.miso[i] = spi_vif.spi_mon_cb.miso;
				xtn.ss = spi_vif.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_vif.spi_mon_cb.spi_inpt_req;
			end
			else begin
				@(negedge spi_vif.spi_mon_cb.sclk);
				xtn.mosi[i] = spi_vif.spi_mon_cb.mosi;
				xtn.miso[i] = spi_vif.spi_mon_cb.miso;
				xtn.ss = spi_vif.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_vif.spi_mon_cb.spi_inpt_req;
			end
		end
	end
	else begin
		for(int i = 7; i >= 0; i--) begin
			if( (!cpol) && (cphase) || (!cphase) && (cpol) ) begin
				@(posedge spi_vif.spi_mon_cb.sclk);
				xtn.mosi[i] = spi_vif.spi_mon_cb.mosi;
				xtn.miso[i] = spi_vif.spi_mon_cb.miso;
				xtn.ss = spi_vif.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_vif.spi_mon_cb.spi_inpt_req;
			end
			else begin
				@(negedge spi_vif.spi_mon_cb.sclk);
				xtn.mosi[i] = spi_vif.spi_mon_cb.mosi;
				xtn.miso[i] = spi_vif.spi_mon_cb.miso;
				xtn.ss = spi_vif.spi_mon_cb.ss;
				xtn.spi_inpt_req = spi_vif.spi_mon_cb.spi_inpt_req;
			end
		end
	end
	
	`uvm_info(get_type_name(), $sformatf("Transaction from DUT to SPI MON is \n %s",xtn.sprint()), UVM_LOW)	
	monitor_port.write(xtn);
endtask	
	
		
