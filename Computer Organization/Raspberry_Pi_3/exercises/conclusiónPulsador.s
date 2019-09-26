/* Parece ser que cuando uso el mismo pulsador para apagar y encender no obtenemos un tiempo de respuesta adecuado, que sí se da cuando
se usan dos botones diferentes.*/

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
        ldr   	r1, =0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2, 9 (salida)
					
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2 como entrada de nuevo

bucle:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100	@ pregunta por los GPIO 2 (pulsador 1)
	beq	red1
	b 	bucle	
	
red1:	
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9
	
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000001000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2, 9 (salida)
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000000000000100
        str     r1, [r0, #GPSET0]	@ 1 en GPIO 2 para pulsador en reposo.
					@ 0 en GPIO 2 para que actue como si estuviera pulsado.
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2 como entrada de nuevo
	
bucle2:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000001000	@ pregunta por los GPIO 2 (pulsador 1)
	beq	apagar
	b 	bucle2
	
apagar:	
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 9
	
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000001000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2, 9 (salida)
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000000000000100
        str     r1, [r0, #GPSET0]	@ 1 en GPIO 2 para pulsador en reposo.
					@ 0 en GPIO 2 para que actue como si estuviera pulsado.
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 2 como entrada de nuevo
	b	bucle
