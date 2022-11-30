`timescale 1ns/100ps
module ASM_musica_atual_testbench;

  reg prox_tb, prev_tb, clk_tb, reset_tb, force_prox_tb;
  wire[1:0] select_tb;
  wire start_tb;
  integer errors;

  ASM_musica_atual UUT (
    .prox(prox_tb),
    .prev(prev_tb),
    .force_prox(force_prox_tb),
    .reset(reset_tb),
    .clk(clk_tb),
    .select(select_tb),
    .start(start_tb)
  );

  task PressPrevious; 
  begin
    #100 prev_tb = 1'b1;
    #100 prev_tb = 1'b0;
  end
  endtask

  task PressProx;
  begin
    #100 prox_tb = 1'b1;
    #100 prox_tb = 1'b0;
  end
  endtask

  task Check;
  input[1:0] expect;
    if (expect != select_tb) begin
      $display("Erros: expected %b, but found %b", expect, select_tb);
      errors = errors + 1;
    end
  endtask

  initial begin
    clk_tb = 1'b0;
    prox_tb = 1'b0;
    prev_tb = 1'b0;
    reset_tb = 1'b0;
    force_prox_tb = 1'b0;
    errors = 0;
    
    $monitor("SELECT: %b, start: %b", select_tb, start_tb); #10
    
    $display("Pressing prox button twice");
    PressProx();  #100
    Check(2'b01); 
    PressProx(); #100
    Check(2'b10); 
    
    #100 $display("Pressing previous button twice");
    PressPrevious(); #100
    Check(2'b01); 
    PressPrevious(); #100
    Check(2'b00); 
    
    #100 $display("Pressing previous button again");
    PressPrevious(); #100
    Check(2'b11); 

    #100 $display("Pressin prox button");
    PressProx(); #100
    Check(2'b00); 

    $display("Pressing next two times an then reset");
    PressProx(); #100
    PressProx(); #100
    reset_tb = 1'b1; #10
    reset_tb = 1'b0; #10
    Check(2'b00);

    $display("Holding force_prox = 1 for six clock pulses - should change two times");
    force_prox_tb = 1'b1;
    #30 force_prox_tb = 1'b0;

    #100

    if (errors == 0) $display("Sem erros");
    else $display("Houve %d erros", errors);
    
    $stop;
  end

  always #10 clk_tb = ~clk_tb;

endmodule
