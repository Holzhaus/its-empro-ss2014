; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universit�t Bochum
; * Makro Definitionen f�r den ASURO
; * (c) 2009 by Tim G�neysu & Teilnehmer
; *****************************************************

; WICHTIG: Die Makros d�rfen R21, R22 als tempor�re Werte verwenden -> daher nicht mit globalen Variablen belegen 

; ############## KONSTANTEN F�R DEN ASURO #####################

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

; ############## Makros f�r die Status-LED ##################

.MACRO SET_STATUS_LED_GREEN
	; deaktiviere rote und aktiviere gr�ne LED
	SBI PORTB, GREEN_LED 
	CBI PORTD, RED_LED 		
.ENDMACRO

.MACRO SET_STATUS_LED_RED
	; deaktiviere gr�ne und aktiviere rote LED
	CBI PORTB, GREEN_LED 
	SBI PORTD, RED_LED 		
.ENDMACRO

.MACRO SET_STATUS_LED_YELLOW
	; aktiviere rote und gr�ne LED
	SBI PORTB, GREEN_LED 
	SBI PORTD, RED_LED 		
.ENDMACRO

.MACRO SET_STATUS_LED_OFF
	; deaktiviere beide LEDs
	CBI PORTB, GREEN_LED 
	CBI PORTD, RED_LED 		
.ENDMACRO

; ############## Makros f�r die Motorsteuerung ##################

.MACRO SET_MOTOR_SPEED ; @0 f�r Geschwindigkeit des linken Motors, @1 f�r Geschwindigkeit des rechten Motors
	; setze Geschwindigkeit f�r linken Motor
	CLR MTEMP1			
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (links) in zweites Register
	OUT OCR1AH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit f�r rechten Motor
	LDI MTEMP2, @1		; lade �bergebenen Geschwindigkeitsparameter (rechts) in zweites Register
	OUT OCR1BH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter
.ENDMACRO


.MACRO FORWARD ; @0 f�r Geschwindigkeit des linken Motors, @1 f�r Geschwindigkeit des rechten Motors
	SET_MOTOR_SPEED @0, @1

	; setze Laufrichtung des linken Motors
	SBI LEFT_ENGINE, FORWARD_PIN
	CBI LEFT_ENGINE, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	SBI RIGHT_ENGINE, FORWARD_PIN
	CBI RIGHT_ENGINE, BACKWARD_PIN
    
.ENDMACRO

.MACRO BACKWARD ; @0 f�r Geschwindigkeit des linken Motors, @1 f�r Geschwindigkeit des rechten Motors
	SET_MOTOR_SPEED @0, @1

	; setze Laufrichtung des linken Motors auf R�ckw�rts
	SBI LEFT_ENGINE, BACKWARD_PIN
	CBI LEFT_ENGINE, FORWARD_PIN

	; setze Laufrichtung des rechten Motors auf R�ckw�rts
	SBI RIGHT_ENGINE, BACKWARD_PIN
	CBI RIGHT_ENGINE, FORWARD_PIN
    
.ENDMACRO

.MACRO TURNLEFT ; @0 f�r Geschwindigkeit
	SET_MOTOR_SPEED @0, @0

	; setze Laufrichtung des linken Motors auf R�ckw�rts
	SBI LEFT_ENGINE, BACKWARD_PIN
	CBI LEFT_ENGINE, FORWARD_PIN

	; setze Laufrichtung des rechten Motors auf Vorw�rts
	SBI RIGHT_ENGINE, FORWARD_PIN
	CBI RIGHT_ENGINE, BACKWARD_PIN
    
.ENDMACRO

.MACRO TURNRIGHT  ; @0 f�r Geschwindigkeit
	SET_MOTOR_SPEED @0, @0

	; setze Laufrichtung des linken Motors auf Vorw�rts
	SBI LEFT_ENGINE, FORWARD_PIN
	CBI LEFT_ENGINE, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors auf R�ckw�rts
	SBI RIGHT_ENGINE, BACKWARD_PIN
	CBI RIGHT_ENGINE, FORWARD_PIN
    
.ENDMACRO

.MACRO BRAKE ; Keine Parameter
	; setze Laufrichtung des linken Motors auf Bremsen
	CBI LEFT_ENGINE, FORWARD_PIN
	CBI LEFT_ENGINE, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors auf Bremsen
	CBI RIGHT_ENGINE, FORWARD_PIN
	CBI RIGHT_ENGINE, BACKWARD_PIN
.ENDMACRO
