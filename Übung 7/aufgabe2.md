# Übung 7

## Frage 2 (15 Punkte)

Warum ist folgender Code zum Inkrementieren des Z Pointers fehlerhaft (unabhängig von einer Schreib-/Leseoperation)? Die fehlerhaft implementierte Funktion lässt sich mit einem einzigen Assembler Befehl realisieren. Verwenden Sie diesen Befehl und korrigieren Sie den gegeben Code.
```
ldi r0,0
inc ZL
adc ZH,r0
```

### Lösung

Der Code ist fehlerhaft, da `INC` kein Carry-Flag setzt und `ADC` daher fälschlicherweise das Carry-Flag einer früheren Operation nutzt.

Korrekt wäre also:

```
ldi r0,1
add ZL,r0
ldi r0,0
adc ZH,r0
```
Allerdings lässt sich statt dieses Codes auch der dafür geeignetere Befehl `ADIW` nutzen:
```
adiw ZL,1
```
Dieser erhöht die 16-Bit-Zahl im Pointer-Registerpaar `Z` um 1 und benötigt dafür lediglich 2 Cycles. Er kommt ohne zusätzliche Register aus, ist doppelt so performant und benötigt mit 2 Byte nur ein Viertel des Speicherplatzes im Vergleich zum obigen Code.
