        .set    GPBASE,   0x3F200000
	.set    GPFSEL0,  0x00
        .set    GPFSEL1,  0x04
	.set    GPFSEL2,  0x08
        .set    GPSET0,   0x1c
	.set	GPLEV0,   0x34
.text
        ldr     r0, =GPBASE
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00001000000000000000000000000000
        str	r1, [r0, #GPFSEL0]  @ Configura GPIO 9  como salida (1)
						@ GPIO 2 y 3 como entrada (0)
								
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00000000000000000000000000001000
        str	r1, [r0, #GPFSEL1]  @ Configura GPIO 11  como salida (1)
	
/* guia bits           xx999888777666555444333222111000*/
        ldr   	r1, =0b00000000000000000000000001000000
        str	r1, [r0, #GPFSEL2]  @ Configura GPIO 22  como salida (1)
	
	
	
@ máscara para testar GPIO2 o GPIO3 (cualquiera de los dos pulsadores)
@ tengo que pulsar los dos (uno detras de otro) para que se enciendan los leds)
/* guia bits	      10987654321098765432109876543210*/
	mov 	r1,	#0b00000000000000000000000000001100	

	
bucle:        
	ldr r2, [r0, #GPLEV0]		@ cargo GPLEV0 para leer GPIO 2 y 3
	ands r1, r2			@ meto en r1 el resultado de la operación AND con  r2
@ tras pulsar uno de los pulsadores, se convierte en 0 uno de los 1, y después el otro, saliendo del bucle y encendiendo los leds
	bne bucle
	
	
/* guia bits           10987654321098765432109876543210*/
        ldr   	r1, =0b00000000010000000000101000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9, 11, 22
	
infi:  	b       infi




