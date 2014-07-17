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


.EQU	CYCLES_PER_MS = 8000		; Konstanten für die WAIT-Funktion
.EQU	HALF_SECOND	 = 500
.EQU	QUARTER_SECOND = 250

.DEF	DELAY_MILLIS_L = R24		;	niederwertiges Byte der Verzögerung in Millisekunden (16-Bit)
.DEF	DELAY_MILLIS_H = R25		;	höherwertiges Byte der Verzögerung in Millisekunden (16-Bit)


.DEF  TMPH=R18
.DEF  TMPL=R17
.DEF	KEY=R19


; ############## UNTERFUNKTION WAIT ##################
; beschäftigt den Prozessor für die Anzahl Millisekunden, die im 16-bit Register DELAY_MILLIS (R25:R24) gespeichert wurden
WAIT_MS:
		PUSH R26						; Register R26 retten
		PUSH R27						; Register R27 retten
OUTER:	LDI  R27, HIGH(CYCLES_PER_MS)	; Lade höherwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenzähler
		LDI  R26, LOW(CYCLES_PER_MS)	; Lade niederwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenzähler
INNER:	SBIW R26, 4						; Subtrahiere 4 vom Zyklenzähler (Anzahl Zyklen, die SBIW und BRNE benötigen)
		BRNE INNER						; Wiederhole so oft, bis Zyklemzähler Null ist
		SBIW DELAY_MILLIS_L, 1			; Subtrahiere 1 vom Millisekundenzähler
		BRNE OUTER						; Wiederhole so lange, bis Millisekundenzähler Null
		POP R27							; Register R27 wiederherstellen
		POP R26							; Register R26 wiederherstellen
		RET



; ############## Makros für die LEDs ##################

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

.MACRO SET_LEFT_BACK_LED_OFF
	; deaktiviere linke Rück-LED
	CBI PORTC, LEFT_BACK_LED 
.ENDMACRO

.MACRO SET_LEFT_BACK_LED_ON
	; aktiviere linke Rück-LED
	SBI PORTC, LEFT_BACK_LED 
.ENDMACRO

.MACRO SET_RIGHT_BACK_LED_OFF
	; deaktiviere rechte Rück-LED
	CBI PORTC, RIGHT_BACK_LED 
.ENDMACRO

.MACRO SET_RIGHT_BACK_LED_ON
	; aktiviere rechte Rück-LED
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



; ############## Makros für die Motorsteuerung ##################



; ############## Makros für den ADC ##################

.MACRO READ_ADC

.ENDMACRO


; ############## Makros für die Taster ##################
.MACRO GET_KEYS
	
.ENDMACRO
