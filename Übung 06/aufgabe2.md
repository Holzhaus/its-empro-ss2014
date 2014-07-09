#Übung 6

## Frage 2 (10 Punkte )

*Einzelaufgabe:* Betrachten Sie nun die Befehle `CP`, `CPC` und `CPI`. Wozu werden die jeweiligen Befehle benötigt und was unterscheidet sie? Was muss bei der Verwendung von `CPI` beachtet werden?

### Lösung

| Befehl      | Bedeutung              | Operation     |
| ----------- | ---------------------- | ------------- |
| `CP Rd,Rr`  | Compare                | `Rd - Rr`     |
| `CPC Rd,Rr` | Compare with Carry     | `Rd - Rr - C` |
| `CPI Rd,K`  | Compare with Immediate | `Rd - K`      |

#### Der `CP`-Befehl

Mit dem Befehl `CP`lassen sich die Zahlen in 2 8-Bit-Registern vergleichen.
```
CP Rd,Rr
```

| Z-Flag | Carry    | Bedeutung
| ------ | -------- | ---------
| 1      | 0        | Die Zahlen sind gleich
| 0      | 1 oder 0 | Die Zahlen sind ungleich
| 0      | 1        | Die Zahlen sind ungleich und die Zahl in Register 1 (`Rd`) ist kleiner als die Zahl in Register 2 (`Rr`)
| 0      | 0        | Die Zahlen sind ungleich und die Zahl in Register 1 (`Rd`) ist größer als die Zahl in Register 2 (`Rr`)

#### Der `CPC`-Befehl

Der Befehl `CPC` ermöglich den Vergleich von 2 16-Bit-Zahlen. Will man die beiden 16-Bit Zahlen in den Registern `Rdh1:Rdl1` und `Rdh2:Rdl2` vergleichen, geschieht das mithilfe des folgenden Codes:
```
CP  Rdl1,Rdl2 ; Vergleiche untere Bytes
CPC Rdh1,Rdh2 ; Vergleiche obere Bytes
```

| Z-Flag | Carry    | Bedeutung
| ------ | -------- | ---------
| 1      | 0        | Die Zahlen sind gleich
| 0      | 1 oder 0 | Die Zahlen sind ungleich
| 0      | 1        | Die Zahlen sind ungleich und die Zahl in Registern (`Rdh1:Rdl1`) ist kleiner als die Zahl in den Registern (`Rdh2:Rdl2`)
| 0      | 0        | Die Zahlen sind ungleich und die Zahl in Registern (`Rdh1:Rdl1`) ist größer als die Zahl in den Registern (`Rdh2:Rdl2`)

#### Der `CPI`-Befehl

Der `CPI`-Befehl vergleich die Zahl in einem 8-Bit-Register mit einer Konstanten. Dabei ist zu beachten, dass nur die Register `R16` bis `R31` verwendet werden können.
```
CP Rd,K
```

| Z-Flag | Carry    | Bedeutung
| ------ | -------- | ---------
| 1      | 0        | Die Zahlen sind gleich
| 0      | 1 oder 0 | Die Zahlen sind ungleich
| 0      | 1        | Die Zahlen sind ungleich und die Zahl im Register (`Rd`) ist kleiner als die Konstante (`K`).
| 0      | 0        | Die Zahlen sind ungleich und die Zahl im Register (`Rd`) ist größer als die Konstante (`K`).
