//Router Source Monitor
class master_monitor extends uvm_monitor;

	`uvm_component_utils(master_monitor)

  // Declare virtual interface handle with wr_mon_mp as modport
   	virtual router_src_if.write_mon_mp vif;

  // Declare the master_agent_config handle as "m_cfg"
     master_agent_config m_cfg;

  // Analysis TLM port to connect the monitor to the scoreboard
  	uvm_analysis_port #(write_xtn) monitor_port;

extern function new(string name = "master_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);
endclass 


//-----------------  constructor new method  -------------------//
function master_monitor::new(string name = "master_monitor", uvm_component parent);
	super.new(name,parent);
	// create object for handle monitor_port using new
	monitor_port = new("monitor_port", this);
endfunction


//-----------------  build() phase method  -------------------//
function void master_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction:build_phase


//-----------------  connect() phase method  -------------------//
function void master_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
   vif = m_cfg.vif;
   `uvm_info(get_type_name(),"IN CONNECT PHASE OF MASTER MONITOR",UVM_LOW)
endfunction:connect_phase


//-----------------  run() phase method  -------------------//
task master_monitor::run_phase(uvm_phase phase);
	forever
        // Call collect data task
		collect_data();     
		   `uvm_info(get_type_name(),"IN RUN PHASE OF MASTER MONITOR",UVM_LOW)

endtask


   // Collect Reference Data from DUV IF 
task master_monitor::collect_data();
	
	    write_xtn data_sent;
	begin
		data_sent= write_xtn::type_id::create("data_sent");
 
	 
  //`uvm_info(get_type_name(),"11111111111111111111111111111111111111111111111111111111",UVM_LOW)

		
		while(vif.wr_mon_cb.pkt_valid==0)
			begin
				@(vif.wr_mon_cb);
			end
			
		while(vif.wr_mon_cb.busy)
			begin
				@(vif.wr_mon_cb);
			end
		
		data_sent.header = vif.wr_mon_cb.data_in;
		
		data_sent.payload =new[data_sent.header[7:2]];
		
		@(vif.wr_mon_cb);

//	  `uvm_info(get_type_name(),"222222222222222222222222222222222222222222222222222222222222",UVM_LOW)
 

		foreach(data_sent.payload[i])
			begin

               while(vif.wr_mon_cb.busy)
				begin
                        	@(vif.wr_mon_cb); 
				end

 //`uvm_info(get_type_name(),"3333333333333333333333333333333333333333333333333333333333333333333333333333",UVM_LOW)
 


				data_sent.payload[i] = vif.wr_mon_cb.data_in;

					@(vif.wr_mon_cb);
			end
 
 //`uvm_info(get_type_name(),"44444444444444444444444444444444444444444444444444444444444444444444444444444444444",UVM_LOW)
 

			

		while(vif.wr_mon_cb.busy)
		begin
			@(vif.wr_mon_cb);
		end

			

		data_sent.parity =  vif.wr_mon_cb.data_in;
	 
		repeat(2)
		//begin
			@(vif.wr_mon_cb);
		//end
		
	//	data_sent.error=vif.wr_mon_cb.error;
	
	data_sent.err=vif.wr_mon_cb.err;
	
		m_cfg.mon_rcvd_xtn_cnt++;
	
			`uvm_info("ROUTER_SRC_MONITOR",$sformatf("printing from monitor\n %s",data_sent.sprint()),UVM_LOW)

		monitor_port.write(data_sent);
	end
	
endtask

function void master_monitor:: report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Master Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction : report_phase

