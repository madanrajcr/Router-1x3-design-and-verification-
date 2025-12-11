//Router  Source Driver
class master_driver extends uvm_driver #(write_xtn);

	`uvm_component_utils(master_driver)
	
   // Declare virtual interface handle with wr_drv_mp as modport
   	virtual router_src_if.write_drv_mp vif;

   // Declare the ram_wr_agent_config handle as "m_cfg"
    master_agent_config m_cfg;

	extern function new(string name ="master_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(write_xtn xtn);
	extern function void report_phase(uvm_phase phase);
	
endclass:master_driver


//-----------------  constructor new method  -------------------//
function master_driver::new(string name ="master_driver",uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
function void master_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction:build_phase


//-----------------  connect() phase method  -------------------//
function void master_driver::connect_phase(uvm_phase phase);
   vif = m_cfg.vif;
endfunction:connect_phase


//-----------------  run() phase method  -------------------//
task master_driver::run_phase(uvm_phase phase);
	@(vif.wr_drv_cb);
		vif.wr_drv_cb.resetn <=1'b0;
	@(vif.wr_drv_cb);
		vif.wr_drv_cb.resetn <=1'b1;

    forever 
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask


//-----------------  send_to_dut method  -------------------//
task master_driver::send_to_dut(write_xtn xtn);
		
	`uvm_info("FROM WRITE DRIVER",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW) 
   

	while(vif.wr_drv_cb.busy)
	//begin
          @(vif.wr_drv_cb);
	//end
			vif.wr_drv_cb.pkt_valid <= 1'b1;
			vif.wr_drv_cb.data_in <= xtn.header;

	@(vif.wr_drv_cb);
	foreach(xtn.payload[i])
	begin
		while(vif.wr_drv_cb.busy)
			//begin
		        @(vif.wr_drv_cb);
			//end
		vif.wr_drv_cb.data_in <= xtn.payload[i];
		@(vif.wr_drv_cb);
	end
	
    vif.wr_drv_cb.pkt_valid <= 1'b0; 

	vif.wr_drv_cb.data_in <= xtn.parity;
	
	m_cfg.drv_data_sent_cnt ++ ;
//	xtn.print();

endtask


function void master_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Master driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endfunction
