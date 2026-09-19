`timescale 1ns/1ps
module tb_binarization_mapped;
localparam N=65536; reg clk,rst_n; reg [7:0] pix_in,threshold; wire pix_out; reg [7:0] img_mem[0:N-1]; integer i,fout;
binarization dut(.clk(clk),.rst_n(rst_n),.pix_in(pix_in),.threshold(threshold),.pix_out(pix_out));
initial clk=0; always #5 clk=~clk;
initial begin $readmemh("gray.hex",img_mem); fout=$fopen("mapped_binary.txt","w"); threshold=8'd128; rst_n=0; pix_in=0; #12 rst_n=1;
 for(i=0;i<N;i=i+1) begin @(negedge clk); pix_in=img_mem[i]; @(posedge clk); #1; $fwrite(fout,"%0d\n",pix_out); end
 $fclose(fout); $display("Mapped GLS: Processed %0d pixels. Done.",N); #10 $finish; end
endmodule
