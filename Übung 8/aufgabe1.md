# Übung 8
## Frage 1 (5 Punkte)

Warum gibt es im EEPROM Kontrollregister EECR zwei Steuerbits (EEMWE, EEWE) zum Schreiben, und nur eines zum Lesen (EERE)?

### Lösung

| Bit   | Bedeutung
| ----- | 
| EEWE  | Startet den Schreibvorgang, wenn EEMWE auf 1 gesetzt ist und EEWE ebenfalls auf 1 gesetzt wird. Bleibt solange auf 1 bis der Schreibvorgang abgeschlossen ist.
| EEMWE | Muss auf 1 gesetzt werden, damit der Schreibvorgang mittels setzen von EEWE gestartet werden kann. Wird hardwareseitig automatisch nach 4 Zyklen wieder auf 0 gesetzt.
| EERE  | Wird es auf 1 gesetzt, wird der Lesevorgang durchgeführt (Dauer: 1 Cycle). Dafür sollte EEWE auf 0 sein (d.h. zeitgleich kein Schreibvorgang durchgeführt werden. 

Mittels EEMWE wird der Schreibmodus aktiviert. Dann muss innerhalb von 4 Cycles EEWE gesetzt werden. EEWE zeigt dann an, ob der Schreibvogang noch läuft (da dieser länger dauert). Bei EERE ist ist dies nicht nötig, da die Leseoperation ohnehin nur 1 Taktzylkus dauert. EEWE kann gepollt werden, damit nicht versehenlich eine Leseoperation gestartet wird, während der schreibvorgang noch läuft. 
