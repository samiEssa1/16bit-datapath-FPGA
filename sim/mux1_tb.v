`timescale 1ns / 1ps


module mux1_tb;

	// Inputs
	reg [15:0] in=16'b0;
	reg [15:0] B=16'b0;
	reg [15:0] A=16'b0;
	reg [15:0] ctrl=16'b0;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	mux1 uut (
		.in(in), 
		.B(B), 
		.A(A), 
		.ctrl(ctrl), 
		.out(out)
	);
	
	initial begin
		A = 16'h1234; B=16'h4334; in = 16'h5588; 
		#10;
		ctrl[6]=1'b1;
		#10;
      if  (out==16'h1234) $display ("pass 1 : mov to B");
      else $display (" fail 1 : mov B");
      #10;
      ctrl = 1'b0; ctrl[7]=1'b1;
      #10;
		if (out==16'H4334) $display ("pass 2 : mov to A");
		else $display ( "fail 2 : mov A ");
		#10
		ctrl = 1'b0; ctrl[9] = 1'b1;
		#10
		if (out == 16'h5588) $display (" pass 3 : in");
		else $display  ( "fail 3: in");
		
		$finish;
		 		
	end
      
endmodule

