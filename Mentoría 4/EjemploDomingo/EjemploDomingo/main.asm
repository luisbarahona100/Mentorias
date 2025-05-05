
.include "m328Pdef.inc"   ;no es necesaria

; CONFIGURAR RESET (OBLIGATORIO)
.org 0x00                 ;si es necesario para buenas prácticas
    rjmp RESET

; DEFINICIONES (VARIABLES)
.DEF estado_leds = R17



RESET:
	; CONFIGURAR STACK POINTER
	LDI R19, LOW(RAMEND)
    OUT SPL, R19
    LDI R19, HIGH(RAMEND)
    OUT SPH, R19
	; CONFIGURAR LOS PUERTOS 
	;ENTRADA 
	;SALIDAS

	
	;PROGRAMA PRINICPAL
MAIN:
	RCALL TIMER ; GENERA UN DELAY DE 3 SEGUNDOS
	


	; RUTINAS
BIN2BCD:
	
	CPI SUMA, 100	;Comprueba valor menor a 100
	BRLO bBCD8_CONTINUA

	RJMP bBCD8_3

bBCD8_CONTINUA:

	PUSH SUMA		;Respalda registro
	CLR	SALIDA_BCD				;Borra el registro del resultado

bBCD8_1:

	SUBI	SUMA,10	                ;ENTRADA = ENTRADA - 10
	BRCS	bBCD8_2					;Si se activa la bandera "CARY", termina
	SUBI	SALIDA_BCD,-$10 		;SALIDA_BCD = SALIDA_BCD + 10
	RJMP	bBCD8_1					;Regresa al bucle

bBCD8_2:

	SUBI	SUMA,-10		;Deshace la última resta
	ADD	SALIDA_BCD, SUMA	;Junta ambos dígitos "PACKED"
	POP SUMA				;Recupera registro

RET


TIMER:
;AQUO DEBERIA IR LA LOGICA DEL TIMER
RET


