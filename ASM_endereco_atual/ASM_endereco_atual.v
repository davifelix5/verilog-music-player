module ASM_endereco_atual(
  input wire passa_10s,
  input wire volta_10s,
  input wire count,
  input wire reset,
  input wire clk,
  output reg[21:0] endereco
);

  reg[3:0] state;

  parameter inicio = 3'b000,
            apertou_mais_10s = 3'b001,
            soltou_mais_10s = 3'b010,
            apertou_menos_10s = 3'b011,
            soltou_menos_10s = 3'b100;
  
  parameter addrs_por_segundo = 22'd3000, // 3kHz
            dez_segundos = 10 * addrs_por_segundo;
  
  initial begin
    state <= inicio;
    endereco = 22'b0;
  end

  always @(posedge clk, posedge reset) begin
    if (reset == 1'b1) begin
      state <= inicio;
      endereco = 22'b0;
    end

    else if (count == 1'b1) begin
      case (state) 

        inicio: begin
          endereco = endereco + 22'b1;
          if (passa_10s == 1'b1)
            state <= apertou_mais_10s;
          else if (volta_10s == 1'b1)
            state <= apertou_menos_10s;
        end

        apertou_mais_10s: begin
          endereco = endereco + 22'b1;
          if (passa_10s == 1'b0)
            state <= soltou_mais_10s;
        end

        soltou_mais_10s: begin
          endereco = endereco + 22'd30000;
          state <= inicio;
        end

        apertou_menos_10s: begin
          endereco = endereco + 22'b1;
          if (volta_10s == 1'b0)
            state <= soltou_menos_10s;
        end

        soltou_menos_10s: begin
          if (endereco >= 22'd30000)
            endereco = endereco - 22'd30000;
          state <= inicio;
        end
      endcase

    end

  end

endmodule