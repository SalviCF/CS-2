.set    GPBASE,		0x3F200000
.set    GPFSEL0,	0x00
.set    GPSET0,		0x1c
.set	GPLEV0,		0x34
.set    GPCLR0,         0x28
.set STBASE, 0x3F003000						
.set STCLO, 0x04
	
.text
        ldr     r0, =GPBASE
	ldr r4, =STBASE	
	
/* guia bits           xx999888777666555444333222111000*/
        mov   	r1, #0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  				@ Configura GPIO 9 como salida
	
/* mask for testing GPIO2 */
/* guia bits       10987654321098765432109876543210*/
	mov r2, #0b00000000000000000000000000001000		@ Pulsador en reposo (no pulsado) -> GPIO 3 = 1
bucle:
	ldr r3, [r0, #GPLEV0]					@ Cuando pulso, lo conecto a GND -> GPIO 3 = 0
	tst r3, r2						@ Si r3 = r2 -> Z=0, si r3 != r2 -> Z=1
	bne bucle						@ Tomo el salto mientras sean iguales; Z=0
								@ Cuando pulse, sacaré al GPIO 3 del estado de reposo y serán diferentes
	
/* guia bits           10987654321098765432109876543210*/
        mov   	r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9

infi:	b	infi
	

						
	
	