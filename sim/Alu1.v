`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:29:47 10/03/2026
// Design Name:   ALU
// Module Name:   /home/ise/share/Microprocessor_project/Alu1.v
// Project Name:  Microprocessor_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Alu;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [15:0] ctrl;

	// Outputs
	wire count;
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B), 
		.ctrl(ctrl), 
		.count(count), 
		.out(out)
	);

	initial begin
	        
			            //tast LSL
			  #10
			  A = 16'b1100110010101111; 
			  #10
			  ctrl[4] = 1'b1;
			  #10
			  if ({count,out}== 17'b11001100101011110) $display ( "LSL pass");
			  else $display ( "LSL fall");
			                //test complement
			  #10
			   ctrl = 1'b0;
			  #10
			  ctrl[8]= 1'b1;
			  #10
			  if ( out == ~A)  $display (" ~A pass");
			  else $display ( "~A fall");
			                   // test add
				#10
				ctrl = 1'b0; B =16'b1111111111111111;
				#10
				ctrl[10] = 1'b1;
				#10
				if ({count,out} == A+B) $display ( "add pass");
				else $display ( "add fall");
				               //sub test
									
				#10
				ctrl = 1'b0; 
				#10
				ctrl[11] = 1'b1; 
				#10
				if ({count,out} == {1'b0,A} - {B, 1'b0}) $display ( "sub pass");
				else $display ("sub fall");
				
				              // test inc
				#10 
				ctrl = 1'b0;
				#10
				ctrl [12] = 1'b1;
				#10
				if ( {count,out}== 17'b1100110010110000) $display ( " inc pass");
				else $display ( "inc fall");
				
				                 //test dec
				#10 
				ctrl = 1'b0;
				#10
				ctrl[13] = 1'b1;
				#10
				if (out == 16'b1100110010101110) $display (" dec pass");
				else $display (" dec fall");
				
				                  // test and 
				#10
				A= 15'b0; B= 15'b1; ctrl = 1'b0;
				#10 
				ctrl [14] = 1'b1;
				#10
				if (out ==15'b0) $display (" and pass");
				else $display (" and fall");
				                 
									   //test or
										
				#10
				ctrl =1'b0;
				#10
				ctrl[15] = 1'b1;
				#10
				if (out == 15'b1) $display (" or pass");
				else $display (" or fall");
				
				$finish;
				
				
			  
		

	end
      
endmodule

