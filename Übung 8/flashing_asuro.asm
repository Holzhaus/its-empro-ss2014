; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universit�t Bochum
; * Beispiel: ASURO "Diskobeleuchtung" in Assembler
; * (c) 2013 by Tim G�neysu
; *****************************************************

.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einf�gen 
.INCLUDE "m8def.inc" 		; Assemblerdirektive: Definitionen f�r den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.EQU	CYCLES_PER_MS = 8000
.EQU	HALF_SECOND	 = 500
.EQU	QUARTER_SECOND = 250

.DEF	DELAY_MILLIS_L = R24		;	Verz�gerung in Millisekunden (16-Bit)
.DEF	DELAY_MILLIS_H = R25		;	Verz�gerung in Millisekunden (16-Bit)

.CSEG						; Assemblerdirektive: Beginn eines Codesegments

; ############## Einsprungsvektoren ##################
.org 0x000
   RJMP MAIN			; Springe zum Hauptprogramm
  
; ############## UNTERFUNKTION WAIT ##################
; besch�ftigt den Prozessor f�r die Anzahl Millisekunden, die im 16-bit Register DELAY_MILLIS (R25:R24) gespeichert wurden
WAIT: 
		PUSH R26						; Register R26 retten
		PUSH R27						; Register R27 retten
OUTER:	LDI  R27, HIGH(CYCLES_PER_MS)	; Lade h�herwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenz�hler
		LDI  R26, LOW(CYCLES_PER_MS)	; Lade niederwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenz�hler
INNER:	SBIW R26, 4						; Subtrahiere 4 vom Zyklenz�hler (Anzahl Zyklen, die SBIW und BRNE ben�tigen)
		BRNE INNER						; Wiederhole so oft, bis Zyklenz�hler Null ist
		SBIW DELAY_MILLIS_L, 1			; Subtrahiere 1 vom Millisekundenz�hler
		BRNE OUTER						; Wiederhole so lange, bis Millisekundenz�hler Null
		POP R27							; Register R27 wiederherstellen
		POP R26							; Register R26 wiederherstellen
		RET


; ############## HAUPTPROGRAMM ##################
MAIN: 						; Sprungmarke zum Hauptprogramm

		; WICHTIG: Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
		LDI R16, HIGH(RAMEND)	; Lade 8 h�chstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die h�chste Adresse des SRAM) in R16
		OUT SPH, R16			; Schreibe diese h�herwertigen Bits in den h�herwertigen Teil des SP
		LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
		OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

; #### Bitte hier Ihr Hauptprogramm einf�gen  #####


END:		RJMP END		; Endlosschleife