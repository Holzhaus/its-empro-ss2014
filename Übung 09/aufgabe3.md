# Übung 9
## Frage 3 (30 Punkte)

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (welches Sie in den Kursunterlagen im Blackboard finden).
 
- Interrupts sind in der Regel hardwarebasiert, d.h. die CPU wird über eine physikalische Signalleitung von einer Verarbeitungseinheit über ein aufgetretenes Ereignis informiert.
  Auf vielen Prozessoren gibt es jedoch auch die Möglichkeit so genannte Softwareinterrupts auszulösen. Dabei wird durch das Programm zu einen bestimmten Zeitpunkt ein Interrupt ausgelöst und anschließend verarbeitet. Unterstützt der ATMega8 ebenfalls solche Softwareinterupts? Falls ja, welche IRQs kämen dafür in Frage und wie müsste man diese konfigurieren?
- In einer Interruptserviceroutine wird durch Deaktivierung des I-Flags im Statusregister (SREG) die Auslösung weiterer Interrupts automatisch abgeschaltet. Nehmen Sie an, Sie konﬁgurieren einen der externen Interrupts INT0/INT1 so, dass er bei einer anliegenden Null am externen Pin ausgelöst wird. Sie reaktivieren außerdem in Ihrer zugehörigen Interruptsserviceroutine (ISR) manuell das I-Flag im SREG, um andere, verschachtelte Interrupts zuzulassen. Eine externe Signalquelle (z.B. ein Taster) setzt nun den Pin Ihres externen Interrupts für den Zeitraum von 2 Sekunden auf logisch Null. Was wird nun im ATMega8 passieren? Mit welchem Fehler müssen Sie rechnen?
- Das General Interrupt Control Register hat noch (eine) weitere Funktion(en), als nur die externen Interrupts INT0 und INT1 zu aktivieren. Welche?

### Lösung
#### Teilaufgabe 1
Softwareinterrupts werden ermöglicht, indem man die Pins von `INT0` bzw. `INT1` (also `PD2` oder `PD3`) auf Output setzt. Wird nun per Software der Ausgabe-Pin geschaltet, wird das entsprechende Interrupt ausgelöst. Auf einem AVR, auf dem nicht mehrere Programme parallel laufen, ist dies jedoch völlig sinnlos und könnte ebenfalls mit einem `RJMP` bzw. `RCALL` bewerkstelligt werden.

#### Teilaufgabe 2
Der normale Verlauf bei einem Interrupt wäre:
1. INT0 wird auslöst, I-Flag wird automatisch deaktiviert (weitere Interrupts werden ignoriert)
2. Interruptroutine ausgeführt
3. Wieder zurück zum Startpunkt

Nun der in der Aufgabenstellung beschriebene Fall:
1. INT0 wird auslöst, I-Flag wird automatisch deaktiviert (weitere Interrupts werden ignoriert)
2. I-Flag wird manuell wieder aktiviert (für verschachtelte Interrupts)
3. Für die dauer von 2 Sekunden werden die Schritte 1 und 2 immer wieder wiederholt und somit N Interrupts gestartet
4. Interruptroutine des zuletzt aufgetretenen Interrupts wird ausgeführt
5. Rücksprung in die Routine des zuvorletzt aufgetretenen Interrupts
6. Die Schritte 4 und 5 werden solange ausgeführt, bis alle N Interruptroutinen abgearbeitet sind
7. Wieder zurück zum Startpunkt

Dabei kann es zu einem Stack Overflow des Stack Pointers kommen, sodass möglicherweise Daten im Bereich der I/O-Speicher (Speicheradresse kleiner als `0x60`) überschieben werden.
#### Teilaufgabe 3
Mithilfe des `IVSEL`-Bits im `GICR` kann eingestellt werden, um festzulegen ob sich die Interruptvektoren auf den Beginn des Flash-Speichers (`IVSEL==0`) oder den Begin der Bootloader-Sektion des Flash-Speichers (`IVSEL==1`) beziehen.
Damit kann zwischen Interrupts für den Bootloader und Interrupts für das eigentliche Programm unterschieden werden.
Damit es während dem Setzen des `IVSEL`-Bits nicht zu Fehlern kommt, wird wiederum das `IVCE`-Bit im `GICR` verwendet  (Interrupt Vector Change Enable), das die Interrupts während der Änderung blockiert ohne das I-Flag im `SREG` zu beeinflussen.
