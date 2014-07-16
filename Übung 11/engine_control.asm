; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universit�t Bochum
; * �bung: Motorsteuerung mit PWM und Callback-Funktionen
; * (c) 2009 by Tim G�neysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einf�gen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen f�r den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

; ##############  EXTERNE MACROS F�R DEN ASURO  #####################
.INCLUDE "asuro_macros.inc"

; ########### KONSTANTEN F�R DIE MOTORGESCHWINDIGKEIT ################

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
  
.ORG OVF0addr      		; Interrupthandler f�r den 8-Bit Timer 0
  	RJMP TIMER0_OVF

; ############## INTERRUPT TIMER0_OVF ##################		
TIMER0_OVF:

	; Rette das TEMP1=R16 und das Statusregister
	PUSH TEMP1
	IN TEMP1, SREG
	PUSH TEMP1

	; inkrementiere einen registerbasierten Z�hler (R20), der z�hlt, wie oft der Overflow-Interrupt ausgel�st wurde
	INC OVERFLOW

	; pr�fe, ob bereits 13 IRQs ausgel�st wurden (d.h. 100ms vorbei sind) und evt. ein Zustandswechsel ansteht
	CPI OVERFLOW, 13
	BRLO FINAL_TICKS_TEST ; in diesem Fall sind 13 IRQ noch nicht vorbei, dann springen zu den anderen F�llen
	
	; 100 ms sind also vorbei, l�sche Overflow Counter, damit die n�chsten 100ms gez�hlt werden k�nnen
	CLR OVERFLOW 

	; pr�fe, ob der wir bereits die vollen x*100ms (wobei x=STATE_TIMER) f�r einen Zustandswechsel gewartet haben
	CPI STATE_TIMER, 0	
	BRNE DEC_STATE_TIMER; falls nicht, dekrementiere STATE_TIMER und warte dann bis die n�chsten 100ms rum sind

	; an diesem Punkt haben wir wohl ausreichend lange gewartet, nun soll der Zustandswechsel erfolgen
	CPI STATE_REG, 0
	BREQ GOTO_STATE1 		; wir sind im Zustand 0, springe also zum �bergang in Zustand S	
	
; Zustand 0: soll f�r 6*100ms gehalten werden
GOTO_STATE0:

	LDI ZH, HIGH(STATE_0)	; setze den Z-Zeiger auf die CALLBACK Adresse (high) mit der Zustandsfunktion des STATE_0
	LDI ZL, LOW(STATE_0)	; setze den Z-Zeiger auf die CALLBACK Adresse (low) mit der Zustandsfunktion des STATE_0
	CLR STATE_REG			; setze den aktuellen Status auf Zustand 0
	LDI STATE_TIMER, 8		; setze den Zustandsz�hler, der angibt, wie viele 100ms Einheiten bis zum n�chsten Zustand gewartet werden soll
	RJMP FINISHED			; springe zum Ende der Interruptroutine

; Zustand 1: soll f�r 3*100ms gehalten werden
GOTO_STATE1:

	LDI ZH, HIGH(STATE_1)	; setze den Z-Zeiger auf die CALLBACK Adresse (high) mit der Zustandsfunktion des STATE_1
	LDI ZL, LOW(STATE_1)	; setze den Z-Zeiger auf die CALLBACK Adresse (low) mit der Zustandsfunktion des STATE_1
	LDI STATE_TIMER, 4		; setze den Zustandsz�hler, der angibt, wie viele 100ms Einheiten bis zum n�chsten Zustand gewartet werden soll
	LDI STATE_REG, 1		; setze den aktuellen Zustand auf 1
	RJMP FINISHED			; springe zum Ende der Interruptroutine

; an diesem Punkt folgt der Test, ob wir den verk�rzten, letzten Z�hlerdurchlauf (um 100ms zu erreichen) durchf�hren mussen
FINAL_TICKS_TEST: 

	; pr�fe, ob bereits 12 IRQs ausgel�st wurden. Falls nicht, springe zum Ende
	CPI OVERFLOW, 12
	BRLO FINISHED
	
	; schreibe 256-53=203 in den Counter des Timer 0
	LDI TEMP1, 203
	OUT TCNT0, TEMP1

	; springe zum Ende der Interruptroutine
	RJMP FINISHED

; nun sind zwar 100ms um, aber der Zustand soll noch nicht gewechselt werden -> Update des STATE_TIMERS
DEC_STATE_TIMER:

	DEC STATE_TIMER		; dekrementiere den STATE_TIMER, der die Anzahl der 100ms Einheiten bis zum Zustandswechsel z�hlt

FINISHED:

	; Stelle Register und SREG wieder her
	POP TEMP1
	OUT SREG, TEMP1
	POP TEMP1

	; springe aus dem Interrupt zur�ck
	RETI

; ############## ZUSTANDSFUNKTIONEN ##################

STATE_0:

	; aktiviere gr�ne LED 
	SET_STATUS_LED_GREEN			
	RJMP RETURN_FROM_CALL;

STATE_1:	

	; aktiviere rote LED 
	SET_STATUS_LED_RED  				
	RJMP RETURN_FROM_CALL;

; ############## SYSTEMRESET ##################	
RESET:					

; Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
	LDI TEMP1, HIGH(RAMEND)	; Lade 8 h�chstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die h�chste Adresse des SRAM) in R16
	OUT SPH, TEMP1			; Schreibe diese h�herwertigen Bits in den h�herwertigen Teil des SP
	LDI TEMP1, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
	OUT SPL, TEMP1			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

	; Setze die Ausgabeports f�r die Status-LED und die Front-LED
	LDI TEMP1,(1<<GREEN_LED)
	OUT DDRB, TEMP1		
	LDI TEMP1,(1<<RED_LED)
	OUT DDRD, TEMP1

	// Overflow-Interrupt des Timer0 aktivieren
	LDI TEMP1, (1<<TOIE0)
	OUT TIMSK, TEMP1

	; Timer 0 aktivieren, dabei Bit(s) f�r Vorteiler CLK/256 setzen (CS02:CS01:CS00=100)
	LDI TEMP1, (1<<CS02)
	OUT TCCR0, TEMP1

	; setze den Initialzustand S0 als Callback-Funktion
	LDI ZH, HIGH(STATE_0)	; setze CALLBACK Adresse (high) auf STATE_0
	LDI ZL, LOW(STATE_0)	; setze CALLBACK Adresse (low) auf STATE_0
	LDI STATE_TIMER, 6		; setze den Timer, wie viele 100ms Einheiten bis zum n�chsten Zustand gewartet werden soll

	; aktiviere globale Interrupts
	SEI

; ############## Hauptprogramm ##################
MAIN:	

	; rufe mit indirektem Sprung die Zustandsfunktion (auf die der Z-Zeiger zeigt) auf, die den ASURO f�r den aktuellen Zustand konfiguriert
	IJMP

RETURN_FROM_CALL:

	; Prozessor schlafen legen
	SLEEP

	RJMP MAIN				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausf�hrt


