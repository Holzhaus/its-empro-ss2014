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

.org 0x002
		rjmp handle_INT1

main:
; Stackpointer initialisieren
ldi temp, low(RAMEND)
out SPL, temp
ldi temp, high(RAMEND)
out SPH, temp

; counter zuruecksetzen
clr count_int0
clr count_int1

; Siehe "MCU Control Register– MCUCR" im Datenblatt
;INT0: Jeder Flankenwechsel am Pin PD2 loest Interrupt INT0 aus
;INT1: Jeder Flankenwechsel am Pin PD3 loest Interrupt INT1 aus
in temp, MCUCR
sbr temp, (1<<ISC00) | (1<<ISC10)
cbr temp, (1<<ISC01) | (1<<ISC11)
out MCUCR, temp

/*
;Alternative Konfiguration
; INT0: The low level of INT0 (PD2) generates an interrupt request
; INT1: The rising edge of INT1 (PD3) generates an interrupt request
in temp, MCUCR
sbr temp, (1<<ISC10) | (1<<ISC11)
cbr temp, (1<<ISC00) | (1<<ISC01) 
out MCUCR, temp
*/


;Aktivieren der externen Interrupts INT0/INT1
in temp, GICR
sbr temp, (1<<INT0) | (1<<INT1)
out GICR, temp

;Interrupts global aktivieren
sei

; Endlosschleife, sobald Flankenwechsel an PD2 oder PD3 wird in entsprechende ISR gesprungen
loop:
	nop	
	rjmp loop

;###########
handle_INT0:
;###########
push temp
in temp, SREG
inc count_int0
;...
;...
out SREG, temp
pop temp
reti

;###########
handle_INT1:
;###########
push temp
in temp, SREG
inc count_int1
;...
;...
out SREG, temp
pop temp
reti
