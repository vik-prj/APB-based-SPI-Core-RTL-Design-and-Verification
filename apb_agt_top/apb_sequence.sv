class apb_sequence extends uvm_sequence #(apb_xtn);
	`uvm_object_utils(apb_sequence)
	
	config_db m_cfg;

	uvm_status_e status;	

	function new (string name = "apb_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(config_db) :: get (null, get_full_name(),"config_db", m_cfg))
			`uvm_error(get_full_name(),"Can't Get Config DB");
	endtask
endclass


// Sequence Class for RESET
class apb_reset_seq extends apb_sequence;
	`uvm_object_utils(apb_reset_seq)

	extern function new (string name = "apb_seq_reset");
	extern task body();
endclass

function apb_reset_seq :: new (string name = "apb_seq_reset");
	super.new (name);
endfunction

task apb_reset_seq :: body();
	super.body();
	repeat(1) begin
		req = apb_xtn :: type_id :: create("req");

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b0;}); //CR1
		finish_item(req);

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b001;}); //CR2
		finish_item(req);

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b010;}); //BR
		finish_item(req);

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b011;}); //DR
		finish_item(req);

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b101;}); //SR
		finish_item(req);
	end
endtask



// lsb 1
//Sequence Class for cpol 1 & cpha 1
class apb_cpol1_cpha1_lsb1 extends apb_sequence;
	`uvm_object_utils(apb_cpol1_cpha1_lsb1)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol1_cpha1_lsb1");
	extern task body();
endclass

function apb_cpol1_cpha1_lsb1 :: new (string name = "apb_cpol1_cpha1_lsb1");
	super.new(name);
endfunction

task apb_cpol1_cpha1_lsb1 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b000; PWDATA == ctrl;});
		finish_item(req);
	
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b001; PWDATA == data2;});
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b010; PWDATA == data3;});
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask




//Sequence Class for cpol 1 & cpha 1
class apb_cpol1_cpha0_lsb1 extends apb_sequence;
	`uvm_object_utils(apb_cpol1_cpha0_lsb1)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol1_cpha0_lsb1");
	extern task body();
endclass

function apb_cpol1_cpha0_lsb1 :: new (string name = "apb_cpol1_cpha0_lsb1");
	super.new(name);
endfunction

task apb_cpol1_cpha0_lsb1 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b0; PWDATA == data1;}); //CR1
		finish_item(req);

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b001; PWDATA == data2;}); //CR2
		finish_item(req);

		start_item(req);
		assert(req.randomize with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b010; PWDATA == data3;}); //BR
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask




//Sequence Class for cpol 0 & cpha 1
class apb_cpol0_cpha1_lsb1 extends apb_sequence;
	`uvm_object_utils(apb_cpol0_cpha1_lsb1)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol0_cpha1_lsb1");
	extern task body();
endclass

function apb_cpol0_cpha1_lsb1 :: new (string name = "apb_cpol0_cpha1_lsb1");
	super.new(name);
endfunction

task apb_cpol0_cpha1_lsb1 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
		finish_item(req);
	
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask




//Sequence Class for cpol 0 & cpha 0
class apb_cpol0_cpha0_lsb1 extends apb_sequence;
	`uvm_object_utils(apb_cpol0_cpha0_lsb1)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol0_cpha0_lsb1");
	extern task body();
endclass

function apb_cpol0_cpha0_lsb1 :: new (string name = "apb_cpol0_cpha0_lsb1");
	super.new(name);
endfunction

task apb_cpol0_cpha0_lsb1 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
		finish_item(req);
	
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask



//lsb 0
//Sequence Class for cpol 1 & cpha 1
class apb_cpol1_cpha1_lsb0 extends apb_sequence;
	`uvm_object_utils(apb_cpol1_cpha1_lsb0)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol1_cpha1_lsb0");
	extern task body();
endclass

function apb_cpol1_cpha1_lsb0 :: new (string name = "apb_cpol1_cpha1_lsb0");
	super.new(name);
endfunction

task apb_cpol1_cpha1_lsb0 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
		finish_item(req);
	
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask




//Sequence Class for cpol 1 & cpha 1
class apb_cpol1_cpha0_lsb0 extends apb_sequence;
	`uvm_object_utils(apb_cpol1_cpha0_lsb0)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol1_cpha0_lsb0");
	extern task body();
endclass

function apb_cpol1_cpha0_lsb0 :: new (string name = "apb_cpol1_cpha0_lsb0");
	super.new(name);
endfunction

task apb_cpol1_cpha0_lsb0 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
		finish_item(req);
	
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask




//Sequence Class for cpol 0 & cpha 1
class apb_cpol0_cpha1_lsb0 extends apb_sequence;
	`uvm_object_utils(apb_cpol0_cpha1_lsb0)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol0_cpha1_lsb0");
	extern task body();
endclass

function apb_cpol0_cpha1_lsb0 :: new (string name = "apb_cpol0_cpha1_lsb0");
	super.new(name);
endfunction

task apb_cpol0_cpha1_lsb0 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
		finish_item(req);
	
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask




//Sequence Class for cpol 0 & cpha 0
class apb_cpol0_cpha0_lsb0 extends apb_sequence;
	`uvm_object_utils(apb_cpol0_cpha0_lsb0)
	
	bit[7:0] ctrl;
	bit[7:0] data1;
	bit[7:0] data2;
	bit[7:0] data3;
	
	extern function new (string name = "apb_cpol0_cpha0_lsb0");
	extern task body();
endclass

function apb_cpol0_cpha0_lsb0 :: new (string name = "apb_cpol0_cpha0_lsb0");
	super.new(name);
endfunction

task apb_cpol0_cpha0_lsb0 :: body();
	super.body();
	if(!uvm_config_db #(bit [7:0]) :: get (null, get_full_name(), "bit", ctrl))
		`uvm_fatal(get_full_name(), "Can't Get CTRL");
	repeat(1) begin
		req = apb_xtn :: type_id :: create ("req");
		data1 = ctrl;
		data2 = 8'b0001_1000;
		data3 = 8'b0001_0001;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
		finish_item(req);
	end
endtask



//low power mode
class low_power_mode_seq extends apb_sequence;
	`uvm_object_utils(low_power_mode_seq)
	bit [7:0] ctrl;
	bit [7:0] data1,data2,data3;
	
	function new(string name ="low_power_mode_seq");
		super.new(name);
	endfunction

	task body();	
		super.body();
		uvm_config_db #(bit[7:0]) :: get(null,get_full_name(),"bit",ctrl);
		repeat(1) begin
			$display("low_power_mode_seq");
			req = apb_xtn :: type_id :: create("req");
			data1 = ctrl;
			data2 = 8'b00011010;//modfault and bidirectional bits are enabled
			data3 = 8'b00010001;//for BR register
			start_item(req);
			assert(req.randomize() with{PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //performs dummy read operation for any registers except data register
			finish_item(req);
	
			start_item(req);
			assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		end
	endtask
endclass
