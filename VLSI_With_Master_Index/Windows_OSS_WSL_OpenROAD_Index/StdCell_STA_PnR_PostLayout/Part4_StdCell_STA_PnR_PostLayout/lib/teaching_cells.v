`timescale 1ns/1ps
module INVX1(input A, output Y); assign Y=~A; endmodule
module BUFX1(input A, output Y); assign Y=A; endmodule
module AND2X1(input A,B, output Y); assign Y=A&B; endmodule
module OR2X1(input A,B, output Y); assign Y=A|B; endmodule
module XOR2X1(input A,B, output Y); assign Y=A^B; endmodule
module XNOR2X1(input A,B, output Y); assign Y=~(A^B); endmodule
module NAND2X1(input A,B, output Y); assign Y=~(A&B); endmodule
module NOR2X1(input A,B, output Y); assign Y=~(A|B); endmodule
module MUX2X1(input A,B,S, output Y); assign Y=S?B:A; endmodule
module DFFRNQX1(input D,CK,RN, output reg Q);
 always @(posedge CK or negedge RN) if(!RN) Q<=1'b0; else Q<=D;
endmodule
