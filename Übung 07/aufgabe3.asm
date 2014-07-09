; # Übung 7
; 
; ## Frage 3 (70 Punkte)
; 
; *Bitte beachten Sie, bei dieser Aufgabe handelt es sich um eine Einzelaufgabe!*
; 
; Eine Basiskomponente für symmetrische Kryptographie ist das Anwenden einer S-Box.
; Die S-Box erhält eine bestimmte Anzahl an Eingangsbits und transformiert diese in
; eine bestimmte Anzahl an Ausgangsbits. Da es meistens sehr aufwändig ist eine S-Box
; on-the-fly zu berechnen, wird diese häufig als Tabelle abgespeichert.
; 
; In der folgenden Aufgabe sollen Sie die S-Box der Present Block Chiffre auswerten.
; Die Present S-Box erhält 8 Eingangsbits und ersetzt diese durch 8 Ausgangsbits,
; welche nach kryptographischen Gesichtspunkten ausgewählt wurden. Unter dem Label
; `sbox` sind daher die 256 Ausgabewerte angegeben. Ein Beispiel für das Auswerten
; der S-Box an Stelle 0 wäre `SBOX(0x00)=0xCC` während die Auswertung der S-Box an
; Stelle `0x02` das Ergebnis `S-Box(0x02)=C6` ergibt.
; 
; Bitte ergänzen Sie das Programm in [u7_haus.asm](u7_haus.asm) und laden die Datei
; anschließend hoch:
; 
; - Laden Sie die 10 Byte Input der S-Box aus dem Flash/Program Memory (Label
;   sbox_input) in den RAM (Label sbox_input_ram). (20 Punkte)
; - Wenden Sie die S-Box auf die 10 Byte Input Daten an, welche Sie zuvor in
;   den RAM geladen haben. Dabei soll der Input mit dem jeweiligen Output der
;   S-Box überschrieben werden. (20 Punkte)
; - Schreiben Sie eine Routine, die die gesamte S-Box (256 Bytes) aus dem Flash
;   in dem RAM kopiert (Label sbox_in_ram). Nutzen Sie dazu eine Schleife und
;   das Zeiger Post-Inkrement. (15 Punkte)
; - Schreiben Sie eine Routine um die nun im *RAM* abgespeicherte S-Box auszuwerten.
;   Vergleichen Sie in einem Kommentar die Geschwindigkeiten der beiden Ansätze
;   (S-Box im Flash vs. S-Box im RAM). Welcher konstante Aufwand entsteht? Gibt es
;   Fälle, in denen es sich lohnen könnte, die S-Box in dem RAM zu kopieren. Falls
;   ja, schätzen Sie ungefähr ab wie oft die S-Box in diesem Fall evaluiert werden
;   müsste. (15 Punkte)

.include "m8def.inc"

.DSEG
sbox_input_ram: 
.BYTE  10  ;Input Data für die S-Box
sbox_in_ram: 
.BYTE  256 ;Platz um die S-Box in den RAM zu kopieren

.CSEG

ldi r16, HIGH(RAMEND) ; HIGH-Byte der obersten RAM-Adresse
out SPH, r16
ldi r16, LOW(RAMEND)  ; LOW-Byte der obersten RAM-Adresse
out SPL, r16

;Teil 1
rcall copy_from_flash
;Teil 2
rcall eval_sbox_flash
;Teil 3
rcall copy_sbox
;Teil 4
rcall copy_from_flash ;Eingangswerte wiederherstellen
rcall eval_sbox_ram

END:
rjmp END

;********************************
; Namen für Hilfsregister
.DEF counter_l = R24
.DEF counter_h = R25
.DEF temp = R0
.DEF zero = R1

; Anzahl der SBOX-Input-Bytes
.EQU num_input_bytes = 10

; Counter-Makros
.MACRO counter_init ; (Zahl)
	LDI counter_l,LOW(@0)  ; Lade Anzahl der Loops in 
	LDI counter_h,HIGH(@0)
.ENDMACRO
.MACRO counter_dec
	SBIW counter_l,1 ; Decrementiert Counter, setzt Z-Flag wenn 0 (daher kein CPI notwendig)
.ENDMACRO

; Die eigentliche Flash-to-Ram-Kopierfunktion
copy_flashbytes_to_ram:
        ; Verwendung:
        ;   1. Flash-Quelladresse in Pointer-Registerpaar Z laden
        ;   2. SRAM-Zieladresse in Pointer-Registerpaar Y laden
        ;   3. Counter initialisieren mittels counter_init <num>
        ;   4. Funktion aufrufen mittels RCALL
        ; [PERFORMANCE] Initialisierung, RCALL und RET: 13 Cycles
        ; [PERFORMANCE] Funktion selbst: 1+8*n
        ; [PERFORMANCE] Gesamt: 14+8*n
	copy_flashbytes_to_ram_loop:     ; Starte Loop
	LPM temp,Z+                      ; Lädt Daten aus Flash in Hilfsregister
                                         ;  und erhöht Flash-Quelladresse danach um 1
	ST Y+,temp                       ; Speichert Daten aus Hilfsregister im SRAM
                                         ;  und erhöht SRAM-Zieladresse danach um 1
	counter_dec                      ; Counter dekrementieren
	BRNE copy_flashbytes_to_ram_loop ; Wenn Counter nicht 0 ist, wiederholen
	ret                              ; Fertig!

;*********************************
copy_from_flash:
	LDI   ZL, LOW(sbox_input*2)      ; Flash-Quelladresse in Pointer-Registerpaar Z laden
	LDI   ZH, HIGH(sbox_input*2)
	LDI   YL, LOW(sbox_input_ram*2)  ; SRAM-Zieladresse in Pointer-Registerpaar Y laden
	LDI   YH, HIGH(sbox_input_ram*2)
        counter_init num_input_bytes     ; Counter initialisierem
	RCALL copy_flashbytes_to_ram     ; Flash-to-RAM-Kopiervorgang starten
	ret
;*********************************
eval_sbox_flash:
	LDI  YL, LOW(sbox_input_ram*2)   ; SRAM-Quelladresse in Pointer-Registerpaar Y laden
	LDI  YH, HIGH(sbox_input_ram*2)
	LDI  XL, LOW(sbox*2)             ; Flash-Adresse der SBOX in Pointer-Registerpaar X laden
	LDI  XH, HIGH(sbox*2)
	; Ab hier wirds wieder spannend
	CLR  zero                        ; 0-Register setzen
	counter_init num_input_bytes     ; Counter initialisierem
	eval_sbox_flash_loop:            ; Starte Loop...
	LD   temp,Y                      ; Kopiere Input ins Hilfsregister
	MOVW ZL,XL                       ; Kopiere Flash-Adresse der SBOX nach Z
	ADD  ZL,temp                     ; Nutze SBOX-Input als Adressoffset für Z
	ADC  ZH,zero
	LPM  temp,Z                      ; Lade SBOX-Output aus Flash ins Hilfsregister
	ST   Y+,temp                     ; Speichere SBOX-Output an Inputadresse und gehe zur Nächsten
	counter_dec                      ; Counter dekrementieren
	BRNE eval_sbox_flash_loop        ; Wenn Counter nicht 0 ist, wiederholen
	ret                              ; Fertig!
        ; [PERFORMANCE] Funktion benötigt 12+12*n Cycles

;*********************************
copy_sbox:
	LDI   ZL, LOW(sbox*2)            ; Flash-Quelladresse in Pointer-Registerpaar Z laden
	LDI   ZH, HIGH(sbox*2)
	LDI   YL, LOW(sbox_in_ram*2)     ; SRAM-Zieladresse in Pointer-Registerpaar Y laden
	LDI   YH, HIGH(sbox_in_ram*2)
        counter_init 256                 ; Counter initialisierem
	RCALL copy_flashbytes_to_ram     ; Flash-to-RAM-Kopiervorgang starten
	ret

;*********************************
eval_sbox_ram:
	; Diese Funktion ist fast identisch mit eval_sbox_flash
        ;  Die beiden einzigen Unterschiede sind:
        ;  1. Statt der Flash-Adresse wird die SRAM-Adresse der
        ;     SBOX ins Register X geladen (Z. 163f)
        ;  2. Statt LPM wird LD zum Laden des SBOX-Outputs ins
        ;     Hilfsregister verwendet (Z. 174)
	; Da der LPM-Befehl mit 3 Cycles langsamer ist als der
        ; LD-Befehl (1 Cycle), ist die Auswertung der SRAM-SBOX
        ; um n*2 Cycles schneller als die Flash-SBOX. Da sie
        ; jedoch zunächst geladen werden muss, was zusätzlich
        ; 7+14+8*256 = 2069 Cycles dauert (inkl. RCALL copy_sbox),
        ; lohnt sich eine SRAM-SBOX erst ab 1035 Eingabewerten:
        ;     2069+12+10*n = 12+12*n | -12
        ; <=> 2069   +10*n =    12*n | -(10*n)
        ; <=> 2069         =     2*n | :2
        ; <=>            n =  1034.5
	LDI  YL, LOW(sbox_input_ram*2)   ; SRAM-Quelladresse in Pointer-Registerpaar Y laden
	LDI  YH, HIGH(sbox_input_ram*2)
	LDI  XL, LOW(sbox_in_ram*2)      ; SRAM-Adresse der SBOX in Pointer-Registerpaar X laden
	LDI  XH, HIGH(sbox_in_ram*2)
	; Ab hier wirds wieder spannend
	CLR  zero                        ; 0-Register setzen
	counter_init num_input_bytes     ; Counter initialisierem
        ; [PERFORMANCE] Bis hierhin 7 Cycles
	eval_sbox_ram_loop:              ; Starte Loop...
	LD   temp,Y                      ; Kopiere Input ins Hilfsregister
	MOVW ZL,XL                       ; Kopiere SRAM-Adresse der SBOX nach Z
	ADD  ZL,temp                     ; Nutze SBOX-Input als Adressoffset für Z
	ADC  ZH,zero
	LD   temp,Z                      ; Lade SBOX-Output aus SRAM ins Hilfsregister
	ST   Y+,temp                     ; Speichere SBOX-Output an Inputadresse und gehe zur Nächsten
	counter_dec                      ; Counter dekrementieren
        ; [PERFORMANCE] Bis hierhin 7+9*n Cycles
	BRNE eval_sbox_ram_loop          ; Wenn Counter nicht 0 ist, wiederholen
        ; [PERFORMANCE] Bis hierhin 8+10*n Cycles
	ret                              ; Fertig!
        ; [PERFORMANCE] Funktion benötigt 12+10*n Cycles

;.ORG 1024 ; Musste ich auskommentieren, da entweder mein Compiler
           ; (avra) oder mein Simulator (simavr) sonst irgendwelche
           ; Datensegmente ausführen will

sbox_input:
.db 0x02, 0x00, 0xC6, 0x11, 0x7F, 0xC1, 0x8A, 0xD4, 0x37, 0x46

 sbox:
.db 0xCC, 0xC5, 0xC6, 0xCB, 0xC9, 0xC0, 0xCA, 0xCD, 0xC3, 0xCE, 0xCF, 0xC8, 0xC4, 0xC7, 0xC1, 0xC2
.db 0x5C, 0x55, 0x56, 0x5B, 0x59, 0x50, 0x5A, 0x5D, 0x53, 0x5E, 0x5F, 0x58, 0x54, 0x57, 0x51, 0x52
.db 0x6C, 0x65, 0x66, 0x6B, 0x69, 0x60, 0x6A, 0x6D, 0x63, 0x6E, 0x6F, 0x68, 0x64, 0x67, 0x61, 0x62
.db 0xBC, 0xB5, 0xB6, 0xBB, 0xB9, 0xB0, 0xBA, 0xBD, 0xB3, 0xBE, 0xBF, 0xB8, 0xB4, 0xB7, 0xB1, 0xB2
.db 0x9C, 0x95, 0x96, 0x9B, 0x99, 0x90, 0x9A, 0x9D, 0x93, 0x9E, 0x9F, 0x98, 0x94, 0x97, 0x91, 0x92
.db 0x0C, 0x05, 0x06, 0x0B, 0x09, 0x00, 0x0A, 0x0D, 0x03, 0x0E, 0x0F, 0x08, 0x04, 0x07, 0x01, 0x02
.db 0xAC, 0xA5, 0xA6, 0xAB, 0xA9, 0xA0, 0xAA, 0xAD, 0xA3, 0xAE, 0xAF, 0xA8, 0xA4, 0xA7, 0xA1, 0xA2
.db 0xDC, 0xD5, 0xD6, 0xDB, 0xD9, 0xD0, 0xDA, 0xDD, 0xD3, 0xDE, 0xDF, 0xD8, 0xD4, 0xD7, 0xD1, 0xD2
.db 0x3C, 0x35, 0x36, 0x3B, 0x39, 0x30, 0x3A, 0x3D, 0x33, 0x3E, 0x3F, 0x38, 0x34, 0x37, 0x31, 0x32
.db 0xEC, 0xE5, 0xE6, 0xEB, 0xE9, 0xE0, 0xEA, 0xED, 0xE3, 0xEE, 0xEF, 0xE8, 0xE4, 0xE7, 0xE1, 0xE2
.db 0xFC, 0xF5, 0xF6, 0xFB, 0xF9, 0xF0, 0xFA, 0xFD, 0xF3, 0xFE, 0xFF, 0xF8, 0xF4, 0xF7, 0xF1, 0xF2
.db 0x8C, 0x85, 0x86, 0x8B, 0x89, 0x80, 0x8A, 0x8D, 0x83, 0x8E, 0x8F, 0x88, 0x84, 0x87, 0x81, 0x82
.db 0x4C, 0x45, 0x46, 0x4B, 0x49, 0x40, 0x4A, 0x4D, 0x43, 0x4E, 0x4F, 0x48, 0x44, 0x47, 0x41, 0x42
.db 0x7C, 0x75, 0x76, 0x7B, 0x79, 0x70, 0x7A, 0x7D, 0x73, 0x7E, 0x7F, 0x78, 0x74, 0x77, 0x71, 0x72
.db 0x1C, 0x15, 0x16, 0x1B, 0x19, 0x10, 0x1A, 0x1D, 0x13, 0x1E, 0x1F, 0x18, 0x14, 0x17, 0x11, 0x12
.db 0x2C, 0x25, 0x26, 0x2B, 0x29, 0x20, 0x2A, 0x2D, 0x23, 0x2E, 0x2F, 0x28, 0x24, 0x27, 0x21, 0x22
