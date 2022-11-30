module ROM_musicas_testbench;
  
  /* Sinais de controle */
  reg passa_10s_tb, volta_10s_tb, passa_30s_tb, volta_30s_tb, clk_tb, prox_tb, prev_tb, play_pause;

  wire[7:0] data_tb; // Palavra atual da memória

  wire[21:0] endereco_tb; // Endereço de música genérico (sem select)
  wire[1:0] select_tb; // Bits de seleção da música
  wire[23:0] full_addr; // Endereço total da música (com select)

  wire proxima_musica_tb, // Sinal para resetar o select
       start_tb, // Sinal para resetar o endereço da música
       play;  // Sinal que indica se está em play ou pause


  wire signed[8:0] time_adder_tb;

  wire[3:0] minutes0_tb,
           seconds0_tb,
           seconds1_tb;

  wire[3:0] volume0_tb, volume1_tb;
  
  reg clk_timer, aumenta_tb, diminui_tb, mute_tb;

  wire[6:0] digit2_tb,
            digit1_tb,
            digit0_tb;

  wire select_display_tb, mudou_volume_tb;

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

  Display_select_counter UUT5(
    .mudou_volume(mudou_volume_tb),
    .display_select(select_display_tb),
    .reset(proxima_musica_tb | start_tb),
    .clk(clk_tb)
  );

  Display UUT6(
    .volume0(volume0_tb),
    .volume1(volume1_tb),
    .minutes0(minutes0_tb),
    .seconds0(seconds0_tb),
    .seconds1(seconds1_tb),
    .select(select_display_tb),
    .digit2(digit2_tb),
    .digit1(digit1_tb),
    .digit0(digit0_tb)
  );

  ASM_volume UUT7(
    .aumenta(aumenta_tb),
    .diminui(diminui_tb),
    .mute(mute_tb),
    .reset(1'b0),
    .clk(clk_tb),
    .mudou_volume(mudou_volume_tb),
    .volume1(volume1_tb),
    .volume0(volume0_tb)
  );

  Timer UUT8 (
    .reset(proxima_musica_tb | start_tb), // Deve integrar com o início de uma próxima música
    .count(play), // Deve integrar com play/pause
    .clk(clk_timer),
    .adder(time_adder_tb), // Deve integrar com a máquina de endereços
    .seconds0(seconds0_tb),
    .seconds1(seconds1_tb),
    .minutes0(minutes0_tb)
  );

  ROM_musicas UUT (
    .addr(full_addr),
    .data(data_tb)
  );

  ASM_endereco_atual UUT2 (
    .passa_10s(passa_10s_tb),
    .volta_10s(volta_10s_tb),
    .passa_30s(passa_30s_tb),
    .volta_30s(volta_30s_tb),
    .count(play),
    .reset(start_tb),
    .clk(clk_tb),
    .current_value(data_tb),
    .time_adder(time_adder_tb),
    .endereco(endereco_tb),
    .prox_musica(proxima_musica_tb)
  );

  ASM_musica_atual UUT3 (
    .prox(prox_tb),
    .prev(prev_tb),
    .force_prox(proxima_musica_tb),
    .reset(1'b0),
    .clk(clk_tb),
    .select(select_tb),
    .start(start_tb)
  );

  FSM_play_pause UUT4 (
     .clk(clk_tb),
     .btn(play_pause),
     .reset(1'b0),
     .saida(play)
  );

  assign full_addr = {select_tb, endereco_tb};

  initial begin
    clk_tb = 1'b0;
    passa_10s_tb = 1'b0;
    volta_10s_tb = 1'b0;
    passa_30s_tb = 1'b0;
    volta_30s_tb = 1'b0;
    prox_tb = 1'b0;
    prev_tb = 1'b0;
    play_pause = 1'b0;
    aumenta_tb = 1'b0;
    diminui_tb = 1'b0;
    mute_tb = 1'b0;
    clk_timer = 1'b0;

    $monitor("\n(%d:%d%d) -- %d\nSELECT: %b; ADDR: %d; ADDRb: %b; Data: %b; Play: %b\n", decoder(digit2_tb), decoder(digit1_tb), decoder(digit0_tb), select_display_tb, select_tb, full_addr, endereco_tb, data_tb, play);
    
    $display("Pressed play_pause");
    #100 play_pause = 1'b1;
    #100 play_pause = 1'b0;
    #500

    #100 passa_10s_tb = 1'b1;
    #100 passa_10s_tb = 0'b0;
    $display("Pressed +10s button"); 

     #100
    aumenta_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_tb = 1'b0;

    #100
    aumenta_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_tb = 1'b0;

    #100
    aumenta_tb = 1'b1;
    #500
    $display("Aumentando");
    aumenta_tb = 1'b0;
    #100

    diminui_tb = 1'b1;
    #500
    $display("Diminuindo");
    diminui_tb = 1'b0;

    #100 passa_30s_tb = 1'b1;
    #100 passa_30s_tb = 0'b0;
    $display("Pressed +30s button"); 

    #500
    #100 volta_30s_tb =1'b1;
    #100 volta_30s_tb = 1'b0;
    $display("Pressed -30s button");

    #100 prox_tb = 1'b1;
    #100 prox_tb = 1'b0;
    $display("Passando de som");

    #500
    #100 prox_tb = 1'b1;
    #100 prox_tb = 1'b0;
    $display("Passando de som");

    #100 play_pause = 1'b1;
    #100 play_pause = 1'b0;
    $display("Pressed play_pause");
    #500

    #500
    #100 prox_tb = 1'b1;
    #100 prox_tb = 1'b0;
    $display("Passando de som");

    #500
    #100 prev_tb = 1'b1;
    #100 prev_tb = 1'b0;
    $display("Voltando de som");

    #500
    $display("Passando de som");
    #100 prox_tb = 1'b1;
    #100 prox_tb = 1'b0;

    #500
    #100 prox_tb = 1'b1;
    #100 prox_tb = 1'b0;
    $display("Passando de som");

    $display("Pressed play_pause");
    #100 play_pause = 1;
    #100 play_pause = 0;
    

    #15000

    $stop;
  end

  always #10 clk_tb = ~clk_tb;
  always #1000 clk_timer = ~clk_timer;

endmodule