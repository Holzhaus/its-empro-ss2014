# Übung 6
## Frage 1 (10 Punkte )

*Einzelaufgabe:* Vergleichen Sie die Befehle `JMP` und `RJMP`. Worin unterscheiden sie sich? Welcher der beiden Befehle ist im ATmega8 nicht enthalten und warum? Die Beschreibung der Befehle finden Sie wie immer im AVR Instruction Set.

### Lösung

- `JMP` führt einen absoluten Sprung zu einer beliebigen Adresse im Programmspeicher (Flash) durch und dauert 3 Taktzyklen.
- `RJMP` führt einen relativen Sprung zu einer Adresse im Programmspeicher (Flash) durch und dauert 2 Taktzyklen. Die Adresse darf maximal -2K+1 und +2K Worte entfernt sein.

Da der ATmega8 aber einen lediglich 4K Worte umfassenden Programmspeicher besitzt, ist der mit 3 Taktzyklen langsamere `JMP`-Befehl überflüssig, da das Anspringen jeder Addresse von jedem beliebligen Punkt aus auch mit dem nur 2 Taktzyklen dauernden `RJMP`-Befehl möglich ist.

Dies liegt daran, dass es keine negativen Addressen gibt. Ist das Programm also zur Zeit beim Wort 0 und will zum Wort 3K springen, kann RJMP zwar aufgrund der Limitierung nicht 3K worte vorwärts springen, jedoch 1K Worte rückwärts.
Damit wäre das Programm rechnerisch an der Stelle `0-1K mod 4K = -1K mod 4K = 3K`.
