`timescale 1 ns / 100 ps
module FSM_play_pause_testbench;

  /* Declaração das variáveis usadas no testbench */ 
  reg btn_tb, clk_tb, reset_tb;
  wire saida_tb;
  /* Variável para contagem de erros */
  integer errors;

  /* Criação do modelo a ser testado */ 
  FSM_play_pause UUT (
     .clk(clk_tb),
     .btn(btn_tb),
     .reset(reset_tb),
     .saida(saida_tb)
  );
  

  initial begin

    errors = 0;
    /* Condições iniciais do teste */
    btn_tb = 1'b0;
    clk_tb = 1'b1;
    reset_tb = 1'b1;

    $monitor("PLAY/PAUSE atual: %d", saida_tb);

    /* O reset começa em 0 */
    #10 reset_tb = 0; #10
    
    /* O botão é pressionado */
    btn_tb = 1'b1; #500
    btn_tb = 1'b0; #1000
    
    /* A saída deve ser 1 */
    #10 if (saida_tb == 1'b0) errors = errors + 1; #10

    /* O botão é pressionado novamente */
    btn_tb = 1'b1; #500
    btn_tb = 1'b0; #1000

    /* A saída deve ser 0 */
    #10 if (saida_tb == 1'b1) errors = errors + 1; #10

    /* O botão é pressionado, mas em seguida é feito um reset */
    btn_tb = 1'b1; #500
    btn_tb = 1'b0; #100
    reset_tb = 1'b1;
    /* A saída deve permanecer em 0 */
    #10 if (saida_tb == 1'b1) errors = errors + 1; #10


    if (errors == 0) $display("Teste completed successfuly!");
    else $display("%d errors", errors);
    
    $stop;
  end

  /* Criação de um clock artificial */
  always #5 clk_tb = ~clk_tb;

endmodule