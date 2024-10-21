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
MOVC A,@A+DPTR ;lÃª a tabela da memÃ³ria de programa
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


;Limpa todo o display e retorna o cursor para primeira posiÃ§Ã£o
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


;Retorna o cursor para primeira posiÃ§Ã£o sem limpar o display
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

COCA:
DB "Coca Cola - 3.50"
DB 0 ;caracter null indica fim da String
SPRITE:
DB "Sprite - 3.50"
DB 0
MONSTER: 
DB "Monster - 7.50"
DB 0
PEPSI:

DB "Pepsi - 3.50"
DB 0

main:
CLR P2.1
CLR P2.3
CLR P2.5
CLR P2.7
ACALL lcd_init
MOV A, #00h
ACALL posicionaCursor
MOV DPTR,#COCA ;DPTR = inÃ­cio da palavra FEI
ACALL escreveString
MOV A, #40h
ACALL posicionaCursor
MOV DPTR,#PEPSI ;DPTR = inÃ­cio da palavra Display
ACALL escreveString

ACALL delay
ACALL clearDisplay
ACALL delay
MOV A, #00h

ACALL posicionaCursor

MOV DPTR, #SPRITE
ACALL delay
ACALL escreveString
MOV A, #40h
ACALL posicionaCursor
MOV DPTR, #MONSTER
ACALL escreveString
ACALL clearDisplay 
JMP main


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

START:
; put data in RAM
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

MAIN:
	ACALL lcd_init
ROTINA:
	ACALL leituraTeclado
	JNB F0, ROTINA   ;if F0 is clear, jump to ROTINA
	MOV A, #07h
	ACALL posicionaCursor	
	MOV A, #40h
	ADD A, R0
	MOV R0, A
	MOV A, @R0        
	ACALL sendCharacter
	CLR F0
	JMP ROTINA




leituraTeclado:
	MOV R0, #0			; clear R0 - the first key is key0

	; scan row0
	MOV P0, #0FFh	
	CLR P0.0			; clear row0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row1
	SETB P0.0			; set row0
	CLR P0.1			; clear row1
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row2
	SETB P0.1			; set row1
	CLR P0.2			; clear row2
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row3
	SETB P0.2			; set row2
	CLR P0.3			; clear row3
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
finish:
	RET

; column-scan subroutine
colScan:
	JNB P0.4, gotKey	; if col0 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.6, gotKey	; if col2 is cleared - key found
	INC R0				; otherwise move to next key
	RET					; return from subroutine - key not found
gotKey:
	SETB F0				; key found - set F0
	RET					; and return from subroutine



