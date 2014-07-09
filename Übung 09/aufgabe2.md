# Übung 9
## Frage 2 (10 Punkte)

*Einzelaufgabe:*

Wenn in Assembler eine Funktion angesprungen (`RCALL`) wird ist es nicht in allen Fällen notwendig, dass Statusregister (`SREG`) zu sichern. Erklären Sie, warum manchmal auf das Sichern des Statusregisters bei durch `RCALL` aufgerufenen Funktionen verzichtet werden kann (max. zwei Sätze). Warum muss in der Regel das Statusregister in einer Interruptserviceroutine immer gesichert werden? Geben Sie ein Beispiel an, in dem sich ein Programm, abhängig davon wann ein Interrupt ausgelöst wird, anders verhält.

### Lösung

Wenn ein Programm bestimmte Flags setzt, die nach der Ausführung der Subroutine mittels `RCALL` weiterverwendet werden sollen (z.B. Carry-Flag), kann durch das Sichern des `SREG` verhindert werden, dass die Subroutine die Flags überschreibt (beim Carry-Flag könnte das der Fall sein, wenn die Subroutine ebenfalls Berechnungen anstellt). Sind die Flags für den weiteren Programmverlauf irrelevant oder verändert die Subroutine keine Flags, kann auf das Sichern verzichtet werden. Da Interruptroutinen jederzeit ausgeführt werden können (z.B. zwischen `ADD` und `ADC`), muss bei Interruptroutinen immer das Statusregister (`SREG`) gesichert werden, sobald die Interruptroutine Operationen durchführt, die `SREG` verändern.

#### Beispiel

Hier ein Beispielcode:
```
ADD R16,R18
ADC R17,R19
```

Wenn allerdings ein Interrupt auftritt:
```
ADD R16,R18
; A wild Interrupt appears!
ADC R17,R19 ; Das funktioniert nicht mehr, wenn die Interruptroutine das Carry-Bit verändert hat.
```
