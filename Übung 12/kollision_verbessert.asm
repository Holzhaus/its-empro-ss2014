; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universit�t Bochum
; * �bung: Photosensoren und BackLED
; * (c) 2009 by Tim G�neysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einf�gen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen f�r den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen


; ##############  GLOBALE DEFINITIONEN  #####################
.DEF 	TEMP1=R16



; ############## Einsprungsvektoren ##################
.ORG 0x000
   	RJMP RESET			; Springe zur Initialisierungsroutine

.org INT1addr
   rjmp KOLLISION   ;Ext Interrupt Vector Address


; ##############  EXTERNE MACROS F�R DEN ASURO  #####################
.INCLUDE "asuro_macros_kollision.inc"

KOLLISION:


	; Nach dem Zur�cksetzen von PD3 ca 20 ms warten.


	; Interrupt Flag zur�cksetzen. Ansonsten wird 
	; sonst sofort nach RETI wieder ein Interrupt ausgel��t
	ldi r16, (1<<INTF1)
	out GIFR, r16

	reti

; ############## SYSTEMRESET ##################	
RESET:					

; Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
	LDI TEMP1, HIGH(RAMEND)	; Lade 8 h�chstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die h�chste Adresse des SRAM) in R16
	OUT SPH, TEMP1			; Schreibe diese h�herwertigen Bits in den h�herwertigen Teil des SP
	LDI TEMP1, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
	OUT SPL, TEMP1			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

	; Setze die Ausgabeports f�r die Status-LED und die Front-LED und die Back-LEDs
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
	


	; Ggf. zur Verbesserung der ADC-Messung und zum Strom sparen, den Prozessor in den Idle Modus legen
	; Hinweis: Im ADC Noise Reduction Modus ist ein Aufwachen mit Hilfe von INT1/INT2 
	; bei Flankenwechsel nicht m�glich. Daher nur den Idle Mode verwenden (SM0=0,SM1=0,SM2=0)
	; Sleep enable setzen
	LDI TEMP1, MCUCR
	ORI TEMP1, (1<<SE)
	OUT MCUCR, TEMP1
	
	; aktiviere globale Interrupts
	SEI


; ############## Hauptprogramm ##################
MAIN:	
;hier das globale Register KEY auswerten und LEDs schalten

	
;SLEEP
RJMP MAIN				; Endlosschleife, damit der Prozessor nicht Restbefehle aus dem Flash (oder einen Reset) ausf�hrt

