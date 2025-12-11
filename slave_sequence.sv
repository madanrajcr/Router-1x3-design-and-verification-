//Destination sequence
class slave_base_seq extends uvm_sequence #(read_xtn);  
	
	`uvm_object_utils(slave_base_seq)  

        extern function new(string name ="slave_base_seq");
endclass:slave_base_seq


function slave_base_seq::new(string name ="slave_base_seq");
	super.new(name);
endfunction:new

////////////////////////////////////////////////////////////////////

//--------------------------- SLAVE SEQ --------------------------//

///////////////////////////////////////////////////////////////////

class slave_pkt extends slave_base_seq;
	
	`uvm_object_utils(slave_pkt)
	
	extern function new(string name="slave_pkt");
	extern task body();

endclass

function slave_pkt::new(string name="slave_pkt");
	super.new(name);
endfunction

task slave_pkt::body();

	super.body();
	begin
		req=read_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_delay==2;});
		finish_item(req);
	end
	
endtask


class slave_corrupt_pkt extends slave_base_seq;
	
	`uvm_object_utils(slave_corrupt_pkt)
	
	extern function new(string name="slave_corrupt_pkt");
	extern task body();

endclass

function slave_corrupt_pkt::new(string name="slave_corrupt_pkt");
	super.new(name);
endfunction

task slave_corrupt_pkt::body();

	super.body();
	begin
		req=read_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_delay inside {[0:30],31};});
		finish_item(req);
	end
	
endtask