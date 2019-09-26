@ Como el temporizador va a 1MHz, para temporizar medio segundo lo �nico que tenemos que hacer es esperar a que el contador se incremente en medio mill�n.
@ cada paso del contador se corresponde con un microsegundo -> 10^-6
@ frecuencia temporizador f = 1 MHz = 10^6 Hz; frecuencia = 1/ tiempo de ciclo (tck); tck = 1/f = 1/10^6 = 10^-6 seg = 1 microsegundo
@ Por tanto, si 1 ck equivale a 1 microsegundo, para 1 seg necesitamos 1 mill�n de ciclos.

.set GPBASE,  0x3F200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPSET0, 0x1c
.set GPCLR0, 0x28
.set STBASE, 0x3F003000						@ direcci�n base del system timer
.set STCLO, 0x04						@ parte baja del contador ascendente de 64 bits

.text
/* Esto no hace falta: es para las interrupciones. C�digo que inicializa los punteros de pila: 10011->supervisor (SVC)
	mov r0, #0b11010011					@ FIQ & IRQ desactivado
	msr cpsr_c, r0						@ cpsr_c no es una errata pero no funciona, con cpsr_f s�
	mov sp, #0x8000000					@ Inicializo pila en modo SVC, FIQ & IRQ desactivado */
	
	ldr r4, =GPBASE						@ este registro se machacar�
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r5, =0b00001000000000000000000000000000
        str	r5, [r4, #GPFSEL0]  				@ Configura GPIO 9
	
/* guia bits 	   10987654321098765432109876543210 */
	mov r5, #0b00000000000000000000001000000000		@ para encender GPIO 9 posteriormente (este registro se machacar�)
	
	ldr r0, =STBASE						@ cargo la direccio�n base del system timer en r0
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
	add	r4, r1						@ r4 = r4 + medio mill�n
ret1:
	ldr	r5, [r0, #STCLO]
	cmp	r5, r4					@ leemos CLO hasta alcanzar el valor de r4
	blo	ret1						@ branch if lower: salto si cuando C=0 (diapo 7 tema 4: Condition codes)
								
	pop	{r4, r5}					@ saco de la pila los registros que guard�
	bx	lr						@ branch and exchange (vuelvo a instrucci�n siguiente a la del salto)
	
	
@ Si op1 > op2 ; C=1
@ Si op1 < op2 ; C=0
@ Si op1 = op2 ; C=1
@ blo: branch if lower: salto si C=0 -> op1 < op2
	
/* Teor�a ***********************************************************************************************
1.
cpsr : Current Program Status Register: es para interrupciones
Almacena las banderas condicionales y los bits de control. Los
bits de control definen la habilitaci�n de interrupciones normales (I), interrupciones
r�pidas (F), modo Thumb 1 (T) y el modo de operaci�n de la CPU.
Existen hasta 8 modos de operaci�n, pero por ahora desde nuestra aplicaci�n
s�lo vamos a trabajar en uno de ellos, el Modo Usuario. Los dem�s son modos
privilegiados usados exclusivamente por el sistema operativo.
Desde el Modo Usuario s�lo podemos acceder a las banderas condicionales,
que contienen informaci�n sobre el estado de la �ltima operaci�n realizada
por la ALU. A diferencia de otras arquitecturas en ARMv6 podemos elegir
si queremos que una instrucci�n actualice o no las banderas condicionales,
poniendo una �s� detr�s del nemot�cnico. Existen 4 banderas y son las
siguientes:
N. Se activa cuando el resultado es negativo.
Z. Se activa cuando el resultado es cero o una comparaci�n es cierta.
C. Indica acarreo en las operaciones aritm�ticas.
V. Desbordamiento aritm�tico.

2.
Un nibble son 4 d�gitos binarios; medio byte

3.
Instrucci�n msr:
El modo viene indicado en la parte m�s baja del registro cpsr, el cual modificaremos
con la instrucci�n especial msr. En la figura 5.1 vemos el contenido completo
del registro cpsr. Como cpsr es un registro muy heterog�neo, usamos sufijos para
acceder a partes concretas de �l. En nuestro caso s�lo nos interesa cambiar el byte
bajo del registro, a�adimos el sufijo _c llam�ndolo cpsr_c, para no alterar el resto
del registro. Esta parte comprende el modo de operaci�n y las m�scaras globales de
las interrupciones. Otra referencia �til es cpsr_f que modifica �nicamente la parte
de flags (byte alto). Las otras 3 referencias restantes apenas se usan y son cpsr_s
(Status) para el tercer byte, cpsr_x (eXtended) para el segundo byte y cpsr_csxf
para modificar los 4 bytes a la vez.
Sirve para forzar a los flags a adquirir el valor que queramos:
Donde para calcular el valor hacemos el paso inverso al explicado en gdb. Queremos
cambiar los flags a estos valores: N=0, Z=1, C=1 y V=0. Por el orden memorizado
de la secuencia NZCV, calculamos el nibble binario, que es 0110. Lo pasamos
a hexadecimal 0110 ->6 y lo ponemos en la parte m�s alta de la constante de 32
bits, dejando el resto a cero-> msr cpsr_f, # 0x60000000. Tambi�n hay otra equivalente mrs si lo que queremos es leer de cpsr a un
registro. M�s informaci�n en las diapositivas del tema 4.

4.
Para las funciones que no sean "hoja" (las que a su vez llamen a otras funciones) tenemos que meter lr en la pila (push) adem�s
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
