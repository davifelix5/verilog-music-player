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
 *  @output seconds_lsd: dígito menos significativo dos segundos no display,
 *  @output seconds_msd: dígito mais significativo dos segundos no display,
 *  @output minutes_digit: dígito dos minutos no display,
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
  output wire[7:0] data
);

  wire[21:0] music_addr;
  wire[1:0] select;
  wire[23:0] full_addr;
  wire play, prox_musica, started_new_song;
  wire[3:0] seconds0, seconds1, minutes0, volume0, volume1;
  wire signed [8:0] time_adder;


  /* Concatena os bits de seleção com o endereço atual da música
    para formar o endereço completo que deve ser acessado na memória */
  assign full_addr = {select, music_addr};

  /* Memória de 2^24 x 8 bits que guarda as 4 músicas esperadas */
  ROM_musicas MEMO (
    .addr(full_addr),
    .data(data)
  );

  /* Máquina de estados finita (Moore) que gerencia o estado de play ou pause, controlado
    pelo sinal do botão play_pause */
  FSM_play_pause PL_PA (
    .clk(clk),
    .btn(play_pause),
    .reset(1'b0), // Por padrão, essa máquina não precisa resetar.
    .saida(play)
  );

  /* Máquina de estados algorítmica que gerencia quais são os bits de seleção da 
    música que está tocando no momento */
  ASM_musica_atual MUSICA_ATUAL (
    .prox(next_song),
    .prev(prev_song),
    .force_prox(prox_musica), // Sinal que força a máquina para a próxima música
    .reset(1'b0), // Por padrão, essa máquina não precisa resetar
    .clk(clk),
    .select(select), // Bits de seleção da música
    .start(started_new_song) // Sinaliza quando outra música foi selecionada
  );

  /* Máquina de estados algoritmica que gerencia o endereço da música que deve ser tocado
    no momento */
  ASM_endereco_atual MAQ_ADDR(
    .passa_10s(pass_10s),
    .volta_10s(back_10s),
    .passa_30s(pass_30s),
    .volta_30s(back_30s),
    .count(play), // O endereço não deve avançar se a música estivar pausada
    .reset(started_new_song), // O endereço deve resetar caso começe outra música
    .clk(clk),
    .current_value(data), // Valor atual para saber quando a música acabar
    .prox_musica(prox_musica), // Caso chegue no endereço final, a máquina sinaliza para que começe outra música
    .time_adder(time_adder), // Fala a quantidade de tempo que deve ser adicionada no timer de acordo com a entrada
    .endereco(music_addr) // Endereço da música (sem os bits de seleção)
  );

  /* Módulo que gerencia o timer que mostra quando tempo da música atual se passou */
  Timer TIME(
    .reset(prox_musica | started_new_song), // O timer deve resetar quando começa outra música
    .count(play), // O timer deve parar de avançar se a música estiver pausada
    .clk(clk_timer), // O timer deve avançar de 1 em 1 segundos (clock de 1 Hz)
    .adder(time_adder), // O timer deve avançar tempos diferentes de acordo com a entrada
    .seconds0(seconds0), // Dígito menos significativo dos segundos
    .seconds1(seconds1), // Dígito mais significativo dos segundos
    .minutes0(minutes0) // Dígito dos minutos
  );

  ASM_volume VOLUME (
    .aumenta(aumenta_volume),
    .diminui(diminui_volume),
    .mute(mute_btn),
    .reset(1'b0),
    .clk(clk),
    .volume1(volume0),
    .volume0(volume1)
  );


endmodule