# Maquina-de-Bebidas

Autores:
<p>Nuno Martins Guilhermino da Silva - RA: 24.123.035-8</p>
<p>Marjorie Luize Martins Costa - RA: 24.223.084-5</p>


Projeto na linguagem Assembly, utilizando o EdSim51

<p>Este projeto é uma máquina de venda de bebidas. Este projeto foi feito baseado nas funcionalidades do EdSim51 e da linguagem de Assembly. No projeto são contidas basicamente duas fases: o pedido e o pagamento, respectivamente. No primeiro, é feito o pedido de bebidas do cliente pelo teclado matricial. Na segunda fase, é usado o mesmo teclado para confirmar o pagamento, sendo inspirado em uma senha de cartão de crédito, são digitados dois zeros e o preço total, sendo comparado após para confirmar ou negar a compra, fazendo com que o usuário tente novamente. </p>


<p>  Primeiramente, é mostrado para o usuário todas as opções de bebida para comprar. Após isso, o usuário pode escolher a sua bebida apertando um botão entre 1 e 6. Quando botões de 7 a 9 são apertados,é mostrado um aviso de número inválido. Quando é apertado o 0, o último item é removido. Além disso, quando é apertado a cerquilha, prossegue para o pagamento, enquanto se for apertado o botão de asterisco do teclado matricial, é reiniciado o programa. O usuário tem um limite de três itens na sua compra que, se excedido, será avisado ao usuário através da LCD. </p>

<p>Para a fase de pagamento, com a intenção de recriar o pagamento via cartão, o usuário deve digitar quatro números, sendo eles dois zeros e o valor total da sua compra. Se a senha for digitada corretamente, serão acesos LEDs verdes para indicar o sucesso da operação, caso contrário, LEDs vermelhos acenderão. Em ambos os casos, é mostrada uma mensagem na LCD declarando o resultado e no caso da compra aprovada, é também rotacionado o motor de acordo com quantos itens foram comprados. Nesta fase, o botão de asterisco é usado para remover o último número inserido, já que o zero será usado para a checagem da senha. Diferentemente da primeira fase, esta fase não tem um botão para reiniciar o programa. Além disso, quando a senha está incorreta, o usuário é levado de volta para a página de pagamento para tentar novamente. </p>

<p>Para especificação de cada função, favor olhar os comentários dentro do código no arquivo main.asm. </p>

<p>Entres as maiores dificuldades do projeto vieram com a administração de memória e leitura do teclado. No primeiro, após uma compra de sucesso, a pilha sobescreve o local no qual é feito o pedido. No quesito do teclado, encontrou-se uma dificuldade de uma leitura fantasma, onde era adicionado um algarismo na senha sem que fosse apertado uma tecla. Este foi resolvido com um CLR F0. </p>

Dynamic Interface Atualizada:
![image](https://github.com/user-attachments/assets/de8874d7-c8a4-43a9-a1e5-cd671906509c)


Fluxograma do projeto:
![Diagrama](https://github.com/user-attachments/assets/ff2b5dde-1833-475d-a2a3-874a1322672e)


Vídeos de exemplo:

Neste vídeo, o aviso de número inválido quando se aperta 7, 8 ou 9.


https://github.com/user-attachments/assets/7ef01136-0c80-4612-a07e-3ca5ded4d2cc

Neste vídeo se tem um exemplo do uso do botão de remover na primeira fase.



https://github.com/user-attachments/assets/0ed82afc-bc7c-4991-94e0-a7f9f553b00e


Neste vídeo, é mostrado o uso do botão de reset.



https://github.com/user-attachments/assets/3dcc1176-8fa8-4e63-93cc-7a26bcf863bb


Neste exemplo, é visto um exemplo do uso de número válidos além do aviso do limite.



https://github.com/user-attachments/assets/8c99faac-7422-4813-b8ea-385287ff66ee


Neste vídeo, é mostrado o uso de mais botões de bebida além do botão para somar o valor da compra.



https://github.com/user-attachments/assets/e654d6af-25ee-40a7-9819-73019c8cc4f6


Neste vídeo, exemplificamos a digitação da senha e o uso do botão de remover da segunda fase.



https://github.com/user-attachments/assets/067a57f0-b205-4062-a99c-a417cbb3c745


Neste vídeo, a senha é escrita incorretamente.



https://github.com/user-attachments/assets/8ee108d6-1fe3-43f3-a13b-5f905e29eff5




Neste vídeo, um exemplo de uma transação bem sucedida.



https://github.com/user-attachments/assets/9083e447-d229-49a2-a829-288f24d1486b









