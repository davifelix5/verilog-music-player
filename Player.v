/* Módulo principal do player
 *
 *  @input clk_timer: sinal de clock com frequência de 1 Hz,
 *  @input clk: sinal de clock do circuito,
 *  @input pass_30s: botão passar 30 segundos da música atual,
 *  @input back_30s: botão para voltar 30 segundos da música atual,
 *  @input pass_10s: botão para passar 10 segundos da música atual,
 *  @input back_10s: botão para voltar 10 segundos da música atual,
 *  @input prev_song: botão para voltar para a música anterior,
 *  @input next_song: botão para adiantar para a próxima música,
 *  @input play_pause: botão para alternar entre play e pause,
 *  @output display_digit4: dígito 4 do display,
 *  @output display_digit2: dígito 2 no display,
 *  @output display_digit1: dígito 1 no display,
 *  @output display_digit0: dígito 0 no display,
 *  @output data: endereço atual da música a ser tocado
 *
*/

module Player(
  input wire clk_timer,
  input wire clk,
  input wire pass_30s,
  input wire back_30s,
  input wire pass_10s,
  input wire back_10s,
  input wire prev_song,
  input wire next_song,
  input wire play_pause,
  input wire aumenta_volume,
  input wire diminui_volume,
  input wire mute_btn,
  output wire[6:0] display_digit0,
  output wire[6:0] display_digit1,
  output wire[6:0] display_digit2,
  output wire[6:0] display_digit4,
  output wire[7:0] data
);

  wire[21:0] endereco; // Endereço de música genérico (sem select)
  wire[1:0] select; // Bits de seleção da música
  wire[23:0] full_addr; // Endereço total da música (com select)

  wire proxima_musica, // Sinal para resetar o select
       start, // Sinal para resetar o endereço da música
       play;  // Sinal que indica se está em play ou pause


  wire signed[8:0] time_adder; // Quantida de de tempo que deve ser adicionada no relógio

  wire[3:0] minutes0, // Dígito mnoes significativo dos minutos
           seconds0, // Dígito menos significativo dos segundos
           seconds1; // Dígito mais singificativo dos seconds

  wire[3:0] volume0, // Dígito menos significativo do volume 
            volume1; // Dígito mais significativo do volume

  wire select_display,  // Seleciona o que deve ser mostrado no display
       mudou_volume,    // Indica mudança no volume
       reset_display;   // Infica se o player deve voltar a mostrar o tempo

  parameter max_addr = {22{1'b1}}; // 2^22 - 1

  assign full_addr = {select, endereco}; // Endereço completo de memória
  assign reset_display = start | time_adder != 9'b1;
  assign proxima_musica = endereco == max_addr | data == 8'b0;

  Display_select_counter DISPLAY_SELECT(
    .mudou_volume(mudou_volume),
    .display_select(select_display), 
    .reset(reset_display), // Volta para o tempo caso tenha começado uma música nova
    .clk(clk)
  );

  Display SEVEN_SEG_DISPLAY(
    .volume0(volume0),
    .volume1(volume1),
    .minutes0(minutes0),
    .seconds0(seconds0),
    .seconds1(seconds1),
    .music({2'b00, select}),
    .select(select_display),
    .digit4(display_digit4),
    .digit2(display_digit2),
    .digit1(display_digit1),
    .digit0(display_digit0)
  );

  ASM_volume VOLUME_MANAGEMENT (
    .aumenta(aumenta_volume),
    .diminui(diminui_volume),
    .mute(mute_btn),
    .reset(1'b0),
    .clk(clk),
    .mudou_volume(mudou_volume),
    .volume1(volume1),
    .volume0(volume0)
  );

  Timer TIMER (
    .reset(start), // Deve voltar para 0 quando começa outra música
    .count(play), // Deve passar apenas quando estiver em play
    .clk(clk_timer),
    .adder(time_adder), // O tempo adicionado vem da ASM de endereços
    .seconds0(seconds0),
    .seconds1(seconds1),
    .minutes0(minutes0)
  );

  ROM_musicas MEM (
    .addr(full_addr),
    .data(data)
  );

  ASM_endereco_atual CURR_ADDR (
    .passa_10s(pass_10s),
    .volta_10s(back_10s),
    .passa_30s(pass_30s),
    .volta_30s(back_30s),
    .count(play),
    .reset(start),
    .clk(clk),
    .time_adder(time_adder),
    .endereco(endereco)
  );

  ASM_musica_atual CURR_SONG (
    .prox(next_song),
    .prev(prev_song),
    .force_prox(proxima_musica),
    .reset(1'b0),
    .clk(clk),
    .select(select),
    .start(start)
  );

  FSM_play_pause PL_PA (
     .clk(clk),
     .btn(play_pause),
     .reset(1'b0),
     .saida(play)
  );


endmodule