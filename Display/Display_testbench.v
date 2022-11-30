`timescale 1ns/100ps
module Display_testbench;

  wire[3:0] minutes0_tb,
           seconds0_tb,
           seconds1_tb;

  wire[3:0] volume0_tb, volume1_tb;
  
  reg reset_tb, clk_tb, clk_timer, aumenta_tb, diminui_tb, mute_tb, reset_display_tb;

  wire mudou_volume_tb;

  wire select_tb;
  
  wire[6:0] digit2_tb,
            digit1_tb,
            digit0_tb,
            digit4_tb;

  function [4:0] decoder;
  /* Função para traduzir o valor de 7 segmentos para um número BCD (facilitar debuging) */
  input [6:0] code;
  begin
    case (code)
			7'b1000000: decoder = 4'b0000; // 0
			7'b1111001: decoder = 4'b0001; // 1
			7'b0100100: decoder = 4'b0010; // 2
			7'b0110000: decoder = 4'b0011; // 3
			7'b0011001: decoder = 4'b0100; // 4
			7'b0010010: decoder = 4'b0101; // 5
			7'b0110010: decoder = 4'b0110; // 6
			7'b1111000: decoder = 4'b0111; // 7
			7'b0000000: decoder = 4'b1000; // 8
			7'b0010000: decoder = 4'b1001; // 9
			default: decoder = 4'b0; // Inválido
		endcase
  end
  endfunction

  Display_select_counter UUT1(
    .mudou_volume(mudou_volume_tb),
    .display_select(select_tb),
    .reset(reset_display_tb),
    .clk(clk_tb)
  );

  Display UUT2(
    .volume0(volume0_tb),
    .volume1(volume1_tb),
    .minutes0(minutes0_tb),
    .seconds0(seconds0_tb),
    .seconds1(seconds1_tb),
    .music(4'b01),
    .select(select_tb),
    .digit4(digit4_tb),
    .digit2(digit2_tb),
    .digit1(digit1_tb),
    .digit0(digit0_tb)
  );

  ASM_volume UUT(
    .aumenta(aumenta_tb),
    .diminui(diminui_tb),
    .mute(mute_tb),
    .reset(1'b0),
    .clk(clk_tb),
    .mudou_volume(mudou_volume_tb),
    .volume1(volume1_tb),
    .volume0(volume0_tb)
  );

  Timer UUT3 (
    .reset(1'b0), // Deve integrar com o início de uma próxima música
    .count(1'b1), // Deve integrar com play/pause
    .clk(clk_timer),
    .adder(9'b1), // Deve integrar com a máquina de endereços
    .seconds0(seconds0_tb),
    .seconds1(seconds1_tb),
    .minutes0(minutes0_tb)
  );


  initial begin
    aumenta_tb = 1'b0;
    diminui_tb = 1'b0;
    mute_tb = 1'b0;
    clk_tb = 1'b0;
    clk_timer = 1'b0;
    reset_display_tb = 1'b0;

    $monitor("%d   %d %d %d %t",decoder(digit4_tb), decoder(digit2_tb), decoder(digit1_tb), decoder(digit0_tb), $realtime);
    
    #4000

    #100
    aumenta_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_tb = 1'b0;
    
    diminui_tb = 1'b1;
    #500
    diminui_tb = 1'b0;
    $display("Diminuindo");

    #10000
    $stop;
  end

  always #10 clk_tb = ~clk_tb;
  always #1000 clk_timer = ~clk_timer;

endmodule