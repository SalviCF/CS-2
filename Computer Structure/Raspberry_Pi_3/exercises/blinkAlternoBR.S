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
	
/* guia bits 	    xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, # GPFSEL1] 				@ Configura GPIO 10, 11, 17
	
/* guia bits 	    xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, # GPFSEL2]					@ Configura GPIO 22, 27
	
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000101000000000		@ para los primeros de cada color
/* guia bits 	   10987654321098765432109876543210 */
	ldr r3, =0b00001000000000100000010000000000		@ para los segundos de cada color     
	
bucle : 
	ldr r2, =900000						@ cargo esa cifra en r2
	
ret1 : 	subs r2, #1 						@ Bucle de retardo 1: voy restando 1 a la cifra
	bne ret1						@ cuando sea el resultado sea 0, z=1 y saldré del loop
	
	str r1, [r0, # GPSET0 ] 				@ Enciende los primeros de cada color 
	str r3, [r0, # GPCLR0 ] 				@ Apaga los segundos
	
	ldr r2, = 900000					@ recargo la constante
	
ret2 : 	subs r2, #1 						@ Bucle de retardo 2
	bne ret2
	
	str r1, [r0, # GPCLR0 ] 				@ Apaga los primeros de cada color 
	str r3, [r0, # GPSET0 ] 				@ Enciende los segundos
								
	b bucle 						@ Repetir para siempre
	
/* Se mantendrán encendido y apagado una cantidad de tiempo que dependerá del valor de la constante.