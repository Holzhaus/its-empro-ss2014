# Übung 7

## Frage 1 (15 Punkte)

- Welches Pointerregisterpaar erlaubt den Zugriff auf den Flash (bitte nur das Register angeben).
- Mit welchen Assemblerbefehlen wird auf dem Atmega8 eine Schreib-/leseoperation auf den Flash ausgelöst (bitte nur die zwei Befehle angeben)? Was ist bei der Adressierung von Daten im Flash im Vergleich zum RAM zu beachten (max. drei Sätze)?

### Lösung

#### Aufgabenteil 1

| Bezeichnung | Register  | Was kann addressiert werden?
| ----------- | --------- | ----------------------------
| `X`         | `R26:R27` | SRAM
| `Y`         | `R28:R29` | SRAM
| `Z`         | `R30:R31` | SRAM oder Programmspeicher (Flash)

#### Aufgabenteil 2

| Befehl            | Bezeichnung              | Bedeutung
| ----------------- | ------------------------ |-----------------
| `LPM`             | Load from Program Memory | Kopiert das Byte, dass sich im Programmspeicher an der Adresse aus Register Z befindet, in das Register R0.
| `.DB a[,b[,..]]`  |                          | Schreibt ein oder mehrere Bytes (`a`, `b`, ...) an die aktuelle Stelle im Programmspeicher
| `.DW a[,b[,..]]`  |                          | Schreibt ein oder mehrere Worte (`a`, `b`, ...) an die aktuelle Stelle im Programmspeicher

Der Zugriff auf den SRAM ist entweder direkt mittels `STS`/`LDS` oder mittels der Pointer-Registerpaare `X`, `Y` und `Z` und die Befehle `LD`, `ST`, `LDD` und `STD` möglich (die letzten beiden Befehle nur i.V.m. den Registerpaaren `Y` und `Z`, nicht `X`), während der (lesende) Zugriff auf den Flash nur mit dem Pointer-Registerpaar `Z` und dem Befehl `LPM` möglich ist. Schreibend kann auf den Programmspeicher nur während der Kompilierung zugegriffen werden, nicht währen der Ausführung (im Gegensatz zum SRAM). Zu beachten ist zudem, dass nach dem Laden mit LPM der Zeiger Z um 1 inkrementiert werden muss, damit er auf das nächste Byte zeigt, wozu der Befehl `ADIW ZL,1` genutzt wird, der zwar nur das niederwertige Register `ZL` als Parameter erwartet, aber dennoch eine 16-Bit-Addition durchführt.

#### Zusatzinfo: SRAM-Zugriff

| Befehl       | Bezeichnung                       | Bedeutung
| ------------ | --------------------------------- |-----------------
| `STS a,Rd`   | Store Direct to Data Space        | Kopiert das Byte aus dem Register `Rd` an die Adresse `a` im SRAM
| `LDS Rd,a`   | Load Direct from Data Space       | Kopiert das Byte an der Adresse `a` im SRAM in das Register `Rd`
| `ST X,Rd`    | Store Indirect                    | Kopiert das Byte aus dem Register `Rd` an die SRAM-Adresse im Pointer-Registerpaar `X`
| `LD Rd,X`    | Load Indirect                     | Kopiert das Byte an der SRAM-Adresse im Pointer-Registerpaar `X` in das Register `Rd`
| `ST X+,Rd`   | Store Indirect and Post-Increment | Kopiert das Byte aus dem Register `Rd` an die SRAM-Adresse im Pointer-Registerpaar `X` und erhöht danach das Registerpaar um 1
| `LD Rd,X+`   | Load Indirect and Post-Increment  | Kopiert das Byte an der SRAM-Adresse im Pointer-Registerpaar `X` in das Register `Rd` und erhöhrt danach das Registerpaar um 1
| `ST -X,Rd`   | Store Indirect and Pre-Decrement  | Verringert das Pointer-Registerpaar `X` um 1 und kopiert danach das Byte aus dem Register `Rd` an die SRAM-Adresse im Registerpaar
| `ST Rd,-X`   | Store Indirect and Pre-Decrement  | Verringert das Pointer-Registerpaar `X` um 1 und kopiert danach das Byte an der SRAM-Adresse im Registerpaar in das Register `Rd`
| `STD Y+q,Rr` | Store Indirect with Displacement  | Kopiert das Byte aus dem Register `Rr` an die SRAM-Adresse im Pointer-Registerpaar `Y` und dem Versatz `q`
| `LDD Rr,Y+q` | Load Indirect with Displacement   | Kopiert das Byte an der SRAM-Adresse im Pointer-Registerpaar `Y` und dem Versatz `q` in das Register `Rr`
