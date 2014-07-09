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
; Als Prescaler sollte 256 gewählt werden.
; Hier die Wartezeiten für t0, t1 und t2:
; i | t    | N   | R   | S   |
; - | ---- | --- | --- | --- |
; 1 | 0.6s |  73 |  62 | 193 |
; 2 | 1.2s | 146 | 124 | 131 |
; 3 | 1.8s | 219 | 186 |  69 |
;
; Entweder könnte ein zusätzliches Zählregister verwendet
; werden, da t1 und t2 jeweils Vielfache von t0 sind.
; Wir finden jedoch unsere Lösung eleganter, bei der die
; Wartezeit (d. h. N und S) in zwei Registern gespeichert
; und beim Statusübergang angepasst werden. (siehe unten)
;
;******************************************************


.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.DEF 	TEMP=R16
.DEF 	TOGGLE_REG=R17
.DEF 	OVR_FLOW=R20

.DEF    FULL_INTERRUPTS = r18 ; 61
.DEF    REMAINING_TICKS = r19 ; 255-9=247

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

        CP OVR_FLOW, FULL_INTERRUPTS
	BREQ SET_REMAINING_TICKS
	BRSH EXECUTE
FINISHED:
	; Stelle Register und SREG wieder her
	POP R16
	OUT SREG, R16
	POP R16
	; springe aus dem Interrupt zurück
	RETI
SET_REMAINING_TICKS:
        MOV R16, REMAINING_TICKS
	OUT TCNT0, R16
	; springe zum Ende der Interruptroutine
	RJMP FINISHED	
EXECUTE:
	CLR OVR_FLOW
	RCALL STATEMACHINE
	RJMP FINISHED

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

	; Startstatus herstellen (LED=Rot)
	SBI PORTD,2
	CBI PORTB,0

	; Setze Variablen
	LDI FULL_INTERRUPTS,61
	LDI REMAINING_TICKS,247 ; 255-9 = 247
	; Für Aufgabenteil c) stattdessen die Werte:
	;   LDI FULL_INTERRUPTS,73
	;   LDI REMAINING_TICKS,193 ; 255-62=193

	; aktiviere globale Interrupts
	SEI

	; Timer aktivieren (d.h. Bit(s) für PRESCALER CLK/256 setzen => Einstellung CS02:CS01:CS00 = 100)
	LDI R16, (1<<CS02)
	OUT TCCR0, R16

; Endlosschleife
END:	
	RJMP END				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausführt

; ########### Statemachine ######################
STATEMACHINE:
        ; Der folgende Code macht quasi folgendes
	; if PD2==0:
	;   current_state1()
	; elif PD2==1 and PB0 == 1:
        ;     current_state2()
	; elif PD2==1 and PB0 == 0:
        ;     current_state0()
	SBIS PORTD,2
	RJMP CURRENT_STATE1_GOTO_STATE2 ; PD2==0, z. Z. in State 1
	SBIC PORTB,0
	RJMP CURRENT_STATE2_GOTO_STATE0 ; PD2==1 und PB0==1, z. Z. in State 2
	; PD2==1 und PB0==0, z. Z. in State 0 (RJMP hier nicht notwendig)
CURRENT_STATE0_GOTO_STATE1:
	; Hier ist noch State 0
        ; Rot -> Grün
	CBI PORTD,2
	SBI PORTB,0
	; Ab jetzt sind wir in State 1
	; Für Aufgabenteil c) noch hinzufügen:
	;   ; Neue Wartezeit für State 2 laden
	;   LDI FULL_INTERRUPTS,146
	;   LDI REMAINING_TICKS,131 ; 255-124=131

	RET
CURRENT_STATE1_GOTO_STATE2:
        ; Grün -> Gelb
	SBI PORTD,2
	; Für Aufgabenteil c) noch hinzufügen:
	;   LDI FULL_INTERRUPTS,219
	;   LDI REMAINING_TICKS,69 ; 255-186=69
	RET
CURRENT_STATE2_GOTO_STATE0:
        ; Gelb -> Rot
	CBI PORTB,0
	; Für Aufgabenteil c) noch hinzufügen:
	;   LDI FULL_INTERRUPTS,73
	;   LDI REMAINING_TICKS,193 ; 255-62=193
	RET

