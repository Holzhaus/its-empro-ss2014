.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einf�gen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen f�r den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen


; ############## Einsprungsvektoren ##################
.org 0x000
   rjmp main			; Springe zum Hauptprogramm


set_R20:
	; F�gen Sie hier Ihren Code ein, der R20 in Abh�ngigkeit von R18 einen Wert aus {0,1,2,4,8} zuweist.
	;
	; Pseudocode:
	; if (R18=='V')
	;    R20=8;
	; else if (R18=='Z')
	;    R20=4;
	; else if (R18=='L')
	;    R20=2;
	; else if (R18=='R')
	;    R20=1;
	; else
	;    R20=0;
	cpi     R18,'V'
	breq    if_R18_eq_V
	cpi     R18,'Z'
	breq    if_R18_eq_Z
	cpi     R18,'L'
	breq    if_R18_eq_L
	cpi     R18,'R'
	breq    if_R18_eq_R
	; else
	ldi     R20,0
	endif:
		ret
	if_R18_eq_V:
		ldi     R20,8
		rjmp    endif
	if_R18_eq_Z:
		ldi     R20,4
		rjmp    endif
	if_R18_eq_L:
		ldi     R20,2
		rjmp    endif
	if_R18_eq_R:
		ldi     R20,1
		rjmp    endif

main:
	;Initialisierung des Stack Pointers
	ldi R18,high(RAMEND)
	out SPH,R18
	ldi R18,low(RAMEND)
	out SPL,R18

	; Testbench
	; Hier wird getestet, ob Sie die Funktion set_R20 richtig implementiert haben
	; Sollte sich ein Fehler eingeschlichen haben wird zur Sprungmarke "fail" verzweigt
	; Ist die Funktion richtig implementiert landen Sie bei der Sprungmarke "win"
	ldi R18,'V'
	rcall set_R20
	cpi R20,8
	brne fail
	ldi R18,'Z'
	rcall set_R20
	cpi R20,4
	brne fail
	ldi R18,'L'
	rcall set_R20
	cpi R20,2
	brne fail
	ldi R18,'R'
	rcall set_R20
	cpi R20,1
	brne fail
	ldi R18,'X'
	rcall set_R20
	cpi R20,0
	brne fail

; Hier sollte man nach Ausf�hrung des Codes landen, wenn alles richtig gemacht wurde
win: rjmp win 

; Hier landet man, wenn die Funktion set_R20 eine falsche Berechnung ausgef�hrt hat
fail: rjmp fail
