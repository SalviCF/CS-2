@ Author: Salvi CF

.include "inter.inc"

.text

/* Agrego vector interrupci�n */

	ADDEXC 0x18, irq_handler
	ADDEXC 0x1c, fiq_handler

@  C�digo para Raspberry Pi 3 . Despu�s de agregar el vector de interrupci�n. Para modo SVC (supervisor)	
	mrs r0,cpsr						@ mete cprs en r0 (CPSR: Current Program Status Register)
	mov r0, #0b11010011 					@ Modo SVC (10011), FIQ&IRQ desac (110); (3 primeros bits: I,F,T y 5 �ltimos: MODE) en r0
	msr spsr_cxsf,r0					@ modifica el spsr los 4 bytes(Saved Program Status Register) (an�logo a cpsr) del modo SVC con lo que hay en r0
	add r0,pc,#4
	msr ELR_hyp,r0
	eret

/* Inicializo la pila en modos FIQ, IRQ y SVC */
	mov r0, #0b11010001 					@ Modo FIQ (10001), FIQ&IRQ desact (110)
	msr cpsr_c, r0
	mov sp, #0x4000
	mov r0, #0b11010010 					@ Modo IRQ (10010), FIQ&IRQ desact (110)
	msr cpsr_c, r0
	mov sp, #0x8000
	mov r0, #0b11010011 					@ Modo SVC (10011), FIQ&IRQ desact (110)
	msr cpsr_c, r0
	mov sp, #0x8000000

/* Configuro GPIOs 4, 9, 10, 11, 17, 22 y 27 como salida */
	ldr r0, =GPBASE
/* guia bits       xx999888777666555444333222111000 */
	ldr r1, =0b00001000000000000000000000000000
	str r1, [r0, #GPFSEL0]
/* guia bits       xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, #GPFSEL1]
/* guia bits       xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]
	
/* Programo C1 y C3 para dentro de 2 microsegundos */
	ldr r0, =STBASE
	ldr r1, [r0, #STCLO]
	add r1, #2						@ sumo los 2 microsegundos
	str r1, [r0, #STC1]					@ meto la suma en el comparador 1
	str r1, [r0, #STC3]					@ meto la suma en el comparador 3
	
/* Habilito C1 para IRQ */
	ldr r0, =INTBASE
	mov r1, #0b0010						@ comparador 1
	str r1, [r0, #INTENIRQ1]
	
/* Habilito C3 para FIQ */
	mov r1, #0b10000011					@ el bit m�s significativo es para habilitar fiq
								@ c3 es el bit 3 de irq1 por tanto su c�digo es 11
								@ si es de irq2 hay que sumar 32 al n� de bit
	str r1, [r0, #INTFIQCON]				@ lo meto en el FIQ control
	
/* Habilito interrupciones globalmente */
	mov r0, #0b00010011 					@ Modo SVC (10011), FIQ&IRQ activo (000)
	msr cpsr_c, r0
	
/* Repetir para siempre */
bucle: 	b bucle

@ ----------------------------------------------------------------------------------------------------------
/* Rutina de tratamiento de interrupci�n IRQ */
irq_handler :
	push {r0, r1, r2}
	ldr r0, =GPBASE
	ldr r1, =cuenta
	
/* Apago todos     10987654321098765432109876543210 */
	ldr r2, =0b00001000010000100000111000000000
	str r2, [r0, #GPCLR0]
	ldr r2, [r1] 							@ Leo variable cuenta
	subs r2, #1 							@ Decremento
	moveq r2, #6 							@ Si es 0, volver a 6
	str r2, [r1], #-4						@ Escribo cuenta y resto 4 a puntero r1
	ldr r2, [r1, +r2, LSL #3] 					@ Leo secuencia
									@ multiplico por 8 porque a�ado los microseg (sonido)
									@ r2 = r1 + (r2*8) me lleva al LED correcto
									@ recordar que 1 word = 4 bytes en arm
	str r2, [r0, # GPSET0]	 					@ Escribo secuencia en LEDs
	
/* Reseteo estado interrupci�n de C1 */
	ldr r0, =STBASE
	mov r2, #0b0010
	str r2, [r0, #STCS ]
	
/* Programo siguiente interrupci�n en 500ms */
	ldr r2, [r0, #STCLO]
	ldr r1, =500000 						@ 2 Hz
	add r2, r1
	str r2, [r0, #STC1]
	
/* Recupero registros y salgo */
	pop {r0, r1, r2}
	subs pc, lr, #4

@ --------------------------------------------------------------------------------------------------------
/* Rutina de tratamiento de interrupci�n FIQ */
fiq_handler :
	ldr r8, =GPBASE
	ldr r9, =bitson
	
/* Hago sonar altavoz invirtiendo estado de bitson */
	ldr r10, [r9]
	eors r10, #1
	str r10, [r9], #4						@ a r9 (puntero) le sumo 4 (lo llevo a la siguiente palabra)
	
/* Leo cuenta y luego elemento correspondiente en secuen */
	ldr r10, [r9]							@ ej primera vez: r10=6, 6*8=48, 48/4=12 words desde pos de cuenta
									@ (que se va decrementando en la irq_handler
	ldr r9, [r9, + r10, LSL #3]
	
/* Pongo estado altavoz seg�n variable bitson */
	mov r10, #0b10000 						@ GPIO 4 ( altavoz )
	streq r10, [r8, #GPSET0]					@ chequeo flag Z el tras el eors de arriba
	strne r10, [r8, #GPCLR0]
	
/* Reseteo estado interrupci�n de C3 */
	ldr r8, =STBASE
	mov r10, #0b1000
	str r10, [r8, #STCS]
	
/* Programo retardo seg�n valor le�do en array */ @ para la siguiente nota
	ldr r10, [r8, #STCLO]
	add r10, r9							@ r9 = [puntero cuenta + r10*8] por lo tanto depende de cuenta
	str r10, [r8, #STC3]
	
@ 220 veces m�s con la nota m�s grave (La) 1136*2= 2272, 500000(medio seg)/2272=220
	
/* Salgo de la RTI */
	subs pc, lr, #4

@ --------------------------------------------------------------------------------------------------------
/* Zona de datos*/
bitson : .word 0 							@ Bit 0 = Estado del altavoz (el -4 te trae aqu�)
cuenta : .word 1 							@ Entre 1 y 6, LED a encender
secuen : .word 0b1000000000000000000000000000
	.word 716	 						@ Retardo para nota 6
	.word 0b0000010000000000000000000000
	.word 758 							@ Retardo para nota 5
/* guia bits    7654321098765432109876543210 */
	.word 0b0000000000100000000000000000
	.word 851 							@ Retardo para nota 4
	.word 0b0000000000000000100000000000
	.word 956 							@ Retardo para nota 3
/* guia bits    7654321098765432109876543210 */
	.word 0b0000000000000000010000000000
	.word 1012 							@ Retardo para nota 2
	.word 0b0000000000000000001000000000
	.word 1136 							@ Retardo para nota 1