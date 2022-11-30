`timescale 1ns/100ps
module ASM_volume_testbench;

  reg aumenta_tb,
      diminui_tb,
      reset_tb,
      mute_tb,
      clk_tb;
  
  wire[3:0] volume1_tb,
            volume0_tb;

  wire mudou_volume_tb;


  ASM_volume UUT(
    .aumenta(aumenta_tb),
    .diminui(diminui_tb),
    .reset(reset_tb),
    .clk(clk_tb),
    .mute(mute_tb),
    .mudou_volume(mudou_volume_tb),
    .volume1(volume1_tb),
    .volume0(volume0_tb)
  );

  initial begin
    aumenta_tb = 1'b0;
    diminui_tb = 1'b0;
    reset_tb = 1'b0;
    mute_tb = 1'b0;
    clk_tb = 1'b0;

    $monitor ("%d %d; mudou volume = %d", volume1_tb, volume0_tb, mudou_volume_tb);

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #100
    $display("Diminuindo");
    #500 diminui_tb = 1'b1;
    #500 diminui_tb = 1'b0;

    #100
    $display("Diminuindo");
    #500 diminui_tb = 1'b1;
    #500 diminui_tb = 1'b0;

    #100
    $display("Resetando");
    #500 reset_tb = 1'b1;
    #500 reset_tb = 1'b0;

    #100
    $display("Diminuindo - não deve mudar");
    #500 diminui_tb = 1'b1;
    #500 diminui_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    #100
    $display("Tentando aumentar - nao deve acontecer nada");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;

    $display("Apertando mute");
    #500 mute_tb = 1'b1;
    #500 mute_tb = 1'b0;
    
    #100
    $stop;
  end

  always #10 clk_tb = ~clk_tb;

endmodule