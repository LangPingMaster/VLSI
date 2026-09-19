`timescale 1ns/1ps
// Teaching/reference structural netlist.
// Functionally equivalent to design.sv, using only small generic cells.
// This file is included so the complete Gate-Level Verification flow can be
// executed immediately. The separate synthesis.ys shows how to generate an
// actual Yosys netlist (binarization_yosys.v) on a machine with Yosys installed.

module binarization_gate_reference(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] pix_in,
    input  wire [7:0] threshold,
    output wire       pix_out
);

wire [7:0] nb;
wire [7:0] eq;
wire [7:0] gt_bit;

INV i_nb0(.A(threshold[0]), .Y(nb[0]));
INV i_nb1(.A(threshold[1]), .Y(nb[1]));
INV i_nb2(.A(threshold[2]), .Y(nb[2]));
INV i_nb3(.A(threshold[3]), .Y(nb[3]));
INV i_nb4(.A(threshold[4]), .Y(nb[4]));
INV i_nb5(.A(threshold[5]), .Y(nb[5]));
INV i_nb6(.A(threshold[6]), .Y(nb[6]));
INV i_nb7(.A(threshold[7]), .Y(nb[7]));

XNOR2 i_eq0(.A(pix_in[0]), .B(threshold[0]), .Y(eq[0]));
XNOR2 i_eq1(.A(pix_in[1]), .B(threshold[1]), .Y(eq[1]));
XNOR2 i_eq2(.A(pix_in[2]), .B(threshold[2]), .Y(eq[2]));
XNOR2 i_eq3(.A(pix_in[3]), .B(threshold[3]), .Y(eq[3]));
XNOR2 i_eq4(.A(pix_in[4]), .B(threshold[4]), .Y(eq[4]));
XNOR2 i_eq5(.A(pix_in[5]), .B(threshold[5]), .Y(eq[5]));
XNOR2 i_eq6(.A(pix_in[6]), .B(threshold[6]), .Y(eq[6]));
XNOR2 i_eq7(.A(pix_in[7]), .B(threshold[7]), .Y(eq[7]));

AND2 i_gt0(.A(pix_in[0]), .B(nb[0]), .Y(gt_bit[0]));
AND2 i_gt1(.A(pix_in[1]), .B(nb[1]), .Y(gt_bit[1]));
AND2 i_gt2(.A(pix_in[2]), .B(nb[2]), .Y(gt_bit[2]));
AND2 i_gt3(.A(pix_in[3]), .B(nb[3]), .Y(gt_bit[3]));
AND2 i_gt4(.A(pix_in[4]), .B(nb[4]), .Y(gt_bit[4]));
AND2 i_gt5(.A(pix_in[5]), .B(nb[5]), .Y(gt_bit[5]));
AND2 i_gt6(.A(pix_in[6]), .B(nb[6]), .Y(gt_bit[6]));
AND2 i_gt7(.A(pix_in[7]), .B(nb[7]), .Y(gt_bit[7]));

// Prefix equality: peq[k] means all bits 7..k are equal.
wire peq7, peq6, peq5, peq4, peq3, peq2, peq1, peq0;
assign peq7 = eq[7];
assign peq6 = eq[7] & eq[6];
assign peq5 = eq[7] & eq[6] & eq[5];
assign peq4 = eq[7] & eq[6] & eq[5] & eq[4];
assign peq3 = eq[7] & eq[6] & eq[5] & eq[4] & eq[3];
assign peq2 = eq[7] & eq[6] & eq[5] & eq[4] & eq[3] & eq[2];
assign peq1 = eq[7] & eq[6] & eq[5] & eq[4] & eq[3] & eq[2] & eq[1];
assign peq0 = &eq;

// A > B when the first unequal bit from MSB toward LSB is 1 in A and 0 in B.
wire t7, t6, t5, t4, t3, t2, t1, t0;
assign t7 = gt_bit[7];
assign t6 = eq[7] & gt_bit[6];
assign t5 = peq6 & gt_bit[5];
assign t4 = peq5 & gt_bit[4];
assign t3 = peq4 & gt_bit[3];
assign t2 = peq3 & gt_bit[2];
assign t1 = peq2 & gt_bit[1];
assign t0 = peq1 & gt_bit[0];

wire greater;
wire greater_equal;
assign greater = t7 | t6 | t5 | t4 | t3 | t2 | t1 | t0;
assign greater_equal = greater | peq0;

DFFRN i_out_ff(
    .D   (greater_equal),
    .CLK (clk),
    .RN  (rst_n),
    .Q   (pix_out)
);

endmodule
