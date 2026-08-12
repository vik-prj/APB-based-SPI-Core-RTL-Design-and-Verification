class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)
	
	uvm_analysis_port #(apb_xtn) monitor_port;
	
	virtual apb_if.APB_MON_MP apb_vif;
	
	apb_config apb_cfg;
	apb_xtn xtn;
	
	extern function new (string name = "apb_monitor", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect ();

endclass

function apb_monitor :: new (string name = "apb_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port",this);
endfunction

function void apb_monitor :: build_phase (uvm_phase phase);
	super.build_phase (phase);
	if(!uvm_config_db #(apb_config) :: get (this, "", "apb_config", apb_cfg))
		`uvm_error(get_full_name(),"Can't Get APB Config DB");
endfunction

function void apb_monitor :: connect_phase (uvm_phase phase);
	apb_vif = apb_cfg.apb_vif;
endfunction

task apb_monitor :: run_phase (uvm_phase phase);
	forever begin
		collect();
	end
endtask

task apb_monitor :: collect ();
	apb_xtn xtn;
	xtn = apb_xtn :: type_id :: create ("xtn");
	
	@(apb_vif.apb_mon_cb);

	wait (apb_vif.apb_mon_cb.PENABLE && apb_vif.apb_mon_cb.PREADY);
		xtn.PRESETn = apb_vif.apb_mon_cb.PRESETn;
		xtn.PADDR = apb_vif.apb_mon_cb.PADDR;
		xtn.PWRITE = apb_vif.apb_mon_cb.PWRITE;
		xtn.PSEL = apb_vif.apb_mon_cb.PSEL;
		xtn.PENABLE = apb_vif.apb_mon_cb.PENABLE;
		xtn.PREADY = apb_vif.apb_mon_cb.PREADY;
		xtn.PSLVERR = apb_vif.apb_mon_cb.PSLVERR;

		if(apb_vif.apb_mon_cb.PWRITE) xtn.PWDATA = apb_vif.apb_mon_cb.PWDATA;
		else xtn.PRDATA = apb_vif.apb_mon_cb.PRDATA;
	
		`uvm_info(get_type_name(), $sformatf("Transaction from DUT to APB MON is \n %s", xtn.sprint()),UVM_LOW)

		monitor_port.write(xtn);
endtask

