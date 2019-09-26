      
/* Según he observado, cuando pulso uno de los botones, se mantiene pulsado.
Pulsar uno de los botones significa conectarlo a tierra. 
El botón se mantendrá pulsado siempre y cuando no pulse el otro botón.
En el momento en el que pulse el otro botón, será este el que quede conectado a tierra
quedando el primero en estado de reposo (sin pulsar) de nuevo.
Aún no he averiguado la forma de regresar al estado de reposo mediante software, aunque
sospecho que tiene que ver con las interrupciones....SOLUCIONADO en  setearPulsador.s ;) */

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
        mov   	r1, #0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 9
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00000000001000000000000000001001
        str	r1, [r0, #GPFSEL1]  @ Configura GPIO 10, 11, 17
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00000000001000000000000001000000
        str	r1, [r0, #GPFSEL2]  @ Configura GPIO 22, 27
inicio:
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00001000000000000000000000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 27

/* guia bits           10987654321098765432109876543210*/
        ldr   	r1, =0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9

bucle:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100
	beq	red2
	b 	bucle

red2:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000001000
	beq	yellow1
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000010000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 10
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 9
	b 	red2
	
yellow1:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100
	beq	yellow2
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000100000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 11
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000010000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 10
	b 	yellow1
	
yellow2:
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000001000
	beq	green1
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000100000000000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 17
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000100000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 11
	b 	yellow2
	
green1:
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100
	beq	green2
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000010000000000000000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 22
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000100000000000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 17
	b 	green1
	
green2:
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000001000
	beq	inicio
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00001000000000000000000000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 27
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000010000000000000000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 22
	b 	green2
