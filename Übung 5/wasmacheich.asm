.nolist						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfuegen 
.include "m8def.inc" 		; Assemblerdirektive: Definitionen fuer den ATMega8, z.B. I/O Ports, Registernamen, etc.
.list						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

main:
; In diesem Programm sind leider die Kommentare und eine geeignete Namesgebung der Register vergessen worden. 
; Welche Funktion berechnet dieses Programm? 
; Stellen Sie die einzelnen Operanden in dezimaler Schreibweise dar! 
; Wo befindet sich und was ist das Ergebnis?

ldi r16, 012
ldi r17, 0xFC
ldi r18, 0b01011000
mul r16, r17
add r0, r18
clr r19
adc r1,r19
lsr r1
ror r0
lsr r1
ror r0

; Endlosschleife
done: rjmp done
