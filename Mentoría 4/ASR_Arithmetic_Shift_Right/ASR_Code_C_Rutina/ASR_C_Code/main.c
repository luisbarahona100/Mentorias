//GOAL: Este code realiza un desplazamiento arimético a la derecha usando rutinas = función 

#include <avr/io.h>
#include <stdint.h>

//RUTINA ASR (Aithmetic Shift Right)
void asr16(int16_t *value, uint8_t n) {
	for (uint8_t i = 0; i < n; i++) {
		// Realizar desplazamiento aritmético
		// Convertimos el número en una variable temporal
		int16_t temp = *value;

		// Desplazamiento aritmético: replicar el bit de signo
		*value = (temp >> 1) | (temp & 0x8000);
	}
}

int main(void) {
	// Simulación del comportamiento del código ensamblador

	int16_t num = 0b0110000000010000;  // Equivale a R17:R16 = 0x60:0x10
	uint8_t shifts = 2;

	asr16(&num, shifts);  // Desplazar 2 veces aritméticamente a la derecha

	while (1) {
		// Aquí podrías observar el resultado con un depurador o exportarlo a un puerto
		// Por ejemplo, si quisieras ver el resultado en PORTD:
		PORTD = (uint8_t)(num & 0x00FF);  // byte bajo
	}
}
