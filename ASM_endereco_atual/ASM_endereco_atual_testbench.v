`timescale 1ns/100ps
module ASM_endereco_atual_testbench;

  reg passa_10s_tb, volta_10s_tb, count_tb, reset_tb, clk_tb;
  wire[21:0] endereco_tb;

  ASM_endereco_atual UUT (
    .passa_10s(passa_10s_tb),
    .volta_10s(volta_10s_tb),
    .count(count_tb),
    .reset(reset_tb),
    .clk(clk_tb),
    .endereco(endereco_tb)
  );

  initial begin
    $monitor("Endereco: %d", endereco_tb);
    
    passa_10s_tb = 1'b0;
    volta_10s_tb = 1'b0;
    count_tb = 1'b1;
    reset_tb = 1'b0;
    clk_tb = 1'b0;

    #1000
    #100 passa_10s_tb = 1'b1;
    #100 passa_10s_tb = 0'b0;
    $display("Pressed +10s button"); 

    #1000
    #100 volta_10s_tb = 1'b1;
    #100 volta_10s_tb = 0'b0;
    $display("Pressed -10s button"); 
    
    #1000 
    $display("Setting count = 0");
    count_tb = 1'b0;
    #500 
    $display("Setting count = 1");
    count_tb = 1'b1;
    
    #1000
    $display("Seeting reset = 1");
    reset_tb = 1'b1;

    #1000
    $display("Seeting reset = 0");
    reset_tb = 1'b0;

    #1000
    #100 volta_10s_tb = 1'b1;
    #100 volta_10s_tb = 0'b0;
    $display("Pressed -10s button (must not change)"); 

    #1000
    $stop;
  end

  always #5 clk_tb = ~clk_tb;

endmodule