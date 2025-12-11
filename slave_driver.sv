//Router Destination driver
class slave_driver extends uvm_driver #(read_xtn);

	`uvm_component_utils(slave_driver)

   // Declare virtual interface handle with dr_drv_mp as modport
   	virtual router_dest_if.read_drv_mp vif;

   // Declare the ram_wr_agent_config handle as "m_cfg"
     slave_agent_config m_cfg;

	extern function new(string name ="slave_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(read_xtn xtn);		
endclass:slave_driver


function slave_driver::new (string name ="slave_driver", uvm_component parent);
	super.new(name, parent);
endfunction : new


function void slave_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(slave_agent_config)::get(this,"","slave_agent_config",m_cfg)) 
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
 endfunction:build_phase

function void slave_driver::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction:connect_phase

task slave_driver::run_phase(uvm_phase phase);
	
	`uvm_info("SLAVE DRIVER","printing from slave driver %s,.xprint(req)",UVM_LOW)
	
//	`uvm_info(get_type_name(),"1111111111111111111111111111111111111111111111111111111111111111111111111111111",UVM_LOW)
	
	forever
	begin
 		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done(req);
	end
endtask

task slave_driver::send_to_dut(read_xtn xtn);

//	@(vif.read_drv_cb);
	
	//`uvm_info(get_type_name(),"22222222222222222222222222222222222222222222222222222222222222222222222222222222",UVM_LOW)
 
	
	while(vif.read_drv_cb.vld_out==0) 
		@(vif.read_drv_cb);
	
	@(vif.read_drv_cb);
	
	//`uvm_info(get_type_name(),"33333333333333333333333333333333333333333333333333333333333333333333333333333333333",UVM_LOW)
	
	repeat(xtn.no_of_delay)
		@(vif.read_drv_cb);
	

	vif.read_drv_cb.read_enb <= 1'b1;
	//`uvm_info(get_type_name(),"44444444444444444444444444444444444444444444444444444444444444444444444444444444444",UVM_LOW)
	
	while(vif.read_drv_cb.vld_out==1)
				@(vif.read_drv_cb);
	
	@(vif.read_drv_cb);
	
	vif.read_drv_cb.read_enb<=1'b0;
	
		`uvm_info("FROM SLAVE DRIVER",$sformatf("printing from sequence \n %s", xtn.sprint()),UVM_LOW) 
		
endtask
	

