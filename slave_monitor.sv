// Destination Monitor
class slave_monitor extends uvm_monitor;

	`uvm_component_utils(slave_monitor)

  // Declare virtual interface handle with RMON_MP as modport
   	virtual router_dest_if.read_mon_mp vif;

  // Declare the ram_wr_agent_config handle as "m_cfg"
      slave_agent_config m_cfg;

  // Analysis TLM port to connect the monitor to the scoreboard 
  uvm_analysis_port #(read_xtn) monitor_port;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "slave_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass :slave_monitor

 function slave_monitor::new (string name = "slave_monitor", uvm_component parent);
    super.new(name, parent);
// create object for handle monitor_port using new
    monitor_port = new("monitor_port", this);
  endfunction : new


function void slave_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);  
	if(!uvm_config_db #(slave_agent_config)::get(this,"","slave_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction:build_phase


function void slave_monitor::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=m_cfg.vif;

$display("i am in slave driver %p",vif);
endfunction:connect_phase

      
task slave_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task slave_monitor::collect_data();
	
	read_xtn mon_data;
	mon_data=read_xtn::type_id::create("read_xtn");
//`uvm_info(get_type_name(),"1111111111111111111111111111111111111111111111111111111111111111111111111111111",UVM_LOW)
	while(vif.read_mon_cb.vld_out==0) 
		@(vif.read_mon_cb);

	while(vif.read_mon_cb.read_enb==0)
		@(vif.read_mon_cb);

          	@(vif.read_mon_cb);
//`uvm_info(get_type_name(),"22222222222222222222222222222222222222222222222222222222222222222222222222222",UVM_LOW)
	
	mon_data.header=vif.read_mon_cb.data_out;
	
	@(vif.read_mon_cb);
	
	mon_data.payload=new[mon_data.header[7:2]];
	
//	@(vif.read_mon_cb);
	
	//`uvm_info(get_type_name(),"3333333333333333333333333333333333333333333333333333333333333333333333333333",UVM_LOW)
	
	foreach(mon_data.payload[i])
		begin
			while(vif.read_mon_cb.read_enb==0)
		//begin
			@(vif.read_mon_cb);
		//end
		
		mon_data.payload[i]=vif.read_mon_cb.data_out;
		@(vif.read_mon_cb);
		end
		
//		`uvm_info(get_type_name(),"444444444444444444444444444444444444444444444444444444444444444444444444444",UVM_LOW)

		while(vif.read_mon_cb.read_enb==0)
		@(vif.read_mon_cb);

	mon_data.parity=vif.read_mon_cb.data_out;
	
	`uvm_info("FROM SLAVE MONITOR",$sformatf("printing from sequence \n %s", mon_data.sprint()),UVM_LOW) 
	
	monitor_port.write(mon_data);
	
endtask
