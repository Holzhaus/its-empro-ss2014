.NOLIST ; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen
.INCLUDE "m8def.inc" ; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST ; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.DEF XIN=R16
.DEF STATE_REG=R17



;Zustandsübergangsdiagram
;Beispiel: Wenn x=0 wird aus dem Zustand s0 in den Zustand s1 gesprungen
;Beispiel: Wenn x=1 wird aus dem Zustand s2 in den Zustand s0 gesprungen
;
;         x=0          x=1
;  [s0] ------>[s1] --------> [s2]
;  <  <           |             |
;  |  |           |             |
;  |   ------------	            |
;  |        x=0                 |
;  |		             x=1    |
;  ------------------------------

clr XIN
clr STATE_REG

BEGIN:

; Statemachine hängt vom Wert X ab. Bitte in der Simulation manipulieren
; X ist entweder 0 oder 1

; Hier gibt es effizientere Möglichkeiten die Abfrage zu realisieren.
CPI STATE_REG, 0
BREQ GOTO_STATE0
CPI STATE_REG, 1
BREQ GOTO_STATE1
CPI STATE_REG, 2
BREQ GOTO_STATE2


; #### State 0 ####
GOTO_STATE0:
CPI XIN, 0
BRNE FINISHED
LDI STATE_REG, 1 ; Springe zu Zustand 1
RJMP FINISHED ; springe zum Ende

; #### State 1 ####
GOTO_STATE1:
CPI XIN, 0
BREQ S1_SET0

; Durchfallen in SET1 (x=1)
LDI STATE_REG, 2 ; Springe zu Zustand 2
RJMP FINISHED ; springe zum Ende

; Setze State auf 0 (x=0)
S1_SET0:
LDI STATE_REG, 0 ; Springe zu Zustand 1
RJMP FINISHED ; springe zum Ende

; #### State 2 ####
GOTO_STATE2:
CPI XIN, 0
BREQ FINISHED  ;Nicht 1

; Setze State auf 0 (x=1)
LDI STATE_REG, 0 ; Springe zu Zustand 1
RJMP FINISHED ; springe zum Ende


FINISHED:


rjmp BEGIN
