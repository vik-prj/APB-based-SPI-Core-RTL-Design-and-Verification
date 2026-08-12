class env extends uvm_env;
	
	`uvm_component_utils(env)

	apb_agt_top apb_agt_top_h;
	spi_agt_top spi_agt_top_h;

	scoreboard sb_h;

	virtual_seqr v_seqr;

	config_db m_cfg;
	
	extern function new (string name = "env", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);

endclass

function env :: new (string name = "env", uvm_component parent);
	super.new(name,parent);
endfunction

function void env :: build_phase (uvm_phase phase);
	super.build_phase (phase);
	
	if(!uvm_config_db #(config_db) :: get (this, "", "config_db", m_cfg))
		`uvm_error (get_full_name(), "Can't Get Config DB");
	
	if(m_cfg.has_apb_agent) begin
		uvm_config_db #(apb_config) :: set (this, "*", "apb_config", m_cfg.apb_cfg);
		apb_agt_top_h = apb_agt_top :: type_id :: create("apb_agt_top_h",this);
	end

	if(m_cfg.has_spi_agent) begin
		uvm_config_db #(spi_config) :: set (this, "*", "spi_config", m_cfg.spi_cfg);
		spi_agt_top_h = spi_agt_top :: type_id :: create("spi_agt_top_h",this);
	end

	if(m_cfg.has_virtual_sequencer) begin
		v_seqr = virtual_seqr :: type_id :: create("v_seqr",this);
	end
	
	if(m_cfg.has_scoreboard) begin
		sb_h = scoreboard :: type_id :: create ("sb_h",this);
	end

endfunction

function void env :: connect_phase (uvm_phase phase);
	
	if(m_cfg.has_scoreboard) begin
		apb_agt_top_h.apb_agt_h.apb_mon_h.monitor_port.connect(sb_h.fifo_apb.analysis_export);
		spi_agt_top_h.spi_agt_h.spi_mon_h.monitor_port.connect(sb_h.fifo_spi.analysis_export);
	end
	if(m_cfg.has_virtual_sequencer) begin
		v_seqr.apb_seqr_h = apb_agt_top_h.apb_agt_h.apb_seqr_h;
		v_seqr.spi_seqr_h = spi_agt_top_h.spi_agt_h.spi_seqr_h;
	end
	
endfunction
