@ Author: Salvi CF

        .set GPBASE, 0x3F200000
	.set GPFSEL0, 0x00
	.set GPSET0, 0x1c
	.set GPCLR0, 0x28
	.set GPLEV0,   0x34
	.set STBASE, 0x3F003000
	.set STCLO, 0x04
 
.text	
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov   	r1, #0b00000000000000000001000000000000
        str	r1, [r0, #GPFSEL0]  					@ Configura GPIO 2 y 3 como entrada y GPIO 4 como salida
	
/* guia bits 	   10987654321098765432109876543210 */
	mov r1, #0b00000000000000000000000000010000			@ Para encender/apagar GPIO 4 luego
	
	ldr r2, =STBASE							@ Base del temporizador

/* Bucle para sondear los pulsadores*/
bucle:	
	ldr	r3, [r0, #GPLEV0]
	ands	r4, r3, #0b00000000000000000000000000000100		@ sondea GPIO 2			
	beq	pulsador1
	ands	r4, r3, #0b00000000000000000000000000001000		@ sondea GPIO 3
	beq	pulsador2
	b 	bucle

pulsador1:	
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, #GPSET0]
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, #GPCLR0]
	
	ldr	r3, [r0, #GPLEV0]
	ands	r4, r3, #0b00000000000000000000000000001000	@ sondea GPIO 3
	beq	pulsador2
	b pulsador1
	
pulsador2:
	bl espera2 						@ Salta a rutina de espera
	str r1, [r0, #GPSET0]
	bl espera2 						@ Salta a rutina de espera
	str r1, [r0, #GPCLR0]
	
	ldr	r3, [r0, #GPLEV0]
	ands	r4, r3, #0b00000000000000000000000000000100		@ sondea GPIO 2	
	beq	pulsador1
	b pulsador2
	
/* rutina que espera 1908 microsegundos (nota DO) *********************************************/
espera: 
	ldr r5, [r2, #STCLO] 					@ Lee contador en r3
	ldr r6, =1908
	add r6, r5 						@ r4= r3 + 1908
ret1: 	
	ldr r5, [r2, #STCLO]
	cmp r5, r6 						@ Leemos CLO hasta alcanzar
	blo ret1 						@ el valor de r4
	bx lr

/* rutina que espera 1278 microsegundos (nota SOL) *********************************************/
espera2: 
	ldr r5, [r2, #STCLO] 					@ Lee contador en r3
	ldr r6, =1278
	add r6, r5 						@ r4= r3 + 1278
ret2: 	
	ldr r5, [ r2, #STCLO]
	cmp r5, r6 						@ Leemos CLO hasta alcanzar
	blo ret2 						@ el valor de r4
	bx lr

/* Teoría:
Vamos a producir un tono de 440 Hz. Para ello generamos una onda cuadrada
por dicho pin, que no es más que una serie de ceros y unos consecutivos de idéntica
duración. A esta duración la llamamos semi-periodo, y es la que queremos calcular.
Como el periodo es el inverso de la frecuencia, tenemos que periodo = 1/(440) =
2.272x10^-3 s, por lo que el semi-periodo buscado es (2.272x10^-3)/2 = 1.136x10^-3 s
o lo que es lo mismo, 1136 microsegundos.*/
