; ESTADO: LED controlado por botón
; GOAL: Prender y apagar un LED cada segundo al presionar un switch

; --- Directivas iniciales ---
.include "m328Pdef.inc"

; --- Redireccionamiento al vector de reset ---
.org 0x00
    rjmp RESET

; --- Configuración del Stack Pointer ---
RESET:
    LDI R19, LOW(RAMEND)
    OUT SPL, R19
    LDI R19, HIGH(RAMEND)
    OUT SPH, R19

; --- Definición de registros temporales ---
.def Rexterno     = R16
.def Rintermedio  = R17
.def Rinterno     = R18

; --- Configuración de puertos ---
    ; Configurar PB1 como entrada (Switch) sin pull-up
    cbi DDRB, 1
    cbi PORTB, 1

    ; Configurar PD1 como salida (LED)
    sbi DDRD, 1
    cbi PORTD, 1     ; Inicialmente LED apagado

; --- Bucle principal ---
MAIN:
    SBIS PINB, 1         ; ¿Switch presionado? (PB1 == 1). Si se cumple, entonces ignora la siguiente línea
    rjmp LEDAPAGADO      ; Si no está presionado (PB1==0), entonces se ejecuta esta línea y reseteamos la salida.

    RCALL TOGGLE_LED     ; Cambia el estado del LED
    RCALL DELAY1SEG      ; Espera 1 segundo

    rjmp MAIN            ; Repetir

LEDAPAGADO:
	cbi PORTD, 1     ;
	RJMP MAIN
; --- Subrutina: Cambiar estado del LED (toggle) ---
TOGGLE_LED:
    LDI R20, (1 << 1)    ; Bitmask para PD1
	IN R21, PIND         ; Cargar el estado del PD1			
    EOR R21, R20         ; Cambiar el bit PD1
	OUT PORTD, R21
    RET

; --- Subrutina: Delay aproximado de 1 segundo ---
DELAY1SEG:
    LDI Rexterno, 4
DELAY_EXTERNO:
    LDI Rintermedio, 250
DELAY_INTERMEDIO:
        LDI Rinterno, 250
DELAY_INTERNO:
            NOP
            DEC Rinterno
            BRNE DELAY_INTERNO
        DEC Rintermedio
        BRNE DELAY_INTERMEDIO
    DEC Rexterno
    BRNE DELAY_EXTERNO
    RET
