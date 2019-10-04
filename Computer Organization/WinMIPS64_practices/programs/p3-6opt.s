; Desenrrollamiento factor 6 optimizado.

.data
array:   .space  960      ; Se reservan 960 bytes 
                          ; (240 elementos word32)

.text
         daddi r2,r0,0
         daddi r6,r0,4
         daddi r3,r0,240  ; Inicializamos r3 a la mayor posición del vector


FOR:     slt r4,r2,r3
         beqz r4, ENDFOR   ; Inicializamos los elementos del vector a 4 (r6)
         nop
         dsll r5,r2,2
         sw r6,array(r5)
         daddi r2,r2,1
         j FOR
ENDFOR:  nop
 

          dsll r1,r3,2     ; Inicializamos r3 a la mayor posición 
                           ; (bytes) del vector

LOOP:     daddi r1,r1,-24   ; Actualizar la variable índice

          lw r10,20(r1)     ; Leer un elemento de un vector
	  lw r11,16(r1)     ; 2ª copia. Leer un elemento de un vector
	  lw r12,12(r1)     ; 3ª copia. Leer un elemento de un vector
	  lw r13,8(r1)     ; 4ª copia. Leer un elemento de un vector
	  lw r14,4(r1)     ; 5ª copia. Leer un elemento de un vector
	  lw r15,0(r1)     ; 6ª copia. Leer un elemento de un vector

	  daddi r10,r10,4  ; Sumar 4 al elemento
	  daddi r11,r11,4  ; Sumar 4 al elemento
	  daddi r12,r12,4  ; Sumar 4 al elemento
	  daddi r13,r13,4  ; Sumar 4 al elemento
	  daddi r14,r14,4  ; Sumar 4 al elemento
	  daddi r15,r15,4  ; Sumar 4 al elemento

	  sw r10,20(r1)     ; Escribir el nuevo valor	  
	  sw r11,16(r1)     ; Escribir el nuevo valor	
	  sw r12,12(r1)     ; Escribir el nuevo valor
	  sw r13,8(r1)     ; Escribir el nuevo valor
	  sw r14,4(r1)     ; Escribir el nuevo valor
	  sw r15,0(r1)     ; Escribir el nuevo valor

	  bne r1,r0,LOOP   ; Fin de vector?
          nop 
          halt