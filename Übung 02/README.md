# Übung 2
## Frage 1
Gruppenaufgabe:

Basierend auf Ihren Motordaten aus der letzen Übung sollen Sie den Asuro jetzt Figuren fahren lassen. Erstellen Sie auf Basis von [VorlageFiguren.c](Aufgabenstellung/VorlageFiguren.c) ein neues Projekt in das Sie die AsuroLib wie gewohnt einbinden. 
 
Definieren Sie in Abhängigkeit Ihrer Testwerte aus der letzen Übung die Konstanten MOTOR_OFFSET_LINKS und MOTOR_OFFSET_RECHTS. Schreiben Sie eine neue Funktion MotorSpeedSet(engineLeft,engineRight), die die Funktion MotorSpeed(engineLeft,engineRight) der AsuroLib aufruft, dabei die übergebenen Werte aber so korrigiert, dass der Asuro bei z.B. MotorSpeedSet(100,100) auch wirklich geradeaus fährt.  
 
Erweitern Sie das obige Programm danach derart, dass der Asuro ein gleichseitiges Dreieck und ein Viereck abfährt und wieder an seiner Ausgangsposition anhält. Dafür werden Sie ausprobieren müssen, wie lange Sie z.B rechts herum fahren müssen, um eine nahezu perfekte 90° bzw. 120° Kurve zu erreichen.

Um den Asuro eine bestimmte Zeit geradeaus oder Kurven fahren zu lassen, können Sie die Funktionen Msleep() der AsuroLib benutzen (Beispiel: Msleep(1500) verzögert die Ausführung des nächsten Befehls um 1500 Milisekunden).

Laden Sie bitte Ihren *kompilierbaren* Quelltext hoch.

## Frage 2
Gruppenaufgabe:

In dieser Aufgabe wollen wir die LEDs des Asuros zum blinken bringen. Der Asuro verfügt über zwei rote LEDs neben den Rädern, eine rote LED an der Unterseite und eine 3-Farb LED neben dem Atmega8 Mikrocontroller. Zunächst wollen wir einen Funktionstest der LEDs durchführen und sie dafür nacheinander aufblinken lassen. Sehen Sie sich dazu die Dokumentation der AsuroLib unter http://www.asurowiki.de/pmwiki/pub/html/ an. Insbesondere die Dokumentationen der Dateien leds.c, motor_low.c und time.c sind für diese Übung relevant. Implementieren sie dann die Funktion TestAllLEDs() in der Datei [VorlageLEDs.c](Aufgabenstellung/VorlageLEDs.c).

Als einfaches Anwendungsbeispiel sollen Sie nun dem Asuro beibringen, die LEDs zum Aussenden eines SOS-Morsesignals zu verwenden. Eine Beschreibung des Morse-Codes sowie andere relevante Hinweise sind direkt in der Vorlage in der Funktion sendSOS() enthalten. Implementieren Sie die SOS-Funktion und testen Sie sie auf dem Asuro!

Bitte laden Sie Ihren kompilierbaren Quelltext hoch.
