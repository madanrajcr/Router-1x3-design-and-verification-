//Router Source Sequence
class mbase_seq extends uvm_sequence #(write_xtn);  
	`uvm_object_utils(mbase_seq)  

  extern function new(string name ="mbase_seq");
  extern task body();

endclass

function mbase_seq::new(string name ="mbase_seq");
	super.new(name);
endfunction

task mbase_seq::body();    
		
endtask


/////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------SMALL PACKET -----------------------------------------/

////////////////////////////////////////////////////////////////////////////////////////////////

class router_master_small_xtns extends mbase_seq;

  	`uvm_object_utils(router_master_small_xtns)

		env_config m_cfg;

        extern function new(string name ="router_master_small_xtns");
        extern task body();
endclass


//-----------------  constructor new method  -------------------//
	function router_master_small_xtns::new(string name = "router_master_small_xtns");
		super.new(name);
	endfunction

	  
//-----------------  task body method  -------------------//
task router_master_small_xtns::body();    
		
	req= write_xtn :: type_id :: create("req");
	// repeat(1)
	//begin	
	  assert(uvm_config_db #(env_config)::get(null,get_full_name, "env_config", m_cfg));
	   start_item(req);
   	   assert(req.randomize() with {header[1:0]==m_cfg.addr && header[7:2] inside {[1:15]};} );
	   finish_item(req);
	//end 
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////

//---------------------------------------- MEDIUM PACKET ---------------------------------------/

////////////////////////////////////////////////////////////////////////////////////////////////

class router_master_medium_xtns extends mbase_seq;

  	`uvm_object_utils(router_master_medium_xtns)

	env_config m_cfg;
	
        extern function new(string name ="router_master_medium_xtns");
        extern task body();
endclass


//-----------------  constructor new method  -------------------//
	function router_master_medium_xtns::new(string name = "router_master_medium_xtns");
		super.new(name);
	endfunction

	  
//-----------------  task body method  -------------------//
task router_master_medium_xtns::body();    

	req= write_xtn :: type_id :: create("req");
	// repeat(1)
	//begin	
		  assert(uvm_config_db #(env_config)::get(null,get_full_name, "env_config", m_cfg));
	   start_item(req);
   	   assert(req.randomize() with {header[1:0]==m_cfg.addr && header[7:2] inside {[16:30]};} );
	   finish_item(req);
	//end 
endtask


/////////////////////////////////////////////////////////////////////////////////////////////////

//---------------------------------------- LARGE PACKET ---------------------------------------/

////////////////////////////////////////////////////////////////////////////////////////////////

class router_master_large_xtns extends mbase_seq;

  	`uvm_object_utils(router_master_large_xtns)

env_config m_cfg;

        extern function new(string name ="router_master_large_xtns");
        extern task body();
endclass


//-----------------  constructor new method  -------------------//
	function router_master_large_xtns::new(string name = "router_master_large_xtns");
		super.new(name);
	endfunction

	  
//-----------------  task body method  -------------------//
task router_master_large_xtns::body();    

	req= write_xtn :: type_id :: create("req");
	// repeat(1)
	//begin	
	  assert(uvm_config_db #(env_config)::get(null,get_full_name, "env_config", m_cfg));
	   start_item(req);
   	   assert(req.randomize() with {header[1:0]==m_cfg.addr ;
									header[7:2] inside {[31:63]};} );
	   finish_item(req);
	//end 
endtask
