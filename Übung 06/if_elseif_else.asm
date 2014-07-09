.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen


; ############## Einsprungsvektoren ##################
.org 0x000
   rjmp main			; Springe zum Hauptprogramm


set_R20:
	; Fügen Sie hier Ihren Code ein, der R20 in Abhängigkeit von R18 einen Wert aus {0,1,2,4,8} zuweist.
	
	
	ret

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
	cpi R20,1
	brne fail
	ldi R18,'Z'
	rcall set_R20
	cpi R20,2
	brne fail
	ldi R18,'L'
	rcall set_R20
	cpi R20,4
	brne fail
	ldi R18,'R'
	rcall set_R20
	cpi R20,8
	brne fail
	ldi R18,'X'
	rcall set_R20
	cpi R20,0
	brne fail

; Hier sollte man nach Ausführung des Codes laden, wenn alles richtig gemacht wurde
win: rjmp win 

; Hier landet man, wenn die Funktion set_R20 eine falsche Berechnung ausgeführt hat
fail: rjmp fail
