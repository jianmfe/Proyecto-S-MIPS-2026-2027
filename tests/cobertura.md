# Tabla de cobertura de tests/ (tabla 3 de la guia)

| Fila de la tabla 3 | Casos obligatorios | Programa principal | Tambien lo ejercitan |
|---|---|---|---|
| add, sub | operandos positivos y al menos uno negativo | t01_aritmetica | t09 |
| and, or | unos en los 16 bits altos | t01_aritmetica | t09 |
| slt, slti | resultado 1 y 0; negativo con comparacion con/sin signo distinta | t02_comparacion_desplazamiento | t09 |
| sll, srl | shamt = 0 y != 0; srl sobre negativo | t02_comparacion_desplazamiento | t09 |
| addi | inmediato negativo | t01_aritmetica | t06, t07, t08, t09 |
| addiu, addu | via li (-2^15..2^15-1) y move | t01_aritmetica | todos |
| andi, ori | inmediato con bit 15 = 1 | t03_inmediatos_zero | t09 |
| lui | inmediato con bit 15 = 1 | t03_inmediatos_zero | t09 |
| lw, sw | desplazamiento positivo y negativo | t04_memoria_palabra | t09 |
| lb, lbu | byte con bit 7 = 1 en varias posiciones | t05_memoria_byte | t09 |
| sb | cuatro posiciones de una palabra, comprobado con lw | t05_memoria_byte | t09 |
| beq, bne | tomado y no tomado; salto hacia atras | t06_saltos | t07, t09 |
| j | al menos una vez | t06_saltos | t07, t09 |
| jal, jr | procedimiento no hoja, $ra en la pila | t07_llamadas | todos (phs/phn) |
| syscall | servicios 11 y 10 | t08_syscall_decimal | todos |
| $zero | escribir en $zero y comprobar que sigue en 0 | t03_inmediatos_zero | - |

Las 25 instrucciones (23 de S-MIPS mas addu y addiu) se ejecutan en el conjunto.
