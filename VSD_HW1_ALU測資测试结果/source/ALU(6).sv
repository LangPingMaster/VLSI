module ALU (
    input  logic [31:0] instruction_i,
    input  logic [31:0] src_A_i,
    input  logic [31:0] src_B_i,
    output logic [31:0] result_o
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] rs1_date;
    logic [31:0] rs2_date;
    logic [4:0] rs2_for_count;
    logic signed [63:0] mul_ss;
    logic        [63:0] mul_uu;
    assign opcode = instruction_i[6:0];
    assign funct3 = instruction_i[14:12];
    assign funct7 = instruction_i[31:25];
    assign rs1_date = src_A_i;
    assign rs2_date = src_B_i;
    assign rs2_for_count = instruction_i[24:20];

always_comb begin : ALU_SIM

    if (opcode == 7'b0110011) begin
        case (funct3)
           3'b000 : begin
            case (funct7)
                7'b0000000 : result_o = rs1_date + rs2_date ;
                7'b0100000 : result_o = rs1_date - rs2_date ;
                7'b0000001 : result_o = (rs1_date * rs2_date);
                default: result_o = 32'd0;
            endcase
           end  
           3'b001 : begin
            case (funct7)
               7'b0000000 : result_o = rs1_date << (rs2_date[4:0]);
               7'b0000001 : begin
                    mul_ss =  ($signed(rs1_date) * $signed(rs2_date)) ;
                    result_o = mul_ss[63:32] ;
               end
               7'b0110000 : result_o = rotate_left(rs1_date, rs2_date[4:0]);
               7'b0010100 : result_o = rs1_date | (1 << rs2_date[4:0]);
               7'b0100100 : result_o = rs1_date & ~(1 << rs2_date[4:0]);
                default: result_o = 32'd0;
            endcase
           end
           3'b010 : begin
            if (funct7 == 7'b0000000) result_o = ($signed(rs1_date) < $signed(rs2_date)) ? 1 : 0  ;
            else begin
                mul_ss = ({{33{rs1_date[31]}},rs1_date}) * {{33{1'b0}}, rs2_date} ;
                result_o = mul_ss[63:32];
            end
           end
           3'b011 : begin
            if (funct7 == 7'b0000000) result_o = ($unsigned(rs1_date) < $unsigned(rs2_date)) ? 1 : 0 ;
            else begin
                mul_uu = ($unsigned(rs1_date) * $unsigned(rs2_date)) ;
                result_o = mul_uu[63:32];
            end
           end
           3'b100 : result_o = (funct7 == 7'b0000000) ? rs1_date ^ rs2_date : (($signed(rs1_date) < $signed(rs2_date)) ? rs1_date : rs2_date);
           3'b101 : begin
            case (funct7)
                7'b0000000 : result_o = rs1_date >> (rs2_date[4:0]);
                7'b0100000 : result_o = $signed(rs1_date) >>> (rs2_date[4:0]);
                7'b0110000 : result_o = rotate_right(rs1_date, rs2_date[4:0]);
                7'b0000101 : result_o = ($unsigned(rs1_date) < $unsigned(rs2_date)) ? rs1_date : rs2_date;
                7'b0100100 : result_o = (rs1_date >> rs2_date[4:0]) & 32'b1;
                default: result_o = 32'd0;
            endcase
           end 
           3'b110 : result_o = (funct7 == 7'b0000000) ? rs1_date | rs2_date :  ($signed(rs1_date) > $signed(rs2_date)) ? rs1_date : rs2_date;
           3'b111 : result_o = (funct7 == 7'b0000000) ?  rs1_date & rs2_date : ($unsigned(rs1_date) > $unsigned(rs2_date)) ? rs1_date : rs2_date;
        default : result_o = 32'd0 ;
        endcase
    end
    else if(opcode == 7'b0010011) begin
        case (rs2_for_count)
            5'b00000 : result_o = count_leading_zeros(rs1_date);
            5'b00001 : result_o = count_trailing_zeros(rs1_date);
            5'b00010 : result_o = count_ones(rs1_date);
            default: result_o = 32'd0;
        endcase
    end else begin
        case (funct3)
           3'b000 : result_o = DOTP4(rs1_date,rs2_date);
           3'b001 : result_o = SADD8(rs1_date,rs2_date);
           3'b010 : result_o = SSUB8(rs1_date,rs2_date);
           3'b011 : result_o = ABS(rs1_date);
           3'b100 : result_o = CLIP8(rs1_date);
            default: result_o = 32'd0;
        endcase
    end

end
    
    function automatic logic [31:0] rotate_left(
        input logic [31:0] data1,
        input logic [4:0] data2
    );
    integer i;
    for(i=0; i<data2;i++)begin
        data1 = {data1[30:0] , data1[31]};
    end
        rotate_left = data1;
    endfunction

    function automatic logic [31:0] rotate_right(
        input logic [31:0] data1,
        input logic [4:0] data2
    );
    integer i;
    for(i=0; i<data2;i++)begin
        data1 = {data1[0], data1[31:1]};
    end
        rotate_right = data1;
    endfunction
    function automatic logic [31:0] count_leading_zeros(
        input logic [31:0] data1
    );
    integer i;
    logic found;
    logic [31:0] count;
    count = 32'd0;
    found = 1'b0;
    for(i=0; i<32;i++)begin
        if (data1[31-i]==0 && found == 1'b0) begin
            count = count + 32'd1;
        end else begin
            found = 1'b1;
        end
    end
        count_leading_zeros = count;
    endfunction
    function automatic logic [31:0] count_trailing_zeros(
        input logic [31:0] data1
    );
    integer i;
    logic found;
    logic [31:0] count;
    count = 32'd0;
    found = 1'b0;
    for(i=0; i<32;i++)begin
        if (data1[i]==0 && found == 1'b0) begin
            count = count + 32'd1;
        end else begin
            found = 1'b1;
        end
    end
        count_trailing_zeros = count;
    endfunction
    function automatic logic [31:0] count_ones(
        input logic [31:0] data1
    );
    integer i;
    logic [31:0] count;
    count = 32'd0;
    for(i=0; i<32;i++)begin
        if (data1[i]==1) begin
            count = count + 32'd1;
        end
    end
        count_ones = count;
    endfunction
    function automatic logic [31:0] DOTP4(
        input logic [31:0] data1,
        input logic [31:0] data2
    );
    integer i;
    logic [63:0] mul;
    logic [31:0] result;
    result = 32'd0;
    for(i=0; i<4;i++)begin
        mul = $signed(data1[8*i+:8])*$signed(data2[8*i+:8]);
        result = result + mul;
    end
        DOTP4 = result;
    endfunction
    function automatic logic [31:0] SADD8(
        input logic [31:0] data1,
        input logic [31:0] data2
    );
    integer i;
    logic signed [8:0] temp;
    logic [31:0] result;
    result = 32'd0;
    for(i=0; i<4;i++)begin
        temp =$signed({data1[8*i+7],data1[8*i+:8]})+$signed({data2[8*i+7],data2[8*i+:8]});
        result[8*i+:8] = SAT8(temp);
    end
        SADD8 = result;
    endfunction
    function automatic logic [31:0] SSUB8(
        input logic [31:0] data1,
        input logic [31:0] data2
    );
    integer i;
    logic signed [8:0] temp;
    logic [31:0] result;
    result = 32'd0;
    for(i=0; i<4;i++)begin
        temp = $signed({data1[8*i+7],data1[8*i+:8]})- $signed({data2[8*i+7],$signed(data2[8*i+:8])});
        result[8*i+:8] = SAT8(temp);
    end
        SSUB8 = result;
    endfunction
    function automatic logic [7:0] SAT8(
        input logic signed [8:0] data
    );
    logic [7:0] result;
    if (data >9'sd127) begin
        result = 8'h7F;
    end else if (data<-9'sd128) begin
        result = 8'h80;
    end else begin
        result = data[7:0];
    end
        SAT8 = result;
    endfunction
    function automatic logic [31:0] ABS(
        input logic [31:0] data
    );
    logic [31:0] result;
    result = (data == 32'h80000000) ? 32'h7FFFFFFF : (($signed(data) < 0) ? -$signed(data) : data);
        ABS = result;
    endfunction
    function automatic logic [31:0] CLIP8(
        input logic [31:0] data
    );
    logic signed [31:0] result;
    result = ($signed(data) > 127) ? 32'sd127 : ($signed(data) < -128) ? -32'sd128 : $signed(data);
        CLIP8 = result;
    endfunction
endmodule

