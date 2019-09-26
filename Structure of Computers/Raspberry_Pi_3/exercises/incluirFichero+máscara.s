.include "inter.inc"	
@ El m�todo para incluir el c�digo fuente de un fichero dentro de otro es mediante la macro .include, seguido del nombre del fichero entre comillas (string)
@ inter.inc contiene todas las direcciones de los puertos, as� nos ahorramos tener que escribirlas...

.text

	ldr r0, =GPBASE						@ cargo la base en r0
	ldr r1, [r0, #GPFSEL0]					@ cargo lo que haya en GPFSEL0: configuraci�n de los pines del 0 al 9
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r2, =0b11001111111111111111111111111111		@ m�scara con todo a 1 excepto los dos bits m�s significativos del noveno pin (depende deen qu� GPFSEL est�)
	ldr r3, =0b00001000000000000000000000000000		@ m�scara con todo a 0 excepto el bit menos significativo del noveno pin (depende deen qu� GPFSEL est�)
	and r1, r1, r2					
@ hubiese lo hubiese en r1 (configuraci�n anterior de los pines), los dos pines m�s significativos del noveno pin, ser�n cero; lo dem�s se matiene igual tras el AND
	orr r1, r1, r3						@ pongo un 1 en el bit menos significativo del noveno pin, lo dem�s se mantiene igual tras el OR
	str r1, [r0, #GPFSEL0]					@ aplico la nueva configuraci�n creada
	ldr r1, [r0, #GPFSEL1]					@ repito el proceso con GPFSEL1 para actuar sobre el GPIO 10
/* guia bits 	   xx999888777666555444333222111000 */
	ldr r2, =0b11111111111111111111111111111001		
	ldr r3, =0b00000000000000000000000000000001		
	and r1, r1, r2						@ pongo esos dos bits a 0 y lo dem�s lo mantengo igual
	orr r1, r1, r3						@ pongo ese bit a 1 y lo dem�s lo mantengo igual
	str r1, [r0, #GPFSEL1]					@ aplico la nueva configuraci�n creada para GPFSEL1
/* guia bits 	 xx33222222222211111111110000000000 */
/* guia bits 	 xx10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000001000000000
	str r1, [r0, #GPSET0]					@ enciendo GPIO 9 (led rojo 1)
/* guia bits 	 xx33222222222211111111110000000000 */
/* guia bits 	 xx10987654321098765432109876543210 */
	ldr r1, =0b00000000000000000000010000000000
	str r1, [r0, #GPCLR0]					@ apago GPIO 10 (led rojo 2)