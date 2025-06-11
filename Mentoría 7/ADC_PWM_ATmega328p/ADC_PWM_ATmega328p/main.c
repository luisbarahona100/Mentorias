

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


// Inicializar Timer1 para PWM
void TIMER1_init() {
	DDRB |= (1<<PB1); // PB1/OC1A como salida PB1 o OC1 como output -> LED que varía su brillo al variar el duty cycle con el pot

	// Configurar Timer1 en modo Fast PWM, 8-bit
	TCCR1A = (1<<WGM10) | (1<<COM1A1); // WGM10 para Fast PWM de 8 bits, COM1A1 para no inversa
	TCCR1B = (1<<WGM12) | (1<<CS11); // Prescaler de 8
}


// Actualizar ciclo de trabajo del PWM
void PWM_set_duty(uint8_t duty) {
	OCR1A = duty; // El valor de OCR1A determina el ciclo de trabajo
}


int main() {
	// Configurar puertos
	DDRC &= ~(1<<0); // PC0 como input -> Potenciómetro
	PORTC &= ~(1<<0); // PC0 sin pull up
	
	DDRB |= (1<<0); // PB0 como output -> LED que se prende si pot>2.5V
	

	// Inicializar ADC y TIMER0
	ADC_init();
	TIMER0_init();
	TIMER1_init();
	
	sei(); // Habilitar interrupciones globales
	
	while(1) {
		
		// Comparar el valor leído del ADC
		if (lectura >= 512) { // ¿lectura >= 4V? 819 corresponde a 4V (4/5 * 1024)
			PORTB |= (1<<0); // Encender LED
			} else {
			PORTB &= ~(1<<0); // Apagar LED
		}
		
		// Convertir la lectura del ADC (0-1023) a un ciclo de trabajo (0-255)
		uint8_t duty_cycle = 0;
		if (lectura > 50) { // Umbral para evitar que el LED se encienda cuando el potenciómetro esté casi en cero
			duty_cycle = lectura / 4;
		}
		PWM_set_duty(duty_cycle);
		
		_delay_ms(50); // Pequeño retraso para estabilidad
		//test_PROGRAMADOR();
		
	}
}
