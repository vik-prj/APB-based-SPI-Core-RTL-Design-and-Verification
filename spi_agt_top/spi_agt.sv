class spi_agt extends uvm_agent;
	
	`uvm_component_utils(spi_agt)
	
	spi_config spi_cfg;
	
	spi_driver spi_drv_h;
	spi_monitor spi_mon_h;
	spi_sequencer spi_seqr_h;
	
	extern function new (string name = "spi_agt", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);

endclass

function spi_agt :: new (string name = "spi_agt", uvm_component parent);
	super.new(name,parent);
endfunction

function void spi_agt :: build_phase (uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(spi_config) :: get (this, "", "spi_config", spi_cfg))
		`uvm_fatal(get_full_name(), "Can't Get SPI Config DB");
	spi_mon_h = spi_monitor :: type_id :: create("spi_mon_h",this);
	
	if(spi_cfg.is_active == UVM_ACTIVE) begin
		spi_drv_h = spi_driver :: type_id :: create("spi_drv_h",this);
		spi_seqr_h = spi_sequencer :: type_id :: create("spi_seqr_h",this);
	end

endfunction

function void spi_agt :: connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	if(spi_cfg.is_active == UVM_ACTIVE)
		spi_drv_h.seq_item_port.connect(spi_seqr_h.seq_item_export);
endfunction
