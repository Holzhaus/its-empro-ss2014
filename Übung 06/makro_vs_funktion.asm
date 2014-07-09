.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfuegen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen fuer den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.MACRO M_COMPUTE
; @0 = A, @1 = B, @2 = C
; Implementieren Sie hier die geforderte Funktionalitaet als Makro

.ENDMACRO

; ############## Einsprungsvektoren ##################
.org 0x000
   rjmp main ; Springe zum Hauptprogramm

F_COMPUTE:
; R16 = A, R17 = B, R18 = C
; Implementieren Sie hier die geforderte Funktionalitaet als Funktion

ret

main:
	;Initialisierung des Stack Pointers
	ldi R16,high(RAMEND)
	out SPH,R16
	ldi R16,low(RAMEND)
	out SPL,R16

	; Testvektoren
	ldi R16, 1 ; A
	ldi R17, 2 ; B
	ldi R18, 3 ; C

	; Rufen Sie hier die entweder das Makro oder die Funktion auf
	

fin: rjmp fin
