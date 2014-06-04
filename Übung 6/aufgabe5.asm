.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfuegen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen fuer den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.MACRO M_COMPUTE
; @0 = A, @1 = B, @2 = C
; Implementieren Sie hier die geforderte Funktionalitaet als Makro
MOV R0,@0 ; 1 Cycle, 2 Bytes
AND R0,@1 ; 1 Cycle, 2 Bytes
OR  R0,@2 ; 1 Cycle, 2 Bytes
.ENDMACRO

; ############## Einsprungsvektoren ##################
.org 0x000
   rjmp main ; Springe zum Hauptprogramm

F_COMPUTE:
; R16 = A, R17 = B, R18 = C
; Implementieren Sie hier die geforderte Funktionalitaet als Funktion
MOV R0,R16 ; 1 Cycle,  2 Bytes
AND R0,R17 ; 1 Cycle,  2 Bytes
OR  R0,R18 ; 1 Cycle,  2 Bytes
ret        ; 4 Cycles, 2 Bytes

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
	M_COMPUTE R16,R17,R18 ; Dauert 0 Cycles und 0 Bytes
	; Das Makro selbst dauert nochmal 3 Cycles und ist 6 Bytes groß
	RCALL F_COMPUTE ; RCALL hat  3 Cycles, 2 Bytes
        ; Die Funktion selbst dauert nochmal 7 Cycles und ist 8 Bytes groß

	; Bei 10 Aufrufen:
	;   Makro benötigt 10*3 = 30 Cycles und 10*6 = 60 Bytes
        ;   Funktion benötigt 10*(3+7) = 100 Cycles und (10*2)+8 = 28 Bytes


fin: rjmp fin
