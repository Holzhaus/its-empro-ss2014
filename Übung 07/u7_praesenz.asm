.include "m8def.inc"
//Eingebettete Prozessoren, SS13, Ruhr-Universität Bochum
//Digitale Präsenzübung 6

//*******************************************************************
//Die ist ausnahmsweise eine interaktive Übung aufgrund des Feiertags
//Das Programm kann im Simulator im Single-Step Modus mit F11 ausgeführt werden
//Nutzen Sie breakpoints um schneller zum interessanten Code zu springen (siehe Hilfe)

//Bitte lesen Sie sich selbstständig in den Hintergrund zu Flash und RAM 
//mit Hilfe des Skripts und der Folien ein oder nutzen Sie ihre Aufzeichungen aus
//der Vorlesung.
//*******************************************************************


//Hinweis zu Direktiven: "The Assembler supports a number of directives. The directives are not translated
//directly into opcodes. Instead, they are used to adjust the location of the program in
//memory, define macros, initialize memory and so on. An overview of the directives is
//given in the following table." (Section 4 AVR Assembler User Guide)


// ############### 1: SRAM ################
//Teil 1: SRAM
//Mittels der DSEG (data segment) Direktive werden Bytes im SRAM reserviert (hier jeweils 10 bytes)
//Auf diese kann mit Hilfe der Sprungmarke Counter bzw. Counter2 zugegriffen werden
.DSEG    
Counter:   .BYTE  10
Counter2:  .BYTE  10

//Die .CSEG (code segment) Direktive markiert, dass nun Programmcode bzw. Assembler Instruktionen folgen
.CSEG

//Öffnen Sie nun bitte über View->Memory die Speicheransicht und stellen Sie auf den Reiter
//"Data" um. Der SRAM ist nicht initialisiert und mit Nullen beschrieben.

//1)a) Direkter Zugriff, d.h. eine Speicherzelle wird direkt in der Instruktion adressiert (LDS/STS)

LDS R16, Counter 
INC R16
STS Counter, R16
LDS R17, Counter

//Machen Sie sich klar, was während dieser Instruktionen passiert und verfolgen Sie 
//die Werte über die Register und Speicheransicht. In Register R17 steht nun eine 0x01, die
//zuvor an Speicheradresse 0 geschrieben wurde.

//Beachten Sie, dass die Marke "Counter" dem Assembler (und Ihnen) die Arbeit erleichtert.
//Es ist aber auch möglich, die Adresse direkt anzugeben. Dies kann allerdings zu Problemen
//führen, wenn der SRAM von anderen Programmteilen benutzt wird.

//Sie können den SRAM im Simulator auch einfach manipulieren.
//Schreiben Sie an die Adresse 0x65 den Wert 0x11 (Adressen stehen links neben den Werten
//im Format 0000xx)

LDS R16, 0x65

//Wenn Sie den Wert in der Speicheransicht richtig gesetzt haben, dann enthält Register
//R16 nun den Wert 0x11.

//Nun eine Knobelaufgabe, die Sie sich mit Hilfe des Skripts auf 
//Seite 17 Abschnitt 2.4 erklären können.

LDI R18, 0x66
LDS R17, 0x12

//Warum steht in Register R17 nun der Wert 0x66?

//Miniaufgabe: Beschreiben Sie die Adressen 10 Byte, die durch die Marke Counter
//reserviert wurden aufsteigend mit 0x01,0x02,x03,0x04,0x05, ...


//[Hier ist Platz zum ausprobieren]


//1)b) Indirekter Zugriff mit Zeigern: Eine Speicherzelle wird durch einen 16-Bit Zeiger X,Y,Z adressiert
//Nun geht es um indirekte Adressierung d.h. über einen Zeiger. Dies ist notwendig, wenn erst zur Laufzeit
//fest steht, auf welche Speicherzelle zugegriffen werden soll.

LDI ZL, LOW(Counter)
LDI ZH, HIGH(Counter)
LDI R16,0xFF
ST Z, R16

//Der folgende Code lädt die Adresse der Marke Counter in das Z Register. Die Adresse ist 16 bit lang und
//muss daher in zwei Register geladen werden. Was ist die absolute Adresse von Counter?

//Bisher hat diese Vorgehensweise noch keine Vorteile gegenüber der direkten Adressierung. Allerdings können Sie
//nun das Z Register manipulieren (z.b. in einer Schleife).

ADIW Z,0x01 //Addiert eine Zahl auf einen 16 bit Zeiger. Was wäre die Alternative?
ST Z, R16

//Welcher Wert steht nun an der Adresse 0x000061 im RAM?

//Initialisieren Sie nun die durch die Marke Counter2 referenzierten 10 Byte mit den aufsteigenden
//Werten 0x10,0x11,0x12,...

//[Z Register laden]
LDI R16, 0x10
LOOP:
  inc R16 //R16 an Adresse des Z Registers schreiben
  //[Z Register inkrementieren]
  //[R16 inkrementieren]
  CPI R16, 0x1A //10 Durchläufe
BRLO LOOP


//1)c) Indirekter Zugriff mit Adressverschiebung (Displacement) Speicheradressierung durch 
//Y oder Z-Zeiger, der jeweils um einen Off- set q verschoben wurde (dabei ist q Teil der Instruktion).

//Mit Hilfe des Displacment kann ein Zeiger um eine Konstante erhöht werden.

LDI YL, LOW(Counter)
LDI YH, HIGH(Counter)

LDD R16 , Y+4 ; Lade Inhalt an Y+4 in R16
STD Y+5, R20 ; Speichere R20 in Zelle Y+5

//1)d) Indirekter Zugriff mit Prädekrement/Postinkrement Ein indirekter Speicherzugriff
//wird ausgeführt, wobei der X,Y,Z-Zeiger entweder vorher dekrementiert (b=1) oder 
//nachher inkrementiert (b=0) wird.

LDI ZL, LOW(Counter)
LDI ZH, HIGH(Counter)

LDI R16,0x01
LDI R17,0x02

ST Z++, R16
ST Z++, R17

LD R18 , --Z 
LD R19 , --Z 

//Das Post oder Preinkrement ist insbesondere in einer Schleife sehr hilfreich, da keine zusätzliche
//Inkrement-Operation benötigt wird.


// ############### 2: Flash ################
// Der Flash wird für das Laden von Werten/Konstanten aus dem Program Memory (PM) mit der LPM-Instruktion benutzt
// Verwendung des Z-Zeigers zur Adressierung des Programmwortes. Z.b. hilfreich um Schlüssel oder 
// Initialisierungsvektoren zu speichern.

// Die Direktiven um Konstanten im Flash abzulegen sind 
// .DB Define constant byte(s)
// .DW Define constant word(s)

//Beispiel
LDI ZL, LOW(INIT*2)
LDI ZH, HIGH(INIT*2)

LPM R20, Z

//R20 enthält nun den Wert 0x5 welcher aus dem Flash geladen wurde.

//Beachten Sie, dass jede Speicherzelle im Flash 16-Bit enthält, aber das Zielregister
//fasst nur 8-Bit! Daher Verwendung des niederwertigen Bits in Z zur Adressierung des High/Low Bytes
//In diesem Fall bewirkt das (INIT*2) eine Verschiebung um eine Stelle nach links und damit ist das niederwertigste 
//Bit auf 0 gesetzt

//Ein weiteres Beispiel:

//Lade das niederwertige Byte (niederwertiges bit ist 0)
LDI ZL, LOW(INIT2*2)
LDI ZH, HIGH(INIT2*2)
LPM R20, Z

//Lade das höherwertige Byte (niederwertiges bit ist 1)
LDI ZL, LOW(INIT2*2+1)
LDI ZH, HIGH(INIT2*2+1)
LPM R20, Z


//Beachten Sie, dass Sie auch den Flash Pointer inkrementieren können
LDI ZL, LOW(INIT3*2)
LDI ZH, HIGH(INIT3*2)

LPM R20, Z+
LPM R20, Z+
LPM R20, Z+
LPM R20, Z+


//Der ausführbare Teil des Programms ist nun zuende
END:
rjmp END


//An dieser Stelle befinden sich die Deklarationen der Konstanten
//Es ist wichtig, dass diese nicht zwischen den Programmteilen eingestreut werden,
//da diese so auch als Instruktion aufgefasst werden könnten. 
INIT: 
.DB 0x05

INIT2: 
.DW 0x1615

INIT3: 
.DW 0x0201,0x0403

INIT4: 
.DW 0x0000,0x0000,0xDEAD,0xBEEF

//Wählen Sie nun unter View->Memory den Reiter "Program" aus
//Können Sie DEAD BEEF entdecken? Der Restliche Teil der Daten im Program Memory sind die Instruktionen
//für die CPU bzw. die eingetragenen Assemblerbefehle. Wo stehen die Konstanten, wo die Befehle?
LDI R16,0x04
//Die zwei Byte nach BEEF sind die binäre Darstellung des Befehls ldi R16,0x04


//Weitere Fragen bitte über das Blackboard stellen
