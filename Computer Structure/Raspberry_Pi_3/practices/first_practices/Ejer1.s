@ Author: Salvi CF

        .set    GPBASE,   0x3F200000
        .set    GPFSEL1,  0x04
        .set    GPSET0,   0x1c
	
.text
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov   	r1, #0b00000000000000000000000000001000
        str	r1, [r0, #GPFSEL1]  @ Configura GPIO 11
	
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000100000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 11
infi:  	b       infi
