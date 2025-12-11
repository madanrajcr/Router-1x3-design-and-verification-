interface router_src_if(input bit clock); 
	logic [7:0] data_in; 
	logic resetn; 
	bit pkt_valid; 
	bit err;
//	bit error; 
	bit busy; 
	

	clocking wr_drv_cb @(posedge clock);
		default input #1 output #1;  
		output data_in, resetn, pkt_valid; 
		input busy;
	//	input error; 
	    input err;
	endclocking 
		
	clocking wr_mon_cb @(posedge clock); 
		default input #1 output #1; 	
		input data_in, resetn, pkt_valid, busy;
	//	input error; 
		input err;
	endclocking 

	modport write_drv_mp(clocking wr_drv_cb);
	modport write_mon_mp(clocking wr_mon_cb);
endinterface 	
