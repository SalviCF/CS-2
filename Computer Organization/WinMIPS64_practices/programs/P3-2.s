.data
array: .space  960       ; Se reservan 960 bytes 
                         ; (240 elementos word32)

.text
         daddi r2,r0,0
         daddi r6,r0,4
         daddi r3,r0,240  ; Inicializamos r3 a la mayor 
                          ; posición del vector


FOR:     slt r4,r2,r3
         beqz r4, ENDFOR  ; Inicializamos los elementos del vector a 4 (r6)
         nop
         dsll r5,r2,2
         sw r6,array(r5)
         daddi r2,r2,1
         j FOR
ENDFOR:  nop
 

          dsll r1,r3,2     ; Inicializamos r3 a la mayor posición (bytes) del vector


LOOP:     daddi r1,r1,-8        ; Actualizar la variable índice
          lw	r10,4(r1)	; Leer elemento vector
 	  daddi	r10,r10,4	; Sumar 4 al elemento
	  sw	r10,4(r1)	; Escribir nuevo valor

	  lw 	r11,0(r1)       ; 2ª copia
          daddi	r11, r11, 4     ; 
	  sw	r11,0(r1)	;		
		
          
	  bne r1,r0,LOOP    ; Fin de vector?
          nop 
          halt          