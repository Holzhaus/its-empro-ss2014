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
.INCLUDE "aufgabe4-asuro_macros_kollision.inc"

KOLLISION:
	; INT1 (PD3) als Output auf HIGH
	SBI DDRD,PD3
	SBI PORTD,PD3

	; Rette das TEMP=R16 und das Statusregister
	PUSH TEMP1   ; 2 Cycles
	IN TEMP1, SREG ; 1 Cycle
	PUSH TEMP1   ; 2 Cycles

	; 150 Takte warten
	CLR TEMP1    ; 1 Cycle
	INC TEMP1    ; 1 Cycle
	CPI TEMP1,37 ; 1 Cycle
	BRNE PC-2    ; 2 Cycles (wenn gleich nur 1 Cycle)
	NOP          ; 1 Cycle
	; 5 + 1 + 36*4 - 1 + 1 = 5 + 144 + 1 = 150 Cycles

	GET_KEYS

	; INT1 (PD3) als Eingang ohne PullUp
	CBI DDRD,PD3
	CBI PORTD,PD3
	
	; Stelle Register und SREG wieder her
	POP TEMP1
	OUT SREG, TEMP1
	POP TEMP1

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
	; LÖSUNG FÜR AUFGABENTEIL 4a):
	LDI TEMP1,(1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0)
	OUT ADCSRA,TEMP1

	; Status-LED abschalten
	SET_STATUS_LED_OFF
	
	; INT1 auf fallende Flank stellen
	LDI TEMP1,(1<<ISC11) | (0<<ISC10)
	OUT MCUCR,TEMP1
	; Aktiviere externen Interrupt INT1
	LDI TEMP1,(1<<INT1)
	OUT GICR,TEMP1
	; INT1 (PD3) als Eingang ohne PullUp
	CBI DDRD,PD3
	CBI PORTD,PD3

	; zur Verbesserung der ADC-Messung, den Prozessor in den ADC Noise Reduction Modus legen
	;LDI TEMP1, (1<<SM0)
	;OUT MCUCR, TEMP1

	LDI TEMP1,0

	; aktiviere globale Interrupts
	SEI


; ############## Hauptprogramm ##################
MAIN:
CP TEMP1,KEY
BREQ MAIN
MOV TEMP1,KEY
;hier das globale Register KEY auswerten und LEDs schalten
CPI KEY,0
BREQ NO_KEY_PRESSED
CPI KEY,1
BREQ K0_PRESSED
CPI KEY,2
BREQ K1_PRESSED
CPI KEY,4
BREQ K2_PRESSED
CPI KEY,8
BREQ K3_PRESSED
CPI KEY,16
BREQ K4_PRESSED
CPI KEY,32
BREQ K5_PRESSED
; Das sollte nicht passieren, aber zu sicherheit
RJMP MAIN
K0_PRESSED:
	SET_STATUS_LED_GREEN
	RJMP MAIN
K1_PRESSED:
	SET_STATUS_LED_RED
	RJMP MAIN
K2_PRESSED:
	SET_STATUS_LED_YELLOW
	RJMP MAIN
K3_PRESSED:
	SET_LEFT_BACK_LED_ON
	RJMP MAIN
K4_PRESSED:
	SET_RIGHT_BACK_LED_ON
	RJMP MAIN
K5_PRESSED:
	ALL_LEDS_OFF
	RJMP MAIN
NO_KEY_PRESSED:
	NOP
;SLEEP
RJMP MAIN				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausführt
