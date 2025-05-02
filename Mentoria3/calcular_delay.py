def calcular_delay(f_cpu_hz, loop1, loop2, loop3, instrucciones_por_iteracion):
    t_instruccion = 1 / f_cpu_hz  # Tiempo por instrucción (segundos)
    total_instrucciones = loop1 * loop2 * loop3 * instrucciones_por_iteracion
    delay_segundos = total_instrucciones * t_instruccion
    return delay_segundos

def main():
    print("=== Cálculo de Delay para bucles anidados en ensamblador (ATmega328P) ===")
    
    # Ingreso de datos
    f_cpu_mhz = float(input("Frecuencia del microcontrolador (en MHz, ej. 16): "))
    f_cpu_hz = f_cpu_mhz * 1_000_000

    # Iteraciones ingresadas
    loop1 = int(input("Valor de loop externo (ej. 100): "))
    loop2 = int(input("Valor de loop medio (ej. 200): "))
    loop3 = int(input("Valor de loop interno (ej. 255): "))
    
    instrucciones_por_iteracion = int(input("Número de instrucciones por iteración interna (nop, dec, brne...): "))

    # Cálculo de delay específico
    delay = calcular_delay(f_cpu_hz, loop1, loop2, loop3, instrucciones_por_iteracion)
    print(f"\n👉 Delay generado: {delay:.6f} segundos ({delay * 1000:.2f} ms)")

    # Cálculo de delay máximo
    delay_max = calcular_delay(f_cpu_hz, 255, 255, 255, instrucciones_por_iteracion)
    print(f"⏱️  Delay máximo con 3 registros de 8 bits (255×255×255): {delay_max:.3f} s")

    # Delay mínimo (1 instrucción nop)
    delay_min = 1 / f_cpu_hz
    print(f"⚡ Delay mínimo (1 instrucción): {delay_min * 1_000_000:.2f} µs")

if __name__ == "__main__":
    main()
