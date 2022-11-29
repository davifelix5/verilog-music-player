`timescale 1ns/100ps
module ASM_endereco_atual_testbench;

  reg passa_10s_tb, volta_10s_tb, passa_30s_tb, volta_30s_tb, count_tb, reset_tb, clk_tb;
  reg[7:0] current_value_tb;
  wire[21:0] endereco_tb;
  wire signed[8:0] time_adder_tb;
  wire proxima_musica_tb;

  ASM_endereco_atual UUT (
    .passa_10s(passa_10s_tb),
    .volta_10s(volta_10s_tb),
    .passa_30s(passa_30s_tb),
    .volta_30s(volta_30s_tb),
    .count(count_tb),
    .reset(reset_tb),
    .clk(clk_tb),
    .time_adder(time_adder_tb),
    .endereco(endereco_tb),
    .prox_musica(proxima_musica_tb),
    .current_value(current_value_tb)
  );

  initial begin
    $monitor("Endereco: %d; Time adder: %d; Prox song: %d", endereco_tb, time_adder_tb, proxima_musica_tb);
    
    passa_10s_tb = 1'b0;
    volta_10s_tb = 1'b0;
    count_tb = 1'b1;
    reset_tb = 1'b0;
    clk_tb = 1'b0;
    current_value_tb = 8'b1011;

    #500
    #100 passa_10s_tb = 1'b1;
    #100 passa_10s_tb = 0'b0;
    $display("Pressed +10s button"); 

    #500
    #100 volta_10s_tb = 1'b1;
    #100 volta_10s_tb = 0'b0;
    $display("Pressed -10s button"); 
    
    #500 
    $display("Setting count = 0");
    count_tb = 1'b0;
    #500 
    $display("Setting count = 1");
    count_tb = 1'b1;
    
    #500
    $display("Seeting reset = 1");
    reset_tb = 1'b1;

    #500
    $display("Seeting reset = 0");
    reset_tb = 1'b0;

    #500
    #100 volta_10s_tb = 1'b1;
    #100 volta_10s_tb = 1'b0;
    $display("Pressed -10s button (must not change)"); 

    #500
    #100 passa_30s_tb =1'b1;
    #100 passa_30s_tb = 1'b0;
    $display("Pressed +30s button");

    #500
    #100 volta_30s_tb =1'b1;
    #100 volta_30s_tb = 1'b0;
    $display("Pressed -30s button");

    #500
    #100 volta_30s_tb =1'b1;
    #100 volta_30s_tb = 1'b0;
    $display("Pressed -30s button (must not change)");

    #500
    $display("Setting o valor PCM atual para 0 (addr must reset)");
    current_value_tb = 8'b0;
    #500 current_value_tb = 8'b1011;
    $display("Serring current value to something != 0");

    #500
    $stop;
  end

  always #5 clk_tb = ~clk_tb;

endmodule