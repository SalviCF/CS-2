.set GPBASE,  0x3F200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPSET0, 0x1c
.set GPCLR0, 0x28

.text
	ldr r0, = GPBASE
	
/* guia bits 	    xx999888777666555444333222111000 */
	mov r1, # 0b00001000000000000000000000000000
	str r1, [r0, # GPFSEL0] 				@ Configura GPIO 9 como salida
	
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, # GPFSEL1] 				@ Configura GPIO 10, 11, 17
	
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, # GPFSEL2]					@ Configura GPIO 22, 27
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000101000000000		@ para los primeros de cada color
   
	
bucle : 
	ldr r2, =900000						@ cargo esa cifra en r2
	
ret1 : 	subs r2, #1 						@ Bucle de retardo 1: voy restando 1 a la cifra
	bne ret1						@ cuando sea el resultado sea 0, z=1 y saldré del loop
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000001000000000
	str r1, [r0, # GPSET0 ] 				@ Enciende red1
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00001000000000000000000000000000
	str r1, [r0, # GPCLR0 ] 				@ Apaga green2
	
	ldr r2, = 900000					@ recargo la constante
	
ret2 : 	subs r2, #1 						@ Bucle de retardo 2
	bne ret2
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000001000000000
	str r1, [r0, # GPCLR0 ] 				@ Apaga red1
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000010000000000
	str r1, [r0, # GPSET0 ] 				@ Enciende red2
	
	ldr r2, = 900000
	
ret3 : 	subs r2, #1 						@ Bucle de retardo 3
	bne ret3
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000010000000000
	str r1, [r0, # GPCLR0 ] 				@ Apaga red2
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000100000000000
	str r1, [r0, # GPSET0 ] 				@ Enciende yellow1
	
	ldr r2, = 900000
	
ret4 : 	subs r2, #1 						@ Bucle de retardo 4
	bne ret4
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000100000000000
	str r1, [r0, # GPCLR0 ] 				@ Apaga yellow1
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000100000000000000000
	str r1, [r0, # GPSET0 ] 				@ Enciende yellow2
	
	ldr r2, = 900000
	
ret5 : 	subs r2, #1 						@ Bucle de retardo 5
	bne ret5
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000100000000000000000
	str r1, [r0, # GPCLR0 ] 				@ Apaga yellow2
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000000000000000
	str r1, [r0, # GPSET0 ] 				@ Enciende green1
	
	ldr r2, = 900000
	
ret6 : 	subs r2, #1 						@ Bucle de retardo 6
	bne ret6
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000000000000000
	str r1, [r0, # GPCLR0 ] 				@ Apaga green1
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00001000000000000000000000000000
	str r1, [r0, # GPSET0 ] 				@ Enciende green2
								
	b bucle 						@ Repetir para siempre
	

