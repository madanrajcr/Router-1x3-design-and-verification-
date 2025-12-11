class write_xtn extends uvm_sequence_item;

    `uvm_object_utils(write_xtn)

rand bit[7:0]header;
rand bit[7:0]payload[];
 bit[7:0]parity;
bit pkt_valid,resten,busy;
//bit error;
bit err;


constraint addr{ header[1:0] != 2'b11; }
constraint valid_length{ header[7:2] !=0; }
constraint size{payload.size == header[7:2]; }

extern function new(string name = "write_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();

endclass:write_xtn

function write_xtn::new(string name = "write_xtn");
	super.new(name);
endfunction:new
	  
function void  write_xtn::do_print (uvm_printer printer);
    super.do_print(printer);

   
    //                   srting name   		      		    bitstream value             size       radix for printing
    printer.print_field( "header", 	            	  		this.header, 	            8,			 UVM_BIN		);
    foreach(payload[i])
    begin
    printer.print_field( $sformatf("payload[%0d]", i), 		this.payload[i], 		    8,			 UVM_DEC		);
    end

    printer.print_field( "parity", 	          				this.parity, 	            8,			  UVM_DEC		);
	//printer.print_field( "error", 	          				this.error, 	            1,			  UVM_DEC		);
	printer.print_field( "error", 	          				this.err, 	            1,			  UVM_DEC		);
	
	printer.print_field( "busy", 	          				this.busy, 	                1,			  UVM_DEC		);
    
   
  endfunction:do_print
    

function void write_xtn::post_randomize();
  parity = parity ^ header;
   foreach(payload[i])
   parity = parity ^ payload[i] ;
endfunction : post_randomize
 
