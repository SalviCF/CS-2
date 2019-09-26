        .set    GPBASE,   0x3F200000
        .set    GPFSEL0,        0x00
	.set    GPFSEL1,        0x04
	.set	 GPFSEL2,		0x08
        .set    GPSET0,         0x1c
 
.text	
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov   r1, #0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 9
	
/* guia bits           xx999888777666555444333222111000*/
	ldr	r1, =0b00000000001000000000000000001001
        str	r1, [r0, #GPFSEL1]  @ Configura GPIO 10, 11, 17
	
/* guia bits           xx999888777666555444333222111000*/
	ldr	r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]	@ Configura GPIO 22, 27

/* guia bits           10987654321098765432109876543210*/
        ldr  	r1, =0b00001000010000100000111000000000
        str     r1, [r0, #GPSET0]   @ Enciende todos los LEDs

infi:  	b       infi


@ El truco era usar ldr en vez de mov  (mov est� limitada cuando son gpios muy separados).


