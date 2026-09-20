module ALU (
    input  logic [31:0] instruction_i,
    input  logic [31:0] src_A_i,
    input  logic [31:0] src_B_i,
    output logic [31:0] result_o
);
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    integer i;
    integer cnt;
    integer shamt;
    logic signed [63:0] prod_ss;
    logic signed [63:0] prod_su;
    logic [63:0] prod_uu;
    logic signed [31:0] dot_sum;
    logic signed [8:0] lane_tmp;

    always @* begin
        opcode = instruction_i[6:0];
        funct3 = instruction_i[14:12];
        funct7 = instruction_i[31:25];
        shamt  = src_B_i[4:0];
        result_o = 32'b0;
        prod_ss = $signed(src_A_i) * $signed(src_B_i);
        prod_su = $signed(src_A_i) * $signed({1'b0,src_B_i});
        prod_uu = src_A_i * src_B_i;
        dot_sum = 0;
        lane_tmp = 0;

        if (opcode == 7'b0110011) begin
            case (funct7)
                7'b0000000: begin
                    case (funct3)
                        3'b000: result_o = src_A_i + src_B_i;                         // ADD
                        3'b001: result_o = src_A_i << shamt;                          // SLL
                        3'b010: result_o = ($signed(src_A_i) < $signed(src_B_i));      // SLT
                        3'b011: result_o = (src_A_i < src_B_i);                        // SLTU
                        3'b100: result_o = src_A_i ^ src_B_i;                          // XOR
                        3'b101: result_o = src_A_i >> shamt;                           // SRL
                        3'b110: result_o = src_A_i | src_B_i;                          // OR
                        3'b111: result_o = src_A_i & src_B_i;                          // AND
                        default: result_o = 0;
                    endcase
                end
                7'b0100000: begin
                    case (funct3)
                        3'b000: result_o = src_A_i - src_B_i;                          // SUB
                        3'b101: result_o = $signed(src_A_i) >>> shamt;                 // SRA
                        default: result_o = 0;
                    endcase
                end
                7'b0000001: begin
                    case (funct3)
                        3'b000: result_o = prod_uu[31:0];                              // MUL
                        3'b001: result_o = prod_ss[63:32];                             // MULH
                        3'b010: result_o = prod_su[63:32];                             // MULHSU
                        3'b011: result_o = prod_uu[63:32];                             // MULHU
                        default: result_o = 0;
                    endcase
                end
                7'b0110000: begin
                    case (funct3)
                        3'b001: result_o = (src_A_i << shamt) | (src_A_i >> ((32-shamt)&31)); // ROL
                        3'b101: result_o = (src_A_i >> shamt) | (src_A_i << ((32-shamt)&31)); // ROR
                        default: result_o = 0;
                    endcase
                end
                7'b0000101: begin
                    case (funct3)
                        3'b100: result_o = ($signed(src_A_i) < $signed(src_B_i)) ? src_A_i : src_B_i; // MIN
                        3'b110: result_o = ($signed(src_A_i) > $signed(src_B_i)) ? src_A_i : src_B_i; // MAX
                        3'b101: result_o = (src_A_i < src_B_i) ? src_A_i : src_B_i;                    // MINU
                        3'b111: result_o = (src_A_i > src_B_i) ? src_A_i : src_B_i;                    // MAXU
                        default: result_o = 0;
                    endcase
                end
                7'b0010100: if (funct3==3'b001) result_o = src_A_i | (32'b1 << shamt); // BSET
                7'b0100100: begin
                    if (funct3==3'b001) result_o = src_A_i & ~(32'b1 << shamt);        // BCLR
                    else if (funct3==3'b101) result_o = (src_A_i >> shamt) & 32'b1;    // BEXT
                end
                default: result_o = 0;
            endcase
        end else if (opcode == 7'b0010011 && funct7 == 7'b0110000 && funct3 == 3'b001) begin
            cnt = 0;
            if (instruction_i[24:20] == 5'b00000) begin                               // CLZ
                cnt = 32;
                for (i=31; i>=0; i=i-1) if (src_A_i[i] && cnt==32) cnt = 31-i;
                result_o = cnt;
            end else if (instruction_i[24:20] == 5'b00001) begin                      // CTZ
                cnt = 32;
                for (i=0; i<32; i=i+1) if (src_A_i[i] && cnt==32) cnt = i;
                result_o = cnt;
            end else if (instruction_i[24:20] == 5'b00010) begin                      // CPOP
                cnt = 0;
                for (i=0; i<32; i=i+1) cnt = cnt + src_A_i[i];
                result_o = cnt;
            end
        end else if (opcode == 7'b0001011 && funct7 == 7'b0000000) begin
            case (funct3)
                3'b000: begin                                                         // DOTP4
                    dot_sum = $signed(src_A_i[7:0])   * $signed(src_B_i[7:0]) +
                              $signed(src_A_i[15:8])  * $signed(src_B_i[15:8]) +
                              $signed(src_A_i[23:16]) * $signed(src_B_i[23:16]) +
                              $signed(src_A_i[31:24]) * $signed(src_B_i[31:24]);
                    result_o = dot_sum;
                end
                3'b001: begin                                                         // SADD8
                    for (i=0; i<4; i=i+1) begin
                        lane_tmp = $signed(src_A_i[i*8 +: 8]) + $signed(src_B_i[i*8 +: 8]);
                        if (lane_tmp > 127) result_o[i*8 +: 8] = 8'h7f;
                        else if (lane_tmp < -128) result_o[i*8 +: 8] = 8'h80;
                        else result_o[i*8 +: 8] = lane_tmp[7:0];
                    end
                end
                3'b010: begin                                                         // SSUB8
                    for (i=0; i<4; i=i+1) begin
                        lane_tmp = $signed(src_A_i[i*8 +: 8]) - $signed(src_B_i[i*8 +: 8]);
                        if (lane_tmp > 127) result_o[i*8 +: 8] = 8'h7f;
                        else if (lane_tmp < -128) result_o[i*8 +: 8] = 8'h80;
                        else result_o[i*8 +: 8] = lane_tmp[7:0];
                    end
                end
                3'b011: begin                                                         // ABS
                    if (src_A_i == 32'h80000000) result_o = 32'h7fffffff;
                    else if (src_A_i[31]) result_o = (~src_A_i) + 1'b1;
                    else result_o = src_A_i;
                end
                3'b100: begin                                                         // CLIP8
                    if ($signed(src_A_i) > 127) result_o = 32'h0000007f;
                    else if ($signed(src_A_i) < -128) result_o = 32'hffffff80;
                    else result_o = {{24{src_A_i[7]}},src_A_i[7:0]};
                end
                default: result_o = 0;
            endcase
        end
    end
endmodule
