@ Usar blo en vez de bne!
@ Este es diferente de alarmaEscalera ya que cuando deja de sonar, dejo de iluminar. No siempre hay algo iluminando.

.set GPBASE, 0x3F200000
.set GPFSEL0, 0x00
.set GPFSEL1, 0x04
.set GPFSEL2, 0x08
.set GPSET0, 0x1c
.set GPCLR0, 0x28
.set STBASE, 0x3F003000
.set STCLO, 0x04

.text
	mov 	sp, #0x8000000				@ LO NECESITO PARA USAR LA PILA!
	ldr r0, =GPBASE
	
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r1, =0b00001000000000000001000000000000
	str r1, [r0, #GPFSEL0] 				@ Configura GPIO 4, 9 como salida
	
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, #GPFSEL1] 				@ Configura GPIO 10, 11, 17  como salida
	
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2] 				@ Configura GPIO 22, 27 como salida
	
/* guia bits 	   10987654321098765432109876543210 */
	mov r1, #0b00000000000000000000000000010000		@ Para encender GPIO 4 luego

	ldr r2, =STBASE

principio:
/* guia bits 	   10987654321098765432109876543210 */
	mov r7, #0b00000000000000000000001000000000		@ Para encender GPIO 9
	bl inicio
/* guia bits 	   10987654321098765432109876543210 */
	mov r7, #0b00000000000000000000010000000000		@ Para encender GPIO 10
	bl inicio
/* guia bits 	   10987654321098765432109876543210 */
	mov r7, #0b00000000000000000000100000000000		@ Para encender GPIO 11
	bl inicio
/* guia bits 	   10987654321098765432109876543210 */
	mov r7, #0b00000000000000100000000000000000		@ Para encender GPIO 17
	bl inicio	
/* guia bits 	   10987654321098765432109876543210 */
	mov r7, #0b00000000010000000000000000000000		@ Para encender GPIO 22
	bl inicio	
/* guia bits 	   10987654321098765432109876543210 */
	mov r7, #0b00001000000000000000000000000000		@ Para encender GPIO 27
	bl inicio
	b principio
	
/* Rutina que se ejecuta durante x segundos***********************************************************/	
inicio:	
	push {lr}
	ldr r5, [r2, # STCLO] 					@ Lee contador en r5
	ldr r6, =500000						@ x millones  = x segundos
	add r6, r5						@ r6 = r5 + x segundos
	str r7, [r0, #GPSET0]					@ Enciende todos los LEDs
bucle : 
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, # GPSET0]					@ Enciende GPIO4
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, # GPCLR0]					@ Apaga GPIO4
	
	ldr     r5, [r2, #STCLO]				@ contador en r5
        cmp	r5, r6           						
        blo     bucle						@ PONER BLO EN VEZ DE BNE ES CLAVE! Hay demasiadas instrucciones en medio
	
	bl espera2						@ Hago la pausa en el sonido
	pop {lr}
	bx lr
	
	
/* rutina que espera 1136 microsegundos *********************************************/
espera: 
	ldr r3, [r2, # STCLO ] 					@ Lee contador en r3
	ldr r4, =1136
	add r4, r3 						@ r4 = r3 + 1136
ret1: 	
	ldr r3, [ r2, # STCLO ]
	cmp r3, r4 						@ Leemos CLO hasta alcanzar. cmp: op1 - op2, si op1 < op2 -> C=0. C=1 en los otros casos
	blo ret1						@ el valor de r4
	bx lr
	
/* rutina que espera x segundos *********************************************/
espera2: 
	str r7, [r0, # GPCLR0 ]					@ Apaga GPIO9
	ldr r3, [r2, # STCLO ] 					@ Lee contador en r3
	ldr r4, =500000
	add r4, r3 						@ r4 = r3 + x millones
ret2: 	
	ldr r3, [ r2, # STCLO ]
	cmp r3, r4 						@ Leemos CLO hasta alcanzar. cmp: op1 - op2, si op1 < op2 -> C=0. C=1 en los otros casos
	blo ret2						@ el valor de r4
	bx lr

	

/* Teor�a:
Vamos a producir un tono de 440 Hz. Para ello generamos una onda cuadrada
por dicho pin, que no es m�s que una serie de ceros y unos consecutivos de id�ntica
duraci�n. A esta duraci�n la llamamos semi-periodo, y es la que queremos calcular.
Como el periodo es el inverso de la frecuencia, tenemos que periodo = 1=(440) =
2.272x10^-3 s, por lo que el semi-periodo buscado es (2.272x10^-3)/2 = 1.136x10^-3 s
o lo que es lo mismo, 1136 microsegundos.*/