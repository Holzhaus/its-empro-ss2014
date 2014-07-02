; # Übung 9
; ## Frage 4 (55 Punkte)
; 
; *Gruppenaufgabe:*
;  
; Die Aufgabe ist eine Tasterprüfung zu implementieren, die bei einem (beliebig) gedrücktem Taster die
; Front-LED (`PORTD`, Bit 6 bzw. `PD6`) und die rechte Rück-LED (`PORTC`, Bit 0 bzw. `PC0`) ansteuert.
; 
; Die Prüfung und (De-)Aktivierung der LED soll komplett nebenläuﬁg geschehen, während der Prozessor in
; einem Hauptprogramm einer ganz anderen Aufgabe nachgeht. Das eigentliche Hauptprogramm des Prozessors
; liegt bereits vor; Sie ﬁnden es unter dem Namen [button_interrupt.asm](button_interrupt.asm) im
; Übungsordner. Es implementiert eine LED-Leuchtsequenz, wobei die Status-LED in gewissem zeitlichen
; Abstand mit einer anderen Farbe blinkt. Zusätzlich finden Sie unter dem Namen [led_busy_lsg.asm](led_busy_lsg.asm)
; im Übungsordner ein Programm, welches die Front-LED leuchten während eines Tastendrucks nicht
; nebenläufig leuchten lässt. Bei dem Programm handelt es sich um die Lösung für eine Aufgabe aus
; dem Sommersemester 2013 (Aufgabenstellung ist enthalten).
;  
; Sie sollen nun mit Hilfe eines externen Interrupts die Tastersteuerung der Front- und rechten Rück-LED
; implementieren. Dazu ist im Schaltplan des ASUROs eine Verbindung vom Tasternetzwerk zum INT1 des
; ATMega8 vorgesehen (vgl. Abbildung unten oder ASURO Handbuch, Seite 74). Durch die Interuptserviceroutine
; soll die Front- und rechten Rück-LED solange leuchten, wie ein beliebiger Kollisionstaster des ASURO
; gedrückt wird, wobei das Hauptprogramm mit der blinkenden Status-LED davon unbehelligt weiterläuft.
; Der Pin des ATMega8, auf dem der Interrupt INT1 implementiert ist, sollte dabei als Eingang ohne
; Pull-up-Widerstand konﬁguriert sein, wobei eine logische Null bei einem gedrückten Schalter und die
; logische Eins bei einen geöffneten Schalter am externen Pinn des INT1 anliegt.
;  
; Hinweis: Dieser sehr einfache Test der Kollisionstaster erlaubt nicht genau zu sagen, welcher Taster
; gedrückt wurde. Auch werden schaltungsbedingt höchstwahrscheinlich nur Taster auf der linken Seite
; des ASUROs funktionieren. Wir werden in den nächsten Vorlesungen kennen lernen, wie wir den Status
; der Taster auf bessere Art und Weise abfragen können.
; 
; - Die externen Interrupts unterstützen verschiedene Signalkonﬁgurationen, wann sie jeweils ausgelöst
; werden sollen (vgl. Vorlesung und Tabelle 31 für INT1 im ATMega8 Handbuch, Seite 64). Welche
; Einstellung sollten Sie für den Interrupt wählen, um die Front-LED bei Tasterdruck ein- und beim
; Loslassen wieder auszuschalten? Wie müssen Sie dabei das Einschalten/Ausschalten in der ISR
; implementieren? Geben Sie die Antwort innerhalb Ihrer asm-Datei im vorgesehenen Feld ab.
; **Hinweis:** *Es gibt hier mehrere Möglichkeiten, die Sie auch gefahrlos ausprobieren können.
; Beachten Sie dabei, dass ein Interrupt grundsätzlich möglichst selten ausgelöst werden soll,
; um das Hauptprogramm nicht zu oft zu unterbrechen! Eine schlechte Wahl haben Sie z.B. getroffen,
; falls Ihr Hauptprogramm gar nicht mehr weiterläuft (d.h. die Status-LED nicht mehr blinkt), weil
; der Interrupt ständig ausgelöst wird.*
; 
; - Integrieren Sie die Interruptsteuerung für die ASURO-Taster in das vorgegebene Programm. Die
; Adresse im Interrupttable, an der eine ISR für den INT1 hinterlegt werden soll, ist durch die
; Konstante INT1addr in den ATMega8 Deﬁnitionen [m8def.inc](../asm/m8def.inc) deﬁniert. Testen Sie
; Ihre Ergebnis auf dem ASURO und geben Sie den Quellcode Ihrer Implementierung ab.
; **Hinweis:** *Vergessen Sie nicht – neben der Konﬁguration des Interrupts INT1 – ihn im
; Hauptprogramm sowohl individuell als auch global zu aktivieren!*

; *****************************************************
; * Eingebettete Prozessoren: AVR Assembler
; * Vorlesung: Eingebettete Prozessoren
; * Ruhr-Universität Bochum
; * Beispiel: Blinkende LEDs mit nebenläufiger Tasterprüfung (steuert Front-LED an)
; * (c) 2009 by Tim Güneysu
; *****************************************************


; *****************************************************
;Beantworten Sie hier den Aufgabenteil a)
;
; INT1 sollte initial auf fallende Flanke gesetzt werden, da beim Drücken des Tasters eine
; Low-Wert anliegt. In der Interruptroutine selbst sollte dann geprüft werden, ob es sich um ein
; Press- oder Release-Event des Tasters handelt. Handelt es sich um ein Press-Event (was beim ersten
; Interrupt der Fall ist), dann wird die LEDs eingeschaltet und anschließend die Interruptbedingung
; auf steigende Flanke gesetzt werden, sodass der nächste Interrupt auftritt, wenn der Taster
; wieder losgelassen wird.
; Beim Release-Event werden die LEDs dann wieder abgeschaltet und INT1 wieder auf fallende Flanke
; gestellt.
; 
; *****************************************************
.NOLIST						; Assemblerdirektive: die folgende Anweisung nicht in den Maschinencode als solches einfügen 
.INCLUDE "m8def.inc" 				; Assemblerdirektive: Definitionen für den ATMega8, z.B. I/O Ports, Registernamen, etc.
.LIST						; Assemblerdirektive: die folgende Anweisungen wieder im Maschinencode aufnehmen

.EQU	CYCLES_PER_MS = 8000			; Konstanten für die WAIT-Funktion
.EQU	HALF_SECOND	 = 500
.EQU	QUARTER_SECOND = 250

.DEF	DELAY_MILLIS_L = R24			; niederwertiges Byte der Verzögerung in Millisekunden (16-Bit)
.DEF	DELAY_MILLIS_H = R25			; höherwertiges Byte der Verzögerung in Millisekunden (16-Bit)

; Assemblerdirektive: Beginn eines Codesegments
.CSEG

; erster Einsprungsvektor verweist auf die Hauptfunktion
.ORG 0x000						
		RJMP MAIN			; Springe zum Hauptprogramm
.ORG INT1addr
		RJMP INT1handler		; IRQ1 Handler

; ############## UNTERFUNKTION WAIT ##################
; beschäftigt den Prozessor für die Anzahl Millisekunden, die im 16-bit Register DELAY_MILLIS (R25:R24) gespeichert wurden
WAIT: 
		PUSH R26			; Register R26 retten
		PUSH R27			; Register R27 retten
OUTER:	LDI  R27, HIGH(CYCLES_PER_MS)		; Lade höherwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenzähler
		LDI  R26, LOW(CYCLES_PER_MS)	; Lade niederwertigen Teil der Zyklenanzahl pro Millisekunde in Zyklenzähler
INNER:	SBIW R26, 4				; Subtrahiere 4 vom Zyklenzähler (Anzahl Zyklen, die SBIW und BRNE benötigen)
		BRNE INNER			; Wiederhole so oft, bis Zyklemzähler Null ist
		SBIW DELAY_MILLIS_L, 1		; Subtrahiere 1 vom Millisekundenzähler
		BRNE OUTER			; Wiederhole so lange, bis Millisekundenzähler Null
		POP R27				; Register R27 wiederherstellen
		POP R26				; Register R26 wiederherstellen
		RET

; ############## INTERRUPTHANDLER FÜR INT1 ##################
.def temp = r16
.def sreg_backup = r17

INT1handler:
		IN sreg_backup, SREG
		IN temp, MCUCR
		SBRC temp,ISC10				; Wenn INT1 auf steigende Flanke gestellt ist...
		RJMP INT1handler_rising			; ... springe zu INT1handler_rising (und schalte LEDs aus)...
		INT1handler_falling:			; ... sonst schalte LEDs an
			; LEDs anschalten
			SBI PORTD,6			; FrontLED anschalten
			SBI PORTC,0			; Rechte BackLED anschalten
			; Interruptbedingung auf steigende Flanke setzen (1<<ISC10 und 1<<ISC11)
			LDI temp, (1<<ISC10) | (1<<ISC11)
			OUT MCUCR, temp
			RJMP INT1handler_end
		INT1handler_rising:
			; LEDs ausschalten
			CBI PORTD,6			; FrontLED ausschalten
			CBI PORTC,0			; Rechte BackLED ausschalten
			; Interruptbedingung auf fallende Flanke setzen (0<<ISC10 und 1<<ISC11)
			LDI temp, (0<<ISC10) | (1<<ISC11)
			OUT MCUCR, temp
		INT1handler_end:
                        OUT SREG, sreg_backup
			RETI				; Zurück zum Hauptprogramm

; ############## Hauptprogramm ##################
MAIN:					

		; WICHTIG: Initialisierung des 16-bit Stackpointer (SPH und SPL sind 0 nach dem Prozessorreset)
		LDI R16, HIGH(RAMEND)		; Lade 8 höchstwertige Bits der Konstante RAMEND (16 Bit Konstante auf die höchste Adresse des SRAM) in R16
		OUT SPH, R16			; Schreibe diese höherwertigen Bits in den höherwertigen Teil des SP
		LDI R16, LOW(RAMEND)		; Lade die 8 niederwertigen Bits der Konstante RAMEND in R16
		OUT SPL, R16			; Schreibe niederwertigen Bits in den niederwertigen Teil des SP

		; Setze die Ausgabeports für die Status-LED und die Front-LED
		LDI R16, (1<<PB0)
		OUT DDRB, R16		
		LDI R16, (1<<PD2) | (1<<PD6)
		OUT DDRD, R16
		; Und jetzt nochmal den Kram für die BackLED rechts
		LDI R16, (1<<PC0) | (1<<PC1)
		OUT DDRC, R16
		; Und PC1 (BackLED links) ausschalten (da die bei uns leuchtet)
		LDI R16, (0<<PC0)
		OUT PORTC, R16
		
		; Interruptbedingung auf fallende Flanke setzen (0<<ISC10 und 1<<ISC11)
		LDI temp, (0<<ISC10) | (1<<ISC11)
		OUT MCUCR, temp
		; INT1 anschalten
		LDI temp, (1<<INT1)
		OUT GICR, temp
		; PC4 als Eingabe einstellen
		CBI DDRC,4
		; Pull-Up-Widerstand für Schalter aktivieren
		SBI PORTC, PC4
		; Interrupts anschalten
		SEI
						
LOOP:	
		; Aktiviere die rote Status-LED für eine Sekunde
		SBI PORTD, PD2
		LDI DELAY_MILLIS_L, LOW(HALF_SECOND)
		LDI DELAY_MILLIS_H, HIGH(HALF_SECOND)
		RCALL WAIT
		LDI DELAY_MILLIS_L, LOW(HALF_SECOND)
		LDI DELAY_MILLIS_H, HIGH(HALF_SECOND)
		RCALL WAIT
		CBI PORTD, PD2

		; Aktiviere die gelbe Status-LED für eine viertel Sekunde
		SBI PORTD, PD2
		SBI PORTB, PB0
		LDI DELAY_MILLIS_L, LOW(QUARTER_SECOND)
		LDI DELAY_MILLIS_H, HIGH(QUARTER_SECOND)
		RCALL WAIT
		CBI PORTD, PD2
		CBI PORTB, PB0

		; Aktiviere die grüne Status-LED für eine halbe Sekunde
		SBI PORTB, PB0
		LDI DELAY_MILLIS_L, LOW(HALF_SECOND)
		LDI DELAY_MILLIS_H, HIGH(HALF_SECOND)
		RCALL WAIT
		CBI PORTB, PB0
		
		RJMP LOOP			; Endlosschleife


