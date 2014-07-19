# Übung 12  
## Frage 1 (20 Punkte [Sonderpunkte])

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (welches Sie in den Kursunterlagen im Blackboard finden).
 
**(a)** Der 10-Bit ADC des ATMega8 speichert das Ergebnis jeder analogen Messung im 16-Bit Register ADC. Das 10-Bit Ergebnis kann in diesem Register mit Hilfe des Flags ADLAR entweder rechts- oder linksbündig ausgerichtet werden (vgl. Handbuch S. 193 ff.). Wann ist es z.B. sinnvoll, das Register linksbündig auszurichten?
 
**(b)** Die oberen und unteren 8-Bit des 16-Bit ADC-Registers müssen nacheinander ausgelesen werden. Jedoch kann in der Zwischenzeit bereits parallel eine weitere ADC-Messung laufen, die zufällig gerade dann das ADC aktualisiert, während erst eine Hälfte des ADC-Registers ausgelesen wurde. Wie wird vom μC verhindert, dass dieser Fall eintritt? Was muss man daher bei der Programmierung des Auslesevorgangs beachten?

### Lösung

#### Teilaufgabe (a)

Dies ist in den Fällen sinnvoll, wenn keine 10-Bit-Genauigkeit gefragt ist. In diesem Fall kann der direkt der 8-Bit-Wert aus dem `ADCH`-Register gelesen werden, da dort die 8 Most Significant Bits (MSBs) gespeichert werden. Dies kann auch zur Kompatibilität mit älteren AVRs genutzt werden, deren ADCs lediglich 8-Bit-Genauigkeit unterstützten.

#### Teilaufgabe (b)

Beim Zugriff auf `ADCL` wird das `ADCH`-Register eingefroren, sodass sichergestellt wird, dass beim Auslesen von `ADCH` sichergestellt ist, dass der enthaltene Wert zur gleiches Messung wie der Wert aus `ADCL` gehört. Beim Lesen von `ADCH` wird die Sperre wieder aufgehoben. Es muss beim Lesen von 10-Bit-Ergebnissen also darauf geachtet werden, zuerst das `ADCL`- und erst dann das `ADCH`-Register zu lesen. Dabei darf nicht versäumt werden, auch `ADCH` auszulesen, weil sonst die Sperre weiter bestehen bleibt und das Ergebnis nicht mehr aktualisiert wird.

Beim Lesen von links ausgerichteten 8-Bit-Ergebnissen dies nicht nötig, hier reicht das Auslesen des einzelnen Registers `ADCH`. Somit ist hier keine Sperre notwendig.
