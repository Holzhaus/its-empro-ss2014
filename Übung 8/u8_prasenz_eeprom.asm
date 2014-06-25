.include "m8def.inc"


;Stackpointer initialisieren
LDI R16, HIGH(RAMEND)	; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
OUT SPH, R16			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
LDI R16, LOW(RAMEND)	; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP


//Bitte unter View->Memory den Reiter EEPROM auswählen

ldi r16, 0x01 ;data
ldi r17, 0x00 ;addr_low
ldi r18, 0x00 ;addr_high

rcall EEPROM_WRITE

ldi r16, 0x02 ;data
ldi r17, 0x01 ;addr_low
ldi r18, 0x00 ;addr_high
rcall EEPROM_WRITE


end:
rjmp end;


EEPROM_WRITE:	; Warten, bis der vorige Schreibzugriff beendet ist (kann dauern)
SBIC EECR,EEWE
RJMP EEPROM_WRITE

; Schreibe die EEPROM Adresse aus den Registern (R18:17) in den EEPROM I/O Bereich
OUT EEARH, R18
OUT EEARL, R17

; Schreibe R16 in das Datenregister
OUT EEDR, R16

; Setze das Master Write Enable-Bit (EEMWE) im EEPROM Control Register (EECR)
SBI EECR, EEMWE

; Starte Schreiboperation durch Setzen des Write Enable-Bit (EEWE) im EEPROM Control Register (EECR)
SBI EECR, EEWE

ret
