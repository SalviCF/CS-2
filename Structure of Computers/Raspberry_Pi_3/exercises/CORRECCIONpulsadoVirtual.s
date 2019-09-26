        .set    GPBASE,   0x3F200000
        .set    GPFSEL0,        0x00
	.set    GPFSEL1,        0x04
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
	.set	GPLEV0,		0x34
 
.text	
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov   	r1, #0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 9
	mov r3, #0

bucle:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100
	beq	encender
	b 	bucle

encender:
	cmp r3, #0
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        streq     r1, [r0, #GPSET0]   @ Enciende GPIO 9
	strne    r1, [r0, #GPCLR0]   @ Enciende GPIO 9
	eor	r3, r3,#1
/* guia bits           xx999888777666555444333222111000*/
        @ldr   	r1, =0b00001000000000000000001000000000
        @str	r1, [r0, #GPFSEL0]  @ Configura GPIO 3 como salida
	b bucle

bucle2:	
	ldr	r1, [r0, #GPLEV0]
	ands	r2, r1, #0b00000000000000000000000000000100
	beq	apagar
	b 	bucle2
	
apagar:
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPCLR0]   @ Apaga GPIO 9
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000001000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 3 como salida
	b 	bucle

