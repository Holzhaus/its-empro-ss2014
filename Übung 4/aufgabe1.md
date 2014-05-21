# Übung 4
## Frage 1 (30 Punkte)
*Einzelaufgabe:* Welchen Wertebereich haben 16-bit Zahlen in der Zweierkomplement-Darstellung?
Was sind die Vorteile der Zweierkomplement-Darstellung gegenüber der Einerkomplement-Darstellung?
Führen Sie die Rechnung `710 + (-1410)` in Zweierkomplement-Darstellung durch. Wie viele Bits benötigen Sie für die Darstellung? Geben Sie alle Zwischenschritte an und konvertieren Sie das Ergebnis wieder zurück ins Dezimalsystem.

### Lösung

#### Wertebereich
```
bits = 16
Obere Grenze:   ((2^bits)/2)-1 =  32767
Untere Grenze: -((2^bits)/2)   = -32768
```

#### Vorteile der Zweierkomplementdarstellung
Es wird keine Fallunterscheidung, ob mit positiven oder negativen Zahlen gerechnet wird, benötigt (im Gegensatz zu der Einerkomplementdarstellung). Der Wertebereich ist für negative Zahlen um 1 größer als bei der Einerkomplementdarstellung bzw. gibt es keine doppelte 0-Darstellung (`+0`/`-0`)

### Rechnung
```
  001011000110 =   710
+ 101001111110 = -1410
--------------
  110101000100 =  -700
```

Es werden 12 Bits zur Darstellung benötigt.

