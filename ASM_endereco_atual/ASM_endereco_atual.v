/**
 * Máquina de estados para gerenciar os endereços de memória a serem acessados
 *  
 *  @input passa_10s: botão para passar 10 segundos da música
 *  @input volta_10s: botão para voltar 10 segundos da música atual
 *  @input passa_30s: botão para passar 30 segundos da música
 *  @input volta_30s: botão para voltar 30 segundos da música atual
 *  @input count: indica se a contagem deve ou não continuar.
 *  @input reset: botão para reiniciar a música (voltar a contagem para o início)
 *  @input clk: sinal de clock.
 *  @output endereco: últimos 22 bits para o endereço da palavra atual da música
 *
**/
module ASM_endereco_atual(
  input wire passa_10s,
  input wire volta_10s,
  input wire passa_30s,
  input wire volta_30s,
  input wire count,
  input wire reset,
  input wire clk,
  output wire prox_musica,
  output reg[21:0] endereco
);

  reg[3:0] state;

  /* Condificação dos estados */
  parameter inicio = 4'b000,
            apertou_mais_10s = 4'b0001,
            soltou_mais_10s = 4'b0010,
            apertou_menos_10s = 4'b0011,
            soltou_menos_10s = 4'b0100,
            apertou_mais_30s = 4'b0101,
            soltou_mais_30s = 4'b0110,
            apertou_menos_30s = 4'b0111,
            soltou_menos_30s = 4'b1000;
  
  /* Parâmetros úteis */
  parameter addrs_por_segundo = 22'd3000, // 3kHz
            dez_segundos = 10 * addrs_por_segundo,
            trinta_segundos = 30 * addrs_por_segundo,
            max_addr = {22{1'b1}}; // 2^20 - 1
  
  assign prox_musica = endereco == max_addr; // Reseta quando chega no máximo

  /* Estado incial da máquina */
  initial begin
    state <= inicio;
    endereco = 22'b0;
  end

  always @(posedge clk, posedge reset) begin
    /* Estado de reset */
    if (reset == 1'b1 | prox_musica == 1'b1) begin
      state <= inicio;
      endereco = 22'b0;
    end

    /* O fluxo da máquina deve continuar apenas se count for nível lógico alto */
    else if (count == 1'b1) begin
      /* Implementação do diagrama ASM da documentação */
      case (state) 

        inicio: begin
          endereco = endereco + 22'b1;
          if (passa_10s == 1'b1)
            state <= apertou_mais_10s;
          else if (volta_10s == 1'b1)
            state <= apertou_menos_10s;
          else if (passa_30s == 1'b1)
            state <= apertou_mais_30s;
          else if (volta_30s == 1'b1)
            state <= apertou_menos_30s;
        end

        apertou_menos_30s: begin
          endereco = endereco + 22'b1;
          if (volta_30s == 1'b0)
            state <= soltou_menos_30s;
        end

        soltou_menos_30s: begin 
          if (endereco >= trinta_segundos)
            endereco = endereco - trinta_segundos;
          state <= inicio;
        end
        
        apertou_mais_30s: begin
          endereco = endereco + 22'b1;
          if (passa_30s == 1'b0)
            state <= soltou_mais_30s;
        end

        soltou_mais_30s: begin 
          if (endereco <= max_addr - trinta_segundos)
            endereco = endereco + trinta_segundos;
          else
            endereco = max_addr;
          state <= inicio;
        end

        apertou_mais_10s: begin
          endereco = endereco + 22'b1;
          if (passa_10s == 1'b0)
            state <= soltou_mais_10s;
        end

        soltou_mais_10s: begin
          if (endereco <= max_addr - dez_segundos)
            endereco = endereco + dez_segundos;
          else
            endereco = max_addr;
          state <= inicio;
        end

        apertou_menos_10s: begin
          endereco = endereco + 22'b1;
          if (volta_10s == 1'b0)
            state <= soltou_menos_10s;
        end

        soltou_menos_10s: begin
          if (endereco >= dez_segundos) // A música só deve voltar se for possível
            endereco = endereco - dez_segundos;
          state <= inicio;
        end
      endcase

    end

  end

endmodule