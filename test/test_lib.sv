class base_test extends uvm_test;
	
	`uvm_component_utils(base_test)

	env env_h;
	config_db m_cfg;
	apb_config apb_cfg;
	spi_config spi_cfg;

	bit reset_test;
	bit [1:0] low_pwr_case;
	

	bit [7:0] ctrl;
	bit has_apb_agent = 1;
	bit has_spi_agent = 1;
	extern function new (string name = "base_test", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void end_of_elaboration_phase (uvm_phase phase);
	extern function void config_env();

endclass

function base_test :: new (string name = "base_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void base_test :: config_env;
	if(has_apb_agent) begin
		apb_cfg = apb_config :: type_id :: create ("apb_cfg");
		if(!uvm_config_db #(virtual apb_if) :: get (this, "", "apb_if", apb_cfg.apb_vif))
			`uvm_error (get_full_name(), "Can't Get APB VIF");
		m_cfg.apb_cfg = apb_cfg;
	end
	
	if(has_spi_agent) begin
		spi_cfg = spi_config :: type_id :: create ("spi_cfg");
		if (!uvm_config_db #(virtual spi_if) :: get (this, "", "spi_if", spi_cfg.spi_vif))
			`uvm_error (get_full_name(), "Can't Get SPI VIF");
		m_cfg.spi_cfg = spi_cfg;
	end
	m_cfg.has_apb_agent = has_apb_agent;
	m_cfg.has_spi_agent = has_spi_agent;
	m_cfg.is_active = UVM_ACTIVE;
	apb_cfg.is_active = m_cfg.is_active;
	spi_cfg.is_active = m_cfg.is_active;
endfunction
	

function void base_test :: build_phase (uvm_phase phase);
	super.build_phase(phase);
	env_h = env :: type_id :: create ("env_h",this);
	m_cfg = config_db :: type_id :: create ("m_cfg",this);

	config_env();	

	uvm_config_db #(config_db) :: set(this,"*","config_db",m_cfg);

endfunction

function void base_test :: end_of_elaboration_phase (uvm_phase phase);
	uvm_top.print_topology();
endfunction




//Class for apb_reset_seq test
class apb_reset_seq_test extends base_test;
	`uvm_component_utils(apb_reset_seq_test)

	apb_v_reset_seq av_reset_seq_h;

	extern function new(string name = "apb_reset_seq_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass 

	//Default Constructor
function apb_reset_seq_test :: new(string name = "apb_reset_seq_test",uvm_component parent);
	super.new(name,parent);
endfunction : new

	
	//Build phase
function void apb_reset_seq_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	reset_test = 1'b1;
	ctrl = 8'b1111_1111;

	uvm_config_db#(bit)::set(this,"*","bit_reset",reset_test);
	uvm_config_db #(bit[7:0])::set(this,"*","bit",ctrl);
endfunction : build_phase


	//Run phase
task apb_reset_seq_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	begin
		
		av_reset_seq_h = apb_v_reset_seq::type_id::create("av_reset_seq_h");
		av_reset_seq_h.start(env_h.v_seqr);
	end
	phase.drop_objection(this);
endtask : run_phase




//cpol=1, cphase=1, lsbfe=1;
class cpol1_cpha1_lsb1 extends base_test;
	`uvm_component_utils(cpol1_cpha1_lsb1)
	cpol1_cpha1_lsb1_vseq cpol1_cpha1_lsb1_vseq_h;
	

	function new(string name ="cpol1_cpha1_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111111;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha1_lsb1_vseq_h = cpol1_cpha1_lsb1_vseq :: type_id :: create("cpol1_cpha1_lsb1_vseq_h");
		cpol1_cpha1_lsb1_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass




//cpol=1, cpahse=0, lsbfe=1;
class cpol1_cpha0_lsb1 extends base_test;
	`uvm_component_utils(cpol1_cpha0_lsb1)
	cpol1_cpha0_lsb1_vseq cpol1_cpha0_lsb1_vseq_h;
	

	function new(string name ="cpol1_cpha0_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111011;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha0_lsb1_vseq_h = cpol1_cpha0_lsb1_vseq :: type_id :: create("cpol1_cpha0_lsb1_vseq_h");
		cpol1_cpha0_lsb1_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
		endtask
endclass	



//cpol=0, cpahse=1, lsbfe=1;
class cpol0_cpha1_lsb1 extends base_test;
	`uvm_component_utils(cpol0_cpha1_lsb1)
	cpol0_cpha1_lsb1_vseq cpol0_cpha1_lsb1_vseq_h;
	

	function new(string name ="cpol0_cpha1_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110111;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha1_lsb1_vseq_h = cpol0_cpha1_lsb1_vseq :: type_id :: create("cpol0_cpha1_lsb1_vseq_h");
		cpol0_cpha1_lsb1_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass	
	

	

//cpol=0, cpahse=0, lsbfe=1;
class cpol0_cpha0_lsb1 extends base_test;
	`uvm_component_utils(cpol0_cpha0_lsb1)
	cpol0_cpha0_lsb1_vseq cpol0_cpha0_lsb1_vseq_h;
	

	function new(string name ="cpol0_cpha0_lsb1", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110011;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha0_lsb1_vseq_h = cpol0_cpha0_lsb1_vseq :: type_id :: create("cpol0_cpha0_lsb1_vseq_h");
		cpol0_cpha0_lsb1_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass	
	
	


//cpol=1, cphase=1, lsbfe=0;
class cpol1_cpha1_lsb0 extends base_test;
	`uvm_component_utils(cpol1_cpha1_lsb0)
	cpol1_cpha1_lsb0_vseq cpol1_cpha1_lsb0_vseq_h;
	

	function new(string name ="cpol1_cpha1_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111110;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha1_lsb0_vseq_h = cpol1_cpha1_lsb0_vseq :: type_id :: create("cpol1_cpha1_lsb0_vseq_h");
		cpol1_cpha1_lsb0_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass




//cpol=1, cpahse=0, lsbfe=0;
class cpol1_cpha0_lsb0 extends base_test;
	`uvm_component_utils(cpol1_cpha0_lsb0)
	cpol1_cpha0_lsb0_vseq cpol1_cpha0_lsb0_vseq_h;
	

	function new(string name ="cpol1_cpha0_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11111010;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol1_cpha0_lsb0_vseq_h = cpol1_cpha0_lsb0_vseq :: type_id :: create("cpol1_cpha0_lsb0_vseq_h");
		cpol1_cpha0_lsb0_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass	




//cpol=0, cpahse=1, lsbfe=0;
class cpol0_cpha1_lsb0 extends base_test;
	`uvm_component_utils(cpol0_cpha1_lsb0)
	cpol0_cpha1_lsb0_vseq cpol0_cpha1_lsb0_vseq_h;
	

	function new(string name ="cpol0_cpha1_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110110;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha1_lsb0_vseq_h = cpol0_cpha1_lsb0_vseq :: type_id :: create("cpol0_cpha1_lsb0_vseq_h");
		cpol0_cpha1_lsb0_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass	
	
	


//cpol=0, cpahse=0, lsbfe=0;
class cpol0_cpha0_lsb0 extends base_test;
	`uvm_component_utils(cpol0_cpha0_lsb0)
	cpol0_cpha0_lsb0_vseq cpol0_cpha0_lsb0_vseq_h;
	

	function new(string name ="cpol0_cpha0_lsb0", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b11110010;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		cpol0_cpha0_lsb0_vseq_h = cpol0_cpha0_lsb0_vseq :: type_id :: create("cpol0_cpha0_lsb0_vseq_h");
		cpol0_cpha0_lsb0_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass		
	



//low power mode seq
class low_power_mode extends base_test;
	`uvm_component_utils(low_power_mode)
	low_power_mode_vseq low_power_mode_vseq_h;
	

	function new(string name ="low_power_mode_vseq_h", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ctrl = 8'b10110010;
		low_pwr_case = 2'b01;
		uvm_config_db #(bit[7:0]) :: set(this,"*","bit",ctrl);
		uvm_config_db #(bit[1:0]) :: set(this,"*","bit[1:0]",low_pwr_case);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		low_power_mode_vseq_h = low_power_mode_vseq :: type_id :: create("low_power_mode_vseq_h");
		low_power_mode_vseq_h.start(env_h.v_seqr);
		phase.drop_objection(this);
	endtask
endclass		
	

