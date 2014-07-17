; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Übung: Verwendung der Fototransistoren und des ADC
; * (c) 2009 by Tim Güneysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

; ##############  EXTERNE MACROS FÜR DEN ASURO  #####################
.INCLUDE "asuro_macros.inc"

; ##############  GLOBALE DEFINITIONEN  #####################
.DEF 	TEMP1=R16
.DEF 	TEMP2=R17

; ############## Einsprungsvektoren ##################
.ORG 0x000
   	RJMP RESET			; Springe zur Initialisierungsroutine

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
	LDI TEMP1,(1<<LEFT_BACK_LED) | (1<<RIGHT_BACK_LED)
	OUT DDRC, TEMP1		
	LDI TEMP1,(1<<RED_LED) | (1<<FRONT_LED)
	OUT DDRD, TEMP1
  
  	; Aktiviere den ADC und schalte den Prescaler auf CLK/64 = 125 KHz
	<???>

	; Status-LED abschalten und Front-LED einschalten
	SET_STATUS_LED_OFF
	SET_FRONT_LED_ON

; ############## Hauptprogramm ##################
MAIN:	
	
	; berechne die Differenz der Fototransistoren in PT_DIFF 
	GET_PT_DIFF
	
	; prüfe, ob Ergebnis positiv oder negativ ist, falls negativ ist die linke Seite dunkler
	TST PT_DIFF_H
	BRMI LEFT_IS_DARKER
	
RIGHT_IS_DARKER:

	; Rechte Seite ist dunkler. Prüfe, ob das Ergebnis auch nach Subtraktion von 10 noch positiv ist
	SBIW PT_DIFF_L, 10
	BRMI ALMOST_SAME	

	; Rechte Seite ist erheblich dunkler (mehr als Toleranz), färbe Status-LED grün
	SET_STATUS_LED_GREEN
	RJMP MAIN

LEFT_IS_DARKER:

	; Linke Seite ist dunkler. Prüfe, ob das Ergebnis auch nach Subtraktion von 10 noch negativ ist
	ADIW PT_DIFF_L, 10
	BRPL ALMOST_SAME

	; Linke Seite ist erheblich dunkler (mehr als Toleranz), färbe Status-LED rot
	SET_STATUS_LED_RED
	RJMP MAIN
	
ALMOST_SAME: 	

	; beide Seiten sind ungefähr gleich hell, schalte Status-LED aus
	SET_STATUS_LED_OFF

	RJMP MAIN				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausführt
