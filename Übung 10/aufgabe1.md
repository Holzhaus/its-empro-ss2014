# Übung 10
## Frage 1 (30 Punkte )

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (welches Sie in den Kursunterlagen im Blackboard ﬁnden).
 
- Geben Sie die notwendigen Assemblerbefehle an, um den Timer 2 des ATMega8 mit dem Vorteiler CLK/64 zu aktivieren. Es soll weiterhin ein Interrupt eingerichtet werden, der ausgelöst wird, sobald der Timer die Hälfte seiner maximalen Zählschritte erreicht hat (Hinweis: Vergleich durch Timer Output Compare Match und Auslösung des zugehörigen Interrupts). Geben Sie nur die Befehle für die Aktivierung des Timers und des Interrupts an, d.h. weitere Teile des Hauptprogramms und der Interruptserviceroutine (ISR) sind nicht notwendig. Sie können - neben dem Handbuch Seite 115 ff. - das Assemblerprogramm [timer.asm](timer.asm) aus den Kursunterlagen hierfür als Hilfestellung verwenden.

- Der Timer 1 des ATMega8 besitzt 16-Bit Register u.a. `TCNT1`, `OCR1A/B` und `ICR1`, die jedoch aufgrund von Sparmaßnahmen individuell nur mit jeweils 8 Bit an den Datenbus angebunden sind. Die verbleibenden 8-Bit werden über ein gemeinsames Temporärregister vom Datenbus gelesen und geschrieben. Welche Konvention muss beim Schreiben und Lesen von 16-Bit Werten bei dieser Einschränkung eingehalten werden?

- Nehmen Sie an, dass sowohl Timer 0 als auch Timer 1 vom AVR gleichzeitig verwendet werden. Nun setzt ein Programm den Timer 1 sowie den zugehörigen Vorteiler per Reset auf Null zurück. Welche Implikation hat das für Timer 0?

### Lösung
#### Teilaufgabe a)

```asm
; Vergleichszahl in Output Compare Register für Timer2 (OCR2) laden
LDI R16, 127
OUT OCR2, R16

; Interrupt des Timer2 aktivieren
LDI R16, (1<<OCIE2)
OUT TIMSK2, R16

; Timer2 aktivieren (d.h. Bit(s) für PRESCALER CLK/64 setzen => Einstellung CS22:CS21:CS20 = 100)
LDI R16, (1<<CS22)
OUT TCCR2, R16
```

#### Teilaufgabe b)

Beim Lesen muss das Low-Byte *vor* dem High-Byte gelesen werden:
```asm
IN R17,ICR1L ; Beim Lesen von ICR1L wird das
             ;  High-Byte in TEMP kopiert
IN R16,ICR1H ; Beim Lesen von ICR1H wird auf
             ;  das TEMP-Register zugegriffen
```
Beim Schreiben muss das Low-Byte *nach* dem High-Byte geschrieben werden:
```
OUT ICR1H,R16 ; Beim Schreiben von ICR1H wird
              ;  stattdessen der Wert in das
              ;  TEMP-Register kopiert
OUT ICR1L,R17 ; Beim Schreiben von ICR1L wird
              ;  sowohl das High-Byte aus dem
              ;  TEMP-Register als auch das
              ;  Low-Byte in das 16-Bit-Register
              ;  kopiert
```

Wenn eine Interruptroutine auf eins dieser 16-Bit-Register zugreift, sollte dieses deaktiviert werden, während das Hauptprogramm auf eins dieser Register  zugreift. Sollte ein Interrupt zwischen der High- und Low-Byte-Operation auftreten und ebenfalls auf eins der 16-Bit-Register zugreifen, würde der Zugriff im Hauptprogramm fehlerhaft.

Alternativ auch möglich ist das Sichern des Temp-Registern in der Interruptroutine:
```
IN R16,ICR1H ; Sichern des TEMP-Registers (kopiert TEMP nach R16)
[...]
OUT ICR1H,R16 ; Wiederherstellen des TEMP-Registers (kopiert R16 nach TEMP)
```

#### Teilaufgabe c)

Timer0 und Timer1 das nutzen das selbe Prescaler-Modul. Daher wird auch der Prescaler-Counter von Timer0 resettet, wenn der Prescaler von Timer1 resettet wird, sodass sich einmalig die Dauer bis zum Auslösen des Interrupts verändert. Der Prescaler-Clock (8,64,256,1024) des Timer0 selbst bleibt dabei unberührt.
