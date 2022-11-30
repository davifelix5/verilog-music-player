module ROM_testbench;

  wire[7:0] data_tb;
  reg[23:0] addr_tb;

  integer errors;

  ROM_musicas UUT (
    .addr(addr_tb),
    .data(data_tb)
  );

  task Check;
  input[7:0] expect;
    if (data_tb != expect) begin
      errors = errors + 1;
      $display("Error: esperada %b e erecebeu %b", expect, data_tb);
    end
  endtask

  initial begin
    errors = 0;
    #100 addr_tb = 24'd0;
    #50 Check(8'b01010101);
    #100 addr_tb = 24'd1;
    #50 Check(8'b01011100);
    #100 addr_tb = 24'd5;
    #50 Check(8'b10000101);
    #100 addr_tb = 24'd20000;
    #50 Check(8'b00110011);
    #100 addr_tb = 24'd41000;
    #50 Check(8'b01000000); #100

    if (errors == 0)
      $display("Teste acabou com sucesso");
    else
      $display("Houve %d erros", errors);

    $stop;
  end

endmodule