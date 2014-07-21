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

.MACRO ALL_LEDS_OFF
	SET_STATUS_LED_OFF
	SET_LEFT_BACK_LED_OFF
	SET_RIGHT_BACK_LED_OFF
	SET_FRONT_LED_OFF
.ENDMACRO



; ############## Makros für die Motorsteuerung ##################



; ############## Makros für den ADC ##################

.MACRO READ_ADC ; @0 Parameter ist der Pin
	; ADC-Wandlung durchführen
	; Eingangspin auswählen und Referenzspannung auf (A)VCC setzen (linksbündiges Ergebnis)
	LDI MTEMP1,(0<<REFS1) | (1<<REFS0) | (1<<ADLAR) | @0
	OUT ADMUX,MTEMP1
	; Wandlung starten
	SBI ADCSRA, ADSC
	; Polling
	SBIC ADCSRA, ADSC
	RJMP PC-1
.ENDMACRO


; ############## Makros für die Taster ##################

.MACRO IF_KEY; Parameter @0=ADC-Wert, @1=KEY-Wert, @2=Zu überspringende Befehle wenn True
	LDI MTEMP2,@0       ; Vergleichswert in MTEMP2 laden
	CPSE MTEMP1,MTEMP2  ; Vergleichen und bei Gleichheit nächsten Befehl auslassen (d.h. weiter mit LDI)...
	RJMP PC+3           ; ... sonst Rest des Makros überspringen
	LDI KEY,@1          ; KEY-Wert in KEY-Register schreiben
	RJMP PC+@2          ; Zum Ende springen (bzw. @2 Befehle überspringen)
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
	; So müssten die Werte sein, wenn der ASURO
        ; nicht so ein Schrott wäre ;D
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

; ######################################################################
; ######################################################################
; ############### ENDE DER MAKRODATEI ##################################
; ######################################################################
; ######################################################################

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
