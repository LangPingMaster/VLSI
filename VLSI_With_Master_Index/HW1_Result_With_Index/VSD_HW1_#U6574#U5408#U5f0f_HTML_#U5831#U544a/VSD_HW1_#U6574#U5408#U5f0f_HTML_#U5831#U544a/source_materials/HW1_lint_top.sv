module HW1_lint_top(
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,
    input  logic [1:0]  fpu_instruction,
    input  logic [31:0] instruction_i,
    input  logic [31:0] src_A_i,
    input  logic [31:0] src_B_i,
    input  logic [31:0] ai,
    input  logic [31:0] bi,
    output logic [31:0] alu_result_o,
    output logic [31:0] fpu_co,
    output logic        fpu_valid
);
ALU u_alu(.instruction_i(instruction_i),.src_A_i(src_A_i),.src_B_i(src_B_i),.result_o(alu_result_o));
FPU u_fpu(.clk(clk),.rst(rst),.enable(enable),.instruction(fpu_instruction),.ai(ai),.bi(bi),.co(fpu_co),.valid(fpu_valid));
endmodule
