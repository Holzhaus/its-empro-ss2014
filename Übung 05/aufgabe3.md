# Übung 5
## Frage 3 (50 Punkte)
*Einzelaufgabe:* Betrachten Sie den Assembler-Code wasmacheich.asm im Übungsordner. Hier hat der Programmierer weder
aussagekräftige Kommentare vergeben noch hilfreiche Namen für die Register gewählt. Ihre Aufgabe ist nun herauszufinden,
was durch den Code berechnet wird. Beantworten Sie dazu die folgenden Fragen:

- Welche Operanden gehen in die Funktion ein? Benennen Sie die verwendeten Eingabe-Register und stellen Sie deren Werte in dezimaler Schreibweise dar.
- In welchen Registern befindet sich das Ergebnis der Berechnung?
- Geben Sie das Ergebnis der Berechnung sowohl für die gegebenen Werte (in dezimaler Schreibweise) als auch in allgemeiner Form an.

### Lösung

#### Kommentierter Quellcode

```Assembly
.nolist        				; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfuegen 
.include "m8def.inc" 		; Assemblerdirektive: Definitionen fuer den ATMega8, z.B. I/O Ports, Registernamen, etc.
.list						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

main:
; In diesem Programm sind leider die Kommentare und eine geeignete Namesgebung der Register vergessen worden. 
; Welche Funktion berechnet dieses Programm? 
; Stellen Sie die einzelnen Operanden in dezimaler Schreibweise dar! 
; Wo befindet sich und was ist das Ergebnis?

ldi r16, 012		; Lade die Zahl '12' in das Register 16
ldi r17, 0xFC       ; Lade die Zahl '252' in das Register 17
ldi r18, 0b01011000 ; Lade die Zahl '88' in das Register 18
mul r16, r17        ; Multipliziere 12 (Register 16) mit 252 (Register 17) und speichere das Ergebnis (3024) in (Register 1:Register 0) (r1 = 11, r0 = 208)
add r0, r18		    ; Addiere 208 mit 88 (=296 bzw. 100101000) und speichere das Ergebnis in Register 0. Da das Ergebnis zu lang ist, wird das Carry-Flag gesetzt und der Wert ohne den Übertrag (=40 bzw. 00101000) gespeichert
clr r19		    	; Register 19 auf 0 setzen
adc r1,r19	    	; Addiere Register 1 und Register 19 und Carry und speichere das Ergebnis in Register 1 ( 11 + 0 + 1 = 12).
lsr r1              ; Rightshift von Register 1. Das MSB wird auf 0 gesetzt, das LSB wird ins Carry geschoben. (r1 = 6)
ror r0              ; Rightshift von Register 0. Das MSB wird auf Carry gesetzt. (r2 = 20)
lsr r1              ; Rightshift von Register 1. Das MSB wird auf 0 gesetzt, das LSB wird ins Carry geschoben. (r1 = 3)
ror r0			    ; Rightshift von Register 0. Das MSB wird auf Carry gesetzt. (r2 = 10)
; Endergebnis r1:r0 = 00000011:00001010 = 778

; Endlosschleife
done: rjmp done
```

#### Programm

| Befehl                | r1:r0                      | r16              | r17              | r18              | r19              | Bedeutung |
| --------------------- | -------------------------- | ---------------- | ---------------- | ---------------- | ---------------- | -------- 
| `ldi r16, 012`        | `????????:????????`        | `00001100`  (12) | `????????`       | `????????`       | `????????`       | Lade die Zahl '12' in das Register 16
| `ldi r17, 0xFC`       | `????????:????????`        | `00001100`  (12) | `11111100` (252) | `????????`       | `????????`       | Lade die Zahl '252' in das Register 17
| `ldi r18, 0b01011000` | `????????:????????`        | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `????????`       | Lade die Zahl '88' in das Register 18
| `mul r16, r17`        | `00001011:11010000` (3024) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `????????`       | Multipliziere 12 (Register 16) mit 252 (Register 17) und speichere das Ergebnis (3024) in (Register 1:Register 0) (r1 = 11, r0 = 208)
| `add r0, r18`         | `00001011:00101000` (2856) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `????????`       | Addiere r0 mit r18 (=296) und speichere das Ergebnis in Register 0. Da das Ergebnis zu lang ist, wird das Carry-Flag gesetzt und der Wert ohne den Übertrag (=40) gespeichert
| `clr r19`             | `00001011:00101000` (2856) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `00000000`   (0) | Register 19 auf 0 setzen
| `adc r1,r19`          | `00001100:00101000` (3112) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `00000000`   (0) | Addiere Register 1 und Register 19 und Carry und speichere das Ergebnis in Register 1 ( 11 + 0 + 1 = 12).
| `lsr r1`              | `00000110:00101000` (1576) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `00000000`   (0) | Rightshift von Register 1. Das MSB wird auf 0 gesetzt, das LSB wird ins Carry geschoben. (r1 = 6)
| `ror r0`              | `00000110:00010100` (1556) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `00000000`   (0) | Rightshift von Register 0. Das MSB wird auf Carry gesetzt. (r2 = 20)
| `lsr r1`              | `00000011:00010100`  (788) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `00000000`   (0) | Rightshift von Register 1. Das MSB wird auf 0 gesetzt, das LSB wird | ins Carry geschoben. (r1 = 3)
| `ror r0`              | `00000011:00001010`  (778) | `00001100`  (12) | `11111100` (252) | `01011000`  (88) | `00000000`   (0) | Rightshift von Register 0. Das MSB wird auf Carry gesetzt. (r2 = 10)

Das Ergebnis befindet sich in den Register **r1:r0**.

#### Allgemeine Rechnung

##### Als Grafik

![Rechnung](aufgabe3-calc.png)

[Link zur Grafik](http://latex.codecogs.com/png.latex?%5Cdpi%7B120%7D%20%5Cbg_white%20%5Clarge%20%5Cbegin%7Balign*%7D%20f%28n%2Cm%29%20%26%3D%20%5Cbegin%7Bcases%7D%200%20%26%20%5Cmbox%7Bwenn%20%7D%20n&plus;m%20%3C%20256%5C%5C%20256%20%26%20%5Cmbox%7Bwenn%20%7D%20n&plus;m%20%5Cgeq%20256%20%5Cend%7Bcases%7D%5C%5C%20x%20%26%3D%20%5Cleft%20%5Clfloor%5Cfrac%7B%5Cleft%5Clfloor%5Cfrac%7Ba%20%5Ccdot%20b&plus;c-f%28a%5Ccdot%20b%2Cc%29&plus;f%28a%5Ccdot%20b%2Cc%29%7D%7B2%7D%20%5Cright%5Crfloor%7D%7B2%7D%20%5Cright%5Crfloor%5C%5C%20%26%3D%20%5Cleft%5Clfloor%5Cfrac%7Ba%20%5Ccdot%20b&plus;c%7D%7B4%7D%20%5Cright%5Crfloor%5C%5C%20%5Ctext%7Bmit%7D%5C%5C%20a%20%26%3D%20%5Cmathtt%7Br16%7D%5Ctext%7B%20%28Register%2016%29%7D%5C%5C%20b%20%26%3D%20%5Cmathtt%7Br17%7D%5Ctext%7B%20%28Register%2017%29%7D%5C%5C%20c%20%26%3D%20%5Cmathtt%7Br18%7D%5Ctext%7B%20%28Register%2018%29%7D%5C%5C%20%5Cend%7Balign*%7D)
##### Als Text
```
A = r16
B = r17
C = r18
f(n,m) = { 0     wenn n+m < 256
         { 256   wenn n+m >= 256
x = floor(floor((A*B+C-f(A*B,C)+f(A*B,C))/2)/2)
  = floor(floor((A*B+C)/2)/2)
  = floor((A*B+C)/4)
```
