class read_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(read_xtn)
	
bit [7:0]header;
bit [7:0]payload[];
bit [7:0]parity;
rand bit [5:0] no_of_delay;

bit valid_out,read_enb;

extern function new(string name = "read_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();

endclass:read_xtn

function read_xtn::new(string name = "read_xtn");
	super.new(name);
endfunction:new
	  
function void  read_xtn::do_print (uvm_printer printer);
    super.do_print(printer);

   
    //                   srting name   		      		    bitstream value             size       radix for printing
    printer.print_field( "header", 	            	  		this.header, 	            8,			 UVM_DEC		);
    foreach(payload[i])
    begin
    printer.print_field( $sformatf("payload[%0d]", i), 		this.payload[i], 		    8,			 UVM_DEC		);
    end

    printer.print_field( "parity", 	          				this.parity, 	            8,			  UVM_DEC		);
    printer.print_field( "no_of_delay", 		            this.no_of_delay, 	        8,		      UVM_DEC		);
 
   
  endfunction:do_print
    

function void read_xtn::post_randomize();
   parity = parity ^ header;
   foreach(payload[i])
   parity = parity ^ payload[i] ;
endfunction : post_randomize
 
