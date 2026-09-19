`timescale 1ns/1ps
`include "../Src/ALU.sv"
module tb_ALU_hidden_defense;
  logic [31:0] instruction_i, src_A_i, src_B_i;
  wire  [31:0] result_o;
  integer total, pass, fail;
  ALU dut(.instruction_i(instruction_i),.src_A_i(src_A_i),.src_B_i(src_B_i),.result_o(result_o));

  task check;
    input [255:0] name;
    input [31:0] inst,a,b,exp;
    begin
      instruction_i=inst; src_A_i=a; src_B_i=b; #1; total=total+1;
      if (result_o === exp) begin pass=pass+1; $display("[PASS] %0s",name); end
      else begin fail=fail+1; $display("[FAIL] %0s A=%h B=%h GOT=%h EXP=%h",name,a,b,result_o,exp); end
    end
  endtask

  initial begin total=0; pass=0; fail=0;
    $display("============================================");
    $display("       ALU HIDDEN-TEST DEFENSE");
    $display("============================================");
    // RV32I boundaries
    check("ADD wrap INT_MAX+1",32'h002081b3,32'h7fffffff,32'h00000001,32'h80000000);
    check("ADD wrap FFFFFFFF+1",32'h002081b3,32'hffffffff,32'h00000001,32'h00000000);
    check("SUB wrap INT_MIN-1",32'h402081b3,32'h80000000,32'h00000001,32'h7fffffff);
    check("SLT signed -1 < +1",32'h0020a1b3,32'hffffffff,32'h00000001,32'h00000001);
    check("SLTU unsigned FFFFFFFF < 1",32'h0020b1b3,32'hffffffff,32'h00000001,32'h00000000);
    check("SLL shamt=0",32'h002091b3,32'h12345678,32'h00000000,32'h12345678);
    check("SLL shamt=31",32'h002091b3,32'h00000001,32'h0000001f,32'h80000000);
    check("SLL rs2=32 masks to 0",32'h002091b3,32'h12345678,32'h00000020,32'h12345678);
    check("SRL rs2=63 masks to 31",32'h0020d1b3,32'h80000000,32'h0000003f,32'h00000001);
    check("SRA negative shamt=31",32'h4020d1b3,32'h80000000,32'h0000001f,32'hffffffff);
    check("SRA negative shamt=1",32'h4020d1b3,32'h80000000,32'h00000001,32'hc0000000);
    // M extension
    check("MUL low signed pattern",32'h022081b3,32'hffffffff,32'h00000002,32'hfffffffe);
    check("MULH -1 * 2",32'h022091b3,32'hffffffff,32'h00000002,32'hffffffff);
    check("MULHSU -1 * FFFFFFFF",32'h0220a1b3,32'hffffffff,32'hffffffff,32'hffffffff);
    check("MULHU max*max",32'h0220b1b3,32'hffffffff,32'hffffffff,32'hfffffffe);
    // unary bit-count
    check("CLZ zero",32'h60009193,32'h00000000,32'h00000000,32'h00000020);
    check("CLZ MSB",32'h60009193,32'h80000000,32'h00000000,32'h00000000);
    check("CTZ zero",32'h60109193,32'h00000000,32'h00000000,32'h00000020);
    check("CTZ bit31",32'h60109193,32'h80000000,32'h00000000,32'h0000001f);
    check("CPOP zero",32'h60209193,32'h00000000,32'h00000000,32'h00000000);
    check("CPOP all ones",32'h60209193,32'hffffffff,32'h00000000,32'h00000020);
    // rotate / minmax / bit ops
    check("ROL shamt=0",32'h602091b3,32'h89abcdef,32'h00000000,32'h89abcdef);
    check("ROL shamt=31",32'h602091b3,32'h00000001,32'h0000001f,32'h80000000);
    check("ROR shamt=0",32'h6020d1b3,32'h89abcdef,32'h00000000,32'h89abcdef);
    check("ROR shamt=31",32'h6020d1b3,32'h00000001,32'h0000001f,32'h00000002);
    check("MIN signed INT_MIN",32'h0a20c1b3,32'h80000000,32'h7fffffff,32'h80000000);
    check("MAX signed",32'h0a20e1b3,32'hffffffff,32'h00000001,32'h00000001);
    check("MINU unsigned",32'h0a20d1b3,32'hffffffff,32'h00000001,32'h00000001);
    check("MAXU unsigned",32'h0a20f1b3,32'hffffffff,32'h00000001,32'hffffffff);
    check("BSET bit31",32'h282091b3,32'h00000000,32'h0000001f,32'h80000000);
    check("BCLR bit31",32'h482091b3,32'hffffffff,32'h0000001f,32'h7fffffff);
    check("BEXT bit31",32'h4820d1b3,32'h80000000,32'h0000001f,32'h00000001);
    // custom DSP
    check("DOTP4 all +1",32'h0020818b,32'h01010101,32'h01010101,32'h00000004);
    check("DOTP4 all -128",32'h0020818b,32'h80808080,32'h80808080,32'h00010000);
    check("SADD8 positive saturation",32'h0020918b,32'h7f7f7f7f,32'h01010101,32'h7f7f7f7f);
    check("SADD8 negative saturation",32'h0020918b,32'h80808080,32'hffffffff,32'h80808080);
    check("SSUB8 positive saturation",32'h0020a18b,32'h7f7f7f7f,32'hffffffff,32'h7f7f7f7f);
    check("SSUB8 negative saturation",32'h0020a18b,32'h80808080,32'h01010101,32'h80808080);
    check("ABS zero",32'h0000b18b,32'h00000000,32'h00000000,32'h00000000);
    check("ABS -1",32'h0000b18b,32'hffffffff,32'h00000000,32'h00000001);
    check("ABS INT_MIN saturates",32'h0000b18b,32'h80000000,32'h00000000,32'h7fffffff);
    check("CLIP8 +128",32'h0000c18b,32'h00000080,32'h00000000,32'h0000007f);
    check("CLIP8 -129",32'h0000c18b,32'hffffff7f,32'h00000000,32'hffffff80);
    check("CLIP8 -1",32'h0000c18b,32'hffffffff,32'h00000000,32'hffffffff);
    $display("============================================");
    $display("TOTAL=%0d PASS=%0d FAIL=%0d",total,pass,fail);
    if(fail==0) $display("ALL ALU DEFENSE TESTS PASS"); else $display("ALU DEFENSE HAS FAILURES");
    $display("============================================"); $finish;
  end
endmodule
