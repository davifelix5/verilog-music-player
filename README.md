# Preparação do ambiente
1. **Criação da pasta work na raiz do projeto**: criação da pasta de trabalho
```bash
vlib work
```
2. **Descompatar o arquivo para a simulação da memória (musics2.rar)**: esse arquivo simulará dados de músicas em PCM.

# Instruções para simulação de cada módulo

  Seguem as instruções para a simulação de cada um dos módulos do projeto

## ASM_endereco_atual
```bash
vsim -c work.ASM_endereco_atual_testbench
run -all
```
- Serão mostrados os valores `endereco`, `Time adder` e `Prox song`.
- O valor `Time adder` indica o incremento de tempo equivalente ao último incremento no endereço.
- São testados as entradas
  - `reset`: endereço deve ficar em 0 enquanto `reset = 1`
  - `+10 e -10`: endereço deve avançar e voltar **30.000 endereços**, respectivamente.
  - `+30 e -30`: endereço deve avançar e voltar **90.000 endereços**, respectivamente.
  - `Prox song`: indica quando uma nova música deve começar (não acontece nessa simulação).

## ASM_musica_atual
```bash
vsim -c work.ASM_musica_atual_testbench
run -all
```
- Nessa simulação, todos os casos para a saída `select` são testados automaticamente, indicando se houve algum erro.
- A saída `start` indica quando uma música acaba de começar.

## ASM_volume
```bash
vsim -c work.ASM_musica_atual_testbench
run -all
```
- Essa simulação checa os valores da saída automaticamente, sinalizando se houve algum erro
- São testadas as entradas de `aumentar`, `diminuir` e `mutar` o volume.
- A saída `mudou volume` indica quando há uma alteração no volume com o objetivo de mudar o display

## driver7seg
```bash
vsim -c work.driver7seg_testbench
run -all
```
- Essa simulação verifica se os número em **BCD** estão sendo codificados da maneira correta
- Os resutados são verificados automaticamente, com eventuais erros sendo indicados

## FSM_play_pause
```bash
vsim -c work.FSM_play_pause_testbench
run -all
```
- Essa simulação verifica e indica automaticamente eventuais erros

## Timer
### Timer_testbench
```bash
vsim -c work.Timer_testbench
run -all
```
- Nessa simulação, é feito o incremento do valor do timer a cada pulso de clock.
- Ao lado dos valores em BCD, estão sua codigicação em 7 segmentos.
- O valor do `adder` e mudado e o deve ser analisado manualmente, é fácil conferir se o incremento está correto.
- Não é levado em conta o caso de o tempo passar de _9:59_ por que as músicas não podem chegar a esse tamanho da memória. 

### Timer_adder_testbench
```bash
vsim -c work.Timer_adder_testbench
run -all
```
- Testa para verificar que o timer muda com a alteração do `adder` mesmo sem haver uma borda de clock.
- A verificação da saída é feita automaticamente.

## ROM músicas
### ROM_testbench
```bash
vsim -c work.ROM_testbench
run -all
```
- Verifica se a palavra `data` retornada realmente corresponde à que está localizada no endereço `addr`.
- As verificações são feitas automaticamente
### ROM_musicas_testbench
```bash
vsim -c work.ROM_musicas_testbench
run -all
```
- Simualação do fluxo geral do player.
  - O display deve mostra o volume quando ele for alterado.
    - O display deve voltar para a mostrar o tempo quando o usuário altera o tempo da música ou a música é trocada.
  - Ao passar ou voltar o tempo, o incremento ou decremento deve ser feito tanto no relógio quanto no endereço.
  - O timer e o endereço devem resetar ao trocar de música.
  - O timer e o endereço só devem mudar se o player estiver no estado de play.

- São mostrados no `log`:
  - informações do display
  - select da música 
  - select do display
  - endereço da música na memória
  - palavra atual obtida da memória
  - Estado play/pause
- Para verficar as alterações basta buscar por onde eles foram feitas com `Ctrl+F` dentro do `transcript` da simulação.

## Display e Display select counter
```bash
vsim -c work.Display_testbench
run -all
```
- É preciso verificar se, quando o volume é alterado, o display passa mostrar o valor do volume durante um tempo corresponde a 5 segundos.
- Percebe-se que o timer dá lugar ao volume quando está em 2 segundos e volta quando está em 7 segundos. Logo, a simulação retorna o resultado esperado.

*OBS*: a simulação demora um pouco mais devido ao tamanho da memória

## Player_testbench
```bash
vsim -c work.Player_testbench
run -all
```
- Simulação muito parecida com a da ROM_musicas_testbench, mas agora com menos informações no `log`, apenas o conteúdo do display e a palavra de 8 bits que está sendo acessada em cada momento.
- Para verificar o efeito de cada alteração, também é possível verificar onde ela foi feita a partir de uma busca com `Crtrl + F`