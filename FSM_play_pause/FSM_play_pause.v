/**
 * Máquina de estados para gerenciar se o player está tocando ou pausado.
 *  
 *  @input clk: sinal de clock.
 *  @input ent: entrada (botão que será apertado pelo usuário).
 *  @input reset: reset assíncrono do estado (volta para pause).
 *  @output saida: 1 caso play, 0 caso pause.
 *
**/
module FSM_play_pause (
  input clk,
  input ent,
  input reset,
  output reg saida
);

  reg[0:1] state;

  parameter pause_m = 2'b00,
            pause_e = 2'b01,
            play_e = 2'b10,
            play_m = 2'b11;
  
  initial begin
    state <= pause_e;
  end

  always @(posedge clk, reset) begin
    if (reset == 1'b1) state <= pause_e;
    else begin
      case (state)
        pause_e: if (ent == 1'b1) state <= play_m;
        play_m:  if (ent == 1'b0) state <= play_e;
        play_e: if (ent == 1'b1) state <= pause_m;
        pause_m: if (ent == 1'b0) state <= pause_e;
      endcase
    end
  end

  always @(state) begin 
    case (state)
      play_e, play_m: saida = 1'b1;
      pause_e, pause_m: saida = 1'b0; 
    endcase
  end
  
endmodule