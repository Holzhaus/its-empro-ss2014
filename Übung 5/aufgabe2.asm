; # Übung 5
; ## Frage 2 (30 Punkte)
; *Einzelaufgabe:* Sie sollen jetzt die Funktion floor( (A+B)/4 ) aus der vorangegangenen
; Aufgabe implementieren. Benutzen Sie hierfür die Vorlage floor.asm aus dem Übungsordner.
; Die Werte A und B befinden sich in den Registern R16-19, wobei A_high, A_low, B_high,
; B_low als Alias verwendet wird. Das Ergebnis der Operation soll in  A_high, A_low stehen.
; Die Suffixe _high, _low stehen dabei jeweils für das höherwertige bzw. das niederwertige
; Byte der 16-Bit Zahlen. Testen Sie Ihre Funktion bitte mit verschiedenen Werten. Laden
; Sie die *kompilierbare* .asm Datei hoch.

.nolist						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfuegen 
.include "m8def.inc" 				; Assemblerdirektive: Definitionen fuer den ATMega8, z.B. I/O Ports, Registernamen, etc.
.list						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

; Alias Definition fuer bessere Lesbarkeit
.def A_high	= R19
.def A_low	= R18
.def B_high	= R17
.def B_low	= R16

main:
; A und B werden mit beliebigen 16-Bit Werten geladen.
; Aendern Sie die Zahlen ggf. ab um Ihr Programm auf andere Eingaben zu testen!

; Setze A auf 0xAB04 (=43780)
ldi A_high, 0xAB
ldi A_low, 0x04
; Setze B auf 0x0815 (=2069)
ldi B_high, 0x08
ldi B_low, 0x15

; *ToDo*
; Berechnen Sie nun die Funktion floor((A+B)/4) moeglichst effizient, das Ergebnis soll sich in A_high:A_low befinden.
; Hinweis: die gewuenschte Funktion laesst sich mit insgesamt 6 Befehlszeilen implementieren ohne ein weiteres Register in Anspruch nehmen zu muessen.
; Versuchen Sie moeglichst nah an diese Vorgabe zu gelangen.

calculate:
;
; A und B addieren
add  A_low, B_low       ; Normale Addition für niedrige Bits
adc  A_high, B_high     ; Addition mit Carry für hohe Bits
; Werte durch 2 teilen (mittels Leftshift)
ror A_high		; Verwende ROR, um Carry von vorhergehender Addition zu beachten
ror A_low
; Das Ergebnis nochmal durch 2 teilen
lsr A_high
ror A_low
; Fertig

; Ende - Endlosschleife
done: rjmp done
