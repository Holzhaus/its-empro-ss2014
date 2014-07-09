;Praesenzuebung 9
.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfuegen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen fuer den ATMega8, z.B. I/O Ports, Registernamen, etc.
.def count_int0 = r16
.def count_int1 = r17
.def temp = r18

; ############## Einsprungsvektoren ##################
.org 0x000
        rjmp main

.org 0x001
		rjmp handle_INT0	

main:
; Stackpointer initialisieren
ldi temp, low(RAMEND)
out SPL, temp
ldi temp, high(RAMEND)
out SPH, temp


;INT0: Jeder Flankenwechsel am Pin PD2 loest Interrupt INT0 aus
in temp, MCUCR
sbr temp, (1<<ISC00)
cbr temp, (1<<ISC01)
out MCUCR, temp



;Aktivieren der externen Interrupts INT0/INT1
in temp, GICR
sbr temp, (1<<INT0) 
out GICR, temp

;Interrupts global aktivieren
sei

; Endlosschleife, sobald Flankenwechsel an PD2 wird in entsprechende ISR gesprungen
loop:
	nop	

	ldi r16, 1
	cpi r16, 1
	nop
	nop
	nop
	nop
	brne BAD

	nop

	rjmp loop

BAD:
	//Sollte nicht angesprungen werden
	rjmp BAD



;###########
handle_INT0:
;###########
;in r21, SREG
ldi r20, 1
cpi r20, 2
;out SREG, r21

reti

