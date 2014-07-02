# Übung 9
## Frage 1 (5 Punkte)

*Einzelaufgabe:*

Nehmen Sie an, dass die Interrupts aktiviert und korrekt konfiguriert wurden. Jetzt werden der Interrupt "EE_RDY" und der Interrupt "INT1" gleichzeitig ausgelöst, während der ATMega einen beliebigen Befehl bearbeitet. An welcher Adresse liegt der Interrupthandler, an den nach Abarbeitung des Befehls gesprungen wird. Antwort bitte als Hexzahl (Format wie im AVR Datasheet, z.B. 0x010).


## Frage 2 (10 Punkte)

*Einzelaufgabe:*

Wenn in Assembler eine Funktion angesprungen (`RCALL`) wird ist es nicht in allen Fällen notwendig, dass Statusregister (`SREG`) zu sichern. Erklären Sie, warum manchmal auf das Sichern des Statusregisters bei durch rcall aufgerufenen Funktionen verzichtet werden kann (max. zwei Sätze). Warum muss in der Regel das Statusregister in einer Interruptserviceroutine immer gesichert werden? Geben Sie ein Beispiel an, in dem sich ein Programm, abhängig davon wann ein Interrupt ausgelöst wird, anders verhält.

## Frage 3 (30 Punkte)

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (welches Sie in den Kursunterlagen im Blackboard finden).
 
- Interrupts sind in der Regel hardwarebasiert, d.h. die CPU wird über eine physikalische Signalleitung von einer Verarbeitungseinheit über ein aufgetretenes Ereignis informiert.
  Auf vielen Prozessoren gibt es jedoch auch die Möglichkeit so genannte Softwareinterrupts auszulösen. Dabei wird durch das Programm zu einen bestimmten Zeitpunkt ein Interrupt ausgelöst und anschließend verarbeitet. Unterstützt der ATMega8 ebenfalls solche Softwareinterupts? Falls ja, welche IRQs kämen dafür in Frage und wie müsste man diese konfigurieren?
- In einer Interruptserviceroutine wird durch Deaktivierung des I-Flags im Statusregister (SREG) die Auslösung weiterer Interrupts automatisch abgeschaltet. Nehmen Sie an, Sie konﬁgurieren einen der externen Interrupts INT0/INT1 so, dass er bei einer anliegenden Null am externen Pin ausgelöst wird. Sie reaktivieren außerdem in Ihrer zugehörigen Interruptsserviceroutine (ISR) manuell das I-Flag im SREG, um andere, verschachtelte Interrupts zuzulassen. Eine externe Signalquelle (z.B. ein Taster) setzt nun den Pin Ihres externen Interrupts für den Zeitraum von 2 Sekunden auf logisch Null. Was wird nun im ATMega8 passieren? Mit welchem Fehler müssen Sie rechnen?
- Das General Interrupt Control Register hat noch (eine) weitere Funktion(en), als nur die externen Interrupts INT0 und INT1 zu aktivieren. Welche?

## Frage 4 (55 Punkte)

*Gruppenaufgabe:*
 
Die Aufgabe ist eine Tasterprüfung zu implementieren, die bei einem (beliebig) gedrücktem Taster die Front-LED (`PORTD`, Bit 6 bzw. `PD6`) und die rechte Rück-LED (`PORTC`, Bit 0 bzw. `PC0`) ansteuert.
Die Prüfung und (De-)Aktivierung der LED soll komplett nebenläuﬁg geschehen, während der Prozessor in einem Hauptprogramm einer ganz anderen Aufgabe nachgeht. Das eigentliche Hauptprogramm des Prozessors liegt bereits vor; Sie ﬁnden es unter dem Namen [button_interrupt.asm](button_interrupt.asm) im Übungsordner. Es implementiert eine LED-Leuchtsequenz, wobei die Status-LED in gewissem zeitlichen Abstand mit einer anderen Farbe blinkt. Zusätzlich finden Sie unter dem Namen [led_busy_lsg.asm](led_busy_lsg.asm) im Übungsordner ein Programm, welches die Front-LED leuchten während eines Tastendrucks nicht nebenläufig leuchten lässt. Bei dem Programm handelt es sich um die Lösung für eine Aufgabe aus dem Sommersemester 2013 (Aufgabenstellung ist enthalten).
 
Sie sollen nun mit Hilfe eines externen Interrupts die Tastersteuerung der Front- und rechten Rück-LED implementieren. Dazu ist im Schaltplan des ASUROs eine Verbindung vom Tasternetzwerk zum INT1 des ATMega8 vorgesehen (vgl. Abbildung unten oder ASURO Handbuch, Seite 74). Durch die Interuptserviceroutine soll die Front- und rechten Rück-LED solange leuchten, wie ein beliebiger Kollisionstaster des ASURO gedrückt wird, wobei das Hauptprogramm mit der blinkenden Status-LED davon unbehelligt weiterläuft. Der Pin des ATMega8, auf dem der Interrupt INT1 implementiert ist, sollte dabei als Eingang ohne Pull-up-Widerstand konﬁguriert sein, wobei eine logische Null bei einem gedrückten Schalter und die logische Eins bei einen geöffneten Schalter am externen Pinn des INT1 anliegt.
 
Hinweis: Dieser sehr einfache Test der Kollisionstaster erlaubt nicht genau zu sagen, welcher Taster gedrückt wurde. Auch werden schaltungsbedingt höchstwahrscheinlich nur Taster auf der linken Seite des ASUROs funktionieren. Wir werden in den nächsten Vorlesungen kennen lernen, wie wir den Status der Taster auf bessere Art und Weise abfragen können.

- Die externen Interrupts unterstützen verschiedene Signalkonﬁgurationen, wann sie jeweils ausgelöst werden sollen (vgl. Vorlesung und Tabelle 31 für INT1 im ATMega8 Handbuch, Seite 64). Welche Einstellung sollten Sie für den Interrupt wählen, um die Front-LED bei Tasterdruck ein- und beim Loslassen wieder auszuschalten? Wie müssen Sie dabei das Einschalten/Ausschalten in der ISR implementieren? Geben Sie die Antwort innerhalb Ihrer asm-Datei im vorgesehenen Feld ab. **Hinweis:** *Es gibt hier mehrere Möglichkeiten, die Sie auch gefahrlos ausprobieren können. Beachten Sie dabei, dass ein Interrupt grundsätzlich möglichst selten ausgelöst werden soll, um das Hauptprogramm nicht zu oft zu unterbrechen! Eine schlechte Wahl haben Sie z.B. getroffen, falls Ihr Hauptprogramm gar nicht mehr weiterläuft (d.h. die Status-LED nicht mehr blinkt), weil der Interrupt ständig ausgelöst wird.*

- Integrieren Sie die Interruptsteuerung für die ASURO-Taster in das vorgegebene Programm. Die Adresse im Interrupttable, an der eine ISR für den INT1 hinterlegt werden soll, ist durch die Konstante INT1addr in den ATMega8 Deﬁnitionen [m8def.inc](../asm/m8def.inc) deﬁniert. Testen Sie Ihre Ergebnis auf dem ASURO und geben Sie den Quellcode Ihrer Implementierung ab. **Hinweis:** *Vergessen Sie nicht – neben der Konﬁguration des Interrupts INT1 – ihn im Hauptprogramm sowohl individuell als auch global zu aktivieren!*
