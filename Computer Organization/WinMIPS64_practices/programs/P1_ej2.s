; Práctica de introducción al simulador
; Práctica de introducción al simulador
; Programa que calcula 2^4 y lo copia en 
; las 20 posiciones de un array A  
; utilizando dmul
.data     
A:        .word32 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;array de 20 posiciones
.text    
	  daddi R2,R0,0   
	  daddi R3,R0,1 
	  daddi R5,R0,20 
	  daddi R7,R0,0

	  jal POWER
          nop

WHILE1:	  slt R6,R2,R5
	  beqz R6,ENDWHILE1
          sw R3,A(R7)   ;POWER devuelve el valor en R3
	  daddi R2,R2,1
          daddi R7,R7,4
   	  j WHILE1 
ENDWHILE1: nop
          halt

POWER:
       	  daddi R22,R0,0   
	  daddi R3,R0,1 
          daddi R24,R0,2
	  daddi R25,R0,4 ;R25 contiene la potencia de 2 a calcular

WHILE2:	  slt R26,R22,R25
	  beqz R26,ENDWHILE2
	  daddi R22,R22,1
	  dmul R3,R3,R24 
   	  j WHILE2
ENDWHILE2: nop
          jr R31      
          nop