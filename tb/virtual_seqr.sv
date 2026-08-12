class virtual_seqr extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(virtual_seqr)

	apb_sequencer apb_seqr_h;
	spi_sequencer spi_seqr_h;

	extern function new (string name = "virtual_seqr", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass


function virtual_seqr :: new (string name = "virtual_seqr", uvm_component parent);
	super.new(name,parent);
endfunction


function void virtual_seqr :: build_phase(uvm_phase phase);
	super.build_phase(phase);
//	apb_seqr_h = apb_sequencer :: type_id :: create ("apb_seqr_h",this);
//	spi_seqr_h = spi_sequencer :: type_id :: create ("spi_seqr_h",this);
endfunction
