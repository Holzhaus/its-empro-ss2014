# Übung 5
## Frage 1 (20 Punkte)
*Einzelaufgabe:* Gegeben seien zwei Eingabewerte A und B, die jeweils maximal 16-Bit Werte beinhalten. Wie lang (in Bits) kann das Ergebnis der Operation floor( (A+B)/4 ) maximal sein?

## Frage 2 (30 Punkte)
*Einzelaufgabe:* Sie sollen jetzt die Funktion floor( (A+B)/4 ) aus der vorangegangenen Aufgabe implementieren. Benutzen Sie hierfür die Vorlage floor.asm aus dem Übungsordner. Die Werte A und B befinden sich in den Registern R16-19, wobei A_high, A_low, B_high, B_low als Alias verwendet wird. Das Ergebnis der Operation soll in  A_high, A_low stehen. Die Suffixe _high, _low stehen dabei jeweils für das höherwertige bzw. das niederwertige Byte der 16-Bit Zahlen. Testen Sie Ihre Funktion bitte mit verschiedenen Werten. Laden Sie die *kompilierbare* .asm Datei hoch.

## Frage 3 (50 Punkte)
*Einzelaufgabe:* Betrachten Sie den Assembler-Code wasmacheich.asm im Übungsordner. Hier hat der Programmierer weder aussagekräftige Kommentare vergeben noch hilfreiche Namen für die Register gewählt. Ihre Aufgabe ist nun herauszufinden, was durch den Code berechnet wird. Beantworten Sie dazu die folgenden Fragen:

- Welche Operanden gehen in die Funktion ein? Benennen Sie die verwendeten Eingabe-Register und stellen Sie deren Werte in dezimaler Schreibweise dar.
- In welchen Registern befindet sich das Ergebnis der Berechnung?
- Geben Sie das Ergebnis der Berechnung sowohl für die gegebenen Werte (in dezimaler Schreibweise) als auch in allgemeiner Form an.


