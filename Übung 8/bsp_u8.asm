.include "m8def.inc"


;Pin PC1 als Ausgabeport konfigurieren
in  r16, DDRC
ldi r17, (1<<PC1) ; 0b00000010
or  r16, r17
out DDRC, r16

;Alternative
sbi DDRC, PC1
sbi DDRC, PC1


;Pin PC1 auf High setzen
in  r16, PORTC
ldi r17, (1<<PC1) ; 0b00000010
or  r16, r17
out PORTC, r16

;Alternative
sbi PORTC, PC1

end:
rjmp end
