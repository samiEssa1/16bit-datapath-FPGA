module top (
input wire clk,
input wire [7:0] sw,
input wire btnu,
input wire btnd,
input wire btnl,
input wire btnr,
input wire btns,
output wire [7:0] led,
output wire [6:0] seg,
output wire [3:0] an);

wire up_clean, dn_clean;
wire up_p, dn_p, hi_p, lo_p, exec_p;
wire reset;

wire [3:0]  op;
wire [15:0] ctrl;

wire [7:0]  stage_hi;
wire [7:0]  stage_lo;
wire [15:0] staging;

wire [15:0] mux_out;
wire [15:0] a_in;
wire [15:0] A_out;
wire [15:0] B_out;
wire [15:0] C_out;
wire [15:0] alu_out;
wire        carry;

wire load_a, load_b, clear_A, clear_B, write_en, a_sel;

wire [5:0] b0, b1, b2, b3;
wire [6:0] seg_n;
wire [3:0] an_n;


button_conditioner bc_up   (.clock(clk), .btn(btnu), .limit(20'd1000000), .clean(up_clean), .pulse(up_p));
button_conditioner bc_dn   (.clock(clk), .btn(btnd), .limit(20'd1000000), .clean(dn_clean), .pulse(dn_p));
button_conditioner bc_hi   (.clock(clk), .btn(btnl), .limit(20'd1000000), .clean(),         .pulse(hi_p));
button_conditioner bc_lo   (.clock(clk), .btn(btnr), .limit(20'd1000000), .clean(),         .pulse(lo_p));
button_conditioner bc_exec (.clock(clk), .btn(btns), .limit(20'd1000000), .clean(),         .pulse(exec_p));

assign reset = up_clean & dn_clean;


opcode op_counter (.up(up_p), .down(dn_p), .clock(clk), .reset(reset), .out(op));

decoder dec (.in(op), .out(ctrl));


register8sw stage_high (.in(sw), .load(hi_p), .reset(reset), .clock(clk), .out(stage_hi));
register8sw stage_low  (.in(sw), .load(lo_p), .reset(reset), .clock(clk), .out(stage_lo));

assign staging = {stage_hi, stage_lo};


mux1 mux_b (.in(staging), .B(B_out), .A(A_out), .ctrl(ctrl), .com(alu_out), .out(mux_out));

assign a_in = a_sel ? alu_out : mux_out;


register16 reg_A (.in(a_in),    .clock(clk), .reset(reset), .clear(clear_A), .load(load_a),   .out(A_out));
register16 reg_B (.in(mux_out), .clock(clk), .reset(reset), .clear(clear_B), .load(load_b),   .out(B_out));
register16 reg_C (.in(alu_out), .clock(clk), .reset(reset), .clear(1'b0),    .load(write_en), .out(C_out));


ALU alu (.A(A_out), .B(B_out), .ctrl(ctrl), .count(carry), .out(alu_out));


controller ctl (.reset(reset), .clock(clk), .ctrl(ctrl), .exec_pulse(exec_p),
                .write_en(write_en), .mux12_control(a_sel),
                .load_a(load_a), .load_b(load_b), .clear_A(clear_A), .clear_B(clear_B),
                .disp_sel());


display_mux dmux (.A_vlaue(A_out), .B_vlaue(B_out), .opcode(op),
                  .low_p(lo_p), .high_p(hi_p), .clock(clk),
                  .load_a(load_a), .clear_A(clear_A), .load_b(load_b), .clear_B(clear_B),
                  .up(up_p), .dn(dn_p), .reset(reset),
                  .mode(), .b0(b0), .b1(b1), .b2(b2), .b3(b3));

seg7_deiver driver (.b0(b0), .b1(b1), .b2(b2), .b3(b3), .reaset(reset), .clock(clk),
                    .counter(17'd100000), .timer(), .outT(), .outb(),
                    .seg(seg_n), .an(an_n));


assign led = sw;
assign seg = ~seg_n;
assign an = ~an_n;

endmodule
