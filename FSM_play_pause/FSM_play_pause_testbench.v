`timescale 1 ns / 100 ps
module FSM_play_pause_testbench;

  reg ent_tb, clk_tb, reset_tb;
  wire saida_tb;
  integer errors;

  FSM_play_pause UUT (
     .clk(clk_tb),
     .ent(ent_tb),
     .reset(reset_tb),
     .saida(saida_tb)
  );
  

  initial begin
    ent_tb = 1'b0;
    clk_tb = 1'b1;
    reset_tb = 1'b1;
    errors = 0;

    $monitor("PLAY/PAUSE atual: %d", saida_tb);
  
    #10 reset_tb = 0; #10
    
    ent_tb = 1'b1; #500
    ent_tb = 1'b0; #1000
    
    #10 if (saida_tb == 1'b0) errors = errors + 1; #10

    ent_tb = 1'b1; #500
    ent_tb = 1'b0; #1000

    #10 if (saida_tb == 1'b1) errors = errors + 1; #10

    ent_tb = 1'b1; #500
    ent_tb = 1'b0; #100
    reset_tb = 1'b1;

    #10 if (saida_tb == 1'b1) errors = errors + 1; #10


    if (errors == 0) $display("Teste completed successfuly!");
    else $display("%d errors", errors);
    
    $stop;
  end

  always #5 clk_tb = ~clk_tb;

endmodule