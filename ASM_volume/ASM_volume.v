/**
 * Módulo responsável por gerenciar o funcionamento de um display de sete segmentos
 *  
 *  @input aumenta: aumenta o volume
 *  @input diminui: diminui o volume
 *  @input muta: muta o volume
 *  @input reset: reset síncrono do volume
 *  @input clk: sinal de clock
 *  @output volume1: dígito menos significativo do volume em BCD
 *  @output volume0: dígito mais significativo do volume em BCD
 *  @output mudou_volume: sinal que indica quanto o volume é alterado
 *  
**/

module ASM_volume(
  input wire aumenta,
  input wire diminui,
  input wire mute,
  input wire reset,
  input wire clk,
  output wire[3:0] volume1,
  output wire[3:0] volume0,
  output reg mudou_volume
);

  reg[2:0] state;
  reg[3:0] volume;

  parameter inicio = 3'b000,
            apertou_aumenta = 3'b001,
            soltou_aumenta = 3'b010,
            apertou_diminui = 3'b011,
            soltou_diminui = 3'b100,
            apertou_mute = 3'b101,
            soltou_mute = 3'b110;

  parameter vol_max = 4'd10;

  initial begin
    state <= inicio;
    volume = 1'b0;
    mudou_volume <= 1'b0;
  end

  assign volume1 = volume / 10;
  assign volume0 = volume % 10;

  always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
      state <= inicio;
      volume = 0;
    end
    else begin
      
      case (state) 

        inicio: begin
          mudou_volume <= 1'b0;
          if (aumenta == 1'b1)
            state <= apertou_aumenta;
          else if (diminui == 1'b1)
            state <= apertou_diminui;
          else if (mute == 1'b1)
            state <= apertou_mute;
        end

        apertou_aumenta: begin
          if (aumenta == 1'b0)
            state <= soltou_aumenta;
        end

        soltou_aumenta: begin
          if (volume < vol_max) begin
            mudou_volume <= 1'b1;
            volume = volume + 4'b1;
          end
          state <= inicio;
        end

        apertou_diminui: begin
          if (diminui == 1'b0)
            state <= soltou_diminui;
        end

        soltou_diminui: begin
          if (volume > 4'b0) begin
            mudou_volume <= 1'b1;
            volume = volume - 4'b1;
          end
          state <= inicio;
        end

        apertou_mute: begin
          if (mute == 1'b0)
            state <= soltou_mute;
        end

        soltou_mute: begin
          volume = 4'b0;
          mudou_volume <= 1'b1;
          state <= inicio;
        end
      
      endcase

    end
  end

endmodule