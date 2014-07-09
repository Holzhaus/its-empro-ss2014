.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST	

.MACRO ADD_16 ; Berechnet @1:@0 + @3:@2
ADD @0, @2
ADC @1, @3
.ENDMACRO 

.org 0x0000 
	rjmp main

main:
	;Initialisierung des Stack Pointers
	ldi R16,high(RAMEND)
	out SPH,R16
	ldi R16,low(RAMEND)
	out SPL,R16

;Beispiel #1: unbedingte Sprünge
	rjmp there

and_back_again:
	nop
	nop

;Beispiel #2: bedingte Sprünge
	
	ldi r16, 1
	cpi r16,1
	brne ungleich

gleich:
	ldi r17, 1	
	rjmp fertig_mit_vergleich

ungleich:
	ldi r17, 2

fertig_mit_vergleich:
	nop
	nop

;Beispiel #3: Aufruf Makro
	ldi R16, 1
	ldi R17, 0
	ldi R18, 0xFF
	ldi R19, 0
	ADD_16 R16, R17, R18, R19

;Beispiel #4: Aufruf Funktion
	ldi R16, 1
	ldi R17, 0
	ldi R18, 0xFF
	ldi R19, 0
	rcall ADD_16_func

ende: rjmp ende

ADD_16_func:
	add R16, R18
	adc R17, R19 
	ret

there:
	nop
	nop
	rjmp and_back_again

