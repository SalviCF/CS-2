        .set    GPBASE,   0x3F200000
        .set    GPFSEL0,  0x00
        .set    GPSET0,   0x1c
	.set	GPLEV0,   0x34
.text
        ldr     r0, =GPBASE
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 9  como salida (1)
	                                                        @ GPIO 2 como entrada (0)
	
@ máscara para testar GPIO2 (pulsador)
/* guia bits	      10987654321098765432109876543210*/
	mov 	r1,	#0b00000000000000000000000000000100	@ un 1 lógico indica que el pulsador está en reposo (no pulsado)	 

	
bucle:        
	ldr r2, [r0, #GPLEV0]		@ cargo GPLEV0 para leer GPIO2 (pulsador 1) cuando pulso, habrá un 0 en GPIO2
	ands r1, r2			@ meto en r1 el resultado de la operación AND con  r2
@ de esta forma, si pulso, pondré un 0 lógico en el GPIO2, acabando en r1 un cero
	bne bucle
@ salto si z=0,  es decir, si r1 no es cero. Si r1 es cero, no saltaré.
@ mientras no pulse, r1 nunca será 0 y seguiré saltando para preguntar
@ cuando pulse, saldré del bucle y se ejecutará lo siguiente (que es el encendido del primer led rojo)
	
/* guia bits           10987654321098765432109876543210*/
        ldr   	r1, =0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9
	
infi:  	b       infi

/*
Por último tenemos los pulsadores. Eléctricamente son interruptores que conectan
el pin a masa cuando están presionados. Cuando están en reposo entran en
juego unas resistencias internas de la Raspberry (de pull-up) que anulan el comportamiento
de las de pull-up/pull-down que se cambian por software. De esta forma
los pulsadores envian un 0 lógico por el pin cuando están pulsados y un 1 cuando
están en reposo. */


