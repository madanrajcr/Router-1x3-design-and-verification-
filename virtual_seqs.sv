// Router Vitual sequence
class vbase_seq extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(vbase_seq)
	master_sequencer m_seqrh[];
	slave_sequencer  s_seqrh[];
	
	virtual_sequencer vsqrh;
	
	env_config m_cfg;
	
//	router_master_small_xtns small_m_xtns;
//	slave_seq s_seq;
	
//	router_master_medium_xtns medium_m_xtns;
	
//	router_master_large_xtns  large_m_xtns;
	 
 	extern function new(string name="vbase_seq");
	extern task body();
endclass: vbase_seq


//-----------------  constructor new method  -------------------//
function vbase_seq::new(string name="vbase_seq");
	super.new(name);
endfunction:new

//-----------------  task body() method  -------------------//
task vbase_seq::body();
	  if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
  
	m_seqrh=new[m_cfg.no_of_master_agents];
	s_seqrh=new[m_cfg.no_of_slave_agents];

	assert($cast(vsqrh,m_sequencer)) 
	 else
	    begin
		`uvm_error("BODY", "Error in $cast of virtual sequencer")
	   end
	
		foreach(m_seqrh[i])
			m_seqrh[i]=vsqrh.m_seqrh[i];
		foreach(s_seqrh[i])
			s_seqrh[i]=vsqrh.s_seqrh[i];
endtask:body


////////////////////////////////////////////////////////////////////////////////////////////

//------------------------------------ SMALL XTNS -----------------------------------------/

////////////////////////////////////////////////////////////////////////////////////////////

class router_small_vseq extends vbase_seq;
	
	`uvm_object_utils(router_small_vseq)
	
		bit[1:0]addr;
		
		router_master_small_xtns small_m_xtns;
		
		slave_pkt pkt_seq;
	
	extern function new (string name="router_small_vseq");
	extern task body();

endclass

//---------------constructor new method ----------------//
function router_small_vseq::new(string name="router_small_vseq");
	super.new(name);
endfunction


//------------------ task body() method ----------------------//
task router_small_vseq::body();

	super.body();
	
	//if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	//	`uvm_fatal(get_type_name(),"cannot get() addr from uvm_config_db. have you set?")
	
	if(m_cfg.has_magent)
		begin
		small_m_xtns=router_master_small_xtns::type_id::create("small_m_xtns");
		end
		
	if(m_cfg.has_sagent)
		begin
		pkt_seq=slave_pkt::type_id::create("pkt_seq");

		end
		
	fork
		begin
				small_m_xtns.start(m_seqrh[0]);				
		end
		
		begin	
				if(m_cfg.addr == 2'b00)
				pkt_seq.start(s_seqrh[0]);
				
				if(m_cfg.addr == 2'b01)
				pkt_seq.start(s_seqrh[1]);
				
				if(m_cfg.addr == 2'b10)
				pkt_seq.start(s_seqrh[2]);
		end
		
	join
		
endtask		
	
////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------- MEDIUM XTNS -----------------------------------------/

////////////////////////////////////////////////////////////////////////////////////////////

class router_medium_vseq extends vbase_seq;
	
	`uvm_object_utils(router_medium_vseq)
	
		bit[1:0]addr;
		
		router_master_medium_xtns medium_m_xtns;
		
		slave_pkt pkt_seq;
	
	extern function new (string name="router_medium_vseq");
	extern task body();

endclass

//---------------constructor new method ----------------//
function router_medium_vseq::new(string name="router_medium_vseq");
	super.new(name);
endfunction


//------------------ task body() method ----------------------//
task router_medium_vseq::body();

	
	super.body();
	
	if(m_cfg.has_magent)
		begin
		medium_m_xtns=router_master_medium_xtns::type_id::create("medium_m_xtns");
		end
		
	if(m_cfg.has_sagent)
		begin
		pkt_seq=slave_pkt::type_id::create("pkt_seq");

		end
		
	fork
		begin
				medium_m_xtns.start(m_seqrh[0]);				
		end
		
		begin	
				if(m_cfg.addr == 2'b00)
				pkt_seq.start(s_seqrh[0]);
				
				if(m_cfg.addr == 2'b01)
				pkt_seq.start(s_seqrh[1]);
				
				if(m_cfg.addr == 2'b10)
				pkt_seq.start(s_seqrh[2]);
		end
		
	join
		
endtask		
	
////////////////////////////////////////////////////////////////////////////////////////////

//------------------------------------ LARGE XTNS -----------------------------------------/

////////////////////////////////////////////////////////////////////////////////////////////

class router_large_vseq extends vbase_seq;
	
	`uvm_object_utils(router_large_vseq)
	
		bit[1:0]addr;
		
		router_master_large_xtns large_m_xtns;
		
		slave_pkt pkt_seq;
	
	extern function new (string name="router_large_vseq");
	extern task body();

endclass

//---------------constructor new method ----------------//
function router_large_vseq::new(string name="router_large_vseq");
	super.new(name);
endfunction


//------------------ task body() method ----------------------//
task router_large_vseq::body();

	super.body();
	if(m_cfg.has_magent)
		begin
		large_m_xtns=router_master_large_xtns::type_id::create("large_m_xtns");
		end
		
	if(m_cfg.has_sagent)
		begin
		pkt_seq=slave_pkt::type_id::create("pkt_seq");

		end
		
	fork
		begin
				large_m_xtns.start(m_seqrh[0]);				
		end
		
		begin	
				if(m_cfg.addr == 2'b00)
				pkt_seq.start(s_seqrh[0]);
				
				if(m_cfg.addr == 2'b01)
				pkt_seq.start(s_seqrh[1]);
				
				if(m_cfg.addr == 2'b10)
				pkt_seq.start(s_seqrh[2]);
		end
		
	join
		
endtask		
