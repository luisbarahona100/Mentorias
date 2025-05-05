//GOAL: Este code realiza un desplazamiento arim�tico a la derecha usando rutinas = funci�n 

#include <avr/io.h>
#include <stdint.h>

//RUTINA ASR (Aithmetic Shift Right)
void asr16(int16_t *value, uint8_t n) {
	uint8_t i = 0;
	while (i < n) {
		// Realizar desplazamiento aritm�tico
		// Convertimos el n�mero en una variable temporal
		int16_t temp = *value;

		// Desplazamiento aritm�tico: replicar el bit de signo
		*value = (temp >> 1) | (temp & 0x8000);
		
		i=i+1;
	}
}

int main(void) {
	// Simulaci�n del comportamiento del c�digo ensamblador
	//Dividir 1024/1024 = 1. Esto equivale a operar 1024>>10 = 8.
	int16_t num = 0b0000010000000000;  // Equivale a R17:R16 = 0x04:0x00
	uint8_t shifts = 10;                //Se necesitan 10 desplazamientos porque 2^10=1024

	asr16(&num, shifts);  // Desplazar 2 veces aritm�ticamente a la derecha

	while (1) {
		// Aqu� podr�as observar el resultado con un depurador o exportarlo a un puerto
		// Por ejemplo, si quisieras ver el resultado en PORTD:
		PORTD = (uint8_t)(num & 0x00FF);  // byte bajo
	}
}
