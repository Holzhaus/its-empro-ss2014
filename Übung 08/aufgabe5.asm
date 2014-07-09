.include "m8def.inc"

#define GRUPPENNR 68
#define SPEEDL 80
#define SPEEDR 75

#define GRUPPENNR_ADDR 42
#define SPEEDL_ADDR 150
#define SPEEDR_ADDR 152

;Bitte tragen Sie hier das von readout.hex berechnete GEHEIMNIS ein. GEHEIMNIS = 12070
; Vor der Ausführung
;  Speed Links ist 255  ;Speed Rechts ist 255  ;GEHEIMNIS: 1268
; Nach der Ausführung:
;  Speed Links ist 80  ;Speed Rechts ist 75  ;GEHEIMNIS: 12070
.CSEG
to_main: rjmp main
data:
.DB GRUPPENNR,0,SPEEDL,SPEEDR
.def temp = r16 ; Hilfsregister festlegen
.def sreg_temp = r17
EEPROM_Write:
    sbic    EECR, EEWE                  ; prüfe ob der letzte Schreibvorgang beendet ist
    rjmp    EEPROM_Write                ; wenn nein, nochmal prüfen
    out     EEARH, YH                   ; Adresse schreiben
    out     EEARL, YL                   ; 
    out     EEDR,temp                   ; Daten  schreiben
    in      sreg_temp,sreg              ; SREG sichern
    cli                                 ; Interrupts sperren, die nächsten
                                        ; zwei Befehle dürfen NICHT
                                        ; unterbrochen werden
    sbi     EECR,EEMWE                  ; Schreiben vorbereiten
    sbi     EECR,EEWE                   ; Und los !
    out     sreg, sreg_temp             ; SREG wieder herstellen
    ret
main:
;Vervollständigen Sie das Assemblerprogramm in der Datei u8_stub.asm so, dass die im Flash abgelegten
;Werte GRUPPENNR, SPEEDL sowie SPEEDR ausgelesen und an die vordefinierten Adressen im
;EEPROM geschrieben werden (xxx_ADDR). Prüfen Sie die Funktionalität im Simulator und stellen Sie
;sicher, dass keine Endlosschleife entsteht, die den EEPROM kontinuierlich beschreibt!

LDI   ZL, LOW(data*2)  ; Flash-Quelladresse in Pointer-Registerpaar Z laden
LDI   ZH, HIGH(data*2)
CLR   YH
LPM   temp,Z
LDI   YL, GRUPPENNR_ADDR ; EEPROM-Zieladresse in Pointer-Register YL laden
RCALL EEPROM_Write
ADIW  ZL,2
LPM   temp,Z+
LDI   YL, SPEEDL_ADDR ; EEPROM-Zieladresse in Pointer-Register YL laden
RCALL EEPROM_Write
LPM   temp,Z+
LDI   YL, SPEEDR_ADDR ; EEPROM-Zieladresse in Pointer-Register YL la
RCALL EEPROM_Write

end:
   nop
   rjmp end
