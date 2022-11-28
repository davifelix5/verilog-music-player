module ROM_musicas(
  input wire[23:0] addr, // endereço a ser retornado
  output wire[7:0] data // palavra da memória
);

  parameter max_addr = {24{1'b1}}; // 2^24 - 1 

  reg[7:0] mem[0: max_addr]; // Array de 2^24 paralavras de 8 bits

  initial begin
    $readmemb("musics2.dat", mem, 0, max_addr); // Inicializa a memória com um arquivo
  end

  assign data = mem[addr]; // Retorna o elemento da memória no endereço addr

endmodule