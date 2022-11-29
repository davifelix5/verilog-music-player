/**
 * Módulo responsável por gerenciar o timer que mostrará o quanto tempo de música se passou
 *  
 *  @input reset: faz com que o timer zere (síncrono).
 *  @input count: indica se o timer deve (1) ou não (0) funcionar.
 *  @input clk: clock responsável por coordenar a contagem (1 Hz esperado).
 *  @output seconds0 (s0): dígito menos significativo dos segundos (0-9)
 *  @output seconds1 (s1): dígito mais significativo dos segundos (0-5)
 *  @output minutes0 (m0): dígito dos minutos (0-9)
 *
**/

module Timer (
  input wire reset,
  input wire count,
  input wire clk,
  input wire signed[8:0] adder,
  output wire[3:0] seconds0,
  output wire[3:0] seconds1,
  output wire[3:0] minutes0
);

  reg[8:0] seconds;

  assign minutes0 = seconds / 60;
  assign seconds1 = (seconds % 60) / 10;
  assign seconds0 = (seconds % 60) % 10;

  initial begin
    seconds = 0'b0;
  end

  /* Contagem do dígito s0, com o clock do input */
  /* O adder pode ser settado de forma assíncrona */
  always @(posedge clk, posedge reset) begin
    if (reset == 1'b1)
      seconds = 9'b0; // Zera o timer de acordo com a entrada de reset
    else if (count == 1'b1)
      seconds = seconds + adder;
  end

  /* Passa o timer quando o adder de forma assíncrona muda para algo diferente de 1 */
  always @(adder) begin
    // So adiciona de forma assíncrona quando é passado um adder customizado 
    if (adder != 1'b1)
      seconds = seconds + adder;
  end

endmodule