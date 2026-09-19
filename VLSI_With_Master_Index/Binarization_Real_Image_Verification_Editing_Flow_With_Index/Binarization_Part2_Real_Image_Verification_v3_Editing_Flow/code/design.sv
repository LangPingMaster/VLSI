`timescale 1ns/1ps
module binarization(
 input wire clk, input wire rst_n, input wire [7:0] pix_in,
 input wire [7:0] threshold, output reg pix_out
);
always @(posedge clk or negedge rst_n) begin
 if(!rst_n) pix_out <= 1'b0;
 else if(pix_in >= threshold) pix_out <= 1'b1;
 else pix_out <= 1'b0;
end
endmodule
