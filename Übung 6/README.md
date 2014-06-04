# Übung 6
## Frage 1 (10 Punkte )

*Einzelaufgabe:* Vergleichen Sie die Befehle `JMP` und `RJMP`. Worin unterscheiden sie sich? Welcher der beiden Befehle ist im ATmega8 nicht enthalten und warum? Die Beschreibung der Befehle finden Sie wie immer im AVR Instruction Set.

## Frage 2 (10 Punkte )

*Einzelaufgabe:* Betrachten Sie nun die Befehle `CP`, `CPC` und `CPI`. Wozu werden die jeweiligen Befehle benötigt und was unterscheidet sie? Was muss bei der Verwendung von `CPI` beachtet werden?

## Frage 3 (20 Punkte)

*Einzelaufgabe:* In der letzten Übung haben Sie dem Asuro Kommandos geschickt, auf die entsprechend reagiert wurde. In dieser Übung sollen Sie die Auswerte-Routine für die Richtungsangaben in Assembler nachbauen. Das empfangene Zeichen befindet sich in Register `R18`. Schreiben Sie eine Funktion, die `R18` auswertet und das Ergebnis in Register `R20` speichert. Gegeben sei dazu folgender Pseudo-Code:
```C
if (R18=='V')
   R20=8;
else if (R18=='Z')
   R20=4;
else if (R18=='L')
   R20=2;
else if (R18=='R')
   R20=1;
else
   R20=0;
```

Erweitern Sie die Vorlage [if_elseif_else.asm](if_elseif_else\(korrigiert\).asm) um die angegebene Funktionalität. Testen Sie Ihren Code und laden Sie die *kompilierbare* Lösung hoch.

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


## Frage 5 (30 Punkte)

*Einzelaufgabe:* Im Folgenden soll der Unterschied zwischen Makros und Funktionen deutlich gemacht werden. Dazu verwenden wir die logische Funktion (A `AND` B) `OR` C, wobei das Ergebnis in Register `R0` gespeichert werden soll. Die Werte `A`, `B` und `C` sollen dabei jeweils 8-Bit Register sein.

- Erstellen Sie ein parametrisiertes Makro `M_COMPUTE`, welches drei Register übergeben bekommt und die o.g. logische Funktion berechnet (das Ergebnis soll in `R0` stehen). Wie viele Bytes im Flash belegt ein Aufruf dieses Makros, und wie viele Takte dauert seine Ausführung? Diese Werte sollen Sie mithilfe des AVR Instruction Set bestimmen und nicht über den Debugger! (Motivation: spätestens in der Klausur haben Sie keinen Debugger mehr zur Hand, der Ihnen diese Arbeit abnimmt.) Schreiben Sie das Makro als Text in Ihre Antwort!
- Erstellen Sie eine Funktion `F_CALC`, die die o.g. logische Funktion berechnet. Nehmen Sie an, dass die Parameter wie folgt in den Registern vorliegen:
  `A=R16`, `B=R17`. `C=R18`.
  Wie viele Bytes im Flash belegt diese Funktion (inkl. eines einmaligen Aufrufs), und wie viele Takte dauert eine Ausführung? Diese Werte sollen Sie mithilfe des AVR Instruction Set bestimmen und nicht über den Debugger!
  Schreiben Sie die Funktion als Text in Ihre Antwort!
- Angenommen während Ihres Programmablaufes wird die logische Funktion zehn mal mit unterschiedlichen Werten berechnet.
  Wieviel Programmspeicher (Flash) und wieviele Takte würden dabei insgesamt verbraucht werden, wenn Sie dies als Makro bzw. als Funktionsaufruf implementieren? Der Funktionsaufruf wird dabei jedesmal mittels `RCALL` durchgeführt.
