/**
 * Módulo responsável por gerenciar o funcionamento de um display de sete segmentos
 *  
 *  @input b: código em BCD que deve ser decodificado para um display de sete segmentos ânodo
 * comum, ou seja, os segmentos acendem quando recebem entrada de nível lógico baixo
 *  
 *  @output d: palavra de 7 bits que indica quais segmentos devem ser acesos. 
 *
**/

module driver7seg(
	input [3:0] b, 
	output reg [6:0] d
);

	always @* begin
		case (b)
			4'b0000: d = 7'b1000000; // 0
			4'b0001: d = 7'b1111001; // 1
			4'b0010: d = 7'b0100100; // 2
			4'b0011: d = 7'b0110000; // 3
			4'b0100: d = 7'b0011001; // 4
			4'b0101: d = 7'b0010010; // 5
			4'b0110: d = 7'b0110010; // 6
			4'b0111: d = 7'b1111000; // 7
			4'b1000: d = 7'b0000000; // 8
			4'b1001: d = 7'b0010000; // 9
			default: d = 7'b1111111; // Inválido
		endcase
	end

endmodule