.include "m328Pdef.inc"

.def temp = r16         ; Definimos un registro temporal

.org 0x00
    rjmp RESET

; --- Macro sin argumentos ---
.macro set_PORTB2
    sbi PORTB, 2
.endm

RESET:
    ; Configuramos el pin como salida
    ldi temp, (1 << PORTB2)
    out DDRB, temp

MAIN:

    ; Activamos PORTB2 con la macro
    set_PORTB2

    rjmp MAIN  ; Bucle infinito
