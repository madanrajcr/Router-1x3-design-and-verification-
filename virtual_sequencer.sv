//Virtual Sequencer In Environment

class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(virtual_sequencer)

	//Declare handle for Master & Slave Sequencer in Vitual sequencer
	master_sequencer m_seqrh[];
	slave_sequencer s_seqrh[];

 	env_config m_cfg;

 	extern function new (string name="virtual_sequencer",uvm_component parent);
	extern function void build_phase (uvm_phase phase);

endclass: virtual_sequencer

function virtual_sequencer :: new(string name="virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction:new

function void virtual_sequencer :: build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db.Have you set() it?")
	if(m_cfg.has_virtual_sequencer)
		begin
			if(m_cfg.has_magent)
			m_seqrh=new[m_cfg.no_of_master_agents];
			
 			if(m_cfg.has_sagent)
			s_seqrh=new[m_cfg.no_of_slave_agents];
		end
endfunction:build_phase

