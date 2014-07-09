.include "m8def.inc"


;Originale Aufgabenstellung

;In dieser Aufgabe wollen wir die Front-LED (D11) leuchten lassen, sobald ein Kollisionstaster 
;am ASURO gedrückt wird. Schreiben Sie ein Programm, welches in einer Schleife wiederholt den 
;Zustand der Taster abfragt, welche alle zusammen am Bit 4 vom Port C (PC4) des ATMega8 
;angeschlossen sind. Während ein beliebiger Taster gedrückt ist, soll die Front-LED leuchten, 
;ansonsten soll sie ausgeschaltet werden. Damit die Tasterabfrage auch bei geöffneten Tastern 
;funktioniert, müssen Sie dafür zuvor PC4 vom Port C als Eingang mit einem Pull-Up Widerstand 
;konfigurieren. Ein gedrückter Kollisionstaster zieht PC4 dann auf Null herunter; ist er geöffnet, 
;realisiert der Pull-Up die logische Eins (active-low).

;Wichtiger Hinweis: Dieser sehr einfache Test der Kollisionstaster erlaubt nicht genau zu sagen, 
;welcher Taster gedrückt wurde. Auch werden schaltungsbedingt höchstwahrscheinlich nur Taster 
;auf der linken Seite des ASUROs funktionieren. Wir werden in den nächsten Vorlesungen kennen 
;lernen, wie wir den Status der Taster auf bessere Art und Weise abfragen können.



;HAUPTPROGRAMM
main:

LDI R16, HIGH(RAMEND)	; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
OUT SPH, R16			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

; Setze die LED Ausgaben
LDI R16,(1<<PD6)
OUT DDRD, R16

; PULL-UP für Schalter aktivieren
SBI PORTC, PC4

LOOP:
; Prüfe die Ausgabe des Tasters
SBIC PINC, PC4
RJMP DEACTIVATE_LED

; aktiviere alle LEDs
SBI PORTD, PD6 ; aktiviere Front-LED
RJMP LOOP

; deaktiviere alle LEDs
DEACTIVATE_LED:
CBI PORTD, PD6 ; deaktiviere Front-LED
RJMP LOOP






