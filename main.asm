
; -------------------------------- Repositorio ---------------------------------

; |
; | https://github.com/AriaGrr/Maquina-de-Bebidas
; | Colaboradores: 
; | Marjorie Luize Martins Costa
; | Nuno Martins Guilhermino da Silva
; |

; -------------------- Mapeamento de Hardware (8051) --------------------------------

; | Usar RS no lugar de P1.3 e EN no lugar de P1.2

          RS      equ     P1.3    ; | Reg Select ligado em P1.3
          EN      equ     P1.2    ; | Enable ligado em P1.2


; ------------------------------ Inicio do programa --------------------------------

org 0000H
LJMP reset

org 0030h

; ------------------------------ Reseta e Mapeia Teclado --------------------------------

; | MAPEAMENTO DAS TECLAS (salva os valores das teclas na memoria a partir do endereço 40h)

reset: 
; | Limpar os registradores (se tiver mais coisas que são usadas e precisa limpar taca aqui)
    clr A
    
    MOV 40H, #'#' 
    MOV 41H, #'0'
    MOV 42H, #'*'
    MOV 43H, #'9'
    MOV 44H, #'8'
    MOV 45H, #'7'
    MOV 46H, #'6'
    MOV 47H, #'5'
    MOV 48H, #'4'
    MOV 49H, #'3'
    MOV 4AH, #'2'
    MOV 4BH, #'1'

    MOV R6, #00
    MOV R5, #30h
    MOV 30H, #0
    MOV 31H, #0
    MOV 32H, #0
    MOV 33H, #0
    MOV 34H, #0
    MOV 35H, #0
    MOV 36H, #0
    MOV 37H, #0
    MOV 38H, #0
    MOV 39H, #0

; | Saltar para o início do programa principal
    LJMP main

; ------------------------------ Mapeia Valores ----------------------------------

; | Talvez desnecessário, analisar.
; | Valor inicial da conta do endereço 30 ao 33



; --------------------------------- Subrotinas -----------------------------------

; --------------------------------- Comparadores ---------------------------------

; | ARRUMAR ESTA PARTE DO CÓDIGO PARA NOSSAS NECESSIDADES

checar_preco:
	MOV B, R5
	MOV R1, B

	checar_coca:
	CJNE A, 4Bh, checar_pepsi
	MOV @R1, #5
	INC R6
	INC R5

	checar_pepsi:
	CJNE A, 4Ah, checar_sprite
	MOV @R1, #6
	INC R6
	INC R5

	checar_sprite:
	CJNE A, 49h, checar_monster
	MOV @R1, #4
	INC R6
	INC R5

	checar_monster:
	CJNE A, 45h, checar_redbull
	MOV @R1, #8
	INC R6
	INC R5

	checar_redbull:
	CJNE A, 46h, checar_sukita
	MOV @R1, #7
	INC R6
	INC R5

	checar_sukita:
	CJNE A, 48h, fim
	MOV @R1, #3
	INC R6
	INC R5
	
fim:
ret

pressionado_1:
	ACALL leituraTeclado
	JNB F0, pressionado_1  ; | if F0 is clear, jump to pressionado_1
    MOV A, #40h ; | pega endereço 40h e guarda ele em A
	ADD A, R0 ; | adiciona em A o que ta no R0 (valor que a pessoa clicou)
 	MOV R0, A 
	MOV A, @R0  ; | passa para A o conteudo do que está no endereço de R0
                  
    MOV R7, A ; | adiciona valor relacionado ao botao do teclado pressionado_1, que esta em a, no R7
    MOV R2, #30H ; | coloca valor 30 no r2 
    SUBB A, R2 ; | subtrai valor de a com 30 que ai da o valor pressionado_1 (para restar somente o valor de fato pessoa clica em 1 fica guardado 31)
    MOV @R1, A ; | coloca o resultado de a no endereco de r1 
    INC R1 ; | incrementa r1 para ir pro prox endereço de valor guardado
    MOV A, R7      
    
	ACALL checar_preco  
 	ACALL sendCharacter 
 	CLR F0 ; | limpa f0 para nao dar problemas 
 	DJNZ R3, pressionado_1 ; | DECREMENTA R3 E VOLTA
	; | Parte para imitar um enter;(#23H = #)(pessoa apos escrever a senha tem que clicar no # para verificar se ta certa ou nao)
	MOV R3, #23H
; | itera pela label ate o valor de A ser igual ao de 03h

; | Quando enter é pressionado no pressionado_1 vem pro pressionado_2
pressionado_2:
	ACALL leituraTeclado
	JNB F0, 2  ; | if F0 is clear, jump to 2
    MOV A, #40h ; | pega endereço 40h e guarda ele em A
	ADD A, R0 ; | adiciona em A o que ta no R0 (valor que a pessoa clicou)
 	MOV R0, A 
	MOV A, @R0  ; | passa para A o conteudo do que está no endereço de R0
                  
    MOV R7, A ; | adiciona valor relacionado ao botao do teclado 2, que esta em a, no R7
    MOV R2, #30H ; | coloca valor 30 no r2 
    SUBB A, R2 ; | subtrai valor de a com 30 que ai da o valor 2 (para restar somente o valor de fato pessoa clica em 1 fica guardado 31)
    MOV @R1, A ; | coloca o resultado de a no endereco de r1 
    INC R1 ; | incrementa r1 para ir pro prox endereço de valor guardado
    MOV A, R7 

enter:
    CLR A
 	ACALL leituraTeclado
    JNB F0, enter 
    MOV A, #40h
	ADD A, R0
	MOV R0, A
 	MOV A, @R0  
	CLR F0 ; | coloca clr f0 para dar certo
    CJNE A, 03H, enter
; | Parte onde comparamos a senha salva com os digitados pelo usuario 
    MOV R3, #4 ; | loop 4x
    MOV R0, #30H ; | valor 30 para ir ao endereço 30 e comparar (ta senha padrao)
    MOV R1, #60H ; | senha que usuario digitou

senha:
    MOV A, #06h ; | centralizado
 	ACALL posicionaCursor ; | escrever senha digitada na memoria
    ; | itera pela posicao de memoria do 40h para ver que valor o usuario digitou e salva-los nas posicao a partir da 60h
    MOV R1, #60H
	MOV R3, #4 ;4 repeticoes pq senha tem 4 digitos

; | Pra comparar a "senha" (valor da compra, com zeros a esquerda até ter 4 digitos)
compara:
    MOV A, @R0 ; | lê o valor do endereço de R0 para A.
    MOV 70H,@R1
    CJNE A, 70H, errado; | DIFERENTE PULA
    INC R0 ; | incrementa r0 para comparar o proximo valor da senha
    INC R1  ; | incrementa r1 para comparar o prox valor da senha com valor digitado pelo user
    DJNZ R3, compara ; | LOOP 4X 
; | "Menu"
; | Deve girar n*2 vezes conforme a quantidade de produtos
 	SETB P3.1 ; |  Gira motor no sentido horário se a pessoaa acerta a senha
 	CLR P3.0

; | Completar
errado:
    LCALL negou

; ------------------------------ Leitura do teclado --------------------------------
     
leituraTeclado:
 	MOV R0, #0		
 	MOV P0, #0FFh	
 	CLR P0.0			; | clear row0
 	CALL colScan		; | call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 		; | (because the pressed key was found and its number is in  R0)
      	; | scan row1
 	SETB P0.0			; | set row0
 	CLR P0.1			; | clear row1
 	CALL colScan		; | call column-scan subroutine
 	JB F0, finish		; | if F0 is set, jump to end of program 						; | (because the pressed key was found and its number is in  R0)
      	; | scan row2
 	SETB P0.1			; | set row1
 	CLR P0.2			; | clear row2
 	CALL colScan		; | call column-scan subroutine
 	JB F0, finish		; | if F0 is set, jump to end of program 				; | (because the pressed key was found and its number is in  R0)
      	; | scan row3
 	SETB P0.2			; | set row2
 	CLR P0.3			; | clear row3
 	CALL colScan		; | call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
      						; | (because the pressed key was found and its number is in  R0)
    
    finish:
        RET
        
    ; | column-scan subroutine
    colScan:
        JNB P0.4, gotKey	; | if col0 is cleared - key found
        INC R0				; | otherwise move to next key
        JNB P0.5, gotKey	; | if col1 is cleared - key found
        INC R0				; | otherwise move to next key
        JNB P0.6, gotKey	; | if col2 is cleared - key found
        INC R0				; | otherwise move to next key
        RET					; | return from subroutine - key not found
    
    gotKey:
        SETB F0				; | key found - set F0
        RET					; | and return from subroutine

; ------------------------------ Manda Caracter --------------------------------

sendCharacter :
    SETB RS ; | set RS: Indica que data esta sendo enviada para o modulo.
    MOV C, ACC.7 ; |
    MOV P1.7, C ; |
    MOV C, ACC.6 ; |
    MOV P1.6, C ; |
    MOV C, ACC.5 ; |
    MOV P1.5, C ; |
    MOV C, ACC.4 ; |
    MOV P1.4, C ; | high nibble set
    SETB EN ; |
    CLR EN	 ; | negative edge on E
    MOV C, ACC.3 ; |
    MOV P1.7, C ; |
    MOV C, ACC.2 ; |
    MOV P1.6, C ; |
    MOV C, ACC.1 ; |
    MOV P1.5, C ; |
    MOV C, ACC.0 ; |
    MOV P1.4, C ; | low nibble set
    SETB EN ; |
    CLR EN ; | negative edge on E
    CALL delay ; | Espera o BF dar clear
    RET

; -------------------------------- Inicia LCD ---------------------------------

lcd_init:
    CLR RS

; | function set
    CLR P1.7
    CLR P1.6
    SETB P1.5
    CLR P1.4

    SETB EN
    CLR EN

    CALL delay

    SETB EN
    CLR EN

    SETB P1.7

    SETB EN
    CLR EN

    CALL delay
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4

    SETB EN
    CLR EN

    SETB P1.6
    SETB P1.5

    SETB EN
    CLR EN
    CALL delay

; | Display on/o
; | The display
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4

    SETB EN
    CLR EN

    SETB P1.7
    SETB P1.6
    SETB P1.5
    SETB P1.4

    SETB EN
    CLR EN
    CALL delay
    RET

; -------------------------------- Escreve String ----------------------------------

escreveString:
    MOV R2, #0

    rot:
        MOV A, R2
        MOVC A,@A+DPTR ; | Tabela de memoria do programa
        ACALL sendCharacter ; | Manda a data de A para o modulo
        INC R2
        JNZ rot ; | if A is 0, then end of data has been reached - jump out of loop
        RET

; -------------------------------- Posiciona cursor --------------------------------

posicionaCursor :
    CLR RS ; | clear RS - indicates that instruction is being sent to module
    SETB P1.7 ; |

    MOV C, ACC.6 ; |
    MOV P1.6, C ; |
    MOV C, ACC.5 ; |
    MOV P1.5, C ; |
    MOV C, ACC.4 ; |
    MOV P1.4, C ; | high nibble set

    SETB EN ; |
    CLR EN ; | negative edge on E

    MOV C, ACC.3 ; |
    MOV P1.7, C ; |
    MOV C, ACC.2 ; |
    MOV P1.6, C ; |
    MOV C, ACC.1 ; |
    MOV P1.5, C ; |
    MOV C, ACC.0 ; |
    MOV P1.4, C ; | low nibble set

    SETB EN ; |
    CLR EN

    CALL delay
    RET

; | Limpa todo o display e retorna o cursor para primeira posicao

; ------------------------------- Clear Display ---------------------------------

clearDisplay :
    CLR RS ; | clear RS - indicates that instruction is being sent to module
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB EN ; |
    CLR EN ; | negative edge on E
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    SETB P1.4 ; | low nibble set
    SETB EN ; |
    CLR EN ; | negative edge on E
    CALL delay ; | wait for BF to clear
    RET

; -------------------------------- Retorna Cursor -------------------------------

; | Retorna o cursor para primeira posicao sem limpar o display

retornaCursor :
    CLR RS ; | clear RS - indicates that instruction is being sent to module
    CLR P1.7 ; |
    CLR P1.6 ; |
    CLR P1.5 ; |
    CLR P1.4 ; | high nibble set
    SETB EN ; |
    CLR EN ; | negative edge on E
    CLR P1.7 ; |
    CLR P1.6 ; |
    SETB P1.5 ; |
    SETB P1.4 ; | low nibble set
    SETB EN ; |
    CLR EN ; | negative edge on E
    CALL delay ; wait for BF to clear
    RET

; ------------------------------- Rotação do Motor ---------------------------------

; | A cada rotação do motor retira 1 da quantidade de itens, enquanto a quantidade não for 0, o motor deve girar.

; | Espera por um sinal de rotação completa no pino P3.2
rotacao:
    JNB P3.2, rotacao ; | Espera até que sensor no pino P3.2 indique a rotação completa
	CLR P3.1  ; | Parar o motor
       
; ----------------------------------- Bebidas e + ----------------------------------

CONFERE:
    DB " " ; | O valor (senha) terá quatro digitos, sendo compostos pelo valor da conta em si, e caso o valor da conta não tenha 4 digitos, adicione um 0 ao começo dele.
    DB 00h ; | Declara string, e lê até o fim

COCA:
    DB "1- Coca    R$ 5 "
    DB 0 ; | Caracter null indica fim da String

PEPSI:
    DB "2- Pepsi   R$ 6 "
    DB 0

SPRITE:
    DB "3- Sprite  R$ 4 "
    DB 0

SUKITA: 
    DB "4- Sukita  R$ 3 "
    DB 0

REDBULL: 
    DB "6- Redbull R$ 7 "
    DB 0

MONSTER:
    DB "7- Monster R$ 8 "
    DB 0

CANCELAR: 
    DB "*-   Cancelar   "
    DB 0

PAGAR:
    DB "#-    Pagar    "
    DB 0

TRANSACAO:
    DB " TRANSACAO "
    DB 0

APROVADA:
    DB " APROVADA "
    DB 0

NEGADA:
    DB " NEGADA "
    DB 0

RETIRE:
    DB " RETIRE OS "
    DB 0

PRODUTOS:
    DB "PRODUTOS ABAIXO"
    DB 0

; ---------------------------------- Prints ---------------------------------------

opcoes:
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#COCA ; | DPTR = Inicio da palavra 
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#PEPSI
    ACALL escreveString
    ACALL delay
    ACALL clearDisplay

; | Inicio
    ACALL delay

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #SPRITE
    ACALL delay
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #SUKITA
    ACALL escreveString
    ACALL clearDisplay 

; | Fim 

; | Para exibir no display 
    ACALL delay

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #REDBULL
    ACALL delay
    ACALL escreveString
; | Segunda linha 
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #MONSTER
    ACALL escreveString
    ACALL clearDisplay 
; | Fim

    ACALL delay

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #PAGAR
    ACALL delay
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #CANCELAR
    ACALL escreveString
    ACALL clearDisplay 
	RET
; | Nega a transação caso o valor inserido esteja incorreto e reseta tudo.

negou:
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#TRANSACAO ; | DPTR = Inicio da palavra 
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#NEGADA
    ACALL escreveString
    ACALL delay
    ACALL clearDisplay

; | Se passar o motor deve girar conforme a quantidade de produtos vezes dois e após isso mostrar a mensagem para retirada.

passou:
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#TRANSACAO ; | DPTR = Inicio da palavra 
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#APROVADA
    ACALL escreveString
    ACALL delay
    ACALL clearDisplay

retirada:
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#RETIRE ; | DPTR = Inicio da palavra 
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#PRODUTOS
    ACALL escreveString
    ACALL delay
    ACALL clearDisplay


; | Fazer o display atualizar com valor e o número de produtos do pedido, conforme a pessoa aperta o teclado em sua primeira fase.

; ---------------------------------- Leds ------------------------------------

; | Função para acender um LED específico no port P2
acender:
    MOV A, R0 ; | Assumindo que o número do pino está em R0
    MOV P2, A
    ACALL delays
    MOV P2, #0FFH 
    ACALL delay
    RET

; | Chamada da função para acender o LED no pino P2
; | Converte o número das portas que quer acender (0 ligado, 1 desligado) do binario 8 casas para hexadecimal e passa para a porta dos leds
; | 00H liga tudo, 0FFH desliga tudo

verde:
    MOV R0, #0DBH 
    CALL acender
    RET

vermelho:
    MOV R0, #0B6H 
    CALL acender
    RET

amarelo:
    MOV R0, #06DH 
    CALL acender
    RET

; ---------------------------------- Delays ------------------------------------

; | Delay normal
delay:
    MOV R1, #50
    MOV R0, #50
    MOV R3, #50
    MOV R4,	#50
    DJNZ R0, $
    DJNZ R1, $
    DJNZ R3, $
    DJNZ R4, $
    RET

delays:
    ;ACALL delay
    ;ACALL delay
    ACALL delay
    ACALL delay
    ACALL delay ; | Chamar a subrotina de delay
    RET 

; ----------------------------- End of subroutines -----------------------------

; ---------------------------------- Main --------------------------------------

main:
    ACALL lcd_init
    ;ACALL vermelho
    ;ACALL verde
    ;ACALL amarelo
    ACALL opcoes
	ACALL pressionado_1
JMP main

; ------------------------------- End of Main ----------------------------------
