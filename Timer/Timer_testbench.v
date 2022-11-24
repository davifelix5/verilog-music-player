`timescale 1 ns / 100 ps
module Timer_testbench;

  /*  Inicialização das variáveis de input */
  reg count_tb, 
       reset_tb, 
       clk_tb;
  
  reg[5:0] adder_tb;

  /* Inicialização da variáveis de output */
  wire[5:0] seconds0_tb, 
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
    reset_tb = 0'b0;
    count_tb = 1'b1;
    adder_tb = 6'b1;

    $monitor("%d : %d %d", minutes0_tb, seconds1_tb, seconds0_tb);

    /* Depois de um tempo, seta o count para 0, o timer deve parar de passar */
    #1000
    $display("Setting count = 0");
    count_tb = 1'b0;

    /* Depois de mais um tempo, o count deve voltar a funcionar */
    #1000
    $display("Setting count = 1");
    count_tb = 1'b1;

    /* Resetando a contagem */
    #300
    $display("Setting reset = 1");
    reset_tb = 1'b1;
    #5
    reset_tb = 1'b0;

    /* Timer rodando de 8 em 8 segundos */
    #1000
    $display("Setting adder = 8");
    adder_tb = 6'b1000;
    #500
    $display("Setting adder = 15");
    adder_tb = 6'b1111;
    #500
    $display("Setting adder = 1");
    adder_tb = 6'b1;

    /* O timer continua por mais um tempo até parar */
    #500
    $stop;

  end

  /* Geração de um clock */
  always #5 clk_tb = ~clk_tb;

endmodule