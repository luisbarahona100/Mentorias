//GOAL: Desplazamiento Aritmético a la Derecha usando una Macro


#include <avr/io.h>
#include <stdint.h>

// Macro para ASR de 8 bits
#define ASR8(x)  (x = (x >> 1) | (x & 0x80))

void ASR16(int16_t *value, uint8_t n) {
	uint8_t *low = (uint8_t *)value;        // Byte bajo
	uint8_t *high = ((uint8_t *)value) + 1; // Byte alto

	while (n--) {
		ASR8(*high);                        // ASR en el byte alto
		uint8_t carry = *high & 0x01;       // Bit menos significativo del alto
		*low = (*low >> 1) | (carry << 7);  // ROR: rotar derecha el byte bajo
	}
}

int main(void) {
	int16_t number = 0x6010;  // Número original
	uint8_t shifts = 2;       // Cantidad de desplazamientos

	ASR16(&number, shifts);   // Ejecutar desplazamiento aritmético 2 veces

	while (1) {
		// Aquí puedes observar el valor en un depurador
	}
}


