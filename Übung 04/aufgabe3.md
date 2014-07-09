# Übung 4
## Frage 3 (40 Punkte)
*Einzelaufgabe:* Hier bitte besonders auf Lesbarkeit achten!

In der Übung haben Sie das Gleitkommaformat 8-bit Minifloat kennengelernt. Die IEEE 754-Bezeichnung lautet (1.4.3.7)-Gleitkommazahl.
Erklären Sie kurz die Bedeutung der einzelnen Stellen der IEEE 754-Bezeichnung.
Geben Sie für die Dezimalzahlen `A = 2,75` und `B = 4,5` jeweils die Bits für Vorzeichen, rechnerischen ("wahren") Exponenten und Mantisse an.
Geben Sie für A und B die binäre Darstellung im Speicher an. (Denken Sie an den Bias des Exponenten)
Addieren Sie beide Zahlen in der (1.4.3.7)-Darstellung und konvertieren Sie das Ergebnis zurück ins Dezimalsystem. Was fällt am Ergebnis auf und warum ist das so?

### Lösung

#### Erklärung der Parameter

Parameter: `(s, r, p, B)`

| Parameter | Bedeutung                        |
| --------- | -------------------------------- |
| s         | Anzahl der Vorzeichenbits        |
| r         | Anzahl der Bits von Exponent e   |
| p         | Anzahl der Bits von Mantisse m   |
| B         | Bias (Offset von e)              |


Die Gleitkommazahl (1.4.3.7) hat demnach 1 Vorzeichenbit, 4 Exponentenbits und 3 Mantissenbits, sowie einen Bias von 7.

#### Bitangabe

Eine Zahl `x` wird dargestellt als `x = s * m * 2^e`.

| Zahl       | s         | e (dez.)      | m (dez., mit führender Null) |
| ---------- | --------- | ------------- | ---------------------------- |
| `A = 2,75` | `1` (+)   | `8` (`8-7=1`) | `1.375`                      |
| `B = 4,50` | `1` (+)   | `9` (`9-7=2`) | `1.125`                      |

| Zahl       | s (binär) | e (binär)     | m (binär)                    | Gesamt      |
| ---------- | --------- | ------------- | ---------------------------- | ----------- |
| `A = 2,75` | `0`       | `1000`        | `011`                        | `0100 0011` |
| `B = 4,50` | `0`       | `1001`        | `001`                        | `0100 1001` |


#### Addition

| Zahl       | s   | e      | hidden bit + m | Überhang |
| ---------- | --- | ------ | -------------- | -------- |
| `A = 2,75` | `0` | `1000` | `(1) 011`      |          |
| `B = 4,50` | `0` | `1001` | `(1) 001`      |          |

Zunächst müssen die Exponenten angeglichen werden. Da `9-8 = 1`, wird bei der Mantisse eine führende Null eingefügt.

| Zahl       | s   | e      | hidden bit + m | Überhang |
| ---------- | --- | ------ | -------------- | -------- |
| `A = 2,75` | `0` | `1001` | `(0) 101`      | `1`      |
| `B = 4,50` | `0` | `1001` | `(1) 001`      |          |

Dann kann werden die Mantissen addiert:

| Zahl       | s   | e      | hidden bit + m | Überhang |
| ---------- | --- | ------ | -------------- | -------- |
| `A = 2,75` | `0` | `1001` | `(0) 101`      | `1`      |
| `B = 4,50` | `0` | `1001` | `(1) 001`      |          |
| `C =  A+B` | `0` | `1001` | `(1) 110`      | `1`      |

Das Ergebnis lautet also:

| Zahl       | s   | e      | m     | Gesamt      |
| ---------- | --- | ------ | ----- | ----------- |
| `C =  A+B` | `0` | `1001` | `110` | `0100 1110` |

```
  1,75 * 2^(9-7)
= 1,75 * 2^2 
= 7,00
```

Hierbei fällt auf, dass das Ergebnis eigentlich `7,25` lauten müsste. Dies ergibt sich aus dem Überlauf der Mantisse (also dem Wegfallen der überhängenden `1`). Bei einer 4-Bit-langen Mantisse lautete diese `1101`, und dass Ergebnis `1,8125 * 2^2 = 7,25` wäre korrekt.
