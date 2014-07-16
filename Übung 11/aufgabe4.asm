; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Übung: Motorsteuerung mit PWM und Callback-Funktionen
; * (c) 2009 by Tim Güneysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

; ##############  EXTERNE MACROS FÜR DEN ASURO  #####################
.INCLUDE "aufgabe4_asuro_macros.inc"

; ########### KONSTANTEN FÜR DIE MOTORGESCHWINDIGKEIT ################

.EQU 	FULL_THROTTLE=0xFF
.EQU 	HALF_THROTTLE=0x7F

; ##############  GLOBALE DEFINITIONEN  #####################
.DEF 	TEMP1=R16
.DEF 	TEMP2=R17
.DEF 	STATE_REG=R18
.DEF	STATE_TIMER=R19
.DEF 	OVERFLOW=R20

; ############## Einsprungsvektoren ##################
.ORG 0x000
   	RJMP RESET			; Springe zur Initialisierungsroutine
  
.ORG OVF0addr      		; Interrupthandler für den 8-Bit Timer 0
  	RJMP TIMER0_OVF

.org INT_VECTORS_SIZE
; ############## INTERRUPT TIMER0_OVF ##################		
TIMER0_OVF:

	; Rette das TEMP1=R16 und das Statusregister
	PUSH TEMP1
	IN TEMP1, SREG
	PUSH TEMP1

	; inkrementiere einen registerbasierten Zähler (R20), der zählt, wie oft der Overflow-Interrupt ausgelöst wurde
	INC OVERFLOW

	; prüfe, ob bereits 13 IRQs ausgelöst wurden (d.h. 100ms vorbei sind) und evt. ein Zustandswechsel ansteht
	CPI OVERFLOW, 13
	BRLO FINAL_TICKS_TEST ; in diesem Fall sind 13 IRQ noch nicht vorbei, dann springen zu den anderen Fällen
	
	; 100 ms sind also vorbei, lösche Overflow Counter, damit die nächsten 100ms gezählt werden können
	CLR OVERFLOW 

	; prüfe, ob der wir bereits die vollen x*100ms (wobei x=STATE_TIMER) für einen Zustandswechsel gewartet haben
	CPI STATE_TIMER, 0	
	BRNE DEC_STATE_TIMER; falls nicht, dekrementiere STATE_TIMER und warte dann bis die nächsten 100ms rum sind

	; an diesem Punkt haben wir wohl ausreichend lange gewartet, nun soll der Zustandswechsel erfolgen
	CPI STATE_REG, 0
	BREQ GOTO_STATE1 		; wir sind im Zustand 0, springe also zum Übergang in Zustand S	
	
; Zustand 0: soll für 6*100ms gehalten werden
GOTO_STATE0:

	LDI ZH, HIGH(STATE_0)	; setze den Z-Zeiger auf die CALLBACK Adresse (high) mit der Zustandsfunktion des STATE_0
	LDI ZL, LOW(STATE_0)	; setze den Z-Zeiger auf die CALLBACK Adresse (low) mit der Zustandsfunktion des STATE_0
	CLR STATE_REG			; setze den aktuellen Status auf Zustand 0
	LDI STATE_TIMER, 8		; setze den Zustandszähler, der angibt, wie viele 100ms Einheiten bis zum nächsten Zustand gewartet werden soll
	RJMP FINISHED			; springe zum Ende der Interruptroutine

; Zustand 1: soll für 3*100ms gehalten werden
GOTO_STATE1:

	LDI ZH, HIGH(STATE_1)	; setze den Z-Zeiger auf die CALLBACK Adresse (high) mit der Zustandsfunktion des STATE_1
	LDI ZL, LOW(STATE_1)	; setze den Z-Zeiger auf die CALLBACK Adresse (low) mit der Zustandsfunktion des STATE_1
	LDI STATE_TIMER, 4		; setze den Zustandszähler, der angibt, wie viele 100ms Einheiten bis zum nächsten Zustand gewartet werden soll
	LDI STATE_REG, 1		; setze den aktuellen Zustand auf 1
	RJMP FINISHED			; springe zum Ende der Interruptroutine

; an diesem Punkt folgt der Test, ob wir den verkürzten, letzten Zählerdurchlauf (um 100ms zu erreichen) durchführen mussen
FINAL_TICKS_TEST: 

	; prüfe, ob bereits 12 IRQs ausgelöst wurden. Falls nicht, springe zum Ende
	CPI OVERFLOW, 12
	BRLO FINISHED
	
	; schreibe 256-53=203 in den Counter des Timer 0
	LDI TEMP1, 203
	OUT TCNT0, TEMP1

	; springe zum Ende der Interruptroutine
	RJMP FINISHED

; nun sind zwar 100ms um, aber der Zustand soll noch nicht gewechselt werden -> Update des STATE_TIMERS
DEC_STATE_TIMER:

	DEC STATE_TIMER		; dekrementiere den STATE_TIMER, der die Anzahl der 100ms Einheiten bis zum Zustandswechsel zählt

FINISHED:

	; Stelle Register und SREG wieder her
	POP TEMP1
	OUT SREG, TEMP1
	POP TEMP1

	; springe aus dem Interrupt zurück
	RETI

; ############## ZUSTANDSFUNKTIONEN ##################

STATE_0:

	; aktiviere grüne LED 
	SET_STATUS_LED_GREEN
	FORWARD 255,255
	RJMP RETURN_FROM_CALL;

STATE_1:	

	; aktiviere rote LED 
	SET_STATUS_LED_RED
	TURNLEFT 127
	RJMP RETURN_FROM_CALL;

; ############## SYSTEMRESET ##################	
RESET:

; Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
	LDI TEMP1, HIGH(RAMEND)	; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
	OUT SPH, TEMP1			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
	LDI TEMP1, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
	OUT SPL, TEMP1			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

	; Setze die Ausgabeports für die Status-LED und die Front-LED
	LDI TEMP1,(1<<GREEN_LED)
	OUT DDRB, TEMP1		
	LDI TEMP1,(1<<RED_LED)
	OUT DDRD, TEMP1

	; Overflow-Interrupt des Timer0 aktivieren
	LDI TEMP1, (1<<TOIE0)
	OUT TIMSK, TEMP1

	; Timer 0 aktivieren, dabei Bit(s) für Vorteiler CLK/256 setzen (CS02:CS01:CS00=100)
	LDI TEMP1, (1<<CS02)
	OUT TCCR0, TEMP1

	; setze den Initialzustand S0 als Callback-Funktion
	LDI ZH, HIGH(STATE_0)	; setze CALLBACK Adresse (high) auf STATE_0
	LDI ZL, LOW(STATE_0)	; setze CALLBACK Adresse (low) auf STATE_0
	LDI STATE_TIMER, 6		; setze den Timer, wie viele 100ms Einheiten bis zum nächsten Zustand gewartet werden soll

        ; PWM, Phase Correct, 8-bit:
	; | WGM13 | WGM12 | WGM11 | WGM10 |
        ; | ----- | ----- | ----- | ----- |
        ; |     0 |     0 |     0 |     1 |
        ;
	; Prescaler CLK/64:
        ; | CS12 | CS11 | CS10 |
        ; | ---- | ---- | ---- |
	; |    0 |    1 |    1 |
        ;
        ; Ausgabeverhalten: Set at bottom, Clear at match
        ; | COM1A1 | COM1B1 | COM1A0 | COM1B0 |
        ; | ------ | ------ | ------ | ------ |
        ; |      1 |      1 |      0 |      0 |
        ;
	; Registerübersicht
        ; | Register |      7 |      6 |      5 |      4 |     3 |     2 |     1 |     0 |
        ; | -------- | ------ | ------ | ------ | ------ | ----- | ----- | ----- | ----- |
        ; | TCCR1A   | COM1A1 | COM1A0 | COM1B1 | COM1B0 | FOC1A | FOC1B | WGM11 | WGM10 |
        ; | TCCR1B   | ICNC1  | ICES1  |      – |  WGM13 | WGM12 |  CS12 |  CS11 |  CS10 |

        ; Einstellung PWM, Phase Correct, 8-bit, CLK/64, Set at bottom, Clear at match
	ldi      TEMP2, 0b10100001
	out      TCCR1A, TEMP2
 	ldi      TEMP2, 0b00000011
 	out      TCCR1B, TEMP2
	; Ausgänge (Motoren)
	; Hier scheint irgendwie ein Fehler zu sein. Solange wir hier die Motorpins nicht auf Ausgang schalten,
	; leuchten die LEDs korrekt im richtigen Abstand auf (allerdings fährt der Asuro nicht). Sobald wir aber
        ; die Pins auf Ausgang schalten, fährt der Asuro zwar, allerdings nur kurz und es kommt zu teilweise zufällig
	; wirkendem Verhalten. Zudem ist der STATE_1 plötzlich extrem kurz. Nach kurzer Zeit leuchtet die FrontLED
        ; auf, der Asuro piept und die Motoren gehen aus. (Evtl. ein Defekt?)
	sbi      DDRD,FORWARD_PIN
	sbi      DDRD,BACKWARD_PIN
	sbi      DDRB,FORWARD_PIN
	sbi      DDRB,BACKWARD_PIN
	; Ausgänge OCA1A/B
	sbi      DDRB,PWM_LEFT ; OC1A
        sbi      DDRB,PWM_RIGHT ; OC1B
 
	; aktiviere globale Interrupts
	SEI

; ############## Hauptprogramm ##################
MAIN:	

	; rufe mit indirektem Sprung die Zustandsfunktion (auf die der Z-Zeiger zeigt) auf, die den ASURO für den aktuellen Zustand konfiguriert
	IJMP

RETURN_FROM_CALL:

	; Prozessor schlafen legen
	SLEEP

	RJMP MAIN				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausführt


