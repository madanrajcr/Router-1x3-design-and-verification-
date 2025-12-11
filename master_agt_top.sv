// Router Master Agent Top
class master_agt_top extends uvm_env;

	`uvm_component_utils(master_agt_top)
	// Declare handle for Master agent and env_config
      	 master_agent agnth[];
         env_config m_cfg;
		 master_agent_config  m_master_agent_cfg;

	extern function new(string name = "master_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass


//-----------------  constructor new method  -------------------//
function master_agt_top::new(string name = "master_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
function void master_agt_top::build_phase(uvm_phase phase);
     super.build_phase(phase);
       	if(! uvm_config_db  #(env_config) :: get(this," ","env_config",m_cfg))
            `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
		agnth=new[m_cfg.no_of_master_agents];
		foreach(agnth[i])
		begin
			uvm_config_db #(master_agent_config) :: set(this,$sformatf("agnth[%0d]*",i),"master_agent_config",m_cfg.m_master_agent_cfg[i]);
			agnth[i]=master_agent::type_id::create($sformatf("agnth[%0d]*",i),this);
		end
endfunction


//-----------------  run() phase method  -------------------//
task master_agt_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask   


