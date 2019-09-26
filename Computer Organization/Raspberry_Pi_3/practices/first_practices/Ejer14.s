@ Author: Salvi CF

.include "inter.inc"
.include "notas.inc"

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
	ldr r1, =0b00001000000000000001000000000000
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
	
	ldr r3, =cuenta2
	ldr r4, [r3]
	subs r4, #1
	moveq r4, #29
	str r4, [r3]
	
/* Apago todos     10987654321098765432109876543210 */
	ldr r2, =0b00001000010000100000111000000000
	str r2, [r0, #GPCLR0]
	ldr r2, [r1] 							@ Leo variable cuenta
	subs r2, #1
									@ Decremento
	moveq r2, #6 							@ Si es 0, volver a 6
	str r2, [r1]							@ almaceno cuenta
	
	ldr r2, [r1, +r2, LSL #2] 					@ Leo secuencia
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
	ldr r1, =500000 						
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
	
/* Hago sonar altavoz invirtiendo estado de bitson (onda cuadrada ceros y unos)*/
	ldr r10, [r9]
	eors r10, #1
	str r10, [r9], #-4						@ a r9 (puntero) le sumo 4 (lo llevo a la palabra anterior: cuenta2)
	
/* Leo cuenta y luego elemento correspondiente en secuen */
	ldr r10, [r9]							@ ej primera vez: r10=13, 13*4=52, 52/4=13 palabras desde secuen2
	ldr r11, =secuen2						@ leo puntero secuen2 (notas)
									
	ldr r9, [r11, +r10, LSL #2]					@ 6*4=24, 24/4=6 words desde secuen2 en r9
	
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
	add r10, r9
	str r10, [r8, #STC3]
	
/* Salgo de la RTI */
	subs pc, lr, #4

@ --------------------------------------------------------------------------------------------------------
/* Zona de datos*/
cuenta2: .word 1
bitson : .word 0 							@ Bit 0 = Estado del altavoz (el -4 te trae aqu�)
cuenta : .word 1 							@ Entre 1 y 6, LED a encender
secuen : 
	.word 0b1000000000000000000000000000
	.word 0b0000010000000000000000000000
	.word 0b0000000000100000000000000000
	.word 0b0000000000000000100000000000
	.word 0b0000000000000000010000000000
secuen2:.word 0b0000000000000000001000000000
	.word 1275	@ SOL
	.word 1136	@ LA
	.word 1275	@ SOL
	.word 1012	@ SI
	.word 955	@ DO'	
	.word 5		@ SILENCIO
	.word 955	@ D0'
	.word 1516	@ MI
	.word 1351	@ FA#
	.word 1275	@ SOL
	.word 1012	@ SI
	.word 851	@ RE'
	.word 1702	@ RE
	.word 5		@ SILENCIO
	.word 1702	@ RE
	.word 1275	@ SOL
	.word 1136	@ LA
	.word 1702	@ RE
	.word 1516	@ MI						
	.word 1702	@ RE
	.word 5		@ SILENCIO
	.word 1702	@ RE		
	.word 1351	@ FA#		
	.word 1275	@ SOL			
	.word 1702	@ RE			
	.word 1516	@ MI			
	.word 1702	@ RE
	.word 5		@ SILENCIO
	.word 1702	@ Primera nota RE			