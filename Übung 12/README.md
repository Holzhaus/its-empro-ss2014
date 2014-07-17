# Übung 12  
## Frage 1 (20 Punkte [Sonderpunkte])

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (welches Sie in den Kursunterlagen im Blackboard finden).
 
**(a)** Der 10-Bit ADC des ATMega8 speichert das Ergebnis jeder analogen Messung im 16-Bit Register ADC. Das 10-Bit Ergebnis kann in diesem Register mit Hilfe des Flags ADLAR entweder rechts- oder linksbündig ausgerichtet werden (vgl. Handbuch S. 193 ff.). Wann ist es z.B. sinnvoll, das Register linksbündig auszurichten?
 
**(b)** Die oberen und unteren 8-Bit des 16-Bit ADC-Registers müssen nacheinander ausgelesen werden. Jedoch kann in der Zwischenzeit bereits parallel eine weitere ADC-Messung laufen, die zufällig gerade dann das ADC aktualisiert, während erst eine Hälfte des ADC-Registers ausgelesen wurde. Wie wird vom μC verhindert, dass dieser Fall eintritt? Was muss man daher bei der Programmierung des Auslesevorgangs beachten?

## Frage 2 (50 Punkte)

*Gruppenaufgabe:*

Diese Aufgabe ist eine Vorübung für die Verfolgung von Linien mit Ihrem ASURO. Dazu setzen wir erstmals die beiden Fototransistoren (engl. photo transistor oder PT) an der Unterseite des ASUROs ein. Beide Fototransistoren liefern entsprechend des Lichteinfalls eine proportionale Spannung, die vom 10-Bit ADC im ATMega in einen digitalen Wert konvertiert wird. Die Ausgabe, ob dabei der rechte oder linke Fototransistor einen helleren Untergrund erkennt, soll in dieser Aufgabe über die Status-LED erfolgen. Genauer gesagt, soll der Lichteinfall über die Differenz der digitalen Eingabewerte beider Fototransistoren gemessen werden, wodurch Störungen vermindert werden, da sie i.d.R. auf beide Sensoren gleichzeitig wirken. Es gilt *δ = d<sub>l</sub> − d<sub>r</sub>*, wobei d<sub>l</sub> der digitale Wert des linken und d<sub>r</sub> der des rechten Fototransistors ist. Falls der Untergrund auf der linken Seite des ASUROs deutlich heller ist (einschließlich einer gewissen Toleranz, d.h. δ ≥ 10), soll die Status-LED grün leuchten. Ist die rechte Seite deutlich heller (δ ≤ −10), leuchtet die Status-LED rot. Sind die beiden Werte nah beieinander (−10 < δ < 10), dann soll die Status-LED ausgeschaltet werden.
 
**(a)** In der Datei [foto_adc.asm](foto_adc.asm) ist ein Rahmenprogramm gegeben, welches die LEDs als Ausgabeports des ASURO konfiguriert und die Berechnung der Differenz sowie die Ansteuerung der LEDs übernimmt. Sie müssen allerdings noch den ADC (innerhalb des RESET) initialisieren. Aktivieren Sie dazu den ADC über das entsprechende Flag (s. Handbuch) im ADCSRA-Register. Außerdem müssen Sie die Abtastrate des ADCs mit Hilfe des Prescalers einstellen. Für die vollen 10-Bit Auflösung genügen bereits 50-200kHz, so dass Sie hier z.B. die Prescalereinstellung CLK/64 = 125 kHz verwenden können.
 
**(b)** Ergänzen Sie in der Datei [asuro_macros.inc](asuro_macros.inc) (im Übungsordner) zwei Makros:
 
- `READ_ADC` mit einem konstanten Übergabeparameter. Dieses Makro führt eine allgemeine Analog-Digitalwandlung mit dem ADC aus. Der Übergabeparameter gibt an, welcher Eingangspin des ATMega8 für die Konvertierung verwendet werden soll (Einstellung per Register `ADMUX`). Die Datei [asuro_macros.inc](asuro_macros.inc) definiert dazu bereits u.a. die Konstanten `ADC_PT_LEFT` und `ADC_PT_RIGHT` jeweils für den Pin des linken und rechten Fototransistors. Neben der Auswahl des Eingangspins müssen Sie noch eine Referenzspannung für den ADC über das Register `ADMUX` einstellen. Verwenden Sie hier die Einstellung (A)VCC mit externer Kapazität (vgl. Handbuch S. 203). Starten Sie danach die Konvertierung durch Setzen des entsprechenden Flags im `ADCSRA` Kontrollregister. Warten Sie per Polling ab, bis die Wandlung beendet ist und dieses Flag wieder von der Hardware auf Null zurückgesetzt wird. Nun liegt der digitalisierte Wert im 16-Bit Register ADC bereit und kann (z.B. vom Hauptprogramm) ausgelesen werden.
- `GET_PT_DIFF` ohne Übergabeparameter. Dieses Makro liest nacheinander die digitalisierten Werte des linken und rechten Fototransistoren über den ADC aus und berechnet daraus die Differenz. Es soll zum Analog-Digital-Wandlung der Werte der Fototransistoren jeweils das Makro `READ_ADC` verwendet werden. Daher muss `GET_PT_DIFF` die gewandelten 16-Bit (bzw. 10-Bit) Werte F<sub>l</sub> und F<sub>r</sub> jeweils aus dem ADC-Register auslesen und die Differenz = F<sub>l</sub> − F<sub>r</sub> berechnen. Das 16-Bit Ergebnis soll in den beiden globalen 8-Bit Registern `PT_DIFF_L=R24` und `PT_DIFF_H=R25` (definiert in der Makrodatei) gespeichert werden. *Hinweis: Da hier verschachtelte Makros verwendet werden, achten Sie genau darauf, welche temporäre Register Sie in den beiden Makros verwenden. Es passiert schnell, dass sonst vom einen Makro Werte des anderen überschrieben werden!*
 
**(c)** Testen Sie das gegebene Programm mit ihren Macros und stellen Sie sicher, dass die Status-LED wie oben beschrieben entweder rot, grün oder gar nicht leuchtet. *Hinweis: Sie können eine etwas dickere schwarze Linie auf einem Blatt weißem Papier verwenden, um die Funktion Ihres Programmes zu testen. Beachten Sie, dass Streulicht und sonstige Einflüsse die Messung beinflussen können, so dass eine gelegentlich flackernde Status-LED nicht ungewöhnlich ist. Weiterhin kann es sein, dass Sie die Fototransistoren kalibrieren müssen, damit bei gleicher Helligkeit an beiden Fototransistoren die Status-LED tatsächlich aus ist. Ergänzen Sie dazu `GET_PT_DIFF` so, dass zur Differenz der Fototransistoren noch eine Konstante addiert/subtrahiert wird, die der Abweichung Ihres ASUROs entspricht (diese müssen Sie natürlich selbst durch Ausprobieren ermitteln).*
 
Zur Abgabe kopieren sie bitte ihren Code zur Initialisierung des ADCs aus der [foto_adc.asm](foto_adc.asm) an den Anfang der [asuro_macros.inc](asuro_macros.inc)-Datei und kommentieren ihn aus. Laden sie die [asuro_macros.inc](asuro_macros.inc) hoch. Dies ist notwendig, da sie nur eine einzelne Datei als Lösung hochladen können.

## Frage 3 (20 Punkte [Sonderpunkte])

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das Asuro Handbuch (welches Sie in den Kursunterlagen im Blackboard ﬁnden) und evt. Informationen zur Zeitkonstante τ (http://de.wikipedia.org/wiki/Zeitkonstante).
 
Neben den Tastern sind an Pin PC4 auch noch R23 und C7 angeschlossen. Dieses sogenannte RC-Glied glättet Störungen der Versorgungsspannung um eine genauere Messung des ADC zu ermöglichen. Allerdings benötigt es eine gewisse Zeit um sich aufzuladen. Berechnen Sie die Zeit 3 ∗ τ, die das RC-Glied benötigt um sich auf ≈ 95% der Versorgungsspannung aufzuladen. Wie vielen Taktzyklen entspricht diese Zeit ungefähr? Um die Ladezeit zu verringern kann man über R24(an PD3) noch einen zusätzlichen Strompfad dazuschalten. Wie gross ist die Zeit 3 ∗ τ jetzt? Wie vielen Taktzyklen entspricht diese neue Zeit ungefähr?

## Frage 4 (50 Punkte)

*Gruppenaufgabe:*

In dieser Aufgabe sollen Sie Routinen scheiben, mit denen Sie ermitteln können, welcher der 6 Taster des Asuros betätigt wurde.
 
**(a)** In der Datei kollision.asm ist ein Rahmenprogramm gegeben, welches bislang nur die LEDs als Ausgabeports des ASURO konﬁguriert. Beginnen Sie zuerst damit in diesem Programm den ADC (innerhalb des `RESET`) zu initialisieren. Aktivieren Sie dazu den ADC über das entsprechende Flag (s. Handbuch) im `ADCSRA`-Register. Außerdem müssen Sie die Abtastrate des ADCs mit Hilfe des Prescalers einstellen. Für die vollen 10-Bit Auﬂösung genügen bereits 50-200kHz, so dass Sie hier z.B. die Prescalereinstellung CLK/64 = 125 kHz verwenden können.
 
*Hinweis: Sie können den notwendigen Code aus der vorherigen Aufgabe übernehmen*
 
**(b)** Ergänzen Sie in der Datei [asuro_macros.inc](asuro_macros.inc) (im Übungsordner) um zwei Makros:
 
- `READ_ADC` mit einem konstanten Übergabeparameter. Dieses Makro führt eine allgemeine Analog-Digitalwandlung mit dem ADC aus. Der Übergabeparameter gibt an, welcher Eingangspin des ATMega8 für die Konvertierung verwendet werden soll (Einstellung per Register `ADMUX`). Die Datei [asuro_macros.inc](asuro_macros.inc) deﬁniert dazu bereits u.a. die Konstante `ADC_SWITCHES` für den Pin der Taster. Neben der Auswahl des Eingangspins müssen Sie noch eine Referenzspannung für den ADC über das Register `ADMUX` einstellen. Verwenden Sie hier die Einstellung (A)VCC mit externer Kapazität (vgl. Handbuch S. 203). Starten Sie danach die Konvertierung durch Setzen des entsprechenden Flags im `ADCSRA` Kontrollregister. Warten Sie per Polling ab, bis die Wandlung beendet ist und dieses Flag wieder von der Hardware auf Null zurückgesetzt wird. Nun liegt der digitalisierte Wert im 16-Bit Register ADC bereit und kann (z.B. vom Hauptprogramm) ausgelesen werden. *Hinweis: Sie können den notwendigen Code für READ_ADC aus der vorherigen Aufgabe übernehmen.*
- `GET_KEYS` ohne Übergabeparameter. Dieses Makro liest den digitalisierten Wert der Taster über den ADC aus und berechnet daraus den betätigten Taster. Es soll zum Analog-Digital-Wandlung des Wertes der Taster das Makro `READ_ADC` verwendet werden. Um Störungen auszugleichen, soll das Makro nur die oberen 8 Bit des AD-Wertes auswerten. (Sie können entweder das `READ_ADC`-Makro anpassen,so das es den ADC im `LEFT_ADJUST_MODE` betreibt, oder sie bauen sich den Wert der oberen 8 Bits selbst zusammen z.B. mit den Befehlen `lsr`/`ror`). Die folgende Tabelle gibt Richtwerte für die den Tasten entsprechenden AD-Werte, den zugehörigen Statuswert und die zugeordnete Funktion an.
 
|       Taste | 8 Bit ADC WERT | KEY Register | Funktion                |
| ----------- | -------------- | ------------ | ----------------------- |
|          K0 |            170 |            1 |  `SET_STATUS_LED_GREEN` |
|          K1 |            204 |            2 |    `SET_STATUS_LED_RED` |
|          K2 |            227 |            4 | `SET_STATUS_LED_YELLOW` |
|          K3 |            240 |            8 |  `SET_LEFT_BACK_LED_ON` |
|          K4 |            248 |           16 | `SET_RIGHT_BACK_LED_ON` |
|          K5 |            251 |           32 |          `ALL_LEDS_OFF` |
| Keine Taste |            255 |            0 |                   `NOP` |

Je nach betätigter Taste soll ein globales Register `KEY` auf den Wert in obiger Tabelle gesetzt werden.

*Hinweis: Die angegebenen Werte können bei Ihrem Asuro etwas abweichen, so dass Sie hier evt. etwas ausprobieren müssen.*

**(c)** Konﬁgurieren Sie im Hauptprogramm den externen `INT1` auf die fallende Flanke. Konﬁgurieren den Interrupt-Pin ohne PullUp-Widerstand. Dies ist notwendig, damit alle 6 Taster den Interrupt auslösen können.
 
**(d)** Fügen Sie das Makro `GET_KEYS` in die `ISR` des `INT1` ein. Vor dem Aufruf des Makros müssen Sie Pin `PD3` auf High-Pegel schalten und die unter Aufgabe 1a berechnete Zeit abwarten (falls Sie Aufgabe 1a nicht lösen konnten, nehmen Sie 150 Takte an) um eine saubere Messung zu erhalten. Nach dem Makro müssen Sie Pin `PD3` wieder als Eingang schalten, damit der externe Interrupt wieder alle Tasten erkennt.
 
**(e)** Erweitern Sie das Hauptprogramm so, das jeder Tastendruck die entsprechende Funktion auslöst. Denken Sie daran, die Fehlauslösungen beim Loslassen einer Taste zu behandeln.
 
Zur Abgabe kopieren sie bitte den Inhalt der [asuro_macros_kollision.inc](asuro_macros_kollision.inc) in die [kollision.asm](kollision.asm) und entfernen dafür die `.include`-Anweisung in dieser Zeile. Laden sie die [kollision.asm](kollision.asm) hoch. Dies ist notwendig, da sie nur eine einzelne Datei als Lösung hochladen können.
