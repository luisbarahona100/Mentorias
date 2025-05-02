import math

def calcular_retardo(FrecuenciaReloj, delayDeseado):
    T_ciclo = 1 / FrecuenciaReloj  # Tiempo de un ciclo
    max_reg = 256  # 8 bits -> 0 a 255
    
    mejor_error = float('inf')
    mejor_config = None
    
    for R1 in range(1, max_reg):
        for R2 in range(1, max_reg):
            nop_float = delayDeseado / (T_ciclo * R1 * R2)
            nop = round(nop_float)
            if nop <= 0:
                continue
            delay_real = nop * T_ciclo * R1 * R2
            error = abs(delay_real - delayDeseado)
            if error < mejor_error:
                mejor_error = error
                mejor_config = (R1, R2, nop, delay_real)
    
    if mejor_config:
        R1, R2, nop, delay_real = mejor_config
        print(f"Delay deseado: {delayDeseado*1e6:.2f} us")
        print(f"Delay real:    {delay_real*1e6:.2f} us")
        print(f"Error:         {mejor_error*1e6:.2f} us")
        return {
            'Registro1': R1,
            'Registro2': R2,
            'NOPs_internos': nop,
            'Delay_real': delay_real,
            'Error': mejor_error
        }
    else:
        print("No se encontró configuración válida.")
        return None

resultado = calcular_retardo(16e6,1) #1Mhz, 1 segundo
print(resultado)