# Übung 3
## Frage 1

Einzelaufgabe:

Im AVR Befehlssatz gibt es mehrere Befehle um eine Subtraktion durchzuführen. Die Befehle lauten SUB, SUBI, SBC, SBCI und SBIW. Beschreiben Sie jeden Befehl kurz, erklären Sie worin jeweils die Unterschiede bestehen und welche Eingangswerte bzw. Operanden für jeden Befehl benötigt werden!

## Frage 2

Einzelaufgabe:

Der Prozessor soll eine Addition und eine Subtraktion durchführen. Das Steuerwerk erhält dazu erst den binär kodierten 16-Bit Befehl 0000 1101 1010 0011 und dann den binär kodierten 16-Bit Befehl 0000 1010 1101 1001 . Dekodieren Sie die Befehle und geben Sie an, welche Operanden verwendet werden.

## Frage 3

Einzelaufgabe:

Betrachten Sie für den Befehl ANDI (Logical AND with Immediate) die mögliche Auswahl an Operanden. Was fällt Ihnen auf und worauf führen Sie das zurück?

## Frage 4

Einzelaufgabe:

Welche Flags beinhaltet das 8-Bit Statusregister des ATmega8? Bitte beschreiben Sie diese jeweils kurz in einem Satz und geben die entsprechenden Abkürzungen an. Hinweis: Angaben zum Statusregister ﬁnden Sie im ATmega8 Benutzerhandbuch.

## Frage 5

Einzelaufgabe:

Erstellen Sie ein neues Projekt im AVR Studio und verwenden Sie wie gehabt den ATmega8 als Zielplattform. Binden Sie die Asurobibliothek hier bitte nicht ein. 

Ziel dieser Aufgabe ist es, die XOR Summe von Werten aus einem konstanten Array in einer Schleife zu berechnen, wobei sich das Array im SRAM des Mikrocontrollers befindet. Benutzen Sie für diesen Aufgabenteil die Vorlage "VorlageSRAM.c" aus dem Blackboard. Zum Abschluss laden Sie bitte die kompilierbare Quelldatei hoch.

## Frage 6

Wie lautet die berechnete XOR-Summe aus der vorangegangenen Aufgabe? Verwenden Sie hierfür den Simulator und setzen Sie die Compileroptionen auf `-O0`. Geben Sie ihre Antwort bitte als Dezimalzahl an!

## Frage 7

Einzelaufgabe:

Wie viele Takte benötigt die Summierschleife bei Verwendung der Optimierungsstufe -Os insgesamt? Hinweis: Im Simulator können Sie sich die bisher verbrauchten Taktzyklen im Fenster "Processor" unter "Cycle counter" anzeigen lassen.

## Frage 8

Einzelaufgabe:

Erstellen Sie ein neues Projekt im AVR Studio und verwenden Sie wie gehabt den ATmega8 als Zielplattform. Binden sie hier die Asurobibliothek hier bitte nicht ein. 

Ziel dieser Aufgabe ist es, die XOR Summe von Werten aus einem konstanten Array in einer Schleife zu berechnen, wobei sich das Array jetzt nur noch im Flash-Speicher des Mikrocontrollers befinden soll. Bitte benutzen Sie für diesen Aufgabenteil die Vorlage "VorlageFlash.c" aus dem Blackboard. Zum Abschluss laden Sie bitte die kompilierbare Quelldatei hoch.

## Frage 9

Einzelaufgabe:

Wie viele Takte benötigt die Summierschleife bei Verwendung der Optimierungsstufe `-Os` jetzt insgesamt? Hinweis: Im Simulator können Sie sich die bisher verbrauchten Taktzyklen im Fenster "Processor" unter "Cycle counter" anzeigen lassen.

## Frage 10

Einzelaufgabe:

Wodurch kommt der Unterschied bei der Summation von Werten aus dem SRAM bzw. Flash zustande?

## Frage 11

Gruppenaufgabe:

Damit dem Asuro nicht langweilig wird, wollen wir in dieser Übung ein Programm entwickeln, mit dem sich der Asuro über die Tastatur Ihres PCs fernsteuern lässt. Die Entwicklung dieses Programms werden wir noch mit Hilfe der AsuroLib und der Programmiersprache C durchführen, da Sie noch nicht genügend Assembler-Befehle kennengelernt haben, um eine solche Funktion realisieren zu können. Erstellen Sie ein neues C-Projekt im AVR Studio, binden Sie wie gehabt die AsuroLib ein und verwenden Sie die Vorlage AsuroRemote.c aus dem Übungsordner.

In der Vorlage sehen Sie ein Programm, welches den Asuro endlich "Hello World!" über die Infrarot-Schnitstelle senden lässt. Außerdem versteht der Asuro die Kommandos "1","2","3" um die Status-LED auf rot, grün oder gelb zu schalten. Die Kommandos werden per Terminalprogramm über die IR-Schnittstelle gesendet. Hierfür können Sie Hterm oder besser ein Programm wie z.B. Putty verwenden, dass die Kommandos direkt bei Tastendruck sendet.

Erweitern Sie das Programm so, das der Asuro auch die folgenden Kommandos versteht:

- "w" vorwärts fahren (ca. 10 cm)
- "s" rückwärts fahren (ca. 10 cm)
- "a" Kurve links fahren (ca. 10 cm)
- "d" Kurve rechts fahren (ca. 10 cm)
- "x" Richtungswechsel, d.h. "w" fährt rückwärts, "s" fährt vorwärts, "a" und "d" fahren eine Kurve rückwärts. Nochmaliges aufrufen von "x" soll wieder den Urspungszustand herstellen usw.
- "h" Der Asuro soll stehen bleiben, 5x die "Martinshorn" Tonfolge abspielen, dabei alle verfügbaren LEDs rot blinken lassen und den String "Tatue Tata" über die Infrarot-Schnitstelle versenden. (Details finden Sie in den Kommentaren der Vorlage AsuroRemote.c)

Denken Sie unbedingt daran, den Asuro nach Ausführung eines Kommandos auch wieder anhalten zu lassen und testen Sie ihn in einer sicheren Umgebung.

Laden Sie die *kompilierbare* und kommentierte Quelldatei hoch.
