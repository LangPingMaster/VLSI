`timescale 1ns/1ps
module tb_postlayout;
    reg clk, rst_n;
    reg [7:0] pix_in, threshold;
    wire pix_out;
    integer errors;

    binarization dut (
        .clk(clk), .rst_n(rst_n), .pix_in(pix_in),
        .threshold(threshold), .pix_out(pix_out)
    );

    always #5 clk = ~clk;

    task check_pixel;
        input [7:0] pixel;
        input expected;
        begin
            @(negedge clk); pix_in = pixel;
            @(posedge clk); #2;
            $display("TIME=%0t pix=%0d threshold=%0d output=%b expected=%b",
                     $time,pixel,threshold,pix_out,expected);
            if (pix_out !== expected) begin
                $display("ERROR: mismatch");
                errors = errors + 1;
            end else $display("PASS");
        end
    endtask

    initial begin
        clk=0; rst_n=1; pix_in=0; threshold=128; errors=0;
        #2 rst_n=0; #18 rst_n=1;
        check_pixel(8'd0,0);   check_pixel(8'd50,0);
        check_pixel(8'd127,0); check_pixel(8'd128,1);
        check_pixel(8'd129,1); check_pixel(8'd200,1);
        check_pixel(8'd255,1);
        if (errors==0) $display("POST-LAYOUT TIMING GLS: PASS");
        else $display("POST-LAYOUT TIMING GLS: FAIL (%0d errors)",errors);
        #10 $finish;
    end
endmodule
