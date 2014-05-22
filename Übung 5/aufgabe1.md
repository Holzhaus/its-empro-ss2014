# Übung 5
## Frage 1 (20 Punkte)
*Einzelaufgabe:* Gegeben seien zwei Eingabewerte A und B, die jeweils maximal 16-Bit Werte beinhalten. Wie lang (in Bits) kann das Ergebnis der Operation floor( (A+B)/4 ) maximal sein?

### Lösung:

*Antwort:* 15 Bits.

*Begründung:*
```
A:= ((2^16)-1) = 65535 (maximaler Wert für 16-Bit-Zahl)
b:= ((2^16)-1) = 65535
C = floor( (A+B)/4 )
  = 32767
  = ((2^15)-1)
```
