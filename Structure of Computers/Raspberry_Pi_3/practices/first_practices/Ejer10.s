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

/* Configuro GPIO 10, 11, 17 como salida */
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        ldr     r1, =0b00001000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
	
/* Configuro GPIO 22, 27 como salida */
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        ldr     r1, =0b00001000001000000000000001000000
        str     r1, [r0, #GPFSEL2]
	

/* Programo contador C1 para futura interrupcion */
/* Podría usar un registro para cargar el tiempo de espera con un ldr. Así es más preciso que con hexadecimal*/
/* Sólo puedo usar contador 1 o 3 (0 y 2 son exclusivos del sistema)*/
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #2    						@ 2 microsegundos (lo que tarda en llegar la primera interrupción)
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
bucle:  b       bucle							@ me quedo aquí esperando a que ocurran las interrupciones

/* Rutina de tratamiento de interrupción */
irq_handler:

/* El estado de los LEDs (si están apagados o encendidos) lo guardamos en la
variable ledst, que conmutamos entre cero y uno mediante un OR exclusivo. Sólo una de las entradas a 1 para salida a 1 (xor)*/
/*Al actualizar los flags tras esta operación, tenemos que si el resultado fue cero nos lo
indica el flag Z activo, mientras que estará inactivo en el caso contrario (resultado
1).*/
/*Mediante las instrucciones de ejecución condicional streq y strne enviamos la
orden al puerto que enciende los LEDs o al puerto que los apaga, respectivamente:*/
	push    {r0, r1}          					@ Salvo registros

	ldr r0, =ledst 							@ Leo el PUNTERO a variable ledst en r0
	ldr r1, [r0] 							@ Ahora leo la variable indica por ese puntero en r1 (lo saco de memoria)
	eors r1, #1 							@ Invierto bit 0, act. flag Z. XOR entre lo que había en variable y 1
									@ Si había 1 paso a 0 y si había un 0 paso a 1
	str r1, [r0] 							@ Escribo variable en la posición indicada por puntero
				
        ldr     r0, =GPBASE
/* guia bits           10987654321098765432109876543210*/
        ldr     r1, =0b00001000010000100000111000000000
        streq   r1, [r0, #GPSET0] 					@ enciendo/almaceno si flag Z=1 (activo)
	strne	r1, [r0, #GPCLR0]					@ apago/almaceno si flag Z=0 (inactivo)
									@ en una interrupción haré una cosa y en la otra la siguiente, logrando el parpadeo
	
	ldr r0, =STBASE							@ base de temporizador
	mov r1, #0b0010							@ pongo 1 en contador 1 para resetearlo (activarlo de nuevo; almacenar un 0)
	str r1, [r0, #STCS]						@ guarda r1 en el comparador
	
	ldr r1, [r0, #STCLO]						@ leo contador en r1
	ldr r2, =500000 						@ medio segundo a 1 Hz (tiempo entre interrupción e interrupción)
	add r1, r2							@ le sumo el medio segundo
	str r1, [r0, #STC1]						@ lo almaceno en el comparador 1
	
        pop     {r0, r1}          					@ Recupero registros
        subs    pc, lr, #4        					@ Salgo de la RTI (siempre de esa forma)
	
ledst: .word 0								@ en memoria esa variable cuyo valor es 0