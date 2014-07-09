1. Global Interrupt Enable/Disable Flag (I)

   Schaltet Interrupts global an oder aus. Werden die Interrupts ausgeschaltet, werden diese ausgeführt, sobald das Flag wieder gesetzt werden und gehen nicht verloren (es sei denn, sie werden vor dem Einschalten überschrieben)

2. Transfer Bit	(T)

   Kein Flag, sondern ein globaler 1-Bit-Speicher, der nur über die Befehle BLD, BST, SET und CLT gesteuert wird.

3. Half Carry Flag (H)

   Zeigt einen Übertrag zwischen Bit 3 und 4 an, was in Sonderfällen (2 parallele 4-Bit-Berechnungen) Sinn machen kann.

4. N XOR V (S)

   Zeigt an, ob die Zahl vorzeichenbehaftet ist
5. Zweierkomplement Overflow Indicator (V)

   Wird gesetzt, wenn die Zahl vorzeichenbehaftet ist und einen Überlauf erzeigt.

6. Negativ-Vorzeichen-Flag (N)

   Gibt an, ob das Most Significant Bit gesetzt ist (bei vorzeichenbehaftenteten Zahlen ist das eine negative Zahl).
7. Zero Flag (Z)

   Zeigt an, ob das Byte-Ergebnis einer Rechnung 0 ist, wird auch in Kombination mit dem Carry-Flag genutzt.
8. Carry Flag (C)

   Zeigt an, ob das Ergebnis einer Rechnung einen Überlauf verursacht (also ob das Ergebnis größer als 255 ist)

