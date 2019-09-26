.set GPBASE,  0x3F200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPSET0, 0x1c
.set GPCLR0, 0x28
.set STBASE, 0x3F003000						@ dirección base del system timer
.set STCLO, 0x04						@ parte baja del contador ascendente de 64 bits

.text
	ldr r0, =GPBASE
	
/* guia bits 	    xx999888777666555444333222111000 */
	mov r1, # 0b00001000000000000000000000000000
	str r1, [r0, # GPFSEL0] 				@ Configura GPIO 9 como salida
/* guia bits 	    xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, # GPFSEL1] 				@ Configura GPIO 10, 11 y 17 como salida
/* guia bits 	    xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, # GPFSEL2] 				@ Configura GPIO 22 y 27 como salida

	
	ldr r2, =STBASE						@ cargo la direccioón base del system timer en r2
	
bucle : 
						
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00001000000000000000001000000000		@ enciendo GPIO 9 y 27
	str r1, [r0, # GPSET0 ]
	bl espera 						@ Salta a rutina de espera
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00001000000000000000001000000000		@ apaga GPIO 9 y 27
	str r1, [r0, # GPCLR0 ]
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000010000000000		@ enciendo GPIO 10 y 22
	str r1, [r0, # GPSET0 ]
	
	bl espera 						@ Salta a rutina de espera (branch with link; como el jal del MIPS)
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000100000100000000000		@ enciendo GPIO 11 y 17
	str r1, [r0, # GPSET0 ]
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000010000000000		@ apaga GPIO 10 y 22
	str r1, [r0, # GPCLR0 ]
	bl espera 						@ Salta a rutina de espera
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000000000100000100000000000		@ apaga GPIO 11 y 17
	str r1, [r0, # GPCLR0 ]
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000010000000000		@ enciendo GPIO 10 y 22
	str r1, [r0, # GPSET0 ]
	
	bl espera 						@ Salta a rutina de espera (branch with link; como el jal del MIPS)
/* guia bits 	   10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000010000000000		@ apaga GPIO 10 y 22
	str r1, [r0, # GPCLR0 ]
	
	b bucle
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
/* rutina que espera medio segundo (500000) */
espera : 
	ldr r3, [r2, #STCLO ] 					@ Lee contador en r3
	ldr r4, =500000
	add r4, r3 						@ r4 = r3 + medio millón
ret1 : 	ldr r3, [ r2, #STCLO ]
	cmp r3, r4 						@ Leemos CLO hasta alcanzar el valor de r4
	bne ret1 						@ cuando lleguemos al valor de r4, volvemos por donde nos quedamos
	bx lr							@ branch and exchange (vuelve a lr: address of next instruction desde el bl)

