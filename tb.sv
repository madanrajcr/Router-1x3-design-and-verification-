//Environment class
class tb extends uvm_env;
	
	`uvm_component_utils(tb);

	//Declaring handles for Master_agent_top and Slave _agent_top to create  environment

	master_agt_top magt_top;
	slave_agt_top sagt_top;
	
	//Declare handle for router_env_config object
	env_config m_cfg;
	
	//Declarer handle for Virtual seqencer
	virtual_sequencer v_sequencer;

	//Declare handle for scoreboard
	scoreboard sb;

	

	extern function new (string name="tb", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass : tb

function tb::new(string name="tb",uvm_component parent);
	super.new(name,parent);
endfunction
 
function void tb::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))

	             	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
                
                         if(m_cfg.has_magent)
							begin
								magt_top= master_agt_top::type_id::create("magt_top" ,this);
							end 
                
                         if(m_cfg.has_sagent) 
							begin
								sagt_top=slave_agt_top::type_id::create("sagt_top" ,this);
							end
           
						super.build_phase(phase);

						if(m_cfg.has_virtual_sequencer)
							v_sequencer=virtual_sequencer::type_id::create("v_sequencer",this);
                        
						if(m_cfg.has_scoreboard) 
							sb=scoreboard :: type_id::create("sb",this);
							
						`uvm_info(get_type_name(), "This is build_phase of tb_env",UVM_LOW);
endfunction:build_phase

function void tb::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	if(m_cfg.has_virtual_sequencer)
		begin
			if(m_cfg.has_magent)
				begin	
					for(int i=0; i<m_cfg.no_of_master_agents; i++)
						v_sequencer.m_seqrh[i]=magt_top.agnth[i].seqrh;
				end
			
			if(m_cfg.has_sagent)
				begin 
					for(int i=0; i<m_cfg.no_of_slave_agents; i++)
						v_sequencer.s_seqrh[i]=sagt_top.agnth[i].seqrh;
				end
		end
		
		
	if(m_cfg.has_scoreboard)
		begin
			for(int i=0; i<m_cfg.no_of_master_agents; i++)
				magt_top.agnth[i].monh.monitor_port.connect(sb.fifo_master.analysis_export);
			
			for(int i=0; i<m_cfg.no_of_slave_agents; i++)
				sagt_top.agnth[i].monh.monitor_port.connect(sb.fifo_slave[i].analysis_export);
		end 
endfunction:connect_phase

