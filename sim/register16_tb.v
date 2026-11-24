`timescale 1ns / 1ps

module register16_tb;

	// Inputs
	reg [15:0] in = 16'b0;
	reg clock  = 0  ;
	reg reset   = 0;
	reg clear    = 0 ;
	reg load     =0 ;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	register16 uut (
		.in(in), 
		.clock(clock), 
		.reset(reset), 
		.clear(clear), 
		.load(load),  
		.out(out)
	);
    always #5 clock =~clock;
	 
	 initial begin
	                  // rest test
		@(negedge clock) in = 16'hFFFF; load = 1 ;
		@(negedge clock); load = 0; reset=1;
		@(negedge clock) reset=0;
		if (out == 16'b0) $display (" pass 1 : rest");
		else $display ("fail 1 : rest");
	
	               
		                // load test
		in = 16'hFFBC; load =1;
		@(negedge clock) load=0;
		if (out == 16'hFFBC) $display ( "pass 2 : load");
		else $display ( "fail 2 : load");
		
		                  //clear
		@(negedge clock) in = 16'h1234;	load = 1;
		@( negedge clock) load = 0 ; clear = 1;
		@ (negedge clock) clear =0;
		if (out == 0) $display (" pass 3 : clear");
		else $display ( "fail 3: clear");
		
		               //  make sure there no mix betewwn rest and load
		@(negedge clock) in = 16'h3214; load = 1;
		@ (negedge clock) reset = 1;
		@(negedge clock) in = 16'h1234 ; load = 1; reset =0;
		@(negedge clock) load =0; reset =0;
		if (out == 16'h1234) $display (" pass 4 : conflicts");
		else $display ( "fail 4: conflicts");
		
		@(negedge clock) in = 16'h3214; load = 1;
		@ (negedge clock) reset = 1;
		@(negedge clock) in = 16'h1234 ; load = 1;
		@(negedge clock) load =0; reset =0;
		if (out == 16'h0) $display (" pass 5 : conflicts");
		else $display ( "fail 5: conflicts");
		$display("test done");
      $finish;
	end
		 		
      
endmodule



