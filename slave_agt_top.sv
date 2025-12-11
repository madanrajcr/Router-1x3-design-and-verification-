//Router Slave Agent top
class slave_agt_top extends uvm_env;

	`uvm_component_utils(slave_agt_top)
    
   // Create the agent handle
      slave_agent agnth[]; 
      env_config m_cfg;
	  slave_agent_config m_slave_agent_cfg;

	extern function new(string name = "slave_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
  endclass

function slave_agt_top::new(string name = "slave_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
function void slave_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this," ","env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	agnth=new[m_cfg.no_of_slave_agents];
	
	foreach(m_cfg.m_slave_agent_cfg[i])
	begin
		agnth[i]= slave_agent::type_id::create($sformatf("agnth[%0d]",i),this);
		uvm_config_db #(slave_agent_config) :: set(this, $sformatf("agnth[%0d]*",i),"slave_agent_config",m_cfg.m_slave_agent_cfg[i]);
	end
endfunction

// Print the topology
task slave_agt_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask:run_phase   


