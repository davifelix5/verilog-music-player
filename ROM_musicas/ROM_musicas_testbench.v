module ROM_musicas_testbench;

  reg[23:0] addr_tb;
  wire[7:0] data_tb;

  ROM_musicas UUT (
    .addr(addr_tb),
    .data(data_tb)
  );

  initial begin
    $monitor("Data: %b", data_tb);
    addr_tb = 24'b0;
    #100
    addr_tb = 24'd2;
    #100
    addr_tb = 24'd3;
    #100
    addr_tb = 24'd0;
    #100
    addr_tb = 24'd2000;
    #100
    $stop;
  end

endmodule