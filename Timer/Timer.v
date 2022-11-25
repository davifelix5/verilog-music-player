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
  input wire[5:0] adder,
  output reg[5:0] seconds0,
  output reg[5:0] seconds1,
  output reg[5:0] minutes0
);

  wire clk_s1, // Clock para a contagem do dítito s1
       clk_m0; // Clock para contagem do dígito s0

  /* Deve ser 1 apenas quando s0 = 1010, gerando uma borda de subida */
  assign clk_s1 = seconds0 > 6'b1001;
  /* Deve ser 1 apenas quando s1 = 0110, gerando uma borda de subida */
  assign clk_m0 = seconds1[2] & seconds1[1];

  /* Estado incial do contador */
  initial begin
    seconds0 = 6'b0;
    seconds1 = 6'b0;
    minutes0 = 6'b0;
  end

  /* Contagem do dígito s0, com o clock do input */
  always @(posedge clk, posedge reset) begin
    if (reset == 1'b1) seconds0 = 6'b0; // Zera o timer de acordo com a entrada de reset
    else begin
      if (count == 1'b1) begin
        seconds0 = seconds0 + adder;
        
        /* Um valor maior que 9 indica que apenas o último dígito deve ser mantido em seconds0 */
        if (seconds0 >= 6'b1010)
          /* Resto da divisão por 10 pega o dígito menos significativo */
          seconds0 <= seconds0 % 6'b1010; // Atribuição não bloqueável permite a subida do clk_s1
      end
     end
  end

  /* Contagem do dígito s0 */
  always @(posedge clk_s1, posedge reset) begin
    if (reset == 1'b1) seconds1 = 6'b0; // Zera o timer de acordo com a entrada de reset
    else begin
      if (count == 1'b1) begin
        seconds1 = seconds1 + (seconds0 / 10); // Divisão por 10 pega o dígita mais significativo
        
        /* Volta para 0 quando passa do 5 */
        if (seconds1 == 6'b0110)
          seconds1 <= 6'b0; // Atribuição não bloqueável permite a subida do clk_m0
      end
     end
  end

  always @(posedge clk_m0, posedge reset) begin 
    if (reset == 1'b1) minutes0 = 6'b0; // Zera o timer de acordo com a entrada de reset
    else if (count == 1'b1) begin 
      minutes0 = minutes0 + 6'b1;
      /* Volta para 0 quando passa de 9 */
      if (minutes0 == 6'b1010)
        minutes0 = 6'b0;
    end
  end


endmodule