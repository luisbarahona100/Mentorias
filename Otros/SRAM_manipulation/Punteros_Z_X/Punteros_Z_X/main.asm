;ESTADO: FUNCIONA


; MAIN
MAIN:
    LDI     R21, 1             ; Primer valor a almacenar
    LDI     R20, 8             ; Contador de 8 elementos
	RCALL GRABAR_En_Z          ; Inicializamos Tabla RAM 1 con 8 valores ascendentes
	RCALL COPIAR_Z_To_X
	RJMP MAIN

; SUBRUTINAS
;=========================================================
; Subrutina para inicializar RAM[$150...$157] con valores 1 a 8
;=========================================================
GRABAR_En_Z:
	LDI     R30, LOW(0x150)    ; ZL - puntero al origen
    LDI     R31, HIGH(0x150)   ; ZH
GRABAR:
    ST      Z+, R21            ; Guarda en RAM[Z], luego Z++
    INC     R21                ; Siguiente valor
    DEC     R20                ; Decrementa contador
    BRNE    GRABAR            ; Repetir si no llega a 0
    RET

;=========================================================
; Subrutina para copiar de RAM[$150...$157] a RAM[$200...$207]
;=========================================================
COPIAR_Z_To_X:
    LDI     R30, LOW(0x150)    ; ZL - origen
    LDI     R31, HIGH(0x150)   ; ZH
    LDI     R26, LOW(0x200)    ; XL - destino
    LDI     R27, HIGH(0x200)   ; XH
    LDI     R20, 8             ; Contador de 8 elementos
COPIAR:
    LD      R21, Z+            ; Carga dato desde origen
    ST      X+, R21            ; Guarda en destino
    DEC     R20                ; Decrementa contador
    BRNE    COPIAR             ; Repetir si no termina
    RET
