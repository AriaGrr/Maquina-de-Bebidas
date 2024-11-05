; -------------------------------- Repositorio -------------------------------------
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

; ------------------------------ Reseta e Mapeia Teclado ----------------------------

; | Ao ter a compra aprovada, fica preso no looping. Erro desconhecido.
zerando:
    MOV R0, #10H ; | Inicializa o registrador R0 com o endereço inicial
    MOV R1, #10H ; | Define o número de bytes a serem zerados (ajuste conforme necessário)

    loop_zerar:
        MOV @R0, #0 ; | Escreve 0 no endereço apontado por R0
        INC R0 ; | Incrementa o endereço para o próximo byte
        DJNZ R1, loop_zerar ; | Decrementa o contador e repete o loop
        RET

reset: 
; | Limpar os registradores e + (se tiver mais coisas que são usadas e precisa limpar taca aqui)

    ;ACALL zerando
    clr A

	MOV R0, #0
	MOV R1, #0
	MOV R2, #0
	MOV R3, #0
	MOV R4, #0
	MOV R5, #20h
	MOV R7, #0

    MOV 20H, #0
	MOV 21H, #0
	MOV 22H, #0
	MOV 23H, #0
	MOV 24H, #0
	MOV 25H, #0
    MOV 26H, #0
	MOV 27H, #0
    MOV 28H, #0
	MOV 29H, #0

    MOV 2AH, #0
    MOV 2BH, #0
	MOV 2CH, #0
    MOV 2DH, #0
    MOV 2EH, #0
	MOV 2FH, #0

    MOV 10H, #0
	MOV 11H, #0
	MOV 12H, #0
	MOV 13H, #0
	MOV 14H, #0
	MOV 15H, #0
    MOV 16H, #0
	MOV 17H, #0
    MOV 18H, #0
	MOV 19H, #0

    MOV 1AH, #0
    MOV 1BH, #0
	MOV 1CH, #0
    MOV 1DH, #0
    MOV 1EH, #0
	MOV 1FH, #0

; | MAPEAMENTO DAS TECLAS (salva os valores das teclas na memoria a partir do endereço 40h)
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

	MOV 70H, #0
    MOV R6, #00
    ;MOV R5, #30h
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

; --------------------------------- Subrotinas -----------------------------------

; --------------------------------- Comparadores ---------------------------------

checar_tecla1:
	MOV B, R5 ; | Coloca endereço em B
	MOV R0, B ; | Colocar endereço em R0 para escrever
	MOV R4, A ; | Coloca número digitado em A

	checar_remocao:
        CJNE A, 41h, checar_reset ; | Se não for igual, ir para próxima função
  	DEC R0 ; | Igualar R0 ao número a ser apagado
	    MOV @R0, #0h ; | Tira o número 
		ACALL amarelo ; | LEDS amarelos acendem
        DEC R5 ; | Registra mudança de endereço
		DEC R6 ; | Diminui o contador
        RET

	checar_reset:
        CJNE A, 42h, checkout ; | Se não for igual, ir para próxima função
        ACALL amarelo ; | LEDS amarelos acendem
        LJMP reset ; | Reseta a máquina

	checkout:
        CJNE A, 40h, checar_limite ; | Se não for igual, ir para próxima função
		ACALL amarelo ; | LEDS amarelos acendem
		ACALL somar_preco ; | Faz soma do preço total e guarda na fileira de 30
		MOV 70h, R6 ; | Coloca os itens registrados pelo contador em 70h
		MOV R6, #0 ; | Reseta o contador para o pagamento
		MOV R5, #20h ; | Reseta o endereço para escrever senha
		MOV R0, #0 ; | Reseta R0
		ACALL valor_total ; | Imprime o valor da compr no LCD
		ACALL mostrar_senha ; | Mostra espaço para a senha
		CLR F0
        ACALL delay_mini ; | Um delay
		ACALL pressionado_2 ; | Leitura do teclado para o input da senha

	checar_limite:
        MOV 10h, #3 ; | Limite de itens para comparação
        MOV A, R6 ; | Coloca o contador em A
        CJNE A, 10h , checar_coca ; | Caso contador não estiver no limite, seguir em frente
        MOV DPTR, #CHEIO ; | Mensagem do limite
        ACALL clearDisplay ; | Limpa o display
        MOV A, #00h ; | Colocar o cursor no início do LCD
        ACALL posicionaCursor
        ACALL escreveString
		ACALL clearDisplay
        RET

	checar_coca:
        MOV A, R4 ; | Coloca o número lido no teclado de volta no A para comparação
        CJNE A, 4Bh, checar_pepsi ; | Compara com o número 1, caso contrário, compara com número 2
        MOV @R0, #5 ; | Coloca preço de uma coca cola na memória
        INC R6 ; | Incrementa o contador
        INC R5 ; | Ir para o próximo endereço
        RET

	checar_pepsi:
        CJNE A, 4Ah, checar_sprite  ; | Compara número 2, caso não seja, olhar número 3
        MOV @R0, #6 ; | Coloca o preço de uma pepsi na memória.
        INC R6 ; | Incrementa o contador
        INC R5 ; | Ir para o próximo endereço
        RET

	checar_sprite:
        CJNE A, 49h, checar_monster ; | Compara com número 3, caso contrário, compara com número 5
        MOV @R0, #4 ; | Coloca preço de uma sprite na memória
        INC R6 ; | Incrementa contador
        INC R5 ; | Incrementa para o próximo endereço
        RET

	checar_monster:
        CJNE A, 46h, checar_redbull ;checa número 6, caso contrário, olhar número 5
        MOV @R0, #8 ; | Inserir preço de um monster na memória
        INC R6 ; | Incrementa o contador
        INC R5 ; | Vai para o próximo endereço
        RET

	checar_redbull:
        CJNE A, 47h, checar_sukita ; | Checar número 5, caso contrário, olhar número 4
        MOV @R0, #7 ; | Inserir preço de uma redbull na memória
        INC R6 ; | Incrementa o contador
        INC R5 ; | Vai para o próximo endereço
        RET

	checar_sukita:
        CJNE A, 48h, checar_sete ; | Checar 4, caso contrário, checar 7
        MOV @R0, #3 ; | Coloca preço de uma sukita na memória
        INC R6 ; | Incrementa o contador
        INC R5 ; | Vai para o próximo endereço
        RET

	checar_sete:
        CJNE A, 45h, checar_oito ; | Se não for 7, comparar com 8
        ACALL invalido ; | Imprimir aviso na LCD
        RET

	checar_oito:
        CJNE A, 44h, checar_nove ; | Se não for 8, comparar com 9
        ACALL invalido ; | Imprimir aviso na LCD
        RET

	checar_nove:
        CJNE A, 43h, fim ; | Se não for 9, terminar operação
        ACALL invalido ; | Imprimir aviso na LCD
        RET
		
fim:
    ret

somar_preco:
    MOV B, R6 ; | Coloca contador em b
    MOV R0, B ; | Coloca contador em R0 para loop
    MOV R1, #20h ; | Endereço dos preços em R1
    MOV A, #0 ;Zerar A para o processo de soma
    loop_soma:
    ADD A, @R1 ; | Adiciona o número dentro de r1 com a
    INC R1 ; | Incrementa o endereço de r1
    MOV R3, A ; | Salva preço em A
    DJNZ R0, loop_soma ; | Decrementa R0 e continua o loop caso R0 não seja 0

dividir:
    MOV B, #10 ; | Coloca dez em B
    DIV AB ;divide o valor total por 10 para dividir os dígitos 
	MOV 30h, #0	; | Coloca 0 para a comparação da senha
	MOV 31h, #0 ; | Coloca 0 para a comparação da senha
    MOV 32h, A ; | Coloca decimo em 32h
	;ACALL sendCharacter
    ;INC R0
    MOV 33h, B ; | Coloca unidade em 33h
    ret

checar_tecla2:
	MOV B, R5 ; | Coloca endereço em B
	MOV R0, B ; | Coloca endereço em R0
	MOV R4, A ; | Coloca número digitado em A

	checar_remover:
        CJNE A, 42h, confirmar_pagamento ; | Igual no primeiro
		ACALL amarelo
		DEC R0
	    MOV @R0, #0h
		ACALL apagar_numero ; | Tira o número inserido da LCD também
		MOV A, R4 ; | Coloca o número digitado de volta em A
        DEC R5
		DEC R6
        RET

	confirmar_pagamento:
        CJNE A, 40h, checar_limite2
		ACALL amarelo
		ACALL checagem ; | Compara a senha escrita digita pelo usuário com a senha feita com o preço
		RET
	
    checar_limite2:  ; | Igual ao checar_limite1
        MOV 10h, #4
        MOV A, R6
        CJNE A, 10h , checar_1
        ACALL delay
        RET

	checar_1: ; | Compara o número com 1, coloca na memória e um X na lcd
        MOV A, R4
        CJNE A, 4Bh, checar_2
        MOV @R0, #1
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_2: ; | Compara o número digitado com 2, coloca na memória e um X na lcd
        CJNE A, 4Ah, checar_3
        MOV @R0, #2
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_3: ; | Compara o número digitado com 3, coloca na memória e um X na lcd
        CJNE A, 49h, checar_4
        MOV @R0, #3
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_4: ; | Compara o número digitado com 4, coloca na memória e um X na lcd
        CJNE A, 48h, checar_5
        MOV @R0, #4
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_5: ; | Compara o número digitado com 5, coloca na memória e um X na lcd
        CJNE A, 47h, checar_6
        MOV @R0, #5
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_6: ; | Compara o número digitado com 6, coloca na memória e um X na lcd
        CJNE A, 46h, checar_7
        MOV @R0, #6
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_7: ; | Compara o número digitado com 7, coloca na memória e um X na lcd
	    CJNE A, 45h, checar_8
        MOV @R0, #7
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_8: ; | Compara o número digitado com 8, coloca na memória e um X na lcd
	    CJNE A, 44h, checar_9
        MOV @R0, #8
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

	checar_9: ; | Compara o número digitado com 9, coloca na memória e um X na lcd
	    CJNE A, 43h, checar_0
        MOV @R0, #9
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET
	
    checar_0: ; | Compara o número digitado com 0, coloca na memória e um X na lcd
        CJNE A, 41h, fim2
        MOV @R0, #0h
		MOV A, #120
		ACALL sendCharacter
		MOV A, R4
        INC R6
        INC R5
        RET

    fim2:
        ret

checagem:
    MOV R0, #20h
    MOV R1, #30h
    MOV R2, #0
    MOV R3, #4
    loop_checagem:
    MOV A, @R1	
    CJNE A, 20h, errado
    INC R1
    MOV A, @R1	
    CJNE A, 21h, errado
    INC R1
    MOV A, @R1	
    CJNE A, 22h, errado
    INC R1
    MOV A, @R1	
    CJNE A, 23h, errado
    INC R1
    ACALL passou
    RET

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
    
	ACALL checar_tecla1
 	;ACALL sendCharacter 
 	CLR F0 ; | limpa f0 para nao dar problemas 
 	DJNZ R3, pressionado_1 ; | DECREMENTA R3 E VOLTA
	; | Parte para imitar um enter;(#23H = #)
	MOV R3, #23H
; | itera pela label ate o valor de A ser igual ao de 03h

; | Quando enter é pressionado no pressionado_1 vem pro pressionado_2
pressionado_2:
	ACALL leituraTeclado
	JNB F0, pressionado_2  ; | if F0 is clear, jump to pressionado_2
    MOV A, #40h ; | pega endereço 40h e guarda ele em A
	ADD A, R0 ; | adiciona em A o que ta no R0 (valor que a pessoa clicou)
 	MOV R0, A 
	MOV A, @R0  ; | passa para A o conteudo do que está no endereço de R0
                  
    MOV R7, A ; | Adiciona valor relacionado ao botao do teclado pressionado_2, que esta em a, no R7
    MOV R2, #30H ; | coloca valor 30 no r2 
    SUBB A, R2 ; | subtrai valor de a com 30 que ai da o valor pressionado_2 (para restar somente o valor de fato pessoa clica em 1 fica guardado 31)
    MOV @R1, A ; | coloca o resultado de a no endereco de r1 
    INC R1 ; | incrementa r1 para ir pro prox endereço de valor guardado
    MOV A, R7   
	 
	ACALL checar_tecla2
 	;ACALL sendCharacter 
 	CLR F0 ; | limpa f0 para nao dar problemas 
 	DJNZ R3, pressionado_2 ; | DECREMENTA R3 E VOLTA
	; | Parte para imitar um enter;(#23H = #)(pessoa apos escrever a senha tem que clicar no # para verificar se ta certa ou nao)
	MOV R3, #23H
    ; | itera pela label ate o valor de A ser igual ao de 03h
	JMP pressionado_2
	
errado:
    LCALL negou ; | Função de erro da senha
	MOV R6, #0 ; | Reset contador
	MOV R5, #20h ; | Reseta endereço 
	ACALL valor_total ; | Imprime preço de novo
	ACALL mostrar_senha ; | Começa o processo de escrever a senha de novo
	RET

; ------------------------------ Leitura do teclado --------------------------------
     
leituraTeclado:
 	MOV R0, #0		
 	MOV P0, #0FFh	
 	CLR P0.0			; | clear row0
 	CALL colScan		; | call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 		
    ; | (because the pressed key was found and its number is in  R0)
      	; | scan row1
 	SETB P0.0			; | set row0
 	CLR P0.1			; | clear row1
 	CALL colScan		; | call column-scan subroutine
 	JB F0, finish		; | if F0 is set, jump to end of program 						
      	; | scan row2
 	SETB P0.1			; | set row1
 	CLR P0.2			; | clear row2
 	CALL colScan		; | call column-scan subroutine
 	JB F0, finish		; | if F0 is set, jump to end of program 				
      	; | scan row3
 	SETB P0.2			; | set row2
 	CLR P0.3			; | clear row3
 	CALL colScan		; | call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
    
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

    CALL delay_mini

    SETB EN
    CLR EN

    SETB P1.7

    SETB EN
    CLR EN

    CALL delay_mini
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
    CALL delay_mini

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
    CALL delay_mini
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

; | Posiciona o cursor na linha e coluna desejada.
; | Escreva no Acumulador o valor de endereço da linha e coluna.

;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|

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

; ------------------------------- Motor ------------------------------------------

; | A cada rotação do motor retira 1 da quantidade de itens, enquanto a quantidade não for 0, o motor deve girar.

; | Espera por um sinal de rotação completa no pino P3.2
rotacao:
	MOV TMOD, #01010000b
	SETB TR1
    JNB P3.2, rotacao ; | Espera até que sensor no pino P3.2 indique a rotação completa
	CLR P3.1  ; | Parar o motor
	RET

loop_motor:
    ACALL rotacao
    DJNZ R0, loop_motor
    SETB P3.0
    SETB P3.1
    RET
       
; ----------------------------------- Bebidas e + ----------------------------------

CONFERE:
    DB " " ; | O valor (senha) terá quatro digitos, sendo compostos pelo valor da conta em si, e caso o valor da conta não tenha 4 digitos, adicione um 0 ao começo dele.
    DB 00h ; | Declara string, e lê até o fim

MAQUINA:
    DB "   MAQUINA DE"
    DB 0 ; | Caracter null indica fim da String

BEBIDAS:
    DB "BEBIDAS"
    DB 0

COCA:
    DB "  1- Coca    R$ 5"
    DB 0 

PEPSI:
    DB "2- Pepsi   R$ 6"
    DB 0

SPRITE:
    DB " 3- Sprite  R$ 4"
    DB 0

SUKITA: 
    DB "4- Sukita  R$ 3"
    DB 0

REDBULL: 
    DB " 5- Redbull R$ 7"
    DB 0

MONSTER:
    DB "6- Monster R$ 8"
    DB 0

PAGAR:
    DB " #-    Pagar"
    DB 0

CANCELAR: 
    DB "*-   Cancelar"
    DB 0

ZERO:
    DB "  0- Retirar item"
    DB 0

TRANSACAO:
    DB "   TRANSACAO "
    DB 0

APROVADA:
    DB "    APROVADA "
    DB 0

NEGADA:
    DB "     NEGADA "
    DB 0

RETIRE:
    DB "   RETIRE OS "
    DB 0

PRODUTOS:
    DB "PRODUTOS ABAIXO"
    DB 0

AVISO:
    DB "   Compras de ate"
    DB 0

AVISO_2:
    DB "    3 itens"
    DB 0

CHEIO:
    DB "  LIMITE EXCEDIDO"
    DB 0 

NUMERO_INVALIDO:
    DB "NUMERO INVALIDO"
    DB 0

VALOR:
    DB "  Total R$"
    DB 0

SENHA:
    DB "Senha - "
    DB 0

; ---------------------------------- Prints ---------------------------------------

opcoes:

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#MAQUINA ; | DPTR = Inicio da palavra 
    ACALL escreveString
    MOV A, #44h
    ACALL posicionaCursor
    MOV DPTR,#BEBIDAS
    ACALL escreveString
    ACALL delay_mini
    ACALL clearDisplay

; | Inicio
    ACALL delay_mini

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#COCA ; | DPTR = Inicio da palavra 
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#PEPSI
    ACALL escreveString
    ACALL delay_mini
    ACALL clearDisplay

; | Inicio
    ACALL delay_mini

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #SPRITE
    ACALL delay_mini
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #SUKITA
    ACALL escreveString
    ACALL clearDisplay 

; | Fim 

; | Para exibir no display 
    ACALL delay_mini

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #REDBULL
    ACALL delay_mini
    ACALL escreveString
; | Segunda linha 
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #MONSTER
    ACALL escreveString
    ACALL clearDisplay 
	ACALL delay_mini

; | Fim

    ACALL delay_mini

    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #PAGAR
    ACALL delay_mini
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #CANCELAR
    ACALL escreveString
    ACALL clearDisplay 
	ACALL delay_mini
	MOV A, #00h
	ACALL posicionaCursor
	MOV DPTR, #ZERO
	ACALL escreveString
	ACALL delay_mini
	ACALL clearDisplay
	ACALL delay_mini
	MOV A, #00h
	ACALL posicionaCursor
	MOV DPTR, #AVISO
	ACALL escreveString
	ACALL delay_mini
	MOV A, #40h
	ACALL posicionaCursor
	MOV DPTR, #AVISO_2
	ACALL escreveString
	ACALL clearDisplay
	;ACALL delay_mini
	RET

; | Nega a transação caso o valor inserido esteja incorreto e reseta tudo.
invalido:
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#NUMERO_INVALIDO ; | DPTR = Inicio da palavra 
	;ACALL delay_mini
    ACALL escreveString
	;ACALL delay_mini
	ACALL clearDisplay
	RET

negou: ; | Print de transação errada
	ACALL vermelho ; | Acende LEDS
	ACALL clearDisplay
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#TRANSACAO ; | DPTR = Inicio da palavra 
	ACALL delay
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#NEGADA
    ACALL escreveString
    ACALL delay
    ACALL clearDisplay
	ACALL delay
	RET

; | Se passar o motor deve girar conforme a quantidade de produtos vezes dois e após isso mostrar a mensagem para retirada.
passou: ; | Imprime transação aprovada
	ACALL verde ; | Acende LEDS
	ACALL clearDisplay
	ACALL delay
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR,#TRANSACAO ; | DPTR = Inicio da palavra 
	ACALL delay
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR,#APROVADA
    ACALL escreveString
    ACALL delay
    ACALL clearDisplay

    retirada: ; | Rotaciona motor e imprime aviso
        MOV A, #00h
        ACALL posicionaCursor
        MOV DPTR,#RETIRE ; | DPTR = Inicio da palavra
        MOV A, 70h
        MOV B, #10 ; | Rotações por item
        MUL AB ; | Número de rotações
        MOV R0, A ; | Movendo para o loop
        ACALL loop_motor
        ACALL delay 
        ACALL escreveString
        MOV A, #40h
        ACALL posicionaCursor
        MOV DPTR,#PRODUTOS
        ACALL escreveString
        ACALL delay
        ACALL clearDisplay
        ACALL reset
        SJMP $

valor_total: ; | Imprime valor da compra
	ACALL delay
    MOV A, #40h
	ACALL delay
    ACALL posicionaCursor
    MOV DPTR, #VALOR
	ACALL delay
    ACALL escreveString
    MOV A, 32h
    ADD A, #30h
    ACALL sendCharacter
    MOV A, 33h
    ADD A, #30h
    ACALL sendCharacter
    RET

mostrar_senha: ; | Mostra quanto da senha está escrito
   ; ACALL clearDisplay
    ACALL delay
    MOV A, #00h
    ACALL posicionaCursor
    ACALL delay
    MOV DPTR, #SENHA
    ACALL escreveString
    RET

apagar_numero: ; | Apaga um número da LCD
    MOV A, #8
    ADD A, R6
    ACALL posicionaCursor
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #8
    ADD A, R6
    ACALL posicionaCursor
    RET
; | Fazer o display atualizar com valor e o número de produtos do pedido, conforme a pessoa aperta o teclado em sua primeira fase.

; ---------------------------------- Leds ------------------------------------

; | Função para acender um LED específico no port P2
acender:
    MOV A, R0 ; | Assumindo que o número do pino está em R0
    MOV P2, A
    ACALL delay2
    RET

; | Apaga todos os leds
apagar:
    ;ACALL delay
    MOV P2, #0FFH 
    RET

; | Chamada da função para acender o LED no pino P2
; | Converte o número das portas que quer acender (0 ligado, 1 desligado) do binario 8 casas para hexadecimal e passa para a porta dos leds
; | 00H liga tudo, 0FFH desliga tudo

verde:
    MOV R0, #0DFH 
    CALL acender
    MOV R0, #0DBH 
    CALL acender
    CALL apagar
    RET

vermelho:
    MOV R0, #0BFH 
    CALL acender
    MOV R0, #0B7H 
    CALL acender
    MOV R0, #0B6H 
    CALL acender
    CALL apagar
    RET

amarelo:
    MOV R0, #07FH 
    CALL acender
    MOV R0, #06FH 
    CALL acender
    MOV R0, #06DH 
    CALL acender
    CALL apagar
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

delay2:
    MOV R1, #50
    MOV R0, #50
    DJNZ R0, $
    DJNZ R1, $

delay_mini:
   MOV R1, #50
   DJNZ R1, $
   RET
   
; ----------------------------- End of subroutines -----------------------------

; ---------------------------------- Main --------------------------------------

main:
    ACALL lcd_init
    ACALL opcoes
	ACALL pressionado_1
JMP main

; ------------------------------- End of Main ----------------------------------