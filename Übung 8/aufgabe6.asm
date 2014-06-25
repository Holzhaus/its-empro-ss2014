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
; Der ASURO soll in dieser Aufgabe als Diskobeleuchtung konfiguriert werden (wenn auch nur mit spärlichem Licht). Ihre Aufgabe ist es nun, die LEDs auf dem ASURO in der
; unten stehenden Reihenfolge nacheinander leuchten zu lassen. Dabei soll jede LED immer für 750ms aktiviert sein, bevor sie wieder abgeschaltet und mit der nächsten 
; LED fortgefahren wird. Im Übungsordner befindet sich die Vorlage flashing_asuro.asm, die Sie verwenden sollen und die Ihnen bereits eine Funktion WAIT zur Verzögerung 
; der Instruktionsausführung (in Millisekunden) zur Verfügung stellt.
; | Reihenfolge | Aktive LED      | Farbe | ASURO Bauteil im Schaltplan
; | ----------- | --------------- | ----- | ---------------------------
; | 1           | Status-LED      | rot   | D12
; | 2           | Linke Rück-LED  | -     | D15
; | 3           | Front-LED       | -     | D11
; | 4           | Status-LED      | grün  | D12
; | 5           | Rechte Rück-LED | -     | D16
; | 6           | Front-LED       | -     | D11
; 
; - Zur Ansteuerung der 4 LEDs (D11, D12, D15 und D16) müssen Sie den Schaltungsplan des ASURO verwenden (im ASURO-Handbuch im Blackboard, Seite 74). Suchen Sie die 
; entsprechenden vier LEDs heraus und geben Sie den jeweiligen Pin innerhalb Ihrer asm-datei an, an dem jede LED mit dem Mikrocontroller verbunden ist. Beachten Sie 
; dabei, dass die Status-LED D12 zwei Pins verwendet, um die LED jeweils in rot und grün (oder gelb, falls rot und grün gleichzeitig aktiv) leuchten lassen zu können.
; 
; | Port | Pin | Funktion
; | ---- | --- | --------
; | PB0  | 14  | Status LED grün
; | PD2  |  4  | Status LED rot
; | PD6  | 12  | Front LED
; | PC0  | 23  | Back LED links
; | PC1  | 24  | Back LED rechts

; - Fügen Sie in flashing_asuro.asm ein Hauptprogramm ein, welches gemäß der Reihenfolge in der obigen Tabelle die LEDs nacheinander blinken lässt (d.h. jeweils für 
; 750ms leuchten lässt und danach wieder ausschaltet). Eine LED leuchtet, sobald am entsprechenden Ausgabepin eine Eins anliegt. Das Programm soll eine Endlosschleife 
; beinhalten, so dass die LED-Schaltreihenfolge permanent wiederholt wird.
;
; *Hinweis:* Bedenken Sie, dass Sie zuerst in Ihrem Programm die LED-Ports als Ausgabeports definieren müssen, bevor Sie die LEDs an- und ausschalten könnten. Achten 
; Sie bitte darauf, wirklich ausschließlich diese LED-Pins für die Ausgabe zu konfigurieren, da im schlimmsten Fall fehlkonfigurierte I/O-Leitungen gegeneinander 
; treiben und dadurch Komponenten und der Asuro beschädigt werden können! Bitte laden Sie die modifizierte Version von flashing_asuro.asm hoch.

.MACRO chill
  LDI DELAY_MILLIS_H,HIGH(750) ; 750ms in DELAY_MILLIS-Register laden
  LDI DELAY_MILLIS_L,LOW(750)
  RCALL WAIT                   ; Wartesubroutine aufrufen
.ENDMACRO
.MACRO on_for_timeout ;(Port, Pin)
  SBI @0,@1 ; Pin einschalten
  chill     ; 750ms lang chillen
  CBI @0,@1 ; Pin wieder ausschalten
.ENDMACRO

; LED-Ports als Ausgabeports definieren (Pin in Register DDRx auf 1 setzen)
SBI DDRB,0
SBI DDRD,2
SBI DDRD,6
SBI DDRC,0
SBI DDRC,1
; Alle LEDs ausschalten (Pin in Register PORTx auf 0 setzen)
CBI PORTB,0
CBI PORTD,2
CBI PORTD,6
CBI PORTC,0
CBI PORTC,1

; Kurz chillen, bevor's abgeht (sonst sieht man das so schlecht)
chill
chill

the_fun:
; Hier geht's los
; StatusLEDRed
on_for_timeout PORTD,2
; BackLEDLeft
on_for_timeout PORTC,0
; FrontLED
on_for_timeout PORTD,6
; StatusLEDGreen
on_for_timeout PORTB,0
; BackLEDRight
on_for_timeout PORTC,1
; FrontLED
on_for_timeout PORTD,6
RJMP the_fun ; Endlosschleife
