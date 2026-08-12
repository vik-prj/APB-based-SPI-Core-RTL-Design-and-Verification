class apb_driver extends uvm_driver #(apb_xtn);

	`uvm_component_utils(apb_driver)
	
	virtual apb_if.APB_DRV_MP apb_vif;
	
	apb_config apb_cfg;

	extern function new (string name = "apb_driver", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern task send_to_dut (apb_xtn xtn);
	extern task reset_dut();

endclass

function apb_driver :: new (string name = "apb_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_driver :: build_phase (uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_config) :: get (this, "", "apb_config", apb_cfg))
		`uvm_error(get_full_name(), "Can't Get APB Config DB");
endfunction

function void apb_driver :: connect_phase (uvm_phase phase);
	apb_vif = apb_cfg.apb_vif;
endfunction

task apb_driver :: run_phase (uvm_phase phase);
	
	reset_dut();
	
	forever begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end

endtask

task apb_driver :: send_to_dut (apb_xtn xtn);
	@(apb_vif.apb_drv_cb);
		apb_vif.apb_drv_cb.PRESETn <= 1'b1;
		apb_vif.apb_drv_cb.PADDR <= xtn.PADDR;
		apb_vif.apb_drv_cb.PWRITE <= xtn.PWRITE;
		apb_vif.apb_drv_cb.PSEL <= 1'b1;
		apb_vif.apb_drv_cb.PENABLE <= 1'b0;
		
	//PSEL = 1, PENABLE = 0 - SetUp Phase
	//check for PWRITE then send PWDATA
	//else receive the PRDATA in the next cycle

	if(xtn.PWRITE) apb_vif.apb_drv_cb.PWDATA <= xtn.PWDATA;
	@(apb_vif.apb_drv_cb)
		apb_vif.apb_drv_cb.PENABLE <= 1'b1; //initiate the Enable Phase

	wait(apb_vif.apb_drv_cb.PREADY); //waiting for DUT to be Ready

	if(xtn.PWRITE == 1'b0) xtn.PRDATA = apb_vif.apb_drv_cb.PRDATA;
	
	`uvm_info(get_full_name(),$sformatf("Transaction From APB DRV to DUT is \n %s", xtn.sprint()), UVM_LOW)

	@(apb_vif.apb_drv_cb)
	apb_vif.apb_drv_cb.PSEL <= 1'b0;
	apb_vif.apb_drv_cb.PENABLE <= 1'b0;
endtask

task apb_driver :: reset_dut();
	@(apb_vif.apb_drv_cb);
		apb_vif.apb_drv_cb.PRESETn <= 1'b0;
	//repeat(5)
	@(apb_vif.apb_drv_cb);
		apb_vif.apb_drv_cb.PRESETn <= 1'b1;
endtask
