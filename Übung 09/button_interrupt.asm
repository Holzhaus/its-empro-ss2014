; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universit�t Bochum
; * Beispiel: Blinkende LEDs mit nebenl�ufiger Tasterpr�fung (steuert Front-LED an)
; * (c) 2009 by Tim G�neysu
; *****************************************************


; *****************************************************
;Beantworten Sie hier den Aufgabenteil a)
;
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einf�gen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen f�r den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.EQU	CYCLES_PER_MS = 8000		; Konstanten f�r die WAIT-Funktion
.EQU	HALF_SECOND	 = 500
.EQU	QUARTER_SECOND = 250

.DEF	DELAY_MILLIS_L = R24		;	niederwertiges Byte der Verz�gerung in Millisekunden (16-Bit)
.DEF	DELAY_MILLIS_H = R25		;	h�herwertiges Byte der Verz�gerung in Millisekunden (16-Bit)

; Assemblerdirektive: Beginn eines Codesegments
.CSEG

; erster Einsprungsvektor verweist auf die Hauptfunktion
.ORG 0x000						
		RJMP MAIN				; Springe zum Hauptprogramm

; ############## UNTERFUNKTION WAIT ##################
; besch�ftigt den Prozessor f�r die Anzahl Millisekunden, die im 16-bit Register DELAY_MILLIS (R25:R24) gespeichert wurden
WAIT: 
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

; ############## Hauptprogramm ##################
MAIN:					

		; WICHTIG: Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
		LDI R16, HIGH(RAMEND)	; Lade 8 h�chstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die h�chste Adresse des SRAM) in R16
		OUT SPH, R16			; Schreibe diese h�herwertigen Bits in den h�herwertigen Teil des SP
		LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
		OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

		; Setze die Ausgabeports f�r die Status-LED und die Front-LED
		LDI R16, (1<<PB0)
		OUT DDRB, R16		
		LDI R16, (1<<PD2) | (1<<PD6)
		OUT DDRD, R16
						
LOOP:	
		; Aktiviere die rote Status-LED f�r eine Sekunde
		SBI PORTD, PD2
		LDI DELAY_MILLIS_L, LOW(HALF_SECOND)
		LDI DELAY_MILLIS_H, HIGH(HALF_SECOND)
		RCALL WAIT
		LDI DELAY_MILLIS_L, LOW(HALF_SECOND)
		LDI DELAY_MILLIS_H, HIGH(HALF_SECOND)
		RCALL WAIT
		CBI PORTD, PD2

		; Aktiviere die gelbe Status-LED f�r eine viertel Sekunde
		SBI PORTD, PD2
		SBI PORTB, PB0
		LDI DELAY_MILLIS_L, LOW(QUARTER_SECOND)
		LDI DELAY_MILLIS_H, HIGH(QUARTER_SECOND)
		RCALL WAIT
		CBI PORTD, PD2
		CBI PORTB, PB0

		; Aktiviere die gr�ne Status-LED f�r eine halbe Sekunde
		SBI PORTB, PB0
		LDI DELAY_MILLIS_L, LOW(HALF_SECOND)
		LDI DELAY_MILLIS_H, HIGH(HALF_SECOND)
		RCALL WAIT
		CBI PORTB, PB0
		
		RJMP LOOP				; Endlosschleife


