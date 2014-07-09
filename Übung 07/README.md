# Übung 7

## Frage 1 (15 Punkte)

- Welches Pointerregisterpaar erlaubt den Zugriff auf den Flash (bitte nur das Register angeben).
- Mit welchen Assemblerbefehlen wird auf dem Atmega8 eine Schreib-/leseoperation auf den Flash ausgelöst (bitte nur die zwei Befehle angeben)? Was ist bei der Adressierung von Daten im Flash im Vergleich zum RAM zu beachten (max. drei Sätze)?

## Frage 2 (15 Punkte)

Warum ist folgender Code zum Inkrementieren des Z Pointers fehlerhaft (unabhängig von einer Schreib-/Leseoperation)? Die fehlerhaft implementierte Funktion lässt sich mit einem einzigen Assembler Befehl realisieren. Verwenden Sie diesen Befehl und korrigieren Sie den gegeben Code.
```
ldi r0,0
inc ZL
adc ZH,r0
```

## Frage 3 (70 Punkte)

*Bitte beachten Sie, bei dieser Aufgabe handelt es sich um eine Einzelaufgabe!*

Eine Basiskomponente für symmetrische Kryptographie ist das Anwenden einer S-Box. Die S-Box erhält eine bestimmte Anzahl an Eingangsbits und transformiert diese in eine bestimmte Anzahl an Ausgangsbits. Da es meistens sehr aufwändig ist eine S-Box on-the-fly zu berechnen, wird diese häufig als Tabelle abgespeichert.

In der folgenden Aufgabe sollen Sie die S-Box der Present Block Chiffre auswerten. Die Present S-Box erhält 8 Eingangsbits und ersetzt diese durch 8 Ausgangsbits, welche nach kryptographischen Gesichtspunkten ausgewählt wurden. Unter dem Label `sbox` sind daher die 256 Ausgabewerte angegeben. Ein Beispiel für das Auswerten der S-Box an Stelle 0 wäre `SBOX(0x00)=0xCC` während die Auswertung der S-Box an Stelle `0x02` das Ergebnis `S-Box(0x02)=C6` ergibt.

Bitte ergänzen Sie das Programm in [u7_haus.asm](u7_haus.asm) und laden die Datei anschließen hoch:

- Laden Sie die 10 Byte Input der S-Box aus dem Flash/Program Memory (Label sbox_input) in den RAM (Label sbox_input_ram). (20 Punkte)
- Wenden Sie die S-Box auf die 10 Byte Input Daten an, welche Sie zuvor in den RAM geladen haben. Dabei soll der Input mit dem jeweiligen Output der S-Box überschrieben werden. (20 Punkte)
- Schreiben Sie eine Routine, die die gesamte S-Box (256 Bytes) aus dem Flash in dem RAM kopiert (Label sbox_in_ram). Nutzen Sie dazu eine Schleife und das Zeiger Post-Inkrement. (15 Punkte)
- Schreiben Sie eine Routine um die nun im *RAM* abgespeicherte S-Box auszuwerten. Vergleichen Sie in einem Kommentar die Geschwindigkeiten der beiden Ansätze (S-Box im Flash vs. S-Box im RAM). Welcher konstante Aufwand entsteht? Gibt es Fälle, in denen es sich lohnen könnte, die S-Box in dem RAM zu kopieren. Falls ja, schätzen Sie ungefähr ab wie oft die S-Box in diesem Fall evaluiert werden müsste. (15 Punkte)
