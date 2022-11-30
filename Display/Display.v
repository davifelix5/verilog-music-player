/**
 * Módulo responsável por gerenciar o que aparece no display
 *  
 * @input volume0: dígito menos significativo do volume em BCD,
 * @input volume1: dígito mais significativo do volume em BCD,
 * @input minutes0: dígito dos minutos em BCD,
 * @input seconds0: dígito menos significativo dos segundos em BCD,
 * @input seconds1 dígito mais significativo do volume em BCD,
 * @input select: entrada seletora (1 mostra volume e 0 mostra tempo),
 * @output digit4: valor codificado para o dígito mais significativo no display de 7 segmentos,
 * @output digit2: valor codificado para o 2 no display de 7 segmentos,
 * @output digit1: valor codificado para o 1 no display de 7 segmentos,
 * @output digit0: valor codificado para o dígito menos significativo no display de 7 segmentos
 *  
**/

module Display(
  input wire[3:0] volume0,
  input wire[3:0] volume1,
  input wire[3:0] minutes0,
  input wire[3:0] seconds0,
  input wire[3:0] seconds1,
  input wire[3:0] music,
  input wire select,
  output wire[6:0] digit4,
  output wire[6:0] digit2,
  output wire[6:0] digit1,
  output wire[6:0] digit0
);

  /* Valores que deverão ser decodificados para 7 segmentos */
  wire[3:0] value_to_convert0, value_to_convert1, value_to_convert2;

  /* Lógica de um multiplexados para selecionar o que deverá ser decodificado */
  assign value_to_convert0 = select == 1 ? volume0 : seconds0;
  assign value_to_convert1 = select == 1 ? volume1 : seconds1;
  assign value_to_convert2 = select == 1 ? 4'b0 : minutes0;

  /* Decodificação para de BCD para 7 segmentos (módulo já testado) */
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

  driver7seg DISPLAY4 (
    .b(music),
    .d(digit4)
  );

endmodule