`timescale 1ns/1ps
`include "../Src/FPU.sv"
module tb_FPU_hidden_defense;
  logic clk,rst,enable; logic [1:0] instruction; logic [31:0] ai,bi; wire [31:0] co; wire valid;
  integer total,pass,fail;
  FPU dut(.clk(clk),.rst(rst),.enable(enable),.instruction(instruction),.ai(ai),.bi(bi),.co(co),.valid(valid));
  initial begin clk=0; forever #5 clk=~clk; end
  task check;
    input [255:0] name; input [1:0] op; input [31:0] a,b,exp;
    begin
      @(negedge clk); instruction=op; ai=a; bi=b; enable=1;
      @(posedge clk); #1;
      if(valid!==1'b1) begin total=total+1; fail=fail+1; $display("[FAIL] %0s valid=%b expected=1",name,valid); end
      else begin total=total+1; if(co===exp) begin pass=pass+1; $display("[PASS] %0s",name); end
      else begin fail=fail+1; $display("[FAIL] %0s A=%h B=%h GOT=%h EXP=%h",name,a,b,co,exp); end end
      @(negedge clk); enable=0;
    end
  endtask
  initial begin
    total=0;pass=0;fail=0; enable=0; instruction=0; ai=0;bi=0; rst=1;
    repeat(2) @(posedge clk); @(negedge clk); rst=0;
    $display("============================================"); $display("       FPU HIDDEN-TEST DEFENSE"); $display("============================================");
    // ADD (2)
    check("ADD 1.0 + 1.0",2,32'h3f800000,32'h3f800000,32'h40000000);
    check("ADD cancellation 1 + -1",2,32'h3f800000,32'hbf800000,32'h00000000);
    check("ADD +Inf + -Inf => NaN",2,32'h7f800000,32'hff800000,32'hffc00000);
    check("ADD NaN canonical",2,32'h7fc00001,32'h3f800000,32'hffc00000);
    check("ADD +0 + -0 => +0",2,32'h00000000,32'h80000000,32'h00000000);
    check("ADD -0 + -0 => -0",2,32'h80000000,32'h80000000,32'h80000000);
    check("ADD zero passthrough",2,32'h00000000,32'hbf800000,32'hbf800000);
    check("ADD overflow => +Inf",2,32'h7f7fffff,32'h7f7fffff,32'h7f800000);
    check("ADD smallest subnormals",2,32'h00000001,32'h00000001,32'h00000002);
    check("ADD tie-even keep even",2,32'h3f800000,32'h33800000,32'h3f800000);
    check("ADD tie-even round odd up",2,32'h3f800001,32'h33800000,32'h3f800002);
    // SUB (3)
    check("SUB 1.0 - 1.0",3,32'h3f800000,32'h3f800000,32'h00000000);
    check("SUB 1.0 - -1.0",3,32'h3f800000,32'hbf800000,32'h40000000);
    check("SUB +Inf - +Inf => NaN",3,32'h7f800000,32'h7f800000,32'hffc00000);
    check("SUB +Inf - -Inf => +Inf",3,32'h7f800000,32'hff800000,32'h7f800000);
    check("SUB +0 - +0 => +0",3,32'h00000000,32'h00000000,32'h00000000);
    check("SUB -0 - +0 => -0",3,32'h80000000,32'h00000000,32'h80000000);
    // MIN (0) / MAX (1)
    check("MIN +0,-0 => -0",0,32'h00000000,32'h80000000,32'h80000000);
    check("MAX +0,-0 => +0",1,32'h00000000,32'h80000000,32'h00000000);
    check("MIN -2,+1",0,32'hc0000000,32'h3f800000,32'hc0000000);
    check("MAX -2,+1",1,32'hc0000000,32'h3f800000,32'h3f800000);
    check("MIN two negatives",0,32'hc0400000,32'hc0000000,32'hc0400000);
    check("MAX two negatives",1,32'hc0400000,32'hc0000000,32'hc0000000);
    check("MIN NaN canonical",0,32'h7fc12345,32'h3f800000,32'hffc00000);
    check("MAX NaN canonical",1,32'h3f800000,32'hffc12345,32'hffc00000);
    // protocol: valid should follow enable on next sampled clock
    @(negedge clk); enable=0; ai=32'h3f800000; bi=32'h3f800000; instruction=2;
    @(posedge clk); #1; total=total+1; if(valid===0) begin pass=pass+1;$display("[PASS] valid low when enable low");end else begin fail=fail+1;$display("[FAIL] valid low when enable low");end
    @(negedge clk); rst=1; @(posedge clk); #1; total=total+1; if(valid===0 && co===0) begin pass=pass+1;$display("[PASS] reset clears valid/co");end else begin fail=fail+1;$display("[FAIL] reset valid=%b co=%h",valid,co);end rst=0;
    $display("============================================"); $display("TOTAL=%0d PASS=%0d FAIL=%0d",total,pass,fail);
    if(fail==0) $display("ALL FPU DEFENSE TESTS PASS"); else $display("FPU DEFENSE HAS FAILURES - inspect first FAIL before editing RTL");
    $display("============================================"); $finish;
  end
endmodule
