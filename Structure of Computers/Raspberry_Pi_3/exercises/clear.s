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
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 9, 2 y 3
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00000000001000000000000000001001
        str	r1, [r0, #GPFSEL1]  @ Configura GPIO 10, 11, 17
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00000000001000000000000001000001
        str	r1, [r0, #GPFSEL2]  @ Configura GPIO 22, 27
	
/* guia bits           10987654321098765432109876543210*/
        ldr   	r1, =0b00001000010000100000111000000000
        str     r1, [r0, #GPSET0]   @ Enciende todos los leds

bucle:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100		@ cuando pulse el pulsador 1, r2 será cero y z=1 y se tomará el salto
	beq	pulsador1
	ands	r2, r1, #0b00000000000000000000000000001000		@ cuando pulse el pulsador 2, r2 será cero y z=1 y se tomará el salto
	beq	pulsador2
	b 	bucle

pulsador1:	
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000111000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9, 10, 11
/* guia bits           10987654321098765432109876543210*/
        ldr   	r1, =0b00001000010000100000000000000000			@ el clear es igual que el set pero apaga en vez de encender. 1 es apagar.
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 17, 22, 27
	b 	bucle
pulsador2:
/* guia bits           10987654321098765432109876543210*/
        ldr   	r1, =0b00001000010000100000000000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 17, 22, 27
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000111000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 9, 10, 11
	b 	bucle

