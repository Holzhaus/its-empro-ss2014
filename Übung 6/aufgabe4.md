# Übung 6

## Frage 4 (30 Punkte)

*Einzelaufgabe:* Im Folgenden finden Sie eine Assemblerfunktion für den AVR, die in Abhängigkeit von drei Parametern bestimmte Operationen ausführt. Die übergebenen Parameter sind in drei 8-Bit Registern (`OP1`, `OP2`, `CMD`) abgelegt.

```Assembly
UNKNOWN_FUNCTION:
START:
CPI  CMD,$01
BRLO  CMD1
BREQ  CMD2
RJMP  CMD3
CMD1:
Loop:
CPI  OP2,0
BREQ  ENDE
LSR  OP1
DEC  OP2
RJMP  Loop
RJMP  ENDE
CMD2:
ADD  OP1,OP2
RJMP  ENDE
CMD3:
SUB  OP1,OP2
ENDE:
RET
```

1. Welche Funktion führt der Code in Abhängigkeit von welchem Parameter aus?
2. Geben Sie für jede mögliche Funktion die Anzahl der Takte an, die zwischen den Sprungmarken `START` und `ENDE` (inkl. `RET`) verbraucht werden. Sie sollen Abhängigkeiten von Übergabewerten berücksichtigen, also z.B. ( Operation `XY`: 3 Takte + (4 x OP2) Takte ). Wie groß ist die maximale Laufzeit?
3. Eine der Funktionen kann einen unnötig großen Parameter übergeben bekommen, wodurch die Laufzeit unnötig verlängert wird. Welche Funktion und welcher Parameter ist gemeint? Warum ist der Parameter unnötig groß? Erweitern Sie das Programm so, dass ein zu großer Parameter erkannt wird und trotzdem das richtige Ergebnis (schneller) zurückgeliefert wird. Geben Sie den neuen Code zwischen den Labeln `START:` und `ENDE:` als Teil Ihrer Antwort im Textfeld mit ab!

### Lösung

![Flowchart](aufgabe4-flowchart.png)

| Bedingung | Operation                       | Taktzyklen
| --------- | ------------------------------- | ----------
| `CMD < 1` | `OP1 = OP1 / (OP2*2) ; OP2 = 0` | `10+(6*OP2) = 1+2+1+((1+1+1+2+1)*OP2)+2+4`
| `CMD = 1` | `OP1 = OP1 + OP2`               | `11         = 1+1+2+1+2+4`
| `CMD > 1` | `OP1 = OP1 - OP2`               | `10         = 1+1+1+2+1+4`

Die maximale Laufzeit ist `10*(6*255) = 10*1530 = 15300` Takte, da OP2<sub>max</sub> = 255.
