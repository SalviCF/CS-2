/* Al configurar un pulsador 1 (GPIO2) como salida (001), tras chequearlo, actúa como si estuviera pulsado. Es decir, tiene un 0 en el GPIO 2.
Es lo mismo que pulsarlo a través de software.
Por tanto, al setearlo y ponerle un 1 en el GPIO 2, regresamos a la posición de reposo (no pulsado) y no saltaremos al bucle de encendido.
Pulsarlo significa conectarlo a tierra, devolviendo 0 lógico.*/
.set    GPBASE,   0x3F200000
        .set    GPFSEL0,        0x00
	.set    GPFSEL1,        0x04
	.set    GPFSEL2,        0x08
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
	.set	GPLEV0,		0x34
 
.text	
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000001000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2, 9 (salida)
	
/* guia bits           10987654321098765432109876543210*/
	mov   	r1, #0b00000000000000000000000000000100
	str     r1, [r0, #GPSET0]	@ 1 en GPIO 2 para pulsador en reposo.
					@ 0 en GPIO 2 para que actue como si estuviera pulsado.

bucle:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100	@ pregunta por los GPIO 2 (pulsador 1)
	beq	red2
	b 	bucle	
	
red2:	
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9
	b 	bucle



