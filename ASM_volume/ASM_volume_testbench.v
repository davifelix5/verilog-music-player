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

  integer errors;

  task Check;
  input[3:0] expect1, expect0;
    begin
      if (volume0_tb != expect0) begin
        $display("Expecting %b (%d), but got %b (%d)", expect0, expect0, volume0_tb, volume0_tb);
        errors = errors + 1;
      end

      if (volume1_tb != expect1) begin
        $display("Expecting %b (%d), but got %b (%d)", expect0, expect0, volume1_tb, volume1_tb);
        errors = errors + 1;
      end
    end
  endtask


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
    errors = 0;

    $monitor ("%d %d; mudou volume = %d", volume1_tb, volume0_tb, mudou_volume_tb);

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;
    #100 Check(0, 1);

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;
    #100 Check(0, 2);

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;
    #100 Check(0, 3);

    #100
    $display("Aumentando");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;
    #100 Check(0, 4);


    #100
    $display("Diminuindo");
    #500 diminui_tb = 1'b1;
    #500 diminui_tb = 1'b0;
    #100 Check(0, 3);


    #100
    $display("Diminuindo");
    #500 diminui_tb = 1'b1;
    #500 diminui_tb = 1'b0;
    #100 Check(0, 2);


    #100
    $display("Resetando");
    #500 reset_tb = 1'b1;
    #500 reset_tb = 1'b0;
    #100 Check(0, 0);


    #100
    $display("Diminuindo - não deve mudar");
    #500 diminui_tb = 1'b1;
    #500 diminui_tb = 1'b0;
    #100 Check(0, 0);

    repeat (10) begin
      #500 aumenta_tb = 1'b1;
      #500 aumenta_tb = 1'b0;
    end
    #100 Check(1, 0);

    #100
    $display("Tentando aumentar - nao deve acontecer nada");
    #500 aumenta_tb = 1'b1;
    #500 aumenta_tb = 1'b0;
    #100 Check(1, 0);


    $display("Apertando mute");
    #500 mute_tb = 1'b1;
    #500 mute_tb = 1'b0;
    #100 Check(0, 0);
    
    #100

    if (errors == 0) $display("Teste finalizado com sucesso");
    else $display("Houve %d erros", errors);

    $stop;
  end

  always #10 clk_tb = ~clk_tb;

endmodule