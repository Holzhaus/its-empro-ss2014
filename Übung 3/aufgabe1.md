```
Befehl	Übertrag?	Konstante?	Aufruf		Rechnung		Beschreibung
SUB					SUB Rd, Rr	Rd = Rd - Rr		Subtrahiert Register Rr von Register Rd und speichert das Ergebnis in Rd.
SUBI			0-255		SUBI Rd, K	Rd = Rd - K		Subtrahiert eine 8-Bit-Konstante von Register Rd und speichert das Ergebnis in Rd.
SBC	X				SBC Rd, Rr	Rd = Rd - Rr - Übertrag	Subtrahiert Register Rr und den Übertrag von Register Rd und speichert das Ergebnis in Rd.
SBCI	X		0-255		SBCI Rd, K	Rd = Rd - K - Übertrag	Subtrahiert eine 8-Bit-Konstante und den Übertrag von Register Rd und speichert das Ergebnis in Rd.
SBIW			0-63		SBIW Rdl, K	Rdh:Rdl = Rdh:Rdl - K	Subtrahiert eine 6-Bit-Konstante von einer 16-Bit-Zahl (Register Rdh und Rdl bilden zusammen die 16-Bit)
```
