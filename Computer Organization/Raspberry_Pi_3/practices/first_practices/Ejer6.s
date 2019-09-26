@ Author: Salvi CF

        .set    GPBASE,   0x3F200000
        .set    GPFSEL0,        0x00
        .set    GPSET0,         0x1c
	.set    GPBASE,   0x3F200000
        .set    GPFSEL0,        0x00
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    STBASE,   0x3F003000
        .set    STCLO,          0x04
.text
	
	mov 	r0, #0b11010011
	@ msr	cpsr_c, r0, debo ponerlo como cpsr_f para que funcione
	mov 	sp, #0x8000000							@ Inicializ. pila en modo SVC
 
	ldr     r4, =GPBASE
	
/* guia bits           xx999888777666555444333222111000*/
        mov   	r5, #0b00001000000000000000000000000000
        str   	r5, [r4, #GPFSEL0]  						@ Configura GPIO 9
	
/* guia bits           10987654321098765432109876543210*/
        mov   	r5, #0b00000000000000000000001000000000
        ldr   	r0, =STBASE    							@ r0 es un parametro de espera (dir. base ST)

	ldr	r6, =6000000							@ Tiempo que estaré en cada cadencia

principio:
	ldr	r1, =500000							@ Cadencia 1 seg (microsec.) medio seg, enciendo, medio seg, apago
	bl	inicio
	ldr	r1, =250000							@ Cadencia medio seg (microsec.) 
	bl	inicio
	ldr	r1, =125000							@ Cadencia medio seg (microsec.) 
	bl	inicio
	b	principio
	
inicio:
	push	{r6, lr}							@ machacaré r6!
	ldr     r7, [r0, #STCLO]						@ Lee contador en r7
        add   	r6, r7								@ le sumo los 6 seg. que estaré en cada estado. Machaco r6!
bucle:	
        bl      espera        							@ Salta a rutina de espera
        str     r5, [r4, #GPSET0]						@ enciende led
        bl      espera        							@ Salta a rutina de espera
        str     r5, [r4, #GPCLR0]						@apaga led
	
	ldr    	r7, [r0, #STCLO]
        cmp  	r7, r6            						@ Leemos CLO hasta alcanzar r6
        blo    	bucle              						
	pop	{r6, lr}
        bx     	lr

/* rutina que espera medio segundo, un cuarto de seg y un octavo de segundo según el valor de r1 antes del bl */
espera:	
	push	{r4,r5}								@ los registros se tiene que guardar en orden
        ldr     r4, [r0, #STCLO]						@ Lee contador en r4
        add   	r4, r1            						@ r4= r4+medio millon
ret1: 	ldr    	r5, [r0, #STCLO]
        cmp  	r5, r4            						@ Leemos CLO hasta alcanzar
        blo    	ret1              						@ el valor de r4
	pop	{r4,r5}
        bx     	lr
	