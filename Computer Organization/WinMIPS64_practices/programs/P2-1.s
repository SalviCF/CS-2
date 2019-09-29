; Ordenacion creciente de un vector por el metodo de la
; Burbuja

.data
A:	.word32	1,3,5,7,9,2,4,6,8,0 ; array a ordenar


.text
MAIN:
		jal Burbuja 
		nop
		halt

; Funcion Burbuja 
Burbuja:
		daddi R10,R0,10	; inic. variable n en registro R10

		daddi R8,R0,0	; for ( i = 0;  variable i en R8
		

FOR1:		daddi R19,R10,-1 ; i < n-1; 
		slt R20,R8,R19	 ; 
		beqz R20,ENDFOR1 ;
		nop	;
 
		daddi R9,R10,-1	; for ( j = n-1;
		

FOR2:		
		slt R27,R8,R9	 ; j > i; 
		beqz R27,ENDFOR2 ;
		nop		 ;

IF1:		
		dsll R2,R9,2	;A [j]
		lw R30,A(R2)	;

		daddi R6,R9,-1	; A [j-1]
		dsll R5,R6,2	; 
		lw R7,A(R5)

		slt R5,R30,R7	;
		beqz R5, IFELSE1 ; if (A[j] < A[j-1])
		nop	;


                dsll R16,R9,2   ; temp = A[j]
		lw R11,A(R16)	;


		dsll R21,R9,2   ; A[j]
		daddi R25,R9,-1 ;	
		dsll R28,R25,2  ; A [j-1] 

		lw R26,A(R28)	; A [j] = A[j-1] 
		sw R26,A(R21)	;

		
		daddi R3,R9,-1	; A [j-1] 
		dsll R6,R3,2	;

		sw R11,A(R6)	; A[j-1] = temp
		j IFEND1	;
		nop

IFELSE1:
IFEND1:	        daddi R9,R9,-1 ; j-- 
		j FOR2	;
		nop

ENDFOR2:	daddi R8,R8,1	; i++ 
		j FOR1
		nop

ENDFOR1:
FIN_Burbuja:	jr R31	; Return to MAIN 
		nop
	