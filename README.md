# Maquina-de-Bebidas

Projeto utilizando assembly

<p>Este projeto é uma máquina de venda de bebidas. Este projeto foi feito baseado nas funcionalidades do EdSim51 e da linguagem de Assembly. No projeto são contidas basicamente duas fases: o pedido e o pagamento, respectivamente. No primeiro, é feito o pedido de bebidas do cliente pelo teclado matricial. Na segunda fase, é usado o mesmo teclado para confirmar o pagamento, sendo inspirado em uma senha de cartão de crédito, são digitados dois zeros e o preço total, sendo comparado após para confirmar ou negar a compra, fazendo com que o usuário tente novamente. </p>


<p>  Primeiramente, é mostrado para o usuário todas as opções de bebida para comprar. Após isso, o usuário pode escolher a sua bebida apertando um botão entre 1 e 6. Quando botões de 7 a 9 são apertados,é mostrado um aviso de número inválido. Quando é apertado o 0, o último item é removido. Além disso, quando é apertado a cerquilha, prossegue para o pagamento, enquanto se for apertado o botão de asterisco do teclado matricial, é reiniciado o programa. O usuário tem um limite de três itens na sua compra que, se excedido, será avisado ao usuário através da LCD. </p>

<p>Para a fase de pagamento, com a intenção de recriar o pagamento via cartão, o usuário deve digitar quatro números, sendo eles dois zeros e o valor total da sua compra. Se a senha for digitada corretamente, serão acesos LEDs verdes para indicar o sucesso da operação, caso contrário, LEDs vermelhos acenderão. Em ambos os casos, é mostrada uma mensagem na LCD declarando o resultado e no caso da compra aprovada, é também rotacionado o motor de acordo com quantos itens foram comprados. Nesta fase, o botão de asterisco é usado para remover o último número inserido, já que o zero será usado para a checagem da senha. Diferentemente da primeira fase, esta fase não tem um botão para reiniciar o programa. Além disso, quando a senha está incorreta, o usuário é levado de volta para a página de pagamento para tentar novamente. </p>

<p>Para especificação de cada função, favor olhar os comentários dentro do código no arquivo main.asm. </p>


Dynamic Interface Atualizada:
![image](https://github.com/user-attachments/assets/de8874d7-c8a4-43a9-a1e5-cd671906509c)
