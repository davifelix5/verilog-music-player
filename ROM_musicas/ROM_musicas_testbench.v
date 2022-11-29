module ROM_musicas_testbench;

  wire signed[8:0] time_adder_tb; // Usado apenas no display
  
  /* Sinais de controle */
  reg passa_10s_tb, volta_10s_tb, passa_30s_tb, volta_30s_tb, clk_tb, prox_tb, prev_tb, play_pause;

  wire[7:0] data_tb; // Palavra atual da memória

  wire[21:0] endereco_tb; // Endereço de música genérico (sem select)
  wire[1:0] select_tb; // Bits de seleção da música
  wire[23:0] full_addr; // Endereço total da música (com select)

  wire proxima_musica_tb, // Sinal para resetar o select
       start_tb, // Sinal para resetar o endereço da música
       play;  // Sinal que indica se está em play ou pause

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

    $monitor("SELECT: %b; ADDR: %d; ADDRb: %b; Data: %b; Play: %b",select_tb, full_addr, endereco_tb, data_tb, play);
    
    $display("Pressed play_pause");
    #100 play_pause = 1'b1;
    #100 play_pause = 1'b0;
    #500

    #100 passa_10s_tb = 1'b1;
    #100 passa_10s_tb = 0'b0;
    $display("Pressed +10s button"); 

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


    #1500

    $stop;
  end

  always #10 clk_tb = ~clk_tb;

endmodule