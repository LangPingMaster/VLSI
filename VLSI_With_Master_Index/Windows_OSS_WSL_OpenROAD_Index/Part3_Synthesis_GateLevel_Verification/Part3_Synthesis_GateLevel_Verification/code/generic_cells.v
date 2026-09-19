`timescale 1ns/1ps

module INV  (input wire A, output wire Y); assign Y = ~A; endmodule
module AND2 (input wire A, B, output wire Y); assign Y = A & B; endmodule
module OR2  (input wire A, B, output wire Y); assign Y = A | B; endmodule
module XNOR2(input wire A, B, output wire Y); assign Y = ~(A ^ B); endmodule

// Generic positive-edge DFF with active-low asynchronous reset.
module DFFRN(
    input  wire D,
    input  wire CLK,
    input  wire RN,
    output reg  Q
);
  always @(posedge CLK or negedge RN) begin
    if (!RN) Q <= 1'b0;
    else     Q <= D;
  end
endmodule
