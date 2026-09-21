`timescale 1ns/10ps
`define PatternPATH "pattern_alu.csv"
`include "ALU.sv"

module tb_ALU;

localparam DATA_WIDTH   = 32;
localparam INST_WIDTH   = 32; 

reg   [INST_WIDTH-1:0  ]   instruction_i;
reg   [DATA_WIDTH-1:0  ]   src_A_i;
reg   [DATA_WIDTH-1:0  ]   src_B_i;
wire  [DATA_WIDTH-1:0  ]   result_o;

int error[31];
int score[31] = '{default:2}; 
int total_score = 0;
int fail_count = 0;

int fd, nread;
string line;
int inst_id;
logic [31:0] inst_hex, a_hex, b_hex, exp_hex;

ALU ALU (
    .instruction_i (instruction_i),
    .src_A_i       (src_A_i),
    .src_B_i       (src_B_i),
    .result_o      (result_o)
);

initial begin
  instruction_i = 32'd0;
  src_A_i       = 32'd0;
  src_B_i       = 32'd0;
  
  for(int i=0; i<31; i++) error[i] = 0;

  fd = $fopen(`PatternPATH, "r");
  if (fd == 0) begin
    $display("[ERROR] Cannot open %s", `PatternPATH);
    $finish;
  end

  while (!$feof(fd)) begin
    void'($fgets(line, fd));
    if (line.len() == 0) continue;

    nread = $sscanf(line, "%d,%h,%h,%h,%h", inst_id, inst_hex, a_hex, b_hex, exp_hex);
    if (nread != 5) continue;

    instruction_i = inst_hex;
    src_A_i       = a_hex;
    src_B_i       = b_hex;
    #10;
    
    if($isunknown(result_o))begin
      $display(" ============ Unknown value occurs at result_o (Inst ID: %0d) ============", inst_id);
      $finish;
    end
    else begin
      if(result_o !== exp_hex)begin
        error[inst_id] += 1;
        if(error[inst_id] <= 5) 
          $display("[FAIL] Inst %0d | A=%h B=%h Inst=%h | GOT=%h EXP=%h", inst_id, src_A_i, src_B_i, instruction_i, result_o, exp_hex);
      end
    end
  end
  $fclose(fd);

  $display("\n========================================");

  
  for(int i=0; i<31; i++) begin
     if(error[i] === 0) begin
        $display("Instruction %2d ALL PASS !!!", i);
        total_score += score[i];
     end else begin
        $display("Instruction %2d FAILED (%0d errors)", i, error[i]);
        fail_count++;
     end
  end
  $display("========================================");

  if(fail_count == 0)begin
    $display("\n");
    $display(" ****************************               ");
    $display(" **                        **       |\\__||  ");
    $display(" **  Congratulations !!    **      / O.O  | ");
    $display(" **                        **    /_____   | ");
    $display(" **  Simulation PASS!!     **   /^ ^ ^ \\  |");
    $display(" **                        **  |^ ^ ^ ^ |w| ");
    $display(" ****************************   \\m___m__|_|");
  end
  else begin
    $display("\n");
    $display(" ****************************               ");
    $display(" **                        **       |\\__||  ");
    $display(" **  OOPS!!                **      / X,X  | ");
    $display(" **                        **    /_____   | ");
    $display(" **  Simulation Failed!!   **   /^ ^ ^ \\  |");
    $display(" **                        **  |^ ^ ^ ^ |w| ");
    $display(" ****************************   \\m___m__|_|");
  end
  
  $display("\n====== Your score : %2d ======\n", total_score);
  $finish;
end

initial begin
    `ifdef FSDB
        $dumpfile("ALU.fsdb");
        $dumpvars(0, tb_ALU);
    `endif
end

endmodule