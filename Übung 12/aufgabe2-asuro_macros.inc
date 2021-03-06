; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universit�t Bochum
; * Makro Definitionen f�r den ASURO
; * (c) 2009 by Tim G�neysu & Teilnehmer
; *****************************************************

; WICHTIG: Die Makros d�rfen R21, R22 als tempor�re Werte verwenden -> daher nicht mit globalen Variablen belegen 

; L�SUNG F�R AUFGABENTEIL 2a):
; Aktiviere den ADC und schalte den Prescaler auf CLK/64 = 125 KHz
; LDI TEMP1,(1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0)
; OUT ADCSRA,TEMP1

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


; ############## Makros f�r den ADC ##################

; hier Makros READ_ADC und GET_PT_DIFF erg�nzen
.MACRO READ_ADC ; @0 Parameter ist der Pin
	; ADC-Wandlung durchf�hren
	; Eingangspin ausw�hlen und Referenzspannung auf (A)VCC setzen
	LDI MTEMP1,(0<<REFS1) | (1<<REFS0) | @0
	OUT ADMUX,MTEMP1
	; Wandlung starten
	SBI ADCSRA, ADSC
	; Polling
	SBIC ADCSRA, ADSC
	RJMP PC-1
.ENDMACRO

.MACRO GET_PT_DIFF ; keine Parameter
	READ_ADC ADC_PT_LEFT
	IN PT_DIFF_L, ADCL
	IN PT_DIFF_H, ADCH
	READ_ADC ADC_PT_RIGHT
	IN MTEMP1,ADCL
	IN MTEMP2,ADCH
	SUB PT_DIFF_L,MTEMP1
	SBC PT_DIFF_H,MTEMP2
.ENDMACRO
