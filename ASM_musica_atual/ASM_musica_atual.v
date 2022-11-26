module ASM_musica_atual (
  input prox,
  input prev,
  input reset,
  input clk,
  output reg[0:1] select,
  output reg start
);
  
  reg[2:0] state;
  
  parameter inicio = 3'b000,
            prox_m = 3'b001,
            passa = 3'b010,
            volta = 3'b011,
            prev_m = 3'b100;

  parameter QTD_MUSICAS = 2'b11;

  initial begin
    state <= inicio;
    select = 2'b00;
    start = 1'b1;
  end

  always @(posedge clk, posedge reset) begin
    
    if (reset == 1'b1) begin
      select = 2'b00;
      start = 1'b1;
      state <= inicio;
    end

    else begin
      case (state) 

        inicio: begin
          if (prev == 1'b1)
            state <= prev_m;
          else if (prox == 1'b1)
            state <= prox_m;
          start = 1'b0;
        end
          
        prox_m: begin
          if (prox == 1'b1)
            state <= prox_m;
          else
            state <= passa;
        end

        passa: begin
          if (select == QTD_MUSICAS)
            select = 2'b0;
          else
            select = select + 2'b1;
          start = 1'b1;
          state <= inicio;
        end

        prev_m: begin
          if (prev == 1'b1)
            state <= prev_m;
          else
            state <= volta;
        end

        volta: begin
          if (select == 2'b0)
            select = 2'b11;
          else
            select = select - 2'b1;
          start = 1'b1;
          state <= inicio;
        end

      endcase
    end
  
  end


endmodule