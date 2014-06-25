# Übung 8
## Frage 1 (5 Punkte)

Warum gibt es im EEPROM Kontrollregister EECR zwei Steuerbits (EEMWE, EEWE) zum Schreiben, und nur eines zum Lesen (EERE)?

## Frage 2 (5 Punkte)

Es gibt zwei unabhängige Steuerleitungen zum Lesen (EERE) und Schreiben (EEWE). Kann daher der EEPROM parallel gelesen und beschrieben werden?

## Frage 3 (10 Punkte)

Erklären Sie, was folgender Assembler Code beim Programmieren des EEPROM bezweckt.
```
<...>
EEPROM_WAIT:
    SBIC EECR, EEWE
    RJMP EEPROM_WAIT
<...>
```
## Frage 4 (30 Punkte [Sonderpunkte])

*Einzelaufgabe*:

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (Kursunterlagen im Blackboard). Insbesondere in Kapitel 12 (I/O Ports) finden Sie wichtige Informationen, die zum selbstständigen Lösen der Aufgabe hilfreich sind.
 
- In der Übung wurde besprochen, dass alle Ausgabeports auch wieder ausgelesen werden können, z.B. um herauszuﬁnden, welcher Signalpegel am Pin des ATMega8 anliegt. Sie können dazu PORTB mit `OUT  PORTB,  R16` beschreiben und anschließend den Inhalt des Registers mit `IN  R16,  PORTB` zurücklesen. Worin liegt der Unterschied, wenn Sie zum Zurücklesen stattdessen `IN  R16,  PINB` verwenden? Gibt es jeweils bei beiden Varianten eine Einschränkung bezüglich der Signallatenzen, d.h. können die Register des Ports bereits im nächsten Takt nach dem OUT-Befehl direkt wieder zurückgelesen werden? Begründen Sie!
- Nehmen Sie an, vom Port D des ATMega8 seien Bit 2 (PD2) als Eingang mit Pull-up Register und Bit 4 (PD4) als Ausgang konﬁguriert. Falls der Inhalt des Register R16 gleich Null ist, soll das Ausgangsbit am PORTD gelöscht, ansonsten gesetzt werden. Geben Sie Assemblercode an, der dieses efﬁzient realisiert. Hinweis: Beachten Sie, dass Sie nicht einfach das Register PORTD ohne Rücksicht mit OUT überschreiben dürfen, da sonst der Pull-up Widerstand für das Eingangsbit deaktiviert wird. Verwenden Sie daher Instruktionen, die nur einzelne Bits eines (I/O-)Registers modiﬁzieren! Fügen Sie den nur den relevanten Assemblercode als Text in das Antwortfeld ein.
- Spielt es bei der Konﬁguration der Eingabe und Ausgabe sowie der Pull-Up Widerstände eine Rolle, ob man zuerst das DDR-Register beschreibt und dann das PORT-Register oder andersherum? Gibt es hier ggf. problematische Konﬁgurationen?
    
## Frage 5 (40 Punkte)

*Gruppenaufgabe*:

In dieser Hausaufgabe sollen sie ein Programm schreiben, welches Werte aus dem Flash ausließt und in den EEPROM schreibt (Gruppennr, Motor Speed Links, Motor Speed Rechts). Das zur Übung gehörende separate [readout.hex](readout.hex)-File enthält ein Programm, welches diese Werte aus dem EEPROM ausließt, die Motoren des Asuros ansteuert und die ausgelesenen Werte auf der seriellen Schnittstelle ausgibt. Zusätzlich berechnet das Programm ein Geheimnis, welches sich aus den im EEPROM gespeicherten Werten zusammensetzt.

Ihre Aufgabe ist nun_

- Ersetzen Sie ggg mit ihrer Gruppennummer, lll mit einer Geschwindigkeit für den linken Motor und rrr mit einer Geschwindigkeit für den rechten Motor, so dass der Asuro bei einem Aufruf von MotorSpeed(lll,rrr) konstant geradeaus fahren würde (Wertebereich 0 bis 255).
- Vervollständigen Sie das Assemblerprogramm in der Datei u8_stub.asm so, dass die im Flash abgelegten Werte GRUPPENNR, SPEEDL sowie SPEEDR ausgelesen und an die vordefinierten Adressen im EEPROM geschrieben werden (xxx_ADDR). Prüfen Sie die Funktionalität im Simulator und stellen Sie sicher, dass keine Endlosschleife entsteht, die den EEPROM kontinuierlich beschreibt!
    - Führen Sie ihr Programm auf dem Asuro aus.
    - Konfigurieren Sie HTerm bzw. eine serielle Konsole wie in Übung 1 beschrieben (Baudrate 2400). Führen Sie zur Funktionskontrolle nun readout.hex auf dem Asuro aus und betrachten Sie die Ausgabe.
Als Lösung reichen Sie bitte das von ihnen modifizierte Programm ein (komplette und lauffähige .asm Datei). Tragen Sie zusätzlich das von readout.hex auf der seriellen Konsole ausgegebene Geheimnis in das vorgegebene Kommentarfeld ein.

## Frage 6 (40 Punkte)

*Gruppenaufgabe:*
 
Der ASURO soll in dieser Aufgabe als Diskobeleuchtung konfiguriert werden (wenn auch nur mit spärlichem Licht). Ihre Aufgabe ist es nun, die LEDs auf dem ASURO in der unten stehenden Reihenfolge nacheinander leuchten zu lassen. Dabei soll jede LED immer für 750ms aktiviert sein, bevor sie wieder abgeschaltet und mit der nächsten LED fortgefahren wird. Im Übungsordner befindet sich die Vorlage flashing_asuro.asm, die Sie verwenden sollen und die Ihnen bereits eine Funktion WAIT zur Verzögerung der Instruktionsausführung (in Millisekunden) zur Verfügung stellt.


| Reihenfolge | Aktive LED      | Farbe | ASURO Bauteil im Schaltplan
| ----------- | --------------- | ----- | ---------------------------
| 1           | Status-LED      | rot   | D12
| 2           | Linke Rück-LED  | -     | D15
| 3           | Front-LED       | -     | D11
| 4           | Status-LED      | grün  | D12
| 5           | Rechte Rück-LED | -     | D16
| 6           | Front-LED       | -     | D11

- Zur Ansteuerung der 4 LEDs (D11, D12, D15 und D16) müssen Sie den Schaltungsplan des ASURO verwenden (im ASURO-Handbuch im Blackboard, Seite 74). Suchen Sie die entsprechenden vier LEDs heraus und geben Sie den jeweiligen Pin innerhalb Ihrer asm-datei an, an dem jede LED mit dem Mikrocontroller verbunden ist. Beachten Sie dabei, dass die Status-LED D12 zwei Pins verwendet, um die LED jeweils in rot und grün (oder gelb, falls rot und grün gleichzeitig aktiv) leuchten lassen zu können.
- Fügen Sie in flashing_asuro.asm ein Hauptprogramm ein, welches gemäß der Reihenfolge in der obigen Tabelle die LEDs nacheinander blinken lässt (d.h. jeweils für 750ms leuchten lässt und danach wieder ausschaltet). Eine LED leuchtet, sobald am entsprechenden Ausgabepin eine Eins anliegt. Das Programm soll eine Endlosschleife beinhalten, so dass die LED-Schaltreihenfolge permanent wiederholt wird.

*Hinweis:* Bedenken Sie, dass Sie zuerst in Ihrem Programm die LED-Ports als Ausgabeports definieren müssen, bevor Sie die LEDs an- und ausschalten könnten. Achten Sie bitte darauf, wirklich ausschließlich diese LED-Pins für die Ausgabe zu konfigurieren, da im schlimmsten Fall fehlkonfigurierte I/O-Leitungen gegeneinander treiben und dadurch Komponenten und der Asuro beschädigt werden können! Bitte laden Sie die modifizierte Version von flashing_asuro.asm hoch.

## Frage 7

*Frage entfernt.*
