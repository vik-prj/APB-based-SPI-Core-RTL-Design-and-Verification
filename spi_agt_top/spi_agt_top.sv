class spi_agt_top extends uvm_env;
	
	`uvm_component_utils(spi_agt_top)

	spi_agt spi_agt_h;
	
	extern function new (string name = "spi_agt_top", uvm_component parent);
	extern function void build_phase (uvm_phase phase);

endclass

function spi_agt_top :: new (string name = "spi_agt_top", uvm_component parent);
	super.new(name,parent);
endfunction

function void spi_agt_top :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	spi_agt_h = spi_agt :: type_id :: create ("spi_agt_h",this);
endfunction

