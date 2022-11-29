module display_timer(
  input wire[3:0] seconds0,
  input wire[3:0] seconds1,
  input wire[3:0] minutes0,
  output wire[6:0] seconds_msd,
  output wire[6:0] seconds_lsd,
  output wire[6:0] minutes
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
    .b(minutes0),
    .d(minutes)
  );

endmodule