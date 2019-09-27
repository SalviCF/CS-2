; Práctica de introducción al simulador
.data
i:   	  .word 0
j:        .word 0
.text
	  daddi R2,R0,0 ; comentario 
	  daddi R3,R0,0 ;
	  daddi R5,R0,10 ;
WHILE:	  slt R6,R2,R5
	  beqz R6,ENDWHILE
	  daddi R3,R3,5 
	  sw R3,j(R0) 
	  daddi R2,R2,1 
	  sw R2,i(R0)
   	  j WHILE 
ENDWHILE: nop
          halt