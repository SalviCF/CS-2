; Ordenacion creciente de un vector por el metodo de la
; Burbuja

.data
i:	.word32	0	; indice en sentido creciente 
j:	.word32	0	; indice en sentido decreciente 
n:	.word32	0	; tamaño del vector
A:	.word32	1,3,5,7,9,2,4,6,8,0 ; array a ordenar
temp:   .word32	0	; var. para intercambio de elementos

.text
MAIN:
		jal Burbuja 
		nop
		halt

; Funcion Burbuja 
Burbuja:
		daddi R2,R0,10	; inic. variable n
 		sw R2,n(R0)	; guardar nuevo valor de n

		lw R14,i(R0)	;
		daddi R15,R0,0	; for ( i = 0; 
		sw R15,i(R0)	;

FOR1:		lw R16,i(R0)	 ; 
		lw R17,n(R0)	 ;
		daddi R18,R0,1	 ; i < n-1; 
		dsub R19,R17,R18 ;
		slt R20,R16,R19	 ; 
		beqz R20,ENDFOR1 ;
		nop	;

		lw R21,j(R0)	;
		lw R22,n(R0)	;
		daddi R23,R0,1	; for ( j = n-1; 
		dsub R24,R22,R23	;
		sw R24,j(R0)	;

FOR2:		lw R25,j(R0)	 ; 
		lw R26,i(R0)	 ;
		slt R27,R26,R25	 ; j > i; 
		beqz R27,ENDFOR2 ;
		nop		 ;

IF1:		lw R28, A(R0)	;
		lw R29, j(R0)	;
		daddi R1,R0,4	; A [j] 
		dmul R2,R1,R29	;
		lw R30,A(R2)	;

		lw R3,A(R0)	;
		lw R4,j(R0)	;
		daddi R5,R0,1	;
		dsub R6,R4,R5	; A [j-1]
		daddi R8,R0,4	;
		dmul R9,R8,R6	; 
		lw R7,A(R9)

		slt R10,R30,R7	;
		beqz R10, IFELSE1 ; if (A[j] < A[j-1])
		nop	;

		lw R11,temp(R0)	; 
		lw R12,A(R0)	;
		lw R13,j(R0)	;
		daddi R15,R0,4	;
		dmul R16,R15,R13;	temp = A[j]

		lw R14,A(R16)	;
		sw R14,temp(R0)	;

		lw R17,A(R0)	;
		lw R18,j(R0)	;
		daddi R20,R0,4	; A[j] 
		dmul R21,R20,R18;
		lw R19,A(R21)	;


		lw R22,A(R0)	 ;
		lw R23,j(R0)	 ;
		daddi R24,R0,1	 ; A [j-1] 
		dsub R25,R23,R24 ;
		daddi R27,R0,4	 ; 
		dmul R28,R27,R25 ;

		lw R26,A(R28)	; A [j] = A[j-1] 
		sw R26,A(R21)	;

		lw R29,A(R0)	;
		lw R30,j(R0)	;
		daddi R1,R0,1	; A [j-1] 
		dsub R3,R30,R1	;
		daddi R5,R0,4	;
		dmul R6,R5,R3	;

		lw R4,A(R6)	;
		lw R7,temp(R0)	;
		sw R7,A(R6)	; A[j-1] = temp
		j IFEND1	;
		nop

IFELSE1:
IFEND1:		lw R11,j(R0)	 ;
		daddi R11,R11,-1 ; j-- 
		sw R11,j(R0)	 ;
		j FOR2	;
		nop

ENDFOR2:	lw R13,i(R0)	;
		daddi R13,R13,1	; i++ 
		sw R13,i(R0)	;
		j FOR1
		nop

ENDFOR1:
FIN_Burbuja:	jr R31	; Return to MAIN 
		nop
	