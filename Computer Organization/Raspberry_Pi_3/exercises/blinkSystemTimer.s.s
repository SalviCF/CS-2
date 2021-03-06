.set GPBASE,  0x3F200000
.set GPFSEL0, 0x00
.set GPSET0, 0x1c
.set GPCLR0, 0x28
.set STBASE, 0x3F003000						@ direcci�n base del system timer
.set STCLO, 0x04						@ parte baja del contador ascendente de 64 bits

.text
	ldr r0, =GPBASE
/* guia bits 	    xx999888777666555444333222111000 */
	mov r1, # 0b00001000000000000000000000000000
	str r1, [r0, # GPFSEL0 ] 				@ Configura GPIO 9 como salida
	
/* guia bits 	    10987654321098765432109876543210 */
	mov r1, # 0b00000000000000000000001000000000		@ para encender GPIO 9
	
	ldr r2, =STBASE						@ cargo la direccio�n base del system timer en r2
	
bucle : 
	bl espera 						@ Salta a rutina de espera (branch with link; como el jal del MIPS)
	str r1, [r0, # GPSET0 ]
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, # GPCLR0 ]
	b bucle
	
/* rutina que espera medio segundo (500000) */
espera : 
	ldr r3, [r2, #STCLO ] 					@ Lee contador en r3
	ldr r4, =500000
	add r4, r3 						@ r4 = r3 + medio mill�n
ret1 : 	ldr r3, [ r2, #STCLO ]
	cmp r3, r4 						@ Leemos CLO hasta alcanzar el valor de r4
	bne ret1 						@ cuando lleguemos al valor de r4, volvemos por donde nos quedamos
	bx lr							@ branch and exchange (vuelve a lr: address of next instruction desde el bl)

