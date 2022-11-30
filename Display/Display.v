module Display(
  input wire[3:0] volume0,
  input wire[3:0] volume1,
  input wire[3:0] minutes0,
  input wire[3:0] seconds0,
  input wire[3:0] seconds1,
  input wire select,
  output wire[6:0] digit2,
  output wire[6:0] digit1,
  output wire[6:0] digit0
);

  wire[3:0] value_to_convert0, value_to_convert1, value_to_convert2;

  assign value_to_convert0 = select == 1 ? volume0 : seconds0;
  assign value_to_convert1 = select == 1 ? volume1 : seconds1;
  assign value_to_convert2 = select == 1 ? 4'b0 : minutes0;

  driver7seg DISPLAY1 (
    .b(value_to_convert0),
    .d(digit0)
  );

  driver7seg DISPLAY2 (
    .b(value_to_convert1),
    .d(digit1)
  );

  driver7seg DISPLAY3 (
    .b(value_to_convert2),
    .d(digit2)
  );

endmodule