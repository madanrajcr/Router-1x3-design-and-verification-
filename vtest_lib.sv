//Test
class base_test extends uvm_test;
	
	`uvm_component_utils(base_test)
 // Handles for ram_tb & ram_env_config
    	 tb envh;
         env_config m_tb_cfg;
         // Declare dynamic array of handles for masster_agent_config & slave_agent_config 
         master_agent_config m_master_cfg[];
         slave_agent_config slave_cfg[];

	// Declare no_of_duts, has_ragent, has_wagent as int which are local
	// variables to this test class
         int has_sagent = 1;
         int has_magent = 1;
		 
		 int no_of_magents=1;
		 int no_of_sagents=3;

		bit [1:0] addr;

	extern function new(string name = "base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass


function base_test::new(string name = "base_test" , uvm_component parent);
	super.new(name,parent);
endfunction

function void base_test::build_phase(uvm_phase phase);
 //'uvm_info("build phase TEST CLASS",uvm_low)
	m_tb_cfg = env_config::type_id::create("m_tb_cfg");
		if(has_magent)
			begin
				m_master_cfg= new[no_of_magents];
				m_tb_cfg.m_master_agent_cfg = new[no_of_magents];
				foreach( m_master_cfg[i]) 
					begin
						m_master_cfg[i]= master_agent_config :: type_id :: create($sformatf("master_cfg[%0d]",i),this);
						if(!uvm_config_db #(virtual router_src_if) :: get(this, " ",$sformatf("master_vif%0d",i),m_master_cfg[i].vif))
							`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
						m_master_cfg[i].is_active= UVM_ACTIVE;
						m_tb_cfg.m_master_agent_cfg[i]=  m_master_cfg[i];
					end
			end
               
		if(has_sagent) 
		begin
           m_tb_cfg.m_slave_agent_cfg = new[no_of_sagents];
           slave_cfg=new[no_of_sagents];
                foreach(slave_cfg[i]) 
					begin
						slave_cfg[i]= slave_agent_config :: type_id :: create($sformatf("slave_cfg[%0d]",i));
						slave_cfg[i].is_active= UVM_ACTIVE;
						if(!uvm_config_db #(virtual router_dest_if) :: get(this," ",$sformatf("vif%0d",i), slave_cfg[i].vif))
							`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
						m_tb_cfg.m_slave_agent_cfg[i]= slave_cfg[i];
					end
		end
	
	m_tb_cfg.has_magent= has_magent;
    m_tb_cfg.has_sagent= has_sagent;
	
	m_tb_cfg.no_of_master_agents=no_of_magents;
	m_tb_cfg.no_of_slave_agents=no_of_sagents;
	
	//addr={$urandom} % 3;
	addr=2'b10;
	m_tb_cfg.addr=addr;

    uvm_config_db #(env_config)::set(this,"*","env_config",m_tb_cfg);
	
 	super.build_phase(phase);
		
	envh=tb::type_id::create("envh",this);
	
endfunction



////////////////////////////////////////////////////////////////////////////////////////

//------------------------------ SMALL TRANSCTION -----------------------------------//

///////////////////////////////////////////////////////////////////////////////////////

class small_xtn_test extends base_test;
	`uvm_component_utils(small_xtn_test)

	router_small_vseq router_seqh;
	
	extern function new(string name = "small_xtn_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


//-----------------  constructor new method  -------------------//
function small_xtn_test ::new(string name = "small_xtn_test" , uvm_component parent);
	super.new(name,parent);
endfunction



//-----------------  build() phase method  -------------------//
function void small_xtn_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task small_xtn_test::run_phase(uvm_phase phase);
	$display("-------------TEST RUN PHASE--------------------------------------");
	router_seqh = router_small_vseq :: type_id :: create( "router_seqh") ;
	phase.raise_objection(this);
	router_seqh.start(envh.v_sequencer);

         #100;

	phase.drop_objection(this);
endtask



////////////////////////////////////////////////////////////////////////////////////////

//------------------------------ MEDIUM TRANSCTION -----------------------------------//

///////////////////////////////////////////////////////////////////////////////////////

class medium_xtn_test extends base_test;
	`uvm_component_utils(medium_xtn_test)

	router_medium_vseq medium_seqh;
	
	extern function new(string name = "medium_xtn_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


//-----------------  constructor new method  -------------------//
function medium_xtn_test ::new(string name = "medium_xtn_test" , uvm_component parent);
	super.new(name,parent);
endfunction



//-----------------  build() phase method  -------------------//
function void medium_xtn_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task medium_xtn_test::run_phase(uvm_phase phase);
	$display("-------------TEST RUN PHASE--------------------------------------");
	medium_seqh = router_medium_vseq :: type_id :: create( "medium_seqh") ;
	phase.raise_objection(this);
	medium_seqh.start(envh.v_sequencer);
	#100;
	phase.drop_objection(this);
endtask

////////////////////////////////////////////////////////////////////////////////////////

//------------------------------ LARGE TRANSCTION -----------------------------------//

///////////////////////////////////////////////////////////////////////////////////////

class large_xtn_test extends base_test;

	`uvm_component_utils(large_xtn_test)

	router_large_vseq large_seqh;
	
	extern function new(string name = "large_xtn_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


//-----------------  constructor new method  -------------------//
function large_xtn_test ::new(string name = "large_xtn_test" , uvm_component parent);
	super.new(name,parent);
endfunction



//-----------------  build() phase method  -------------------//
function void large_xtn_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task large_xtn_test::run_phase(uvm_phase phase);
	$display("-------------TEST RUN PHASE--------------------------------------");
	large_seqh = router_large_vseq :: type_id :: create( "large_seqh") ;
	phase.raise_objection(this);
	large_seqh.start(envh.v_sequencer);
	#500;
	phase.drop_objection(this);
endtask

