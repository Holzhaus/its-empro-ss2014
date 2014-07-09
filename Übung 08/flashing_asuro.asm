; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Beispiel: ASURO "Diskobeleuchtung" in Assembler
; * (c) 2013 by Tim Güneysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.EQU	CYCLES_PER_MS = 8000
.EQU	HALF_SECOND	 = 500
.EQU	QUARTER_SECOND = 250

.DEF	DELAY_MILLIS_L = R24		;	Verzögerung in Millisekunden (16-Bit)
.DEF	DELAY_MILLIS_H = R25		;	Verzögerung in Millisekunden (16-Bit)

.CSEG						; Assemblerdirektive: Beginn eines Codesegments

; ############## Einsprungsvektoren ##################
.org 0x000
   RJMP MAIN			; Springe zum Hauptprogramm
  
; ############## UNTERFUNKTION WAIT ##################
; beschäftigt den Prozessor für die Anzahl Millisekunden, die im 16-bit Register DELAY_MILLIS (R25:R24) gespeichert wurden
WAIT: 
		PUSH R26						; Register R26 retten
		PUSH R27						; Register R27 retten
OUTER:	LDI  R27, HIGH(CYCLES_PER_MS)	; Lade höherwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenzähler
		LDI  R26, LOW(CYCLES_PER_MS)	; Lade niederwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenzähler
INNER:	SBIW R26, 4						; Subtrahiere 4 vom Zyklenzähler (Anzahl Zyklen, die SBIW und BRNE benötigen)
		BRNE INNER						; Wiederhole so oft, bis Zyklenzähler Null ist
		SBIW DELAY_MILLIS_L, 1			; Subtrahiere 1 vom Millisekundenzähler
		BRNE OUTER						; Wiederhole so lange, bis Millisekundenzähler Null
		POP R27							; Register R27 wiederherstellen
		POP R26							; Register R26 wiederherstellen
		RET


; ############## HAUPTPROGRAMM ##################
MAIN: 						; Sprungmarke zum Hauptprogramm

		; WICHTIG: Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
		LDI R16, HIGH(RAMEND)	; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
		OUT SPH, R16			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
		LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
		OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

; #### Bitte hier Ihr Hauptprogramm einfügen  #####


END:		RJMP END		; Endlosschleife