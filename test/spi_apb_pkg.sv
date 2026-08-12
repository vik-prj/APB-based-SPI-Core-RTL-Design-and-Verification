			//Package Class

	package spi_apb_pkg;


	//import uvm_pkg.sv
		import uvm_pkg::*;
	//include uvm_macros.sv

	uvm_status_e status;
	`include "uvm_macros.svh"

	`include "spi_config.sv"
	`include "apb_config.sv"

	`include "apb_xtn.sv"
	`include "env_config.sv"
	`include "apb_driver.sv"
	`include "apb_monitor.sv"
	`include "apb_sequencer.sv"
	`include "apb_agt.sv"
	`include "apb_agt_top.sv"
	`include "apb_sequence.sv"

	`include "spi_xtn.sv"
	`include "spi_monitor.sv"
	`include "spi_sequencer.sv"
	`include "spi_sequence.sv"
	`include "spi_driver.sv"
	`include "spi_agt.sv"
	`include "spi_agt_top.sv"

	`include "virtual_seqr.sv"
	`include "virtual_seq.sv"
	`include "scoreboard.sv"

	`include "env.sv"


	`include "test_lib.sv"
endpackage

