class spi_sequence extends uvm_sequence #(spi_xtn);
	`uvm_object_utils(spi_sequence)
	
	config_db m_cfg;

	function new (string name = "spi_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(config_db) :: get (null, get_full_name(), "config_db", m_cfg))
			`uvm_error(get_type_name(), "Can't Get Config DB");
	endtask

endclass


//RESET SEQ
class spi_seq1 extends spi_sequence;
	`uvm_object_utils(spi_seq1)

	extern function new (string name = "spi_seq1");
	extern task body();

endclass
	
function spi_seq1:: new (string name = "spi_seq1");
	super.new(name);
endfunction

task spi_seq1 :: body();
	super.body();
	repeat(1) begin
		req = spi_xtn :: type_id :: create ("req");
		start_item(req);
		assert(req.randomize);
		finish_item(req);
	end
endtask


			
