#define F_CPU 1000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

// Variables que almacenan la data
volatile uint16_t lectura = 0; // La variable debe ser volatile ya que se modifica en una interrupción

ISR(TIMER0_COMPA_vect) { // Ingresará cada 100ms (usa este tiempo como periodo de muestreo)
	ADCSRA |= (1<<ADSC); // Iniciar conversión
}

ISR(ADC_vect) { //Ingresa a la rutina de servicio de interrupción solo cuando una conversión haya sido completada
	lectura = ADC; // Leer el valor de los registros ADCL y ADCH
}

void ADC_init() {
	// Configurar ADC
	ADMUX = (1<<REFS0); // Referencia AVcc con un condensador externo en AREF (bit7:6 -> 01)
	ADMUX &= ~(1<<ADLAR); // Justificar la data a la derecha (bit5 = 0)
	ADMUX &= ~((1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (1<<MUX0)); // Elegir canal ADC0 para leer -> PC0 -> Potenciómetro (bit3:0 -> 0000)

	ADCSRA = (1<<ADEN); // Habilita el ADC (bit7 -> 1)
	ADCSRA |= (1<<ADIE); // Habilitar interrupciones de conversión terminada (bit3 -> 1)
	//ADCSRA |= (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0); // Seleccionar prescaler de 128 -> 1MHz/128 -> 7.8125kHz
	
	//->  Seleccionar prescaler de 8 -> 1MHz/8 -> 125kHz
	ADCSRA &=~(1<<ADPS2); //Bit2=0
	ADCSRA |= (1<<ADPS1) | (1<<ADPS0); // Bit1:0 -> 11
}

void TIMER0_init() {
	// Configurar TIMER/COUNTER 0 para interrupción por comparación con A
	TCCR0A = (1<<WGM01); // Modo CTC
	TCCR0B = (1<<CS02) | (1<<CS00); // Prescaler = 1024
	TIMSK0 = (1<<OCIE0A); // Habilitar interrupción por comparación con OCR0A
	TCNT0 = 0; // Inicialización del contador
	OCR0A = 97; // Calculado para delay de 100ms
}

void test_PROGRAMADOR(){
	
	PORTB ^= (1<<0);
	_delay_ms(2000);
}
int main() {
	// Configurar puertos
	DDRC &= ~(1<<0); // PC0 como input -> Potenciómetro
	PORTC &= ~(1<<0); // PC0 sin pull up
	
	DDRB |= (1<<0); // PB0 como output -> LED

	// Inicializar ADC y TIMER0
	ADC_init();
	TIMER0_init();
	
	sei(); // Habilitar interrupciones globales
	
	while(1) {
		
		// Comparar el valor leído del ADC
		if (lectura >= 819) { // ¿lectura >= 4V? 819 corresponde a 4V (4/5 * 1024)
			PORTB |= (1<<0); // Encender LED
			} else {
			PORTB &= ~(1<<0); // Apagar LED
		}
		
		//test_PROGRAMADOR();
		
	}
}
