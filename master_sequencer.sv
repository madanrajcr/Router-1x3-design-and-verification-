//Router Source sequencer
class master_sequencer extends uvm_sequencer #(write_xtn);

	`uvm_component_utils(master_sequencer)

	extern function new(string name = "master_sequencer",uvm_component parent);
endclass:master_sequencer


//-----------------  constructor new method  -------------------//
function master_sequencer::new(string name="master_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction



