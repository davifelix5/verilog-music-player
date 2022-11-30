module Player_testbench;

  reg pass_30s_tb, back_30s_tb, pass_10s_tb, back_10s_tb, clk_tb, prev_song_tb, next_song_tb, play_pause_tb;
  reg clk_timer_tb, aumenta_volume_tb, diminui_volume_tb, mute_btn_tb;

  wire[6:0] display_digit0_tb, display_digit1_tb, display_digit2_tb, display_digit4_tb;
  wire[7:0] data_tb;

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

  Player UUT(
  .clk_timer(clk_timer_tb),
  .clk(clk_tb),
  .pass_30s(pass_30s_tb),
  .back_30s(back_30s_tb),
  .pass_10s(pass_10s_tb),
  .back_10s(back_10s_tb),
  .prev_song(prev_song_tb),
  .next_song(next_song_tb),
  .play_pause(play_pause_tb),
  .aumenta_volume(aumenta_volume_tb),
  .diminui_volume(diminui_volume_tb),
  .mute_btn(mute_btn_tb),
  .display_digit0(display_digit0_tb),
  .display_digit1(display_digit1_tb),
  .display_digit2(display_digit2_tb),
  .display_digit4(display_digit4_tb),
  .data(data_tb)
);

  initial begin
    clk_tb = 1'b0;
    clk_timer_tb = 1'b0;
    pass_30s_tb = 1'b0;
    back_30s_tb = 1'b0;
    pass_10s_tb = 1'b0;
    back_10s_tb = 1'b0;
    prev_song_tb = 1'b0;
    next_song_tb = 1'b0;
    play_pause_tb = 1'b0;
    aumenta_volume_tb = 1'b0;
    diminui_volume_tb = 1'b0;
    mute_btn_tb = 1'b0;

    $monitor("\n%d (%d:%d%d)\nData: %b;\n", decoder(display_digit4_tb), decoder(display_digit2_tb), decoder(display_digit1_tb), decoder(display_digit0_tb), data_tb);
    
    $display("Pressed play_pause");
    #100 play_pause_tb = 1'b1;
    #100 play_pause_tb = 1'b0;
    #500

    #100 pass_10s_tb = 1'b1;
    #100 pass_10s_tb = 0'b0;
    $display("Pressed +10s button"); 

     #100
    aumenta_volume_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_volume_tb = 1'b0;

    #100
    aumenta_volume_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_volume_tb = 1'b0;

    #100
    aumenta_volume_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_volume_tb = 1'b0;
    #100

    diminui_volume_tb = 1'b1;
    #500
    $display("Diminuindo");
    diminui_volume_tb = 1'b0;

    #100 pass_30s_tb = 1'b1;
    #100 pass_30s_tb = 0'b0;
    $display("Pressed +30s button"); 

    #500
    #100 back_30s_tb =1'b1;
    #100 back_30s_tb = 1'b0;
    $display("Pressed -30s button");

    #100 next_song_tb = 1'b1;
    #100 next_song_tb = 1'b0;
    $display("Passando de som");

    #500
    #100 next_song_tb = 1'b1;
    #100 next_song_tb = 1'b0;
    $display("Passando de som");

    #100 play_pause_tb = 1'b1;
    #100 play_pause_tb = 1'b0;
    $display("Pressed play_pause_tb");
    #500

    #500
    #100 next_song_tb = 1'b1;
    #100 next_song_tb = 1'b0;
    $display("Passando de som");

    #500
    #100 prev_song_tb = 1'b1;
    #100 prev_song_tb = 1'b0;
    $display("Voltando de som");

    #500
    $display("Passando de som");
    #100 next_song_tb = 1'b1;
    #100 next_song_tb = 1'b0;

    #500
    #100 next_song_tb = 1'b1;
    #100 next_song_tb = 1'b0;
    $display("Passando de som");

    $display("Pressed play_pause");
    #100 play_pause_tb = 1;
    #100 play_pause_tb = 0;
    

    #15000

    $stop;
  end

  always #10 clk_tb = ~clk_tb;
  always #1000 clk_timer_tb = ~clk_timer_tb;

endmodule