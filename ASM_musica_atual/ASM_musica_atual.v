/**
 * Máquina de estados para gerenciar qual música está tocando no instante atual
 *  
 *  @input clk: sinal de clock.
 *  @input prox: botão para passar para a próxima música
 *  @input prev: botão para voltar para a música anterior
 *  @input reset: botão para voltar para a primeira música (síncrono)
 *  @output select: saída que indica os dois primeiros bits dos endereços das 
 * palavras da música na memória
 *  @output start: sinal que indica a borda de clock na qual uma música começou
 *
**/
module ASM_musica_atual (
  input wire prox,
  input wire prev,
  input wire reset,
  input wire clk,
  output reg[0:1] select,
  output reg start
);
  
  reg[2:0] state;
  
  /* Definição e codificação dos estados */
  parameter inicio = 3'b000,
            prox_m = 3'b001,
            passa = 3'b010,
            volta = 3'b011,
            prev_m = 3'b100;

  /* Parâmetro que indica a quantidade máxima de músicas */
  parameter QTD_MUSICAS = 2'b11;

  /* Condição inicial da máquina */
  initial begin
    state <= inicio;
    select = 2'b00;
    start = 1'b1;
  end

  /* Procedimento executado em toda borda de block */
  always @(posedge clk, posedge reset) begin
    
    /* Estado de reset */
    if (reset == 1'b1) begin
      select = 2'b00;
      start = 1'b1; // A música 0 irá começar a tocar
      state <= inicio;
    end

    else begin
      /* Implementação do diagrama mostrado na documentação */
      case (state) 

        inicio: begin
          if (prev == 1'b1)
            state <= prev_m;
          else if (prox == 1'b1)
            state <= prox_m;
          start = 1'b0; // Alguma música já está tocando
        end
          
        prox_m: begin
          if (prox == 1'b0)
            state <= passa;
        end

        passa: begin
          /* Select volta para o início ao passar para uma música inexistente */
          if (select == QTD_MUSICAS)
            select = 2'b0;
          else
            select = select + 2'b1;
          start = 1'b1; // Alguma música irá começar a tocar
          state <= inicio;
        end

        prev_m: begin
          if (prev == 1'b0)
            state <= volta;
        end

        volta: begin
          /* Select vai para a última música ao voltar para música inexistente */
          if (select == 2'b0)
            select = 2'b11;
          else
            select = select - 2'b1;
          start = 1'b1; // Alguma música irá começar a tocar
          state <= inicio;
        end

      endcase
    end
  
  end


endmodule