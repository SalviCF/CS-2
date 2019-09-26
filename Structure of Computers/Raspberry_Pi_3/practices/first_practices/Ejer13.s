@ Author: Salvi CF

.include "inter.inc"

.text

/* Agrego vector interrupción */

	ADDEXC 0x18, irq_handler

@  Código para Raspberry Pi 3 . Después de agregar el vector de interrupción. Para modo SVC (supervisor)	
	mrs r0,cpsr						 	@ mete cprs en r0 (CPSR: Current Program Status Register)
	mov r0, #0b11010011 						@ Modo SVC (10011), FIQ&IRQ desac (110); (3 primeros bits: I,F,T y 5 últimos: MODE) en r0
	msr spsr_cxsf,r0						@ modifica el spsr los 4 bytes(Saved Program Status Register) (análogo a cpsr) del modo SVC con lo que hay en r0
	add r0,pc,#4
	msr ELR_hyp,r0
	eret
	
/* Inicializo la pila en modos IRQ y SVC */
	mov r0, # 0b11010010 @ Modo IRQ, FIQ&IRQ desact
	msr cpsr_c, r0
	mov sp, # 0x8000
	mov r0, # 0b11010011 @ Modo SVC, FIQ&IRQ desact
	msr cpsr_c, r0
	mov sp, # 0x8000000

/* Configuro GPIOs 4, 9, 10, 11, 17, 22 y 27 como salida */
	ldr r0, =GPBASE		      @
	ldr r1, =0b00001000000000000001000000000000
	str r1, [r0, #GPFSEL0 ]
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, #GPFSEL1]
	ldr r1, = 0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]
	
/* Programo C1 y C3 para dentro de 2 microsegundos */
	ldr r0, =STBASE
	ldr r1, [r0, #STCLO]
	add r1, #2
	str r1, [r0, #STC1]
	str r1, [r0, #STC3]
	
/* Habilito interrupciones, local y globalmente */
	ldr r0, =INTBASE
	mov r1, #0b1010						@ timer 1 y 3
	str r1, [r0, #INTENIRQ1]				@ pending 1
	mov r0, # 0b01010011 					@ Modo SVC, IRQ activo (010)
	msr cpsr_c, r0
	
/* Repetir para siempre */
bucle : b bucle

@ ----------------------------------------------------------------------------------------------------------
/* Rutina de tratamiento de interrupción */
irq_handler :
	push {r0, r1, r2, r3}
	
/* Leo origen de la interrupción */
	ldr r0, =STBASE						@ base del system timer
	ldr r1, =GPBASE						@ base GPIO
	
	ldr r2, [r0, #STCS]					@ leo el estado de los comparadores en r2
	ands r2, #0b0010					@ si comparador 1 estaba a 1, Z=0 tras el ands, no saltaré, ejecuto LEDs
	beq sonido
	
/* Si es C1, ejecuto secuencia de LEDs */
	ldr r2, =cuenta						@ puntero en r2 contador desde 6 hasta 1. Índice de array secuen
/* guia bits  	   10987654321098765432109876543210 */
	ldr r3, =0b00001000010000100000111000000000
	str r3, [r1, #GPCLR0] 					@ Apago todos los LEDs
	ldr r3, [r2] 						@ Leo valor variable cuenta (contador)
	subs r3, #1 						@ Decremento 1 al contador y actualizo flags
	moveq r3, #6						@ Si es 0, retorno a 6 (inicio)
	str r3, [r2] 						@ Escribo cuenta (almaceno en pos memoria que indica puntero)
	ldr r3, [r2, +r3, LSL #2] 				@ r3 = r2 + (r3*4)
								@ el + se puede omitir pero el - no
								@ r2 = dir base cuenta. r3 valor contador
								@ cambio de orden los .word se cambia todo
	str r3, [r1, #GPSET0 ] 					@ Escribo secuencia en LEDs. El .word que toque
	
/* Reseteo estado interrupción de C1 */
	mov r3, # 0b0010					@ pongo un 1 para almacenar un 0
	str r3, [r0, #STCS]
	
/* Programo siguiente interrupción en 200ms */
	ldr r3, [r0, #STCLO]
	ldr r2, =200000 					@ 0.2 segundos
	add r3, r2
	str r3, [r0, #STC1]
	
/* ¿Hay interrupción pendiente en C3?*/
	ldr r3, [r0, #STCS]
	ands r3, # 0b1000					@ Si no hubo interrupción (no coincidió con stc1), r3 = 0 tras el ands y voy a final
	beq final 						@ Si sí, no tomo el salto y hago sonar el altavoz
	
/* Si es C3, hago sonar el altavoz */
sonido : ldr r2, =bitson
	ldr r3, [r2]
	eors r3, #1 						@ Invierto estado con xor
	str r3, [r2]
	mov r3, #0b10000 					@ GPIO 4 (altavoz)
	streq r3, [r1, #GPSET0] 				@ Escribo en altavoz
	strne r3, [r1, #GPCLR0] 				@ Escribo en altavoz
	
/* Reseteo estado interrupción de C3 */
	mov r3, #0b1000
	str r3, [r0, #STCS]
	
/* Programo interrupción para sonido de 440 Hz */
	ldr r3, [r0, #STCLO]
	ldr r2, =1136
	add r3, r2
	str r3, [r0, #STC3]
	
/* Recupero registros y salgo */
final : pop {r0, r1, r2, r3}
	subs pc, lr, #4
	
bitson : .word 0 							@ Bit 0 = Estado del altavoz
cuenta : .word 1 							@ Entre 1 y 6, LED a encender
/* guia bits    7654321098765432109876543210 */
secuen :.word 0b1000000000000000000000000000
	.word 0b0000010000000000000000000000
	.word 0b0000000000100000000000000000
	.word 0b0000000000000000100000000000
	.word 0b0000000000000000010000000000
	.word 0b0000000000000000001000000000
