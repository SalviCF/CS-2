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
	
/* Configuro GPIOs 9 y 10 como salida */
	ldr r0, =GPBASE
	mov r1, #0b00001000000000000000000000000000
	str r1, [r0, #GPFSEL0]
/* guia bits 	    xx999888777666555444333222111000 */
	mov r1, # 0b00000000000000000000000000000001
	str r1, [r0, #GPFSEL1]
	
/* Enciendo LEDs 10987654321098765432109876543210 */
	mov r1, # 0b00000000000000000000011000000000
	str r1, [r0, #GPSET0]
	
/* Habilito pines GPIO 2 y 3 (botones) para que sean fuente de interrupción */
	mov r1, # 0b00000000000000000000000000001100				@ GPIO 2 y 3 (pulsadores)
	str r1, [r0, #GPFEN0]							@ GPIO falling edge detect enable registers
	
	
	ldr r0, =INTBASE							@ base interrupciones
/* Habilito interrupciones, local y globalmente */
@ Localmente
	mov r1, # 0b00000000000100000000000000000000				@ bit 20 de la IRQ pending 2 (IRQ2) para interrupciones de GPIO
/* guia bits        10987654321098765432109876543210 */
	str r1, [r0, #INTENIRQ2]
@ Globalmente
	mov r0, # 0b01010011 							@ Modo SVC, IRQ activo	(010)
	msr cpsr_c, r0
	
/* Repetir para siempre */
bucle:	b bucle

/* Rutina de tratamiento de interrupción */
irq_handler :
	push {r0, r1}
	ldr r0, =GPBASE
	
/* Apago los dos LEDs rojos 54321098765432109876543210 */
	   mov r1, #0b00000000000000000000011000000000
	str r1, [r0, #GPCLR0]
	
/* Consulto si se ha pulsado el botón GPIO2 */
	ldr r1, [r0, #GPEDS0]							@ GPIO event detect status regiterss
	ands r1, #0b00000000000000000000000000000100				@ Si pulsé el GPIO2 habrá un 1 en ese pin tras leer GPEDS0
										@ con lo que NO habrá un 0 en r1: flag Z=INACT tras el ands
	
/* Sí: Activo GPIO 9; No: Activo GPIO 10 */
	movne r1, #0b00000000000000000000001000000000				@ si Z=inac enciendo GPIO9
	moveq r1, #0b00000000000000000000010000000000				@ si Z=act enciendo GPIO10
	str r1, [r0, #GPSET0]
	
/* Desactivo los dos flags GPIO pendientes de atención
guia bits 		  54321098765432109876543210 */
	mov r1, # 0b00000000000000000000000000001100				@ los desactivo poniéndoles un 1 para que me vuelvan a interrumpir
	str r1, [r0, #GPEDS0]
	pop {r0, r1}
	subs pc, lr, #4