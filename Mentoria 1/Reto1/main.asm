;
; Reto1.asm
;
; Created: 18/04/2025 07:28:00
; Author : luisdavidbarahona
;


; Replace with your application code
; --- Directivas iniciales ---
.include "m328Pdef.inc"

.org 0x00
    rjmp RESET

; --- Variables temporales ---
.def temp = r16
.def input = r17
.def result = r18
.def num1 = r19
.def num2 = r20
.def diff = r21

; --- RESET vector ---
RESET:
    ; Configurar switches (PD3–PD0) como entrada 
    cbi DDRC, 0
    cbi DDRC, 1
    cbi DDRC, 2
    cbi DDRC, 3
	; Configurar entradas para que sean pull down
	cbi PORTC, 0 ; El PC0 =0 => esto me permite crear un pull down fisico, fuera del atmega
	cbi PORTC, 1 ; El PC1=0 => same 
	cbi PORTC, 2 ; El PC1=0 => same 
	cbi PORTC, 3 ; El PC1=0 => same 

    ; Configurar pulsadores (PB0–PB3) como entrada
    cbi DDRB, 0
    cbi DDRB, 1
    cbi DDRB, 2
    cbi DDRB, 3

	; Configurar pulsadores como pull down = desactivar pull up 
	cbi PORTB, 0 ; el pull down será creado fuera del atega usando una resistencia y un pulsador
    cbi PORTB, 1 ; PORTB[1]=0
    cbi PORTB, 2
    cbi PORTB, 3


    ; No pull-up, pull-down externo (no se configura en el AVR, se asume por hardware externo)

	; Configurar PORTC como salida para PC5 para LED9 y PC4 para LED10
	sbi DDRC, 5  ; DDRC[5]=1
	sbi DDRC, 4  ; DDRC[4]=1

    ; Configurar PORTD (PD7–PD0) como salida (LEDs L7–L0)
    ldi temp, 0xFF
    out DDRD, temp

    

    ; Limpiar LEDs (los inicializamos apagados)
    ldi temp, 0x00
    out PORTD, temp ; PORTD = 0x00 = 0b0000 00000
    cbi PORTC, 5  ; Limpia el PORT[5]=0 LIMPIA EL LED 10
	cbi PORTC, 4 ; Limpia el LED 9

MAIN:
    ; Leer botones
    in temp, PINB

    sbic PINB, 3      ; B3 presionado ; Salta 2 líneas si PINB[3]=0; Pero si PINB[3]=1, salta una linea
    rjmp SAVE_NUM1

    sbic PINB, 2      ; B2 presionado; Slata 2 líneas si PINB[2]=0 (switch B3 no presionado); Saltar una línea si PINB[2]=1 (switch 3 presionado)
    rjmp SAVE_NUM2

    sbic PINB, 1      ; B1 presionado
    rjmp DO_SUM

    sbic PINB, 0      ; B0 presionado
    rjmp DO_SUB

    rjmp MAIN

; --- Guardar Número 1 (R19) y mostrar en LEDs L3-L0 ---
SAVE_NUM1:
    in input, PINC            ; Leer switches en PC3–PC0
    andi input, 0x0F          ; Enmascarar para obtener solo 4 bits
    mov num1, input           ; Guardar en num1

    ; Limpiar solo bits 3–0 del PORTD (mantener bits 7–4 intactos)
    in temp, PIND
    andi temp, 0xF0
    or temp, num1             ; Insertar num1 en bits 3–0
    out PORTD, temp

    rjmp MAIN

; --- Guardar Número 2 (R20) y mostrar en LEDs L7-L4 ---
SAVE_NUM2:
    in input, PINC            ; Leer switches en PC3–PC0
    andi input, 0x0F
    mov num2, input

    ; Limpiar solo bits 7–4 del PORTD (mantener bits 3–0 intactos)
    in temp, PIND
    andi temp, 0x0F           ; F0 = 11110000 ? 0F = 00001111 (mantiene LSB, limpia MSB)
	swap input                ; Mover los bits al nibble alto
    or temp, input             ; Insertar num2 en bits 7–4
    out PORTD, temp

    rjmp MAIN


; --- Suma de R19 + R20 ---
DO_SUM:
    mov temp, num1
    add temp, num2   ;temp = num1+num2
    mov result, temp
	;Limpiar leds 7:0 antes de poner el resultado
	ldi temp, 0x00
    out PORTD, temp 
	;Mostrar el reusltado de la suma
    out PORTD, result

	;Limpiar los prevención los Leds10 y Led9
    in temp, PORTC         ; Leer el valor actual de PORTC
	andi temp, 0b11001111  ; Borrar bits 5 y 4 (conservar los demás)
	out PORTC, temp        ; Escribir el nuevo valor


    rjmp MAIN

; --- Resta de R19 - R20 ---
DO_SUB:
    mov temp, num1
    sub temp, num2  ;temp = num1 - num2
    mov diff, temp
	;Limpiar leds 7:0 antes de poner el resultado
	ldi temp, 0x00
    out PORTD, temp 
	;Mostrar resultado
    out PORTD, diff

    ; Mostrar indicadores LED9 (negativo), LED10 (cero)

    brmi NEGATIVE
    breq ZERO
    rjmp MAIN

NEGATIVE:
    sbi PORTC, 4      ; LED9 prendido con PC4
    rjmp MAIN

ZERO:
    sbi PORTC, 5      ; LED10 prendido con PC5
    rjmp MAIN
