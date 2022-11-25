module driver7seg(
	input [5:0] b, 
	output reg [6:0]d
);

	always @* begin
		case (b)
			6'b0000: d = 7'b1000000;
			6'b0001: d = 7'b1111001;
			6'b0010: d = 7'b0100100;
			6'b0011: d = 7'b0110000;
			6'b0100: d = 7'b0011001;
			6'b0101: d = 7'b0010010;
			6'b0110: d = 7'b0110010;
			6'b0111: d = 7'b1111000;
			6'b1000: d = 7'b0000000;
			6'b1001: d = 7'b0010000;
			default: d = 7'b1111111;
		endcase
	end

endmodule