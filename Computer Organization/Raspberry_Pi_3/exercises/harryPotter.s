.set GPBASE, 0x3F200000
.set GPFSEL0, 0x00
.set GPSET0, 0x1c
.set GPCLR0, 0x28
.set STBASE, 0x3F003000
.set STCLO, 0x04

.text
	ldr r0, =GPBASE
	
	mov 	sp, #0x8000000
	
/* guia bits 	   xx999888777666555444333222111000 */
	mov r1, #0b00000000000000000001000000000000
	str r1, [r0, #GPFSEL0 ] 				@ Configura GPIO 4 como salida
	
/* guia bits 	   10987654321098765432109876543210 */
	mov r1, #0b00000000000000000000000000010000		@ Para encender GPIO 4 luego
	ldr r2, =STBASE

prin:								@ Escala musical 4ª Octava

	ldr r5, =1516						@ MI
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =500000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =165000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =666666						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =851						@ RE AGUDO (5ª Octava)
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =500000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =165000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =650000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1072						@ SI BEMOL= LA SOSTENIDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =1000000					@ tiempo que sonará nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	
	ldr r5, =25000						@ Entretiempo de espera (medio segundo)
	bl espera
	
	ldr r5, =1516						@ MI
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =500000						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =165000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =666666						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =637						@ SOL AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =675						@ SOL AGUDO BEMOL
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =851						@ RE AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =500000						@ tiempo que sonará nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =165000						@ tiempo que sonará nota
	bl ini
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1607						@ RE SOSTENIDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =666666						@ tiempo que sonará la nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =500000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =165000						@ tiempo que sonará nota
	bl ini
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1607						@ RE SOSTENIDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =1000000					@ tiempo que sonará nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =637						@ SOL AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =675						@ SOL AGUDO BEMOL (FA #)
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =851						@ RE AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =500000						@ tiempo que sonará nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =165000						@ tiempo que sonará nota
	bl ini
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1607						@ RE SOSTENIDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =666666						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =500000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =165000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =666666						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =851						@ RE AGUDO (5ª Octava)
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =500000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =165000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =650000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1072						@ SI BEMOL= LA SOSTENIDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =1000000					@ tiempo que sonará nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	
	ldr r5, =25000						@ Entretiempo de espera (medio segundo)
	bl espera
	
	ldr r5, =1516						@ MI
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =500000						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =165000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1012						@ SI
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =666666						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =637						@ SOL AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =675						@ SOL AGUDO BEMOL
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =851						@ RE AGUDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =500000						@ tiempo que sonará nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =165000						@ tiempo que sonará nota
	bl ini
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =333333						@ tiempo que sonará nota
	bl ini
	ldr r5, =1607						@ RE SOSTENIDO
	ldr r6, =666666						@ tiempo que sonará nota
	bl ini
	ldr r5, =955						@ DO AGUDO
	ldr r6, =333333						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =1000000					@ tiempo que sonará la nota
	bl ini
	ldr r5, =500000						@ Entretiempo de espera (medio segundo)
	bl espera
	
@ 2ª parte  --------------------------------------------------------------------------------------------

	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1607						@ RE SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1431						@ FA
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1607						@ RE SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1911						@ DO
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1702						@ RE
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =50000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1702						@ RE
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1803						@ DO SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1702						@ RE
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1431						@ FA
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1012						@ SI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =955						@ DO AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =780000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =803						@ RE AGUDO SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =637						@ SOL AGUDO
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =715						@ FA AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =758						@ MI AGUDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =715						@ FA AGUDO
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1072						@ SI BEMOL (LA SOSTENIDO)
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =955						@ DO AGUDO
	ldr r6, =780000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =780000						@ tiempo que sonará la nota
	bl ini
		
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini 
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1072						@ SI BEMOL 
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1431						@ FA
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	
@ hasta aquí ok	
	ldr r5, =1275						@ SOL
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =50000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1275						@ SOL
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1351						@ FA SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1275						@ SOL
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1072						@ SI ¿BEMOL?
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =195000						@ Entretiempo de espera (SILENCIO NEGRA)
	bl espera
	ldr r5, =1516						@ MI
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1431						@ FA
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =780000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =955						@ DO AGUDO
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1072						@ SI BEMOL 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1072						@ SI BEMOL 
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1607						@ MI BEMOL 
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1072						@ SI BEMOL 
	ldr r6, =390000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1136						@ LA 
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1203						@ SOL SOSTENIDO
	ldr r6, =97500						@ tiempo que sonará la nota
	bl ini
	ldr r5, =97500						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1136						@ LA 
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =1702						@ RE 
	ldr r6, =195000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (medio segundo)
	bl espera
	ldr r5, =901						@ DO AGUDO SOSTENIDO
	ldr r6, =780000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =1516						@ MI
	ldr r6, =780000						@ tiempo que sonará la nota
	bl ini
	ldr r5, =195000						@ Entretiempo de espera (SILENCIO NEGRA)
	bl espera
	
	ldr r5, =500000						@ Entretiempo de espera (medio segundo)
	bl espera
	
	b prin

ini:
	push {lr}
	ldr r3, [r2, # STCLO ] 					@ Lee contador en r3
	add r3, r6 						@ r3 = r3 + r6 (3 seg)
bucle : 
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, # GPSET0 ]
	bl espera 						@ Salta a rutina de espera
	str r1, [r0, # GPCLR0 ]
	
	ldr r7, [ r2, # STCLO ]
	cmp r7, r3
	
	blo bucle
	pop {lr}
	bx lr
	
/* rutina que espera x microsegundos dependiendo de la nota que toque (notas DO, MI, SOL) *********************************************/
espera : 
	ldr r8, [r2, # STCLO ] 					@ Lee contador en r8
	add r8, r5						@ r8 = r8 + r5 (956 microseg)
ret1 : 	
	ldr r4, [ r2, # STCLO ]
	cmp r4, r8						@ Leemos CLO hasta alcanzar
	blo ret1 						@ el valor de r8
	bx lr
	

	

/* Teoría:
Vamos a producir un tono de 440 Hz. Para ello generamos una onda cuadrada
por dicho pin, que no es más que una serie de ceros y unos consecutivos de idéntica
duración. A esta duración la llamamos semi-periodo, y es la que queremos calcular.
Como el periodo es el inverso de la frecuencia, tenemos que periodo = 1/(440) =
2.272x10^-3 s, por lo que el semi-periodo buscado es (2.272x10^-3)/2 = 1.136x10^-3 s
o lo que es lo mismo, 1136 microsegundos.*/