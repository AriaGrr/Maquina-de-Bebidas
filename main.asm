;-------------------------------- Repositorio ---------------------------------
; | https://github.com/AriaGrr/Maquina-de-Bebidas
; | Colaboradores: 
; | Marjorie Luize Martins Costa
; | Nuno Martins Guilhermino da Silva
; |

; -------------------- Mapeamento de Hardware (8051) --------------------------------

; | Usar RS no lugar de P1.3 e EN no lugar de P1.2

          RS      equ     P1.3    ; | Reg Select ligado em P1.3
          EN      equ     P1.2    ; | Enable ligado em P1.2


;------------------------------ Inicio do programa --------------------------------
org 0000H
LJMP main

org 0030h

;------------------------------ Mapeia Teclado --------------------------------

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

;------------------------------ Mapeia Valores --------------------------------
; | Talvez desnecessário, analisar.
; | Valor inicial da conta do endereço 30 ao 33

 MOV 30H, #0
 MOV 31H, #0
 MOV 32H, #0
 MOV 33H, #0

;--------------------------------- Subrotinas ---------------------------------

;------------------------------ Manda Caracter --------------------------------

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

;-------------------------------- Inicia LCD ---------------------------------

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

;-------------------------------- Escreve String ------------------------------------

escreveString:
MOV R2, #0
rot:
MOV A, R2
MOVC A,@A+DPTR ; | Tabela de memoria do programa
ACALL sendCharacter ; | Manda a data de A para o modulo
INC R2
JNZ rot ; | if A is 0, then end of data has been reached - jump out of loop
RET

;-------------------------------- Posiciona cursor ---------------------------------

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

;------------------------------- Clear Display ---------------------------------

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

;-------------------------------- Retorna Cursor -------------------------------

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

;----------------------------------- Prints e + ----------------------------------

CONFERE:
    DB " " ; | O valor (senha) terá quatro digitos, sendo compostos pelo valor da conta em si, e caso o valor da conta não tenha 4 digitos, adicione um 0 ao começo dele.
    DB 00h ; | Declara string, e lê até o fim

COCA:
    DB "1- Coca    R$ 5 "
    DB 0 ; | Caracter null indica fim da String

PEPSI:
    DB "2- Pepsi   R$ 6 "
    DB 0

SUKITA: 
    DB "3- Sukita  R$ 3 "
    DB 0

SPRITE:
    DB "4- Sprite  R$ 4 "
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

; ---------------------------------- Opções ------------------------------------
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
    MOV DPTR, #CANCELAR
    ACALL delay
    ACALL escreveString
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #PAGAR
    ACALL escreveString
    ACALL clearDisplay 

; ---------------------------------- Delay ------------------------------------

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

;----------------------------------- End of subroutines -----------------------

; ---------------------------------- Main -------------------------------------

main:
    ACALL lcd_init
    ACALL opcoes

JMP main

; ------------------------------- End of Main ---------------------------------
