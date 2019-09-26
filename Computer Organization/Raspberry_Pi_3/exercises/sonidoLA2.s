        .set    GPBASE,   0x3F200000
        .set    GPFSEL0,        0x00
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    STBASE,   0x3F003000
        .set    STCLO,          0x04
.text
	mov 	r0, #0b11010011
	@ msr	cpsr_c, r0, tengo que ponerlo como cpsr_f para que funcione o direcctamente ponerlo como comentario
	mov 	sp, #0x8000000							@ Inicializ. pila en modo SVC
	
        ldr     r4, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov   	r5, #0b00000000000000000001000000000000
        str	r5, [r4, #GPFSEL0]  						@ Configura GPIO 4 como salida
	
/* guia bits           10987654321098765432109876543210*/
        mov	r5, #0b00000000000000000000000000010000				@ Para encender GPIO 4 luego
        ldr	r0, =STBASE							@ r0 es un par�metro de sonido (dir base ST)
	ldr	r1, =1136							@ r1 es un parametro de sonido (periodo/2)...EXPLICACI�N AL FINAL

bucle:	bl     	sonido								@ Salta a rutina de sonido
        str    	r5, [r4, #GPSET0]						@ Enciende GPIO 4
        bl     	sonido 								@ Salta a rutina de sonido
        str     r5, [r4, #GPCLR0]						@ Apaga GPIO 4
        b       bucle

/* rutina que espera r1 microsegundos *************************************************************************************/
sonido: 
	push	{r4,r5}								@ Guarda r4 y r5 en pila
        ldr     r4, [r0, #STCLO]  						@ Lee contador en r4 (machaca lo que hab�a en r4, pero lo guard� con la instrucci�n anterior)
        add    	r4, r1    	 						@ r4 = r4 + perido/2
ret1: 	ldr     r5, [r0, #STCLO]						@ Lee contador en r5 (machaca lo que hab�a en r5, pero lo guard�)
        cmp	r5, r4            						@ Leemos CLO hasta alcanzar el valor de r4. cmp -> op1 - op2
        blo     ret1              						@ Salto si C=0, siempre que r5 < r4, cuando r5 = r4, no tomar� el salto. Es decir, branch if lower
	pop	{r4,r5}	
        bx      lr
	

@ Si op1 > op2 ; C=1
@ Si op1 < op2 ; C=0
@ Si op1 = op2 ; C=1
@ blo: branch if lower: salto si C=0 -> op1 < op2

/* Teor�a:
Vamos a producir un tono de 440 Hz. Para ello generamos una onda cuadrada
por dicho pin, que no es m�s que una serie de ceros y unos consecutivos de id�ntica
duraci�n. A esta duraci�n la llamamos semi-periodo, y es la que queremos calcular.
Como el periodo es el inverso de la frecuencia, tenemos que periodo = 1=(440) =
2.272x10^-3 s, por lo que el semi-periodo buscado es (2.272x10^-3)/2 = 1.136x10^-3 s
o lo que es lo mismo, 1136 microsegundos.*/