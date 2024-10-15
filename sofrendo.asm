org 0000H
LJMP main

org 0030h

sendCharacter :
SETB P1.3 ; set RS - indicates that data is being sent to module
MOV C, ACC.7 ; |
MOV P1.7, C ; |
MOV C, ACC.6 ; |
MOV P1.6, C ; |
MOV C, ACC.5 ; |
MOV P1.5, C ; |
MOV C, ACC.4 ; |
MOV P1.4, C ; | high nibble set
SETB P1.2 ; |
CLR P1.2	 ; | negative edge on E
MOV C, ACC.3 ; |
MOV P1.7, C ; |
MOV C, ACC.2 ; |
MOV P1.6, C ; |
MOV C, ACC.1 ; |
MOV P1.5, C ; |
MOV C, ACC.0 ; |
MOV P1.4, C ; | low nibble set
SETB P1.2 ; |
CLR P1.2 ; | negative edge on E
CALL delay ; wait for BF to clear
RET


lcd_init:

CLR P1.3

; function set
CLR P1.7
CLR P1.6
SETB P1.5
CLR P1.4

SETB P1.2
CLR P1.2

CALL delay

; Why is functic

SETB P1.2
CLR P1.2

SETB P1.7

SETB P1.2
CLR P1.2

CALL delay
CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4

SETB P1.2
CLR P1.2

SETB P1.6
SETB P1.5

SETB P1.2
CLR P1.2
CALL delay


;isplay on/o
;he display
CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4

SETB P1.2
CLR P1.2

SETB P1.7
SETB P1.6
SETB P1.5
SETB P1.4

SETB P1.2
CLR P1.2
CALL delay
RET

escreveString:
MOV R2, #0
rot:
MOV A, R2
MOVC A,@A+DPTR ;lê a tabela da memória de programa
ACALL sendCharacter ; send data in A to LCD module
INC R2
JNZ rot ; if A is 0, then end of data has been reached - jump out of loop
RET

posicionaCursor :
CLR P1.3 ; clear RS - indicates that instruction is being sent to module
SETB P1.7 ; |
MOV C, ACC.6 ; |
MOV P1.6, C ; |
MOV C, ACC.5 ; |
MOV P1.5, C ; |
MOV C, ACC.4 ; |
MOV P1.4, C ; | high nibble set
SETB P1.2 ; |
CLR P1.2 ; | negative edge on E
MOV C, ACC.3 ; |
MOV P1.7, C ; |
MOV C, ACC.2 ; |
MOV P1.6, C ; |
MOV C, ACC.1 ; |
MOV P1.5, C ; |
MOV C, ACC.0 ; |
MOV P1.4, C ; | low nibble set

SETB P1.2 ; |
CLR P1.2

CALL delay
RET


;Limpa todo o display e retorna o cursor para primeira posição
clearDisplay :
CLR P1.3 ; clear RS - indicates that instruction is being sent to module
CLR P1.7 ; |
CLR P1.6 ; |
CLR P1.5 ; |
CLR P1.4 ; | high nibble set
SETB P1.2 ; |
CLR P1.2 ; | negative edge on E
CLR P1.7 ; |
CLR P1.6 ; |
CLR P1.5 ; |
SETB P1.4 ; | low nibble set
SETB P1.2 ; |
CLR P1.2 ; | negative edge on E
CALL delay ; wait for BF to clear
RET


;Retorna o cursor para primeira posição sem limpar o display
retornaCursor :
CLR P1.3 ; clear RS - indicates that instruction is being sent to module
CLR P1.7 ; |
CLR P1.6 ; |
CLR P1.5 ; |
CLR P1.4 ; | high nibble set
SETB P1.2 ; |
CLR P1.2 ; | negative edge on E
CLR P1.7 ; |
CLR P1.6 ; |
SETB P1.5 ; |
SETB P1.4 ; | low nibble set
SETB P1.2 ; |
CLR P1.2 ; | negative edge on E
CALL delay ; wait for BF to clear
RET

FEI:
DB "CC-4.50  Spr-6.00"
DB 0 ;caracter null indica fim da String
Display:
DB "P-3.50 Mons-7.00"
DB 0

main:
ACALL lcd_init
MOV A, #00h
ACALL posicionaCursor
MOV DPTR,#FEI ;DPTR = início da palavra FEI
ACALL escreveString
MOV A, #40h
ACALL posicionaCursor
MOV DPTR,#Display ;DPTR = início da palavra Display
ACALL escreveString
JMP $


delay:
MOV R0, #50
DJNZ R0, $
RET