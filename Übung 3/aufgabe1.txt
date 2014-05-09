SUB: subtrahiert ohne carry. Funktioniert -> SUB ard1, ard2. Dabei wird gerechnet ard1 = ard1-ard2.

SUBI: subtrahiert mit Konstante. Funktioniert -> SUBI ard1, k. Dabei wird gerechnet ard1 = ard1-k.

SBC: subtrahiert mit carry. Funktioniert -> SBC ard1, ard2. Dabei wird gerechnet ard1 = ard1 -ard2 - carry.

SBCI: subtrahiert mit Konstante und carry. Funktioniert -> SBCI ard1, k. Dabei wird gerechnet ard1 = ard1 - k - carry.

SBIW: subtrahiert einen Wert (0-63) von einem Registerpaar und speichert das Ergebnis in diesen Registern. Dabei wird gerechnet R2:R1 = R2:R1-Wert.