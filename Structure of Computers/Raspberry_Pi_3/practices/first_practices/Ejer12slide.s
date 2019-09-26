@ Author: Salvi CF

        .include  "inter.inc"
.text
/* Agrego vector interrupcion */
        ADDEXC  0x18, irq_handler
	
@  Código para Raspberry Pi 3 . Después de agregar el vector de interrupción. Para modo SVC (supervisor)	 --------------------------------------------------------

	mrs r0,cpsr						 	@ mete cprs en r0 (CPSR: Current Program Status Register)
	mov r0, #0b11010011 						@ Modo SVC (10011), FIQ&IRQ desac (110); (3 primeros bits: I,F,T y 5 últimos: MODE) en r0
	msr spsr_cxsf,r0						@ modifica el spsr los 4 bytes(Saved Program Status Register) (análogo a cpsr) del modo SVC con lo que hay en r0
	add r0,pc,#4
	msr ELR_hyp,r0
	eret

/* Inicializo la pila en modos IRQ y SVC */
        mov     r0, #0b11010010   @ Modo IRQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0b11010011   @ Modo SVC, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000000

/* Configuro GPIOs 9 como salida */
        ldr     r0, =GPBASE
        mov     r1, #0b00001000000000000000000000000000
        str     r1, [r0, #GPFSEL0]
/* Configuro GPIOs 10 como salida */
        mov     r1, #0b00000000000000000000000000000001
        str     r1, [r0, #GPFSEL1]
	
/* Enciendo LEDs    10987654321098765432109876543210 */
	mov r1, # 0b00000000000000000000011000000000
	str r1, [r0, #GPSET0 ]

/* Habilito pines GPIO 2 y 3 (pulsadores) para interrupciones*/
        mov     r1, #0b00000000000000000000000000001100
        str     r1, [r0, #GPFEN0]
        ldr     r0, =INTBASE

/* Habilito interrupciones, local y globalmente */
        mov     r1, #0b00000000000100000000000000000000
/* guia bits           10987654321098765432109876543210*/
        str     r1, [r0, #INTENIRQ2]
        mov     r0, #0b01010011   @ Modo SVC, IRQ activo
        msr     cpsr_c, r0

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupcion */
irq_handler:
        push    {r0, r1}
        ldr     r0, =GPBASE
	
/* Consulto si se ha pulsado el boton GPIO2 */
        ldr     r2, [r0, #GPEDS0]
	mov	r3, r2 
        ands    r2, #0b00000000000000000000000000000100
/* Si: Activo GPIO 9*/
/*  guia bits                54321098765432109876543210*/
        movne   r1, #0b00000000000000000000001000000000
	strne   r1, [r0, #GPSET0]
	
/* Desactivo el flag GPIO pendiente de atencion
   guia bits                 54321098765432109876543210*/
        movne   r1, #0b00000000000000000000000000000100	
	strne   r1, [r0, #GPEDS0]
   
fin:	pop     {r0, r1, r2}
        subs    pc, lr, #4
