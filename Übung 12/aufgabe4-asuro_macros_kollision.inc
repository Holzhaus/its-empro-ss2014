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


.EQU	CYCLES_PER_MS = 8000		; Konstanten f�r die WAIT-Funktion
.EQU	HALF_SECOND	 = 500
.EQU	QUARTER_SECOND = 250

.DEF	DELAY_MILLIS_L = R24		;	niederwertiges Byte der Verz�gerung in Millisekunden (16-Bit)
.DEF	DELAY_MILLIS_H = R25		;	h�herwertiges Byte der Verz�gerung in Millisekunden (16-Bit)


.DEF  TMPH=R18
.DEF  TMPL=R17
.DEF	KEY=R19


; ############## UNTERFUNKTION WAIT ##################
; besch�ftigt den Prozessor f�r die Anzahl Millisekunden, die im 16-bit Register DELAY_MILLIS (R25:R24) gespeichert wurden
WAIT_MS:
		PUSH R26						; Register R26 retten
		PUSH R27						; Register R27 retten
OUTER:	LDI  R27, HIGH(CYCLES_PER_MS)	; Lade h�herwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenz�hler
		LDI  R26, LOW(CYCLES_PER_MS)	; Lade niederwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenz�hler
INNER:	SBIW R26, 4						; Subtrahiere 4 vom Zyklenz�hler (Anzahl Zyklen, die SBIW und BRNE ben�tigen)
		BRNE INNER						; Wiederhole so oft, bis Zyklemz�hler Null ist
		SBIW DELAY_MILLIS_L, 1			; Subtrahiere 1 vom Millisekundenz�hler
		BRNE OUTER						; Wiederhole so lange, bis Millisekundenz�hler Null
		POP R27							; Register R27 wiederherstellen
		POP R26							; Register R26 wiederherstellen
		RET



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

.MACRO ALL_LEDS_OFF
	SET_STATUS_LED_OFF
	SET_LEFT_BACK_LED_OFF
	SET_RIGHT_BACK_LED_OFF
	SET_FRONT_LED_OFF
.ENDMACRO



; ############## Makros f�r die Motorsteuerung ##################



; ############## Makros f�r den ADC ##################

.MACRO READ_ADC ; @0 Parameter ist der Pin
	; ADC-Wandlung durchf�hren
	; Eingangspin ausw�hlen und Referenzspannung auf (A)VCC setzen (linksb�ndiges Ergebnis)
	LDI MTEMP1,(0<<REFS1) | (1<<REFS0) | (1<<ADLAR) | @0
	OUT ADMUX,MTEMP1
	; Wandlung starten
	SBI ADCSRA, ADSC
	; Polling
	SBIC ADCSRA, ADSC
	RJMP PC-1
.ENDMACRO


; ############## Makros f�r die Taster ##################
.MACRO IF_KEY; Parameter @0=ADC-Wert, @1=KEY-Wert, @2=Zu �berspringende Befehle wenn True
	LDI MTEMP2,@0       ; Vergleichswert in MTEMP2 laden
	CPSE MTEMP1,MTEMP2  ; Vergleichen und bei Gleichheit n�chsten Befehl auslassen (d.h. weiter mit LDI)...
	RJMP PC+3           ; ... sonst Rest des Makros �berspringen
	LDI KEY,@1          ; KEY-Wert in KEY-Register schreiben
	RJMP PC+@2          ; Zum Ende springen (bzw. @2 Befehle �berspringen)
.ENDMACRO
.MACRO GET_KEYS ; keine Parameter
	READ_ADC ADC_SWITCHES
	IN MTEMP1, ADCH
	;
	; Wir haben *alle* Werte mit diesem C-Programm gemessen:
	; 
	; #include "asuro.h"
	; #include <stdio.h> 
	; int main(void)
	; {
	;   Init();
	;   SerPrint("\r\nADC Test\r\n");
	;   autoencode = FALSE;
	;   DDRD |= SWITCHES;                     // Port-Bit SWITCHES als Output
	;   SWITCH_ON;                            // Port-Bit auf HIGH zur Messung
	;   while (1)
	;   {
	; 	unsigned int i;
	; 	char buffer [50];
	; 	i = ReadADC(SWITCH, 10);
	; 	sprintf(buffer, "%u\r\n", i);
	; 	SerPrint(buffer);
	; 	Msleep(500);
	;   }
	;   return 0;
	; }
	;
	; So m�ssten die Werte sein, wenn der ASURO
        ; nicht so ein Schrott w�re ;D
	;
	;Table ADC | KEY | JMP
	IF_KEY 170,    1,   31
	IF_KEY 204,    2,   26
	IF_KEY 227,    4,   21
	IF_KEY 240,    8,   16
	IF_KEY 248,   16,   11
	IF_KEY 252,   32,    6 ; hier 252 statt 251 (Messung)
	IF_KEY 255,    0,    1
	;
	; Mit diesen Werten (bzw. mehreren Werten pro Taster)
        ; hat es bei uns besser geklappt (allerdings immer
	; noch nicht perfekt). Je nachdem, welche LEDs an
        ; sind, scheinen die ADC-Messergebnisse erheblich
        ; zu schwanken.
	;
	;;Table ADC | KEY | JMP
	;IF_KEY 170,    1,   71
	;IF_KEY 204,    2,   66
	;IF_KEY 227,    4,   61
	;IF_KEY 239,    8,   56
	;IF_KEY 240,    8,   51
	;IF_KEY 241,    8,   46
	;IF_KEY 247,   16,   41
	;IF_KEY 248,   16,   36
	;IF_KEY 249,   16,   31
	;IF_KEY 250,   16,   26
	;IF_KEY 251,   32,   21
	;IF_KEY 252,   32,   16
	;IF_KEY 253,   32,   11
	;IF_KEY 254,   32,   6
	;IF_KEY 255,0,1
	; Ende
	NOP
.ENDMACRO
