# Übung 4
## Frage 2 (30 Punkte)
*Einzelaufgabe:* Gegeben seien die Zahlen `A = 207` und `B = -36`. Geben Sie jeweils die Bitdarstellungen der Zahlen A und B in den folgenden Zahlenformaten mit jeweils 8-Bit Präzision an. Beachten Sie dabei, dass das MSB immer links und das LSB jeweils rechts stehen soll! Geben Sie an, falls A oder B in einem Format gar nicht oder nicht mit 8-Bit darstellbar sein sollte.
- Vorzeichenlose ganze Zahl
- Vorzeichenbehaftete ganze Zahl
- Ganze Zahl im Einerkomplement
- Ganze Zahl im Zweierkomplement

### Lösung

#### Vorzeichenlose ganze Zahl
```
A = 11001111
B = n/A
```

`B` ist ist nicht darstellbar, da vorzeichenlose Zahlen nunmal keine Vorzeichen haben - `36` wäre also darstellbar, `-36` aber nicht.

#### Vorzeichenbehaftete ganze Zahl
```
A = n/A
B = 10100100
```
`A` ist nicht darstellbar, da es außerhalb des darstellbaren Wertebereichs liegt (`A > 127`).

#### Ganze Zahl im Einerkomplement
```
A = n/A
B = 11011011
```
`A` ist nicht darstellbar, da es außerhalb des darstellbaren Wertebereichs liegt (`A > 127`).


#### Ganze Zahl im Zweierkomplement
```
A = n/A
B = 11011100
```
`A` ist nicht darstellbar, da es außerhalb des darstellbaren Wertebereichs liegt. (`A > 127`)

