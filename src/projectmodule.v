`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:54 10/02/2026 
// Design Name: 
// Module Name:    projectmodule 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module register16(

input wire [15:0] in,
input wire clock,
input wire reset,
input wire clear,
input wire load,
output reg [15:0] out );

     always @(posedge clock) begin
	       if (reset)          out <= 16'd0;
			 else if (clear)     out <= 16'd0;
			 else if (load)      out <= in;
		end

endmodule

module register8sw(
input wire [7:0] in,
input wire load,
input wire reset,
input wire clock,
output reg [7:0] out);

       always @(posedge clock) begin
		       if (load)          out <= in;
				 else if(reset)    out <=8'd0;
		 end

endmodule	

	
module mux1( 
input wire [15:0] in,
input wire [15:0] B,
input wire [15:0] A,
input wire [15:0] ctrl,
input wire [15:0] com,
output reg [15:0] out);

      always @(*) begin
		case (1'b1)
		     ctrl[6]: out = A ;
			  ctrl[7]: out = B ;
			  ctrl[9]: out = com;
			  default: out = in ;
			  
		endcase
	end
endmodule	


module decoder (
input wire [3:0] in,
output reg [15:0] out);

        always@(*) begin
		  case (in)
                 4'b0000 : out = 16'b0000000000000001;	
                 4'b0001 : out = 16'b0000000000000010;			  
		           4'b0010 : out = 16'b0000000000000100;
					  4'b0011 : out = 16'b0000000000001000;
					  4'b0100 : out = 16'b0000000000010000;
					  4'b0101 : out = 16'b0000000000100000;
					  4'b0110 : out = 16'b0000000001000000;
					  4'b0111 : out = 16'b0000000010000000;
					  4'b1000 : out = 16'b0000000100000000;
					  4'b1001 : out = 16'b0000001000000000;
					  4'b1010 : out = 16'b0000010000000000;
					  4'b1011 : out = 16'b0000100000000000;
					  4'b1100 : out = 16'b0001000000000000;
					  4'b1101 : out = 16'b0010000000000000;
					  4'b1110 : out = 16'b0100000000000000;
					  4'b1111 : out = 16'b1000000000000000;
					  default: out = 16'b0;
			endcase
     end
endmodule



module opcode ( 
input wire up,
input wire down,
input wire clock,
input wire reset,
output reg [3:0] out);

       always@ ( posedge clock) begin
               if (reset)                     out <= 4'b0;
					else if (up)                   out <= out+1'b1;
					else if (down)                 out <= out-1'b1;
		  end
endmodule
					

module ALU ( 
input wire [15:0] A,
input wire [15:0] B,
input wire [15:0] ctrl,
output reg count,
output reg [15:0] out);

         always@(*) begin
			count = 1'b0;
			case (1'b1)
			      
					 ctrl[4] : {count, out } = { A, 1'b0};
					 ctrl[5] : {out, count } = {1'b0, A};
          		 ctrl[8] : out = ~A;
					 ctrl[9]: out = ~B;
					 ctrl[10]: {count,out} = A + B;
					 ctrl[11]: {count,out} = {1'b0, A} - {1'b0, B};
					 ctrl[12]: {count,out} = A + 1'b1;
					 ctrl[13]: out = A - 1'b1;
					 ctrl[14]: out = A & B;
					 ctrl[15]: out = A | B;
					 default : out = A;
			endcase
			
		end
endmodule


module controller (
input wire reset,
input wire clock,
input wire [15:0] ctrl,
input wire exec_pulse,
output wire write_en,
output wire mux12_control,
output wire load_a,
output wire load_b,
output wire clear_A,
output wire clear_B,
output reg disp_sel);


wire writes_a = ctrl[0]  | ctrl[4]  | ctrl[5]  | ctrl[7]  | ctrl[8] | ctrl[10] | ctrl[11] | ctrl[12] | ctrl[13] | ctrl[14] | ctrl[15];

wire writes_b = ctrl[1] | ctrl[6] | ctrl[9];  

wire writes_c = ctrl[10] | ctrl[11] | ctrl[14] | ctrl [15];

assign load_a =  exec_pulse &  writes_a ; 
assign load_b =  exec_pulse &  writes_b ;
assign clear_A = exec_pulse & ctrl[2] ;
assign clear_B = exec_pulse & ctrl[3] ;
assign write_en =exec_pulse & writes_c ;
assign mux12_control = ctrl[4]  | ctrl[5]  | ctrl[8]  | ctrl[10] | ctrl[11] | ctrl[12] | ctrl[13] | ctrl[14] | ctrl[15];
  
 
        always @(posedge clock) begin
        if (reset)           disp_sel <= 1'b0;
        else if (exec_pulse) disp_sel <= writes_b | ctrl[3];
    end
endmodule	


 
module display_mux (
input wire [15:0] A_vlaue,
input wire [15:0] B_vlaue,
input wire [3:0] opcode,
input wire low_p,
input wire high_p,
input wire clock,
input wire load_a,
input wire clear_A,
input wire load_b,
input wire clear_B,
input wire up,
input wire dn,
input wire reset,
output reg [1:0] mode,
output reg [5:0] b0,
output reg [5:0] b1,
output reg [5:0] b2,
output reg [5:0] b3);

        always  @ (posedge clock) begin
		  if (load_a | clear_A )       mode <= 2'b11;
		  else if ( load_b | clear_B)  mode <= 2'b01;
		  else if ( up | dn )          mode <= 2'b10;
        else 		                   mode <= 2'b00;  
      end


        always @ (posedge clock) begin 

		  if (high_p)     begin b3 <= 6'b010000;
		                        b0 <= 6'b111111;
										b2 <= 6'b101111;
										b1 <= 6'b111111;
								end
		  
		  else if (low_p)   begin b3 <= 6'b010001;
		                          b0 <= 6'b111111;
										  b1 <= 6'b111111;
										  b2 <= 6'b110111;
								   end
        else if (	mode == 2'b10)					  
		          case (opcode)
					 
					   4'b0000  :    begin b0 <= 6'b010010;
		                                b1 <= 6'b111111;
										        b2 <= 6'b111011;
										        b3 <= 6'b110111;
										  end
				      4'b0001  :    begin b0 <= 6'b010011;
						                    b1 <= 6'b111111;
										        b2 <= 6'b111011;
										        b3 <= 6'b110111;
								        end
				      4'b0010  :    begin b0 <= 6'b010100;
						                    b1 <= 6'b111111;
										        b2 <= 6'b111011;
										        b3 <= 6'b110111;
								        end
				      4'b0011  :    begin b0 <= 6'b010101;
						                    b1 <= 6'b111111;
										        b2 <= 6'b111011;
										        b3 <= 6'b110111;
								        end
				      4'b0100  :    begin b0 <= 6'b010110;
						                    b1 <= 6'b111111;
										        b2 <= 6'b111011;
										        b3 <= 6'b110111;
								        end
				      4'b0101  :     begin b0 <= 6'b010111;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								         end
				      4'b0110  :     begin b0 <= 6'b011000;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								        end
				      4'b0111  :     begin b0 <= 6'b011001;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								        end
				      4'b1000  :     begin b0 <= 6'b011010;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								         end
				      4'b1001  :     begin b0 <= 6'b011011;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								         end
				      4'b1010  :     begin b0 <= 6'b011100;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								        end
			     	   4'b1011  :     begin b0 <= 6'b011101;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								        end
				      4'b1100  :     begin b0 <= 6'b011110;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								        end
				      4'b1101  :     begin b0 <= 6'b011111;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								         end
				      4'b1110  :     begin b0 <= 6'b100000;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								        end
				      4'b1111  :     begin b0 <= 6'b100001;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111011;
										         b3 <= 6'b110111;
								         end
				      default  :     begin b0 <= 6'b010010;
						                     b1 <= 6'b111111;
										         b2 <= 6'b111111;
										         b3 <= 6'b111111;
								          end
			
			        endcase
					  
			else if (mode == 2'b01)        begin   b0 <= {2'b0 , B_vlaue[3:0]};
		                                    b1 <= {2'b0 , B_vlaue[7:4]};
				                              b2 <= {2'b0 , B_vlaue[11:8]};
														b3 <= {2'b0 , B_vlaue[15:12]};
											 end
			
         else if ( mode == 2'b11)         begin   b0 <= {2'b0 , A_vlaue[3:0]};
		                                    b1 <= {2'b0 , A_vlaue[7:4]};
				                              b2 <= {2'b0 , A_vlaue[11:8]};
														b3 <= {2'b0 , A_vlaue[15:12]};				 
		                             end		

										
		else if (reset)      begin b3 <= 6'b111111;
		                           b0 <= 6'b111111;
										   b2 <= 6'b111111;
										   b1 <= 6'b111111;
												end
	 end
endmodule


		  
module seg7_deiver (

input wire [5:0] b0,
input wire [5:0] b1,
input wire [5:0] b2,
input wire [5:0] b3,
input wire reaset,
input wire clock,
input wire [16:0] counter,
output reg [16:0] timer,
output reg [1:0] outT,
output reg [5:0] outb,
output reg [6:0] seg,
output reg [3:0] an);

reg start = 1'b1;
reg [1:0] A = 2'b0;
              always@(posedge clock) begin
				          
			               if (reaset)            timer <= 17'b0;
								else if (start)       begin timer <= counter;
								                            start <= 0;
																	 
															 end
						      else if (timer !=0)   timer <= timer - 1'b1;
								else                begin  if (A < 2'b11) A<= A+1'b1;
								                           else      A<=2'b00;
								                           start <= 1'b1;
															end
                  end
						
				 always@(posedge clock) begin
				    
					   case (A) 
						    2'b00       :   begin outb <= b0;
							                    an <= 4'b1110;
												end
							 2'b01       :   begin outb <= b1;
							                    an <= 4'b1101;
											  end
							 2'b10       :   begin outb <= b2;
							                    an <= 4'b1011;
										     end
							 2'b11       :   begin outb <= b3;
							                    an<= 4'b0111;
											  end
						endcase
						
					  case (outb)
					  
					  6'b111111     :  seg <= 7'b1111111;
					  6'b010000     :  seg <= 7'b1001000;
					  6'b101111     :  seg <= 7'b1001111;
					  6'b010001     :  seg <= 7'b1110001;
					  6'b110111     :  seg <= 7'b0000001;
					  6'b111011     :  seg <= 7'b0011000;
					  6'b010010     :  seg <= 7'b0000001;
					  6'b010011     :  seg <= 7'b1001111;
					  6'b010100     :  seg <= 7'b0010010;
					  6'b010101     :  seg <= 7'b0000110;
					  6'b010110     :  seg <= 7'b1001100;
					  6'b010111     :  seg <= 7'b0100100;
					  6'b011000     :  seg <= 7'b0100000;
					  6'b011001     :  seg <= 7'b0001111;
					  6'b011010     :  seg <= 7'b0000000;
					  6'b011011     :  seg <= 7'b0000100;
					  6'b011100     :  seg <= 7'b0001000;
					  6'b011101     :  seg <= 7'b1100000;
					  6'b011110     :  seg <= 7'b0110001;
					  6'b011111     :  seg <= 7'b1000010;
					  6'b100000     :  seg <= 7'b0110000;
					  6'b100001     :  seg <= 7'b0111000;
					  6'b000000     :  seg <= 7'b0000001;
					  6'b000001     :  seg <= 7'b1001111;
					  6'b000010     :  seg <= 7'b0010010;
					  6'b000011     :  seg <= 7'b0000110;
					  6'b000100     :  seg <= 7'b1001100;
					  6'b000101     :  seg <= 7'b0100100;
					  6'b000110     :  seg <= 7'b0100000;
					  6'b000111     :  seg <= 7'b0001111;
					  6'b001000     :  seg <= 7'b0000000;
					  6'b001001     :  seg <= 7'b0000100;
					  6'b001010     :  seg <= 7'b0001000;
					  6'b001011     :  seg <= 7'b1100000;
					  6'b001100     :  seg <= 7'b0110001;
					  6'b001101     :  seg <= 7'b1000010;
					  6'b001110     :  seg <= 7'b0110000;
					  6'b001111     :  seg <= 7'b0111000;
				  
				  endcase
		end
endmodule
				  
	           											 
module button_conditioner (
input wire clock,
input wire btn,
input wire [19:0] limit,
output reg clean,
output reg pulse);

reg sync1 = 1'b0;
reg sync2 = 1'b0;
reg clean_prev = 1'b0;
reg [19:0] count = 20'b0;

        always @(posedge clock) begin
            sync1 <= btn;
            sync2 <= sync1;
        end

        always @(posedge clock) begin
            if (sync2 == clean)          count <= 20'b0;
            else if (count == limit)     begin clean <= sync2;
                                               count <= 20'b0;
                                         end
            else                         count <= count + 1'b1;
        end

        always @(posedge clock) begin
            clean_prev <= clean;
            pulse <= 1'b0;
            if (clean == 1'b1 && clean_prev == 1'b0)   pulse <= 1'b1;
        end

endmodule
																 
                                    																	 
				  
         
      		  
		  
		  
		  
