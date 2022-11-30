/**
 * Módulo responsável por genrenciar o que aparece no display: volume ou tempo.
 *  
 *  @input mudou_volume: representando quando houve uma mudança de volume (lógica positiva)
 *  @input clk: sinal de clock
 *  @input reset: volta para o estado padrão (counter zerado e o tempo no display)
 *  @output display_select: sinal para selecionar o que é mostrado no display (0 para tempo e 1 para volume)
 *  
**/

module Display_select_counter(
  input wire mudou_volume,
  input wire clk,
  input wire reset,
  output reg display_select
);

  parameter clock_freq = 28'd100, // Considerando a frequência do clk_timer como 1MHz
            five_seconds = clock_freq * 5; // Fica contando por 5 passagem do timer

  reg[27:0] counter;

  initial begin
    counter = 1'b0;
    display_select = 1'b0;
  end

  always @(posedge clk) begin
    if (reset ==1'b1) begin
      display_select <= 1'b0;
      counter = 28'b0;
    end
    /* Ou a contagem iniciou ou deve iniciar */
    if (mudou_volume == 1'b1 || counter != 28'b0) begin
      if (counter < five_seconds) begin
        display_select <= 1'b1;
        counter = counter + 28'b1;
      end
      /* Se chegou na contagem máxima, reseta o select e o contador */
      else begin
        counter = 28'b0;
        display_select <= 1'b0;
      end
    end


  end

endmodule