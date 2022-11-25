module driver7seg_testbench;

  reg [5:0] b;
  wire [6:0] d;

  integer i = 0, errors;

  driver7seg UUT (
    .b(b),
    .d(d)
  );

  task Check;
  input[6:0] expect;

    if (d != expect) begin
      $display("Erro para o decimal %d -> Mostrou %b no lugar de %b", i, d, expect);
      errors = errors + 1;
    end

  endtask

  initial begin
    errors = 0;
    for (i = 0; i < 10; i = i + 1) begin
      b = i; #10
      case (b)
        0: Check(7'b1000000);
        1: Check(7'b1111001);
        2: Check(7'b0100100);
        3: Check(7'b0110000);
        4: Check(7'b0011001);
        5: Check(7'b0010010);
        6: Check(7'b0110010);
        7: Check(7'b1111000);
        8: Check(7'b0000000);
        9: Check(7'b0010000);
      endcase
    end

    if (errors == 0)
      $display("Test ended successfully");
    else
      $display("Houve %d errors", errors);

    $stop;
  end

endmodule