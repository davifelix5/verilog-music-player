module Display_select_counter(

  input wire mudou_volume,
  input wire clk,
  input wire reset,
  output reg display_select
);

  parameter clock_freq = 28'd100, // Considerando a frequência do clk_timer como 1MHz
            five_seconds = clock_freq * 5;

  reg[27:0] counter;

  initial begin
    counter = 1'b0;
    display_select = 1'b0;
  end

  always @(posedge clk) begin
    if (reset ==1'b1) begin
      display_select <= 1'b0;
      counter = 28'b0;
    end
    if (mudou_volume == 1'b1 || counter != 28'b0) begin
      if (counter < five_seconds) begin
        display_select <= 1'b1;
        counter = counter + 28'b1;
      end
      else begin
        counter = 28'b0;
        display_select <= 1'b0;
      end
    end


  end

endmodule