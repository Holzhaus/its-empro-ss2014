# Übung 8
## Frage 2 (5 Punkte)

Es gibt zwei unabhängige Steuerleitungen zum Lesen (EERE) und Schreiben (EEWE). Kann daher der EEPROM parallel gelesen und beschrieben werden?

### Lösung

Nein, da es nur 1 16-Bit-Adressregister (EEarh:EEarl) und ein 16-Bit-Datenregister (EEdrh:EEdrl) gibt. Da ein Lesevorgang wesentlich schneller ist als ein Schreibvorgang würde der Lesevorgang die Daten in Adress- und Datenregister überschreiben, lange bevor der Schreibvorgang abgeschlossen ist.
