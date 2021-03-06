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

; ADC MUX Konstanten
.EQU 	ADC_PT_LEFT=(1<<MUX0)|(1<<MUX1)
.EQU 	ADC_PT_RIGHT=(1<<MUX1)
.EQU 	ADC_SWITCHES=(1<<MUX2)

; LEDs
.EQU 	LEFT_BACK_LED=PC1
.EQU 	RIGHT_BACK_LED=PC0
.EQU 	FRONT_LED=PD6
.EQU	GREEN_LED=PB0
.EQU	RED_LED=PD2

; ##############  MACRO DEFINITIONEN  #####################
.DEF 	MTEMP1=R21
.DEF 	MTEMP2=R22

.DEF	PT_DIFF_L = R24
.DEF	PT_DIFF_H = R25

; ############## Makros f�r die LEDs ##################

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

.MACRO SET_LEFT_BACK_LED_OFF
	; deaktiviere linke R�ck-LED
	CBI PORTC, LEFT_BACK_LED 
.ENDMACRO

.MACRO SET_LEFT_BACK_LED_ON
	; aktiviere linke R�ck-LED
	SBI PORTC, LEFT_BACK_LED 
.ENDMACRO

.MACRO SET_RIGHT_BACK_LED_OFF
	; deaktiviere rechte R�ck-LED
	CBI PORTC, RIGHT_BACK_LED 
.ENDMACRO

.MACRO SET_RIGHT_BACK_LED_ON
	; aktiviere rechte R�ck-LED
	SBI PORTC, RIGHT_BACK_LED 
.ENDMACRO

.MACRO SET_FRONT_LED_OFF
	; deaktiviere FRONT-LED
	CBI PORTD, FRONT_LED 
.ENDMACRO

.MACRO SET_FRONT_LED_ON
	; aktiviere FRONT-LED
	SBI PORTD, FRONT_LED 
.ENDMACRO



; ############## Makros f�r die Motorsteuerung ##################

.MACRO FORWARD 

	; setze Geschwindigkeit f�r linken Motor
	CLR MTEMP1			
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (links) in zweites Register
	OUT OCR1AH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit f�r rechten Motor
	LDI MTEMP2, @1		; lade �bergebenen Geschwindigkeitsparameter (rechts) in zweites Register
	OUT OCR1BH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	; setze Laufrichtung des linken Motors
	SBI PORTD, FORWARD_PIN
	CBI PORTD, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	SBI PORTB, FORWARD_PIN
	CBI PORTB, BACKWARD_PIN
    
.ENDMACRO

.MACRO BACKWARD 

	; setze Geschwindigkeit f�r linken Motor
	CLR MTEMP1			
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (links) in zweites Register
	OUT OCR1AH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit f�r rechten Motor (Richtungsbits f�r vorw�rts und r�ckw�rts werden gleichzeitig ge�ndert)
	LDI MTEMP2, @1		; lade �bergebenen Geschwindigkeitsparameter (rechts) in zweites Register
	OUT OCR1BH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	; setze Laufrichtung des linken Motors
	CBI PORTD, FORWARD_PIN
	SBI PORTD, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	CBI PORTB, FORWARD_PIN
	SBI PORTB, BACKWARD_PIN

.ENDMACRO

.MACRO TURNLEFT 

	; setze Geschwindigkeit f�r linken Motor
	CLR MTEMP1			
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (links) in zweites Register
	OUT OCR1AH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit f�r rechten Motor (Richtungsbits f�r vorw�rts und r�ckw�rts werden gleichzeitig ge�ndert)
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (rechts) in zweites Register
	OUT OCR1BH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	; setze Laufrichtung des linken Motors
	CBI PORTD, FORWARD_PIN
	SBI PORTD, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	SBI PORTB, FORWARD_PIN
	CBI PORTB, BACKWARD_PIN
	
.ENDMACRO

.MACRO TURNRIGHT

	; setze Geschwindigkeit f�r linken Motor
	CLR MTEMP1			
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (links) in zweites Register
	OUT OCR1AH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit f�r rechten Motor (Richtungsbits f�r vorw�rts und r�ckw�rts werden gleichzeitig ge�ndert)
	LDI MTEMP2, @0		; lade �bergebenen Geschwindigkeitsparameter (rechts) in zweites Register
	OUT OCR1BH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	; setze Laufrichtung des linken Motors
	SBI PORTD, FORWARD_PIN
	CBI PORTD, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	CBI PORTB, FORWARD_PIN
	SBI PORTB, BACKWARD_PIN

.ENDMACRO

.MACRO BRAKE

	; setze Geschwindigkeit f�r linken Motor
	CLR MTEMP1			
	LDI MTEMP2, 0xFF	; setze PWM des linken Motors auf Maximalwert => C=1
	OUT OCR1AH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1AL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	;setze Geschwindigkeit f�r rechten Motor (Richtungsbits f�r vorw�rts und r�ckw�rts werden gleichzeitig ge�ndert)
	LDI MTEMP2, 0xFF	; setze PWM des rechten Motors auf Maximalwert => C=1
	OUT OCR1BH, MTEMP1	; beschreibe h�herwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Null 
	OUT OCR1BL, MTEMP2	; schreibe niederwertiges Byte des Referenzwertes (Output Compare des Timer 1, Kanal B) mit Geschwindigkeitsparameter

	; setze Laufrichtung des linken Motors
	SBI PORTD, FORWARD_PIN
	SBI PORTD, BACKWARD_PIN

	; setze Laufrichtung des rechten Motors
	SBI PORTB, FORWARD_PIN
	SBI PORTB, BACKWARD_PIN

.ENDMACRO

; ############## Makros f�r den ADC ##################

; hier Makros READ_ADC und GET_PT_DIFF erg�nzen