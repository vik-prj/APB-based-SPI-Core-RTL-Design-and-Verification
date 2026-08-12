class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(apb_xtn) fifo_apb;
	uvm_tlm_analysis_fifo #(spi_xtn) fifo_spi;
	
	uvm_status_e status;
	
	apb_xtn a_xtn;
	spi_xtn s_xtn;

	config_db m_cfg;
	
	apb_xtn apb_cov;
	spi_xtn spi_cov;

	bit reset_case;
	bit[1:0] low_pwr_case;
	bit[7:0] cntr_reg1, cntr_reg2, baud_reg, status_reg, data_reg;

	extern function new (string name = "scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase (uvm_phase phase);
//	extern task compare_data();
//	extern task compare_data1();

	covergroup write_cov;
	       	option.per_instance =1;
		 RESET:coverpoint apb_cov.PRESETn{bins rst={0,1};}
       		 ADDR:coverpoint apb_cov.PADDR{bins addr[]={0,1,2,3,5};}
                 SELX:coverpoint apb_cov.PSEL{bins sel={0,1};}
        	 ENABLE:coverpoint apb_cov.PENABLE{bins enb={0,1};}
       		 WRITE:coverpoint apb_cov.PWRITE{bins write ={0,1};}
       		 READY:coverpoint apb_cov.PREADY{bins ready={0,1};}
        	 ERROR:coverpoint apb_cov.PSLVERR{bins err={0,1};}
        	 WDATA:coverpoint apb_cov.PWDATA{bins low={[8'h00:8'hff]};}
        	 RDATA:coverpoint apb_cov.PRDATA{bins low={[8'h00:8'hff]};}
       		 selx_enable:cross SELX,ENABLE;
       		 sel_enable_read:cross SELX,ENABLE,READY;
        endgroup

        covergroup read_cov;
        option.per_instance=1;
        SLAVE_SELECT:coverpoint spi_cov.ss{bins ss1={0,1};}
        MISO_DATA   :coverpoint spi_cov.miso{bins low={[8'h00:8'hff]};}
        MOSI_DATA   :coverpoint spi_cov.mosi{bins low={[8'h00:8'hff]};}
        SPI_INTER_REQ:coverpoint spi_cov.spi_inpt_req{bins inpt ={0,1};}
        endgroup

endclass

function scoreboard :: new (string name = "scoreboard", uvm_component parent);
	super.new(name,parent);
	fifo_apb = new ("fifo_apb",this);
	fifo_spi = new ("fifo_spi",this);
	write_cov = new();
	read_cov = new();
endfunction

function void scoreboard :: build_phase (uvm_phase phase);
	super.build_phase (phase);
	if(!uvm_config_db #(config_db) :: get(this, "","config_db", m_cfg))
		`uvm_error(get_full_name(), "Can't Get Config DB");

	if(!uvm_config_db #(bit) :: get(this, "", "bit", reset_case))
		`uvm_info(get_type_name(), "Can't Get Reset Case", UVM_LOW);

	if(!uvm_config_db #(bit[1:0]) :: get(this, "", "bit[1:0]",low_pwr_case))
		`uvm_info(get_type_name(), "Can't Get Low Pwr Case", UVM_LOW);
endfunction

function void scoreboard :: connect_phase (uvm_phase phase);
	super.connect_phase (phase);
endfunction

task scoreboard :: run_phase (uvm_phase phase);
	fork 
		begin
			forever begin
			fifo_apb.get(a_xtn);
			`uvm_info(get_type_name(), $sformatf("APB Trans in SB is %s", a_xtn.sprint), UVM_LOW)
			apb_cov = a_xtn;
			write_cov.sample();
			
			//compare_data1();
			end
		end
		begin
			forever begin
			fifo_spi.get(s_xtn);
			`uvm_info(get_type_name(), $sformatf("SPI Trans in SB is %s", s_xtn.sprint), UVM_LOW)
			spi_cov = s_xtn;
			read_cov.sample();
		
		//	compare_data();
			end
		end
	join
endtask
/*
task scoreboard :: compare_data ();
	wait (a_xtn != null);
	wait (s_xtn != null);
		
	if(a_xtn.PWRITE && a_xtn.PADDR == 3'b101) begin
		if(a_xtn.PWDATA == s_xtn.mosi) begin
			`uvm_info(get_type_name(), "Write Success", UVM_LOW);
		end
		else
			`uvm_info(get_type_name(), "Write Error", UVM_LOW);
	end
endtask

task scoreboard :: compare_data1();	
	if(reset_case) begin
	
		if((cntr_reg1 == 8'b0000_0100) && (cntr_reg2 == 8'b0000_0000) && (baud_reg == 8'b0000_0000) && (status_reg == 8'h20) && (data_reg == 8'h00)) begin
			`uvm_info(get_type_name(),"reset test case is success",UVM_LOW);
		end
		else
			`uvm_error(get_type_name(),"error at reset test case");
	end

	else if(low_pwr_case == 2'b01) begin
		if((!a_xtn.PWRITE) && (a_xtn.PADDR == 3'b101)) begin
			this.spi_rg_blk.data_reg.read(status,data_reg, .path(UVM_BACKDOOR), .map(spi_rg_blk.spi_reg_map));
			if(a_xtn.PRDATA == data_reg) begin
				`uvm_info(get_type_name(),"low power case working fine",UVM_LOW);
			end
			else
				`uvm_info(get_type_name(),"failed to verify the low power case",UVM_LOW);
		end
	end

	else begin
		if((!a_xtn.PWRITE) && (a_xtn.PADDR == 3'b101)) begin
			wait(s_xtn != null);
			if(a_xtn.PRDATA == s_xtn.miso) begin	
				`uvm_info(get_type_name(),"read operation success",UVM_LOW);
			end
			else 
				`uvm_error(get_type_name(),"read operation failure");
		
		end
	end
	
endtask
*/






