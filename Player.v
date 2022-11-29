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
  output wire[6:0] seconds_lsd,
  output wire[6:0] seconds_msd,
  output wire[6:0] minutes_digit,
  output wire[7:0] data
);

  wire[21:0] music_addr;
  wire[1:0] select;
  wire[23:0] full_addr;
  wire play, prox_musica, started_new_song;
  wire[5:0] seconds0, seconds1, minutes0;
  wire signed [8:0] time_adder;

  assign full_addr = play ? {select, music_addr} : 8'b0;

  ROM_musicas MEMO (
    .addr(full_addr),
    .data(data)
  );

  FSM_play_pause PL_PA (
    .clk(clk),
    .btn(play_pause),
    .reset(1'b0),
    .saida(play)
  );

  ASM_musica_atual MUSICA_ATUAL (
    .prox(next_song),
    .prev(prev_song),
    .force_prox(prox_musica),
    .reset(1'b0),
    .clk(clk),
    .select(select),
    .start(started_new_song)
  );

  ASM_endereco_atual MAQ_ADDR(
    .passa_10s(pass_10s),
    .volta_10s(back_10s),
    .passa_30s(pass_30s),
    .volta_30s(back_30s),
    .count(play),
    .reset(started_new_song),
    .clk(clk),
    .prox_musica(prox_musica),
    .time_adder(time_adder),
    .endereco(music_addr)
  );

  Timer TIME(
    .reset(prox_musica | started_new_song),
    .count(play),
    .clk(clk_timer),
    .adder(time_adder),
    .seconds0(seconds0),
    .seconds1(seconds1),
    .minutes0(minutes0)
  );

  driver7seg DISPLAY1 (
    .b(seconds0),
    .d(seconds_lsd)
  );

  driver7seg DISPLAY2 (
    .b(seconds1),
    .d(seconds_msd)
  );

  driver7seg DISPLAY3 (
    .b(seconds1),
    .d(seconds_msd)
  );

endmodule