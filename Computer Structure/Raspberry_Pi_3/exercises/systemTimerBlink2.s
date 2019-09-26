@ Como el temporizador va a 1MHz, para temporizar medio segundo lo único que tenemos que hacer es esperar a que el contador se incremente en medio millón.
@ cada paso del contador se corresponde con un microsegundo -> 10^-6
@ frecuencia temporizador f = 1 MHz = 10^6 Hz; frecuencia = 1/ tiempo de ciclo (tck); tck = 1/f = 1/10^6 = 10^-6 seg = 1 microsegundo
@ Por tanto, si 1 ck equivale a 1 microsegundo, para 1 seg necesitamos 1 millón de ciclos.

.set GPBASE,  0x3F200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPSET0, 0x1c
.set GPCLR0, 0x28
.set STBASE, 0x3F003000						@ dirección base del system timer
.set STCLO, 0x04						@ parte baja del contador ascendente de 64 bits

.text
/* Esto no hace falta: es para las interrupciones. Código que inicializa los punteros de pila: 10011->supervisor (SVC)
	mov r0, #0b11010011					@ FIQ & IRQ desactivado
	msr cpsr_c, r0						@ cpsr_c no es una errata pero no funciona, con cpsr_f sí
	mov sp, #0x8000000					@ Inicializo pila en modo SVC, FIQ & IRQ desactivado */
	
	ldr r4, =GPBASE						@ este registro se machacará
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r5, =0b00001000000000000000000000000000
        str	r5, [r4, #GPFSEL0]  				@ Configura GPIO 9
	
/* guia bits 	   10987654321098765432109876543210 */
	mov r5, #0b00000000000000000000001000000000		@ para encender GPIO 9 posteriormente (este registro se machacará)
	
	ldr r0, =STBASE						@ cargo la direccioón base del system timer en r0
	ldr r1, =500000						@ mete en r1 esa constante
	
bucle:
	bl espera
	str r5, [r4, #GPSET0]					@ Enciende GPIO 9
	bl espera
	str r5, [r4, #GPCLR0]					@ Apaga GPIO 9
	b bucle
	
/* Rutina espera *****************************************************************************************/

espera:
	push	{r4, r5}					@ guarda los valores que hay en r4 y r5 en la pila porque se van a machacar
	ldr	r4, [r0, #STCLO]				@ lee contador en r4
	add	r4, r1						@ r4 = r4 + medio millón
ret1:
	ldr	r5, [r0, #STCLO]
	cmp	r5, r4					@ leemos CLO hasta alcanzar el valor de r4
	blo	ret1						@ branch if lower: salto si cuando C=0 (diapo 7 tema 4: Condition codes)
								
	pop	{r4, r5}					@ saco de la pila los registros que guardé
	bx	lr						@ branch and exchange (vuelvo a instrucción siguiente a la del salto)
	
	
@ Si op1 > op2 ; C=1
@ Si op1 < op2 ; C=0
@ Si op1 = op2 ; C=1
@ blo: branch if lower: salto si C=0 -> op1 < op2
	
/* Teoría ***********************************************************************************************
1.
cpsr : Current Program Status Register: es para interrupciones
Almacena las banderas condicionales y los bits de control. Los
bits de control definen la habilitación de interrupciones normales (I), interrupciones
rápidas (F), modo Thumb 1 (T) y el modo de operación de la CPU.
Existen hasta 8 modos de operación, pero por ahora desde nuestra aplicación
sólo vamos a trabajar en uno de ellos, el Modo Usuario. Los demás son modos
privilegiados usados exclusivamente por el sistema operativo.
Desde el Modo Usuario sólo podemos acceder a las banderas condicionales,
que contienen información sobre el estado de la última operación realizada
por la ALU. A diferencia de otras arquitecturas en ARMv6 podemos elegir
si queremos que una instrucción actualice o no las banderas condicionales,
poniendo una “s” detrás del nemotécnico. Existen 4 banderas y son las
siguientes:
N. Se activa cuando el resultado es negativo.
Z. Se activa cuando el resultado es cero o una comparación es cierta.
C. Indica acarreo en las operaciones aritméticas.
V. Desbordamiento aritmético.

2.
Un nibble son 4 dígitos binarios; medio byte

3.
Instrucción msr:
El modo viene indicado en la parte más baja del registro cpsr, el cual modificaremos
con la instrucción especial msr. En la figura 5.1 vemos el contenido completo
del registro cpsr. Como cpsr es un registro muy heterogéneo, usamos sufijos para
acceder a partes concretas de él. En nuestro caso sólo nos interesa cambiar el byte
bajo del registro, añadimos el sufijo _c llamándolo cpsr_c, para no alterar el resto
del registro. Esta parte comprende el modo de operación y las máscaras globales de
las interrupciones. Otra referencia útil es cpsr_f que modifica únicamente la parte
de flags (byte alto). Las otras 3 referencias restantes apenas se usan y son cpsr_s
(Status) para el tercer byte, cpsr_x (eXtended) para el segundo byte y cpsr_csxf
para modificar los 4 bytes a la vez.
Sirve para forzar a los flags a adquirir el valor que queramos:
Donde para calcular el valor hacemos el paso inverso al explicado en gdb. Queremos
cambiar los flags a estos valores: N=0, Z=1, C=1 y V=0. Por el orden memorizado
de la secuencia NZCV, calculamos el nibble binario, que es 0110. Lo pasamos
a hexadecimal 0110 ->6 y lo ponemos en la parte más alta de la constante de 32
bits, dejando el resto a cero-> msr cpsr_f, # 0x60000000. También hay otra equivalente mrs si lo que queremos es leer de cpsr a un
registro. Más información en las diapositivas del tema 4.

4.
Para las funciones que no sean "hoja" (las que a su vez llamen a otras funciones) tenemos que meter lr en la pila (push) además
de otros reegistros que queramos salvar para que no sean machacados.
Manejo de la pila: 
push {lr} -> salvar contenido de un registro (lr en este caso) en la pila. Se pueden almacenar varios registros a la vez {r1, r2, r3}
pop {lr} -> sacar contenido de pila y meterlo en un registro (lr). Se puede hacer con varios rg. {r1, r2, r3, r4} 

5.
The C flag is set if the result of an unsigned operation overflows the 32-bit result register. 
The carry (C) flag is set when an operation results in a carry, or when a subtraction results in no borrow.
This bit can be used to implement 64-bit unsigned arithmetic, for example.
https://www.community.arm.com/processors/b/blog/posts/condition-codes-1-condition-flags-and-codes
*/
