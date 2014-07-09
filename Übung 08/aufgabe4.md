# Übung 8
## Frage 4 (30 Punkte [Sonderpunkte])

*Einzelaufgabe*:

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (Kursunterlagen im Blackboard). Insbesondere in Kapitel 12 (I/O Ports) finden Sie wichtige Informationen, die zum selbstständigen Lösen der Aufgabe hilfreich sind.

- In der Übung wurde besprochen, dass alle Ausgabeports auch wieder ausgelesen werden können, z.B. um herauszuﬁnden, welcher Signalpegel am Pin des ATMega8 anliegt. Sie können dazu PORTB mit `OUT  PORTB,  R16` beschreiben und anschließend den Inhalt des Registers mit `IN  R16,  PORTB` zurücklesen. Worin liegt der Unterschied, wenn Sie zum Zurücklesen stattdessen `IN  R16,  PINB` verwenden? Gibt es jeweils bei beiden Varianten eine Einschränkung bezüglich der Signallatenzen, d.h. können die Register des Ports bereits im nächsten Takt nach dem OUT-Befehl direkt wieder zurückgelesen werden? Begründen Sie!
- Nehmen Sie an, vom Port D des ATMega8 seien Bit 2 (PD2) als Eingang mit Pull-up Register und Bit 4 (PD4) als Ausgang konﬁguriert. Falls der Inhalt des Register R16 gleich Null ist, soll das Ausgangsbit am PORTD gelöscht, ansonsten gesetzt werden. Geben Sie Assemblercode an, der dieses efﬁzient realisiert. Hinweis: Beachten Sie, dass Sie nicht einfach das Register PORTD ohne Rücksicht mit OUT überschreiben dürfen, da sonst der Pull-up Widerstand für das Eingangsbit deaktiviert wird. Verwenden Sie daher Instruktionen, die nur einzelne Bits eines (I/O-)Registers modiﬁzieren! Fügen Sie den nur den relevanten Assemblercode als Text in das Antwortfeld ein.
- Spielt es bei der Konﬁguration der Eingabe und Ausgabe sowie der Pull-Up Widerstände eine Rolle, ob man zuerst das DDR-Register beschreibt und dann das PORT-Register oder andersherum? Gibt es hier ggf. problematische Konﬁgurationen?

### Lösung
#### Teilaufgabe 1
Während bei `IN  R16,  PORTB` lediglich der Inhalt des Registers PORTB in das Register R16 zurückkopiert wird, wird bei `IN  R16,  PINB` tatsächlich über Flip-Flops abgetastet wird, an welchen Pins Spannung anliegt. Die Abtastung kann jedoch eine Latenz von 1,5 Takten haben und dadurch zu fehlerhaften Werten führen, da der IN-Befehl lediglich 1 Takt dauert. Daher sollte zwischen `OUT  PORTB,  R16` und `IN  R16,  PINB` mindestens ein weiterer Befehl (oder ein `NOP`) stehen, um Syncronisierungsprobleme zu vermeiden.

#### Teilaufgabe 2
```Assembly
CPI r16,0
BRNE not_equal
equal:
	SBI PORTD,4
	RJMP end
not_equal:
	CBI PORTD,4
end:
[...]

```

#### Teilaufgabe 3
Fall 1: Sind Pins als auf Eingabe mit Pullup festgelegt und werden dann zuerst mittels DDRx auf Ausgabe, anschließend mit PORTx auf Low geschaltet, liegt für kurze Zeit Strom an den entsprechenden Ausgabepins an.

Fall 2: Pins sind auf Output (Low) geschaltet und sollen zu Input-Pins mit Pullup-Widerstand umgeschaltet werden. Werden nun erst die Einsen ins das PORTx-Register geschrieben (für die Pull-Up-Widerstände) und erst danach im DDRx die Richtung auf Eingabe gestellt, liegt kurzzeitig Stom an den Ausgabepins an (bevor sie zu Eingabepins werden) und beschädigen so möglicherweise die Peripherie.
