interface router_dest_if(input bit clock); 
	bit read_enb; 
	logic [7:0] data_out; 
	bit vld_out; 
	
	clocking read_drv_cb @(posedge clock); 
		default input #1 output #1; 
		input vld_out; 
		output read_enb; 
	endclocking 
	
	clocking read_mon_cb @(posedge clock); 
		default input #1 output #1; 
		input read_enb;
		input data_out;
		input vld_out; 
	endclocking 

	modport read_drv_mp(clocking read_drv_cb); 
	modport read_mon_mp(clocking read_mon_cb);  

endinterface 
	
