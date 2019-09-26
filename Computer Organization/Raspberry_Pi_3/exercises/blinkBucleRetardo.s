.set GPBASE,  0x3F200000
.set GPFSEL0, 0x00
.set GPSET0, 0x1c
.set GPCLR0, 0x28

.text
	ldr r0, = GPBASE
	
/* guia bits xx999888777666555444333222111000 */
	mov r1, # 0b00001000000000000000000000000000
	str r1, [r0, # GPFSEL0 ] 				@ Configura GPIO 9 como salida
	
/* guia bits 	    10987654321098765432109876543210 */
	mov r1, # 0b00000000000000000000001000000000		@ para encender GPIO 9
	
bucle : 
	ldr r2, =700000						@ cargo esa cifra en r2
ret1 : 	subs r2, #1 						@ Bucle de retardo 1: voy restando 1 a 700000
	bne ret1						@ cuando sea el resultado sea 0, z=1 y saldré del loop
	str r1, [r0, # GPSET0 ] 				@ Enciende el LED
	
	ldr r2, = 700000
ret2 : 	subs r2, #1 						@ Bucle de retardo 2
	bne ret2
	str r1, [r0, # GPCLR0 ] 				@ Apaga el LED
	
	b bucle 						@ Repetir para siempre
	
/* Se mantendrá encendido y apagado la cantidad de tiempo que dependerá del valor de la constante.