# Übung 9
## Frage 1 (5 Punkte)

*Einzelaufgabe:*

Nehmen Sie an, dass die Interrupts aktiviert und korrekt konfiguriert wurden. Jetzt werden der Interrupt "EE_RDY" und der Interrupt "INT1" gleichzeitig ausgelöst, während der ATMega einen beliebigen Befehl bearbeitet. An welcher Adresse liegt der Interrupthandler, an den nach Abarbeitung des Befehls gesprungen wird. Antwort bitte als Hexzahl (Format wie im AVR Datasheet, z.B. 0x010).

### Lösung

`0x002`

#### Begründung

Die Prioritäten der Interrupts werden durch die Interruptvektoren (i.e. Speicheradressen) festgelegt. Je niedriger die Adresse, desto höher die Priorität. (Vgl. ATmega8 Manual, S. 10)
