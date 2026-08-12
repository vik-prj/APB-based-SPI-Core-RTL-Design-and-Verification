class apb_agt extends uvm_agent;
	`uvm_component_utils(apb_agt)
		
	apb_config apb_cfg;
	
	apb_driver apb_drv_h;
	apb_monitor apb_mon_h;
	apb_sequencer apb_seqr_h;

	extern function new (string name = "apb_agt", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);

endclass

function apb_agt :: new (string name = "apb_agt", uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_agt :: build_phase (uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_config) :: get (this, "", "apb_config", apb_cfg))
		`uvm_error (get_full_name(), "Can't Get APB Config DB");
	apb_mon_h = apb_monitor :: type_id :: create ("apb_mon_h",this);
	
	if(apb_cfg.is_active == UVM_ACTIVE) begin
		apb_drv_h = apb_driver :: type_id :: create ("apb_drv_h",this);
		apb_seqr_h = apb_sequencer :: type_id :: create ("apb_seqr_h",this);
	end
endfunction

function void apb_agt :: connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	if(apb_cfg.is_active == UVM_ACTIVE)
		apb_drv_h.seq_item_port.connect(apb_seqr_h.seq_item_export);
endfunction
