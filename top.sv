
//Top module of Router
module top();
	import test_pkg::*;
	import uvm_pkg::*;

	bit clock;
	
	always
 	 	begin
		#5 clock = ! clock;
	end
	

	//source interface instantiation
	router_src_if in(clock);

	//destination interface instantiation
    router_dest_if in0(clock);
	router_dest_if in1(clock);
	router_dest_if in2(clock);

	//Router DUV instantiation
	router DUV(.clock(clock), .resetn(in.resetn), 
					.read_enb_0(in0.read_enb), .read_enb_1(in1.read_enb), .read_enb_2(in2.read_enb),
					.pkt_valid(in.pkt_valid), .data_in(in.data_in),
					.data_out_0(in0.data_out), .data_out_1(in1.data_out), .data_out_2(in2.data_out), 
					.vld_out_0(in0.vld_out), .vld_out_1(in1.vld_out), .vld_out_2(in2.vld_out),
					.err(in.err), .busy(in.busy)
					);
/*
	router_top DUV(.clock(clock), .resetn(in.resetn), 
					.read_enb_0(in0.read_enb), .read_enb_1(in1.read_enb), .read_enb_2(in2.read_enb),
					.pkt_valid(in.pkt_valid), .data_in(in.data_in),
					.data_out_0(in0.data_out), .data_out_1(in1.data_out), .data_out_2(in2.data_out), 
					.valid_out_0(in0.vld_out), .valid_out_1(in1.vld_out), .valid_out_2(in2.vld_out),
					.error(in.error), .busy(in.busy)
					);
	*/				
	//Passing virtual interface for agent
	initial
	begin

		`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

	
			
		uvm_config_db #(virtual router_src_if) ::set(null,"*","master_vif0",in);
		uvm_config_db #(virtual router_dest_if) ::set(null,"*","vif0",in0);
 		uvm_config_db #(virtual router_dest_if) ::set(null,"*","vif1",in1);
		uvm_config_db #(virtual router_dest_if) ::set(null,"*","vif2",in2);
	
		run_test();
	end
	

	property STABLE_DATA;
		@(posedge clock) in.busy |=> $stable(in.data_in);

	endproperty
	
	property BUSY_CHECK;
		@(posedge clock) $rose(in.pkt_valid) |=> in.busy;
	endproperty
	
	property VALID_SIGNAL;
		@(posedge clock) $rose(in.pkt_valid) |=> ##3 (in0.vld_out | in1.vld_out | in2.vld_out);
	endproperty
	
	property READ_ENABLE_1;
		@(posedge clock) in0.vld_out |=> ##[0:29](in0.read_enb);
	endproperty
	
	property READ_ENABLE_2;
		@(posedge clock) in1.vld_out |=> ##[0:29](in1.read_enb);
	endproperty
	
	property READ_ENABLE_3;
		@(posedge clock) in2.vld_out |=> ##[0:29](in2.read_enb);
	endproperty
	
	property READ_LOW_0;
		@(posedge clock) $fell(in0.vld_out) |=> ##1 $fell(in0.read_enb);
	endproperty
	
	property READ_LOW_1;
		@(posedge clock) $fell(in1.vld_out) |=> $fell(in1.read_enb);
	endproperty
	
	property READ_LOW_2;
		@(posedge clock) $fell(in2.vld_out) |=> $fell(in2.read_enb);
	endproperty
	
	
	A1: assert property(STABLE_DATA)
			$display("ASSERTION SUCCESS FOR STABLE_DATA");
		else
			$display("ASSERTION FAILED FOR STABLE_DATA");
			
	A11: cover property(STABLE_DATA);
	
	A2: assert property(BUSY_CHECK)
			$display("ASSERTION SUCCESS FOR BUSY_CHECK");
		else
			$display("ASSERTION FAILED FOR BUSY_CHECK");
			
	A21: cover property(BUSY_CHECK);
	
	A3: assert property(VALID_SIGNAL)
			$display("ASSERTION SUCCESS FOR VALID_SIGNAL");
		else
			$display("ASSERTION FAILED FOR VALID_SIGNAL");
			
	A31: cover property(VALID_SIGNAL);
	
	A4: assert property(READ_ENABLE_1)
			$display("ASSERTION SUCCESS FOR READ_ENABLE_1");
		else
			$display("ASSERTION FAILED FOR READ_ENABLE_1");
			
	A41: cover property(READ_ENABLE_1);
	
	A5: assert property(READ_ENABLE_2)
			$display("ASSERTION SUCCESS FOR READ_ENABLE_2");
		else
			$display("ASSERTION FAILED FOR READ_ENABLE_2");
			
	A51: cover property(READ_ENABLE_2);
	
	A6: assert property(READ_ENABLE_3)
			$display("ASSERTION SUCCESS FOR READ_ENABLE_3");
		else
			$display("ASSERTION FAILED FOR READ_ENABLE_3");
			
	A61: cover property(READ_ENABLE_3);
	
	A7: assert property(READ_LOW_0)
			$display("ASSERTION SUCCESS FOR READ_LOW_0");
		else
			$display("ASSERTION FAILED FOR READ_LOW_0");
			
	A71: cover property(READ_LOW_0);
	
	A8: assert property(READ_LOW_1)
			$display("ASSERTION SUCCESS FOR READ_LOW_1");
		else
			$display("ASSERTION FAILED FOR READ_LOW_1");
			
	A81: cover property(READ_LOW_1);
	
	A9: assert property(READ_LOW_2)
			$display("ASSERTION SUCCESS FOR READ_LOW_2");
		else
			$display("ASSERTION FAILED FOR READ_LOW_2");
			
	A91: cover property(READ_LOW_2);
	

endmodule
