@ Author: Salvi CF

/*Using these starting files, the Raspberry Pi3 goes to a new special mode denoted "v7-Hypervisor (HYP)". 
This mode does not allow to change to IRQ mode or FIQ mode and thus, 
we have to move the processor from HYP mode to supervisor mode (SVC) which is the defalult mode of the Raspberry Pi 1 & 2.
To do that, you have to include the next code at the beginning of any program if we use a Raspberry Pi 3*/   

.include  "inter.inc"							@ Puertos, macros etc

.text

	
/* Agrego vector interrupcion */
        ADDEXC  0x18, irq_handler					@ Macro que calcula es offset del manejador y escribe el vector en la tabla de vectores
	
@  Código para Raspberry Pi 3 . Después de agregar el vector de interrupción. Para modo SVC (supervisor)	 --------------------------------------------------------

	mrs r0,cpsr						 	@ mete cprs en r0 (CPSR: Current Program Status Register)
	mov r0, #0b11010011 						@ Modo SVC (10011), FIQ&IRQ desac (110); (3 primeros bits: I,F,T y 5 últimos: MODE) en r0
	msr spsr_cxsf,r0						@ modifica el spsr los 4 bytes(Saved Program Status Register) (análogo a cpsr) del modo SVC con lo que hay en r0
	add r0,pc,#4
	msr ELR_hyp,r0
	eret
@ ---------------------------------------------------------------------------------------------------------------------------------------------

/* Inicializo la pila en modos IRQ y SVC */
        mov     r0, #0b11010010   					@ cargo r0 con Modo IRQ (10010), FIQ&IRQ desact (110)
        msr     cpsr_c, r0						@ modifica ese segmento del registro cpsr (efectúa el cambio)
        mov     sp, #0x8000						@ inicializo puntero de pila modo irq (8000)
        mov     r0, #0b11010011   					@ Modo SVC (10011), FIQ&IRQ desact (110)
        msr     cpsr_c, r0						@ modifica ese segmento (efectúa el cambio)
        mov     sp, #0x8000000						@ inicializo puntero pila modo svc (8000000)
	

/* Configuro GPIO 9 como salida */
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov     r1, #0b00001000000000000000000000000000
        str     r1, [r0, #GPFSEL0]
	

/* Programo contador C1 para futura interrupcion */
/* Podría usar un registro para cargar el tiempo de espera con un ldr. Así es más preciso que con hexadecimal*/
/* Sólo puedo usar contador 1 o 3 (0 y 2 son exclusivos del sistema)*/
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #0x400000     					@ (400000)hex = (4,19 segundos) decimal (lo que tarda en producirse la interrupción)
        str     r1, [r0, #STC1]						@ lo meto en el contador 1

/* Habilito interrupciones, local y globalmente */
@ Localmente
        ldr     r0, =INTBASE						@ Base de las interrupciones en r0
        mov     r1, #0b0010						@ comparador 1 activo en r1
        str     r1, [r0, #INTENIRQ1]					@ habilito como interrupción con su puerto asociado
@ Globalmente
        mov     r0, #0b01010011   					@ Modo SVC, IRQ activo (010)
        msr     cpsr_c, r0						@ modifico byte c por r0

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupción */
irq_handler:
        push    {r0, r1}          					@ Salvo registros
			
        ldr     r0, =GPBASE
/* guia bits           10987654321098765432109876543210*/
        ldr     r1, =0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0] 					@ Enciendo LED

        pop     {r0, r1}          					@ Recupero registros
        subs    pc, lr, #4        					@ Salgo de la RTI (siempre de esa forma)
