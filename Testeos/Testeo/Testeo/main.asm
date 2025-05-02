


; --- Directivas iniciales ---
.include "m328Pdef.inc"  ; PERMITE USAR LAS PALABRAS RESERVADAS PARA EL AAVR

; --- Variables temporales ---

; --- MACRO DE ASR (DESPLAZAMIENTO ARITMETICO A LA DERECHA DE UN BIT)
.macro ASR_1_POSICION
	;PASO 1: COPIAR EL MSB DEL DIVIDENDO EN UN TEMP
	;PASO 2: LSR -> Desplazamiento LÓGICO a la DERECHA
	;PASO 3: AGREGAR EL TEMP EN LOS BITS VACIÓS DEL DIVDIDENDO DESPLAZADO
	bst R17, 7      ; T = R17[7] - HEMOS COPIADO EL msb DEL DIVIDENDO
	lsr R17         ; Desplazamiento lógico a la derecha (rellena con 0)
	bld R17, 7      ; Carga el bit T en el bit 7 (restaurando el signo)
	
.endm

;  --- Redireccionamiento al posición 0x00 de la memoria de programa
.org 0x00
    rjmp RESET


; --- Configuración de puertos e inicialización ---
RESET:


; --- Programa principal ---
MAIN:
	;QUEREMOS: D/d=Q
	;K = LOG2(d) = 1
	LDI R17, 0xF8 ;R17=-8 dividendo
	LDI R18, 0b00000010 ;R18=2 divisor
	
	;ASR_1_POSICION ; LLAMAMOS A LA MACRO PARA EJECUTAR LA DIVISIÓN
	RCALL RUTINA_ASR_1_POSICION
	
	RJMP MAIN




; --- Subrutinas ---
RUTINA_ASR_1_POSICION:
	bst R17, 7      ; T = R17[7] - HEMOS COPIADO EL msb DEL DIVIDENDO
	lsr R17         ; Desplazamiento lógico a la derecha (rellena con 0)
	bld R17, 7      ; Carga el bit T en el bit 7 (restaurando el signo)
RET




