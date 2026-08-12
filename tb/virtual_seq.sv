class virtual_seq extends uvm_sequence #(uvm_sequence_item);
	
	`uvm_object_utils(virtual_seq)

	apb_sequencer apb_seqr_h;
	spi_sequencer spi_seqr_h;

	virtual_seqr v_seqr_h;

	apb_reset_seq apb_reset_seq_h;

	spi_seq1 spi_seq1_h;
	
	apb_cpol1_cpha1_lsb1 cpol1_cpha1_lsb1_h;
	apb_cpol1_cpha0_lsb1 cpol1_cpha0_lsb1_h;
	apb_cpol0_cpha1_lsb1 cpol0_cpha1_lsb1_h;
	apb_cpol0_cpha0_lsb1 cpol0_cpha0_lsb1_h;
	apb_cpol1_cpha1_lsb0 cpol1_cpha1_lsb0_h;
	apb_cpol1_cpha0_lsb0 cpol1_cpha0_lsb0_h;
	apb_cpol0_cpha1_lsb0 cpol0_cpha1_lsb0_h;
	apb_cpol0_cpha0_lsb0 cpol0_cpha0_lsb0_h;
	low_power_mode_seq low_power_mode_seq_h;


	extern function new (string name = "virtual_seq");
	extern task body ();

endclass

function virtual_seq :: new (string name = "virtual_seq");
	super.new(name);
endfunction

task virtual_seq :: body();
	
	if(!$cast(v_seqr_h,m_sequencer))
		`uvm_fatal(get_full_name(),"Casting of v_seqr and m_sequencer Failed");
	apb_seqr_h = v_seqr_h.apb_seqr_h;
	spi_seqr_h = v_seqr_h.spi_seqr_h;	
	
endtask


//virtual reset seq
class apb_v_reset_seq extends virtual_seq;
	`uvm_object_utils(apb_v_reset_seq)

	function new (string name = "apb_v_reset_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		apb_reset_seq_h = apb_reset_seq :: type_id :: create ("apb_reset_seq_h");
		apb_reset_seq_h.start(apb_seqr_h);
	endtask
endclass
	


//cpol =1, cphase=1, lsbfe =1;
class cpol1_cpha1_lsb1_vseq extends virtual_seq;
	`uvm_object_utils(cpol1_cpha1_lsb1_vseq)
	
	function new(string name ="cpol1_cpha1_lsb1_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol1_cpha1_lsb1_h = apb_cpol1_cpha1_lsb1 :: type_id :: create("cpol1_cpha1_lsb1_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol1_cpha1_lsb1_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass



//cpol=1, cphase=0, lsbfe=1;
class cpol1_cpha0_lsb1_vseq extends virtual_seq;
	`uvm_object_utils(cpol1_cpha0_lsb1_vseq)
	
	function new(string name ="cpol1_cpha0_lsb1_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol1_cpha0_lsb1_h = apb_cpol1_cpha0_lsb1 :: type_id :: create("cpol1_cpha0_lsb1_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol1_cpha0_lsb1_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass



//cpol=0, cphase=1, lsbfe=1;
class cpol0_cpha1_lsb1_vseq extends virtual_seq;
	`uvm_object_utils(cpol0_cpha1_lsb1_vseq)
	
	function new(string name ="cpol0_cpha1_lsb1_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol0_cpha1_lsb1_h = apb_cpol0_cpha1_lsb1 :: type_id :: create("cpol0_cpha1_lsb1_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol0_cpha1_lsb1_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass	



//cpol=0, cphase=0, lsbfe=1;
class cpol0_cpha0_lsb1_vseq extends virtual_seq;
	`uvm_object_utils(cpol0_cpha0_lsb1_vseq)
	
	function new(string name ="cpol0_cpha0_lsb1_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol0_cpha0_lsb1_h = apb_cpol0_cpha0_lsb1 :: type_id :: create("cpol0_cpha0_lsb1_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol0_cpha0_lsb1_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass
		


//cpol =1, cphase=1, lsbfe =0;
class cpol1_cpha1_lsb0_vseq extends virtual_seq;
	`uvm_object_utils(cpol1_cpha1_lsb0_vseq)
	
	function new(string name ="cpol1_cpha1_lsb0_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol1_cpha1_lsb0_h = apb_cpol1_cpha1_lsb0 :: type_id :: create("cpol1_cpha1_lsb0_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol1_cpha1_lsb0_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass



//cpol=1, cphase=0, lsbfe=0;
class cpol1_cpha0_lsb0_vseq extends virtual_seq;
	`uvm_object_utils(cpol1_cpha0_lsb0_vseq)
	
	function new(string name ="cpol1_cpha0_lsb0_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol1_cpha0_lsb0_h = apb_cpol1_cpha0_lsb0 :: type_id :: create("cpol1_cpha0_lsb0_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol1_cpha0_lsb0_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass



//cpol=0, cphase=1, lsbfe=0;
class cpol0_cpha1_lsb0_vseq extends virtual_seq;
	`uvm_object_utils(cpol0_cpha1_lsb0_vseq)
	
	function new(string name ="cpol0_cpha1_lsb0_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol0_cpha1_lsb0_h = apb_cpol0_cpha1_lsb0 :: type_id :: create("cpol0_cpha1_lsb0_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol0_cpha1_lsb0_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass	



//cpol=0, cphase=0, lsbfe=0;
class cpol0_cpha0_lsb0_vseq extends virtual_seq;
	`uvm_object_utils(cpol0_cpha0_lsb0_vseq)
	
	function new(string name ="cpol0_cpha0_lsb0_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		cpol0_cpha0_lsb0_h = apb_cpol0_cpha0_lsb0 :: type_id :: create("cpol0_cpha0_lsb0_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		cpol0_cpha0_lsb0_h.start(apb_seqr_h);
		spi_seq1_h.start(spi_seqr_h);
	endtask
endclass



//low power mode 
class low_power_mode_vseq extends virtual_seq;
	`uvm_object_utils(low_power_mode_vseq)
	
	function new(string name ="low_power_mode_vseq");
		super.new(name);
	endfunction

	task body();		
		super.body();
		low_power_mode_seq_h = low_power_mode_seq :: type_id :: create("low_power_mode_seq_h");
		spi_seq1_h = spi_seq1 :: type_id :: create("spi_seq1_h");

		low_power_mode_seq_h.start(apb_seqr_h);
	//	spi_seq1_h.start(spi_seqrh);
	endtask
endclass

