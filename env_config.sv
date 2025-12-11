// Router environment congiguration class
class env_config extends uvm_object;
	
	`uvm_object_utils(env_config)

	bit has_magent =1;
	bit has_sagent =1;
	bit has_virtual_sequencer =1;
	bit has_scoreboard =1;

	//Creating handle for Master agent configuration class
	master_agent_config m_master_agent_cfg[];
	//Creating handle for Slave agent Configuration class
	slave_agent_config  m_slave_agent_cfg[];

	//declaring no_of_master&slave_agnts as int type which can be set to the required DUT value
	int no_of_master_agents=1;
	int no_of_slave_agents=3;
	
	bit[1:0] addr;

	extern function new(string name="env_config");

endclass :env_config

function env_config::new(string name="env_config");
	super.new(name);
endfunction : new

	   
