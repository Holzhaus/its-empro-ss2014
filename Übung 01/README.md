Übung 1
======================
## Frage 1:
Gruppenaufgabe: Mit dem Befehl `MotorSpeed(255,255)` wird die Geschwindigkeit beider Räder des ASUROs auf den maximalen Wert gestellt. Ermitteln Sie experimentell, wie weit Sie die Werte verringern können, bis der ASURO nicht mehr anfährt (d.h. die Haftreibung nicht mehr überwindet). Geben Sie die Werte für Geradeausfahrt, Rechts- und Linkskurve an (dabei soll jeweils ein Rad still stehen).

## Frage 2:
Gruppenaufgabe: In den nächsten Übungen wollen wir dem ASURO einige Kunststücke beibringen, z.B. könnte man ihn tanzen lassen. Damit das Programm des ASUROs aber nicht über den gesamten Zeitraum komplett gleichförmig abläuft, wollen wir sein Verhalten etwas randomisieren. Dazu entwickeln wir nun einen einfachen (deterministischen) Zufallszahlengenerator auf Basis eines linearen Kongruenzgenerators (LCG), wie er auch in vielen PCs zum Einsatz kommt. Die Rechenvorschrift ist sehr einfach: zu einem gegebenen Startwert `x0` und drei bekannten Parametern `a, b, m` können weitere pseudozufällige Elemente `x1, x2, x3, . . .` durch die Folge
```
xi+1    =   (a · xi + b) mod m
```
erzeugt werden.

Schreiben Sie eine Funktion 
```c
int  randomValue(int  x)
```
in der Programmiersprache C für den ATMega8, die einen LCG mit den Parameter `a = 57, b = 113 und m = 256` implementiert und als Rückgabewert den Wert `xi+1`  hat. Rufen Sie diese Funktion iterativ 5 Mal von einem Hauptprogramm mit dem Startwert `x0  = 165` auf. Kompilieren Sie Ihr Programm mit der Optimierungsstufe  `-O0` für den ATMega8 (d.h. ohne Optimierungen), damit sie jeden Schritt ihres Programms mit Hilfe des im AVR Studio eingebauten Simulators im Debugmodus gut nachvollziehen können.
Laden Sie ihren kompilierbaren Quelltext hoch.

## Frage 3

Gruppenaufgabe: Welche Werte `x1, x2, . . . , x5`  werden
in den 5 Durchläufen erreicht (lt. Ausgabe des Simulators)?
```c
x1=[0]
x2=[1]
x3=[2]
x4=[3]
x5=[4]
```

## Frage 4
Gruppenaufgabe: Sie haben in Aufgabe 2 einen Zufallszahlengenerator entworfen. Gegeben ist das Hauptprogramm [DancingAsuro.c](Aufgabenstellung/DancingAsuro.c) im Übungsordner, welches, abhängig von dieser Zufallszahlenfunktion, den Asuro in verschiedene Richtungen lenken soll.

Integrieren Sie Ihre Zufallszahlenfunktion in das Hauptprogramm und ﬂashen Sie den ASURO damit. Begutachten Sie das Ergebnis und die Bewegungen des Asuros. Sie können dem ASURO auch gerne neue „Moves“ beibringen. Bitte geben Sie Ihren modiﬁzierten und kompilierbaren Quellcode ab.
