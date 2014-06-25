# Übung 8
## Frage 3 (10 Punkte)

Erklären Sie, was folgender Assembler Code beim Programmieren des EEPROM bezweckt.
```
<...>
EEPROM_WAIT:
    SBIC EECR, EEWE
    RJMP EEPROM_WAIT
<...>
```

### Lösung
Dieser Code pollt das EEWE-Statusbit aus dem EEPROM-Control-Register (EECR) und überprüft, ob es 0 ist. Falls nicht, wird zum Label EEPROM_WAIT gesprungen und somit eine Warteschleife realisiert. Wenn EEWE 0 ist, wird der RJMP-Befehl übersprungen und die Schleife verlassen.
