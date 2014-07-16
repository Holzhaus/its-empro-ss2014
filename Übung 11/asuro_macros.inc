; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Makro Definitionen für den ASURO
; * (c) 2009 by Tim Güneysu & Teilnehmer
; *****************************************************

; WICHTIG: Die Makros dürfen R21, R22 als temporäre Werte verwenden -> daher nicht mit globalen Variablen belegen 

; ############## KONSTANTEN FÜR DEN ASURO #####################

; Motorkonstanten
.EQU	LEFT_ENGINE=PORTD
.EQU	RIGHT_ENGINE=PORTB

.EQU	FORWARD_PIN=5
.EQU	BACKWARD_PIN=4
.EQU	PWM_LEFT=PB1
.EQU	PWM_RIGHT=PB2

.EQU	RWD = 0x10
.EQU	FWD = 0x20

; LEDs
.EQU	GREEN_LED=PB0
.EQU	RED_LED=PD2

; ##############  MACRO DEFINITIONEN  #####################
.DEF 	MTEMP1=R21
.DEF 	MTEMP2=R22

; ############## Makros für die Status-LED ##################

.MACRO SET_STATUS_LED_GREEN
	; deaktiviere rote und aktiviere grüne LED
	SBI PORTB, GREEN_LED 
	CBI PORTD, RED_LED 		
.ENDMACRO

.MACRO SET_STATUS_LED_RED
	; deaktiviere grüne und aktiviere rote LED
	CBI PORTB, GREEN_LED 
	SBI PORTD, RED_LED 		
.ENDMACRO

.MACRO SET_STATUS_LED_YELLOW
	; aktiviere rote und grüne LED
	SBI PORTB, GREEN_LED 
	SBI PORTD, RED_LED 		
.ENDMACRO

.MACRO SET_STATUS_LED_OFF
	; deaktiviere beide LEDs
	CBI PORTB, GREEN_LED 
	CBI PORTD, RED_LED 		
.ENDMACRO

; ############## Makros für die Motorsteuerung ##################

.MACRO FORWARD 

	; setze Geschwindigkeit für linken Motor
	CLR MTEMP1			
	LDI MTEMP2, @0		; lade übergebenen Geschwindigkeitsparameter (links) in zweites Register
	OUT OCR1AH, MTEMP1	; beschreibe höherwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit für rechten Motor
	LDI MTEMP2, @1		; lade übergebenen Geschwindigkeitsparameter (rechts) in zweites Register
	OUT OCR1BH, MTEMP1	; beschreibe höherwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	; setze Laufrichtung des linken Motors
	SBI PORTD, FORWARD_PIN
	CBI PORTD, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	SBI PORTB, FORWARD_PIN
	CBI PORTB, BACKWARD_PIN
    
.ENDMACRO
