; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung 8: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Übung 9: Echtzeitsteuerung: Invertieren des Registers R17 im 100 Millisekunden-Abstand 
; * (c) 2009 by Tim Güneysu
; *****************************************************

;******************************************************
;Schreiben Sie hier Ihre Antwort für Teil (c) hin.
;
;
;
;******************************************************


.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.DEF 	TEMP=R16
.DEF 	TOGGLE_REG=R17
.DEF 	OVR_FLOW=R20

; ############## Einsprungsvektoren ##################
.ORG 0x000
   RJMP MAIN			; Springe zum Hauptprogramm
  
.ORG OVF0addr      		; Overflow-Interrupthandler für den 8-Bit Timer 0
  RJMP TIMER0_OVF

; ############## INTERRUPT TIMER0_OVF ##################		
TIMER0_OVF:

	; Rette das TEMP=R16 und das Statusregister
	PUSH R16
	IN R16, SREG
	PUSH R16

	; inkrementiere einen registerbasierten Zähler (R20), wie oft der Interrupt ausgelöst wurde
	INC OVR_FLOW

	; prüfe, ob bereits 12 IRQs ausgelöst wurden. Falls ja, setze Timer manuell (auf 256-53=203), damit nur noch die restlichen 53 Timer-Ticks (bis 100ms) gezählt werden
	CPI OVR_FLOW, 12
	BRNE TEST_100MS

	; schreibe 203 in den Counter des Timer 0
	LDI R16, 203
	OUT TCNT0, R16

	; springe zum Ende der Interruptroutine
	RJMP FINISHED	

TEST_100MS:

	; prüfe, ob bereits 13 IRQs ausgelöst wurden. Falls ja, sind die 100ms erreicht, wird der Zählvorgang für die nächsten 100ms neu gestartet (OVR_FLOW=0)
	BRLO FINISHED
	CLR OVR_FLOW

	; ## führe nun die gewünschte Aktion mit einer Wartezeit von 100ms, in diesem Beispiel das Invertieren eines Registers (TOGGLE_REG=R17)
	COM TOGGLE_REG

FINISHED:

	; Stelle Register und SREG wieder her
	POP R16
	OUT SREG, R16
	POP R16

	; springe aus dem Interrupt zurück
	RETI


; ############## Hauptprogramm ##################	
MAIN:					

; Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
	LDI R16, HIGH(RAMEND)	; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
	OUT SPH, R16			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
	LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
	OUT SPL, TEMP			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

	; Interrupt des Timer0 aktivieren
	LDI R16, (1<<TOIE0)
	OUT TIMSK, R16

	; aktiviere globale Interrupts
	SEI

	; Timer aktivieren (d.h. Bit(s) für PRESCALER CLK/256 setzen => Einstellung CS02:CS01:CS00 = 100)
	LDI R16, (1<<CS02)
	OUT TCCR0, R16

; Endlosschleife
END:	
	RJMP END				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausführt


