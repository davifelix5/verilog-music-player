`timescale 1 ns / 100 ps
module Timer_adder_testbench;

  /*  Inicialização das variáveis de input */
  reg count_tb, 
       reset_tb, 
       clk_tb;
  
  reg[8:0] adder_tb;

  /* Inicialização da variáveis de output */
  wire[3:0] seconds0_tb, 
           seconds1_tb, 
           minutes0_tb;

  /* Inicialização do módulo a ser testado */
  Timer UUT (
    .reset(reset_tb),
    .count(count_tb),
    .clk(clk_tb),
    .adder(adder_tb),
    .seconds0(seconds0_tb),
    .seconds1(seconds1_tb),
    .minutes0(minutes0_tb)
  );

  initial begin 
    /* Condições inciais */
    clk_tb = 1'b0;
    reset_tb = 1'b0;
    count_tb = 1'b1;
    adder_tb = 9'b1;

    $monitor("%d : %d %d", minutes0_tb, seconds1_tb, seconds0_tb);

    /* Mesmo sem clock, deve mudar o valor */
    adder_tb = 9'd30;

  end


endmodule