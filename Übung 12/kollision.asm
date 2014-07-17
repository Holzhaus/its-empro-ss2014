; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Übung: Photosensoren und BackLED
; * (c) 2009 by Tim Güneysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen


; ##############  GLOBALE DEFINITIONEN  #####################
.DEF 	TEMP1=R16



; ############## Einsprungsvektoren ##################
.ORG 0x000
   	RJMP RESET			; Springe zur Initialisierungsroutine

.org INT1addr
   rjmp KOLLISION   ;Ext Interrupt Vector Address


; ##############  EXTERNE MACROS FÜR DEN ASURO  #####################
.INCLUDE "asuro_macros_kollision.inc"

KOLLISION:
	reti

; ############## SYSTEMRESET ##################	
RESET:					

; Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
	LDI TEMP1, HIGH(RAMEND)	; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
	OUT SPH, TEMP1			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
	LDI TEMP1, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
	OUT SPL, TEMP1			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

	; Setze die Ausgabeports für die Status-LED und die Front-LED und die Back-LEDs
	LDI TEMP1,(1<<GREEN_LED)
	OUT DDRB, TEMP1		
	LDI TEMP1,(1<<LEFT_BACK_LED) | (1<<RIGHT_BACK_LED)
	OUT DDRC, TEMP1		
	LDI TEMP1,(1<<RED_LED) | (1<<FRONT_LED) |(1<<PD7);
	OUT DDRD, TEMP1

	; Aktiviere den ADC und schalte den Prescaler auf CLK/64 = 125 KHz
	

	; Status-LED abschalten
	SET_STATUS_LED_OFF
	
	;Aktiviere externen Interrupt INT1
	

	; zur Verbesserung der ADC-Messung, den Prozessor in den ADC Noise Reduction Modus legen
	;LDI TEMP1, (1<<SM0)
	;OUT MCUCR, TEMP1

	; aktiviere globale Interrupts
	SEI


; ############## Hauptprogramm ##################
MAIN:	
;hier das globale Register KEY auswerten und LEDs schalten

	
;SLEEP
RJMP MAIN				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausführt

