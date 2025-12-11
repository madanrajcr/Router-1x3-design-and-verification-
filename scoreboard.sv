//Scoreboard class
class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(read_xtn) fifo_slave[];
	uvm_tlm_analysis_fifo #(write_xtn) fifo_master;

	env_config m_cfg;
	
	write_xtn wr_data;
	read_xtn rd_data;
	

	
	covergroup cov_master; 
		Address : 		coverpoint wr_data.header[1:0]{
														bins add_0 = {0};
														bins add_1 = {1};
														bins add_2 = {2};
														}
		Payload_size: 	coverpoint wr_data.header[7:2]{
														bins small_pkt = {[1: 16]};
														bins mid_pkt = {[17:40]}; 
														bins big_pkt = {[41:63]}; 
														}
 /*
		Error:			coverpoint wr_data.error {	bins sucess={0};
													bins fail={1};
												  }
*/
		Error:			coverpoint wr_data.err {	bins sucess={0};
													bins fail={1};
												  }
	
		endgroup 

		covergroup cov_slave; 
		Address : 		coverpoint rd_data.header[1:0]{
														bins add_0 = {0};
														bins add_1 = {1};
														bins add_2 = {2};
														}
		Payload_size: 	coverpoint rd_data.header[7:2]{
														bins small_pkt = {[1: 16]};
														bins mid_pkt = {[17:40]}; 
														bins big_pkt = {[41:63]}; 
														}

		endgroup 

	extern function new (string name="scoreboard", uvm_component parent);
	extern task run_phase(uvm_phase phase);
	extern task check_data(read_xtn rd_data);
endclass:scoreboard

function scoreboard::new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
         if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))

	             	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

		
		
         fifo_slave= new[m_cfg.no_of_slave_agents];
         fifo_master= new("fifo_master",this);

         foreach(fifo_slave[i])
         fifo_slave[i]= new($sformatf("fifo_slave[%0d]",i),this);
		 
		 //Creating covergroup object
		 cov_master=new;
		 cov_slave=new;
endfunction :new

task scoreboard::run_phase(uvm_phase phase);
		fork 
			begin 
				forever 
					begin 
						fifo_master.get(wr_data);
						//	$display("sxtn: %p", sxtn); 
						cov_master.sample();  
					end
			end

			begin 
				forever
				begin
					fork 
						begin 
							fifo_slave[0].get(rd_data); 
							cov_slave.sample(); 
							check_data(rd_data); 
						end
						
						begin 
							fifo_slave[1].get(rd_data); 
							cov_slave.sample(); 
							check_data(rd_data); 
						end

						begin 
							fifo_slave[2].get(rd_data); 
							cov_slave.sample(); 
							check_data(rd_data); 
						end
					join_any
					disable fork;
				end 
			end
		join 
endtask  


task scoreboard::check_data(read_xtn rd_data);
	`uvm_info(get_type_name(),$sformatf("source_xtns %s dest_xtns %s",wr_data.sprint,rd_data.sprint),UVM_LOW) 
		if(wr_data.header == rd_data.header)	
			`uvm_info("Scoreboard", "Header compared successfully", UVM_LOW)
		else
			`uvm_info("Scoreboard", "Header mismatch", UVM_LOW)

		if(wr_data.payload == rd_data.payload)	
			`uvm_info("Scoreboard", "Payload compared successfully", UVM_LOW)
		else
			`uvm_info("Scoreboard", "Payload mismatch", UVM_LOW)

		if(wr_data.parity == rd_data.parity)	
			`uvm_info("Scoreboard", "Parity compared successfully", UVM_LOW)
		else
			`uvm_info("Scoreboard", "Parity mismatch", UVM_LOW)


endtask 	