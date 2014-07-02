.include "m8def.inc"


;Originale Aufgabenstellung

;In dieser Aufgabe wollen wir die Front-LED (D11) leuchten lassen, sobald ein Kollisionstaster 
;am ASURO gedr�ckt wird. Schreiben Sie ein Programm, welches in einer Schleife wiederholt den 
;Zustand der Taster abfragt, welche alle zusammen am Bit 4 vom Port C (PC4) des ATMega8 
;angeschlossen sind. W�hrend ein beliebiger Taster gedr�ckt ist, soll die Front-LED leuchten, 
;ansonsten soll sie ausgeschaltet werden. Damit die Tasterabfrage auch bei ge�ffneten Tastern 
;funktioniert, m�ssen Sie daf�r zuvor PC4 vom Port C als Eingang mit einem Pull-Up Widerstand 
;konfigurieren. Ein gedr�ckter Kollisionstaster zieht PC4 dann auf Null herunter; ist er ge�ffnet, 
;realisiert der Pull-Up die logische Eins (active-low).

;Wichtiger Hinweis: Dieser sehr einfache Test der Kollisionstaster erlaubt nicht genau zu sagen, 
;welcher Taster gedr�ckt wurde. Auch werden schaltungsbedingt h�chstwahrscheinlich nur Taster 
;auf der linken Seite des ASUROs funktionieren. Wir werden in den n�chsten Vorlesungen kennen 
;lernen, wie wir den Status der Taster auf bessere Art und Weise abfragen k�nnen.



;HAUPTPROGRAMM
main:

LDI R16, HIGH(RAMEND)	; Lade 8 h�chstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die h�chste Adresse des SRAM) in R16
OUT SPH, R16			; Schreibe diese h�herwertigen Bits in den h�herwertigen Teil des SP
LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

; Setze die LED Ausgaben
LDI R16,(1<<PD6)
OUT DDRD, R16

; PULL-UP f�r Schalter aktivieren
SBI PORTC, PC4

LOOP:
; Pr�fe die Ausgabe des Tasters
SBIC PINC, PC4
RJMP DEACTIVATE_LED

; aktiviere alle LEDs
SBI PORTD, PD6 ; aktiviere Front-LED
RJMP LOOP

; deaktiviere alle LEDs
DEACTIVATE_LED:
CBI PORTD, PD6 ; deaktiviere Front-LED
RJMP LOOP






