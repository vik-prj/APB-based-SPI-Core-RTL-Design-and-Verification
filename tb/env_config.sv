class config_db extends uvm_object;
	
	`uvm_object_utils(config_db)

	bit has_apb_agent = 1;
	bit has_spi_agent = 1;
	bit has_scoreboard = 1;
	bit has_virtual_sequencer = 1;
	
	apb_config apb_cfg;
	spi_config spi_cfg;
	
	uvm_active_passive_enum is_active;
	
	function new (string name = "config_db");
		super.new(name);
	endfunction

endclass
