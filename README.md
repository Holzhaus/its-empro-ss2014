# Übungen zur Vorlesung "Eingebettete Prozessoren" (Sommersemester 2014)

## C-Programme kompilieren und flashen:

- Zunächst unter ArchLinux das [`asuro-flashtool` aus dem AUR ](https://aur.archlinux.org/packages/asuro-flashtool/) installieren
- Auch `avr-gcc` muss installiert werden
- Dann das compile_and_flash.sh-script mit -u <ÜBUNG> -a <AUFGABE> [-f] (die -f-Option flasht das Kompilat direkt auf den ASURO)

## Assembler-Programme kompilieren und debuggen

### Benötigte Tools
- Atmel-AVR-Assembler [avra aus dem AUR](https://aur.archlinux.org/packages/avra/)
- AVR-Simulator [simavr aus dem \[community\]-Repo](https://www.archlinux.org/packages/community/i686/simavr/)
- GNU-Debugger für AVR [avr-gdb aus dem \[community\]-Repo](https://www.archlinux.org/packages/community/i686/avr-gdb/)

### Anleitung
Zunächst das asm-File mit `avra` kompilieren, z.B.
```bash
cd "Übung 6"
avra -I ../asm aufgabe3.asm
```
Im Order `../asm` befindet sich dabei die von `avra` benötigte Datei `m8def.inc`.

Dann kann der Simulator gestartet werden, z.B.:
```bash
simavr -g -m atmega8 -f 8 aufgabe3.hex
```

In einem anderen Terminal kann man nun den Debugger starten:
```bash
avr-gdb
```
Im Debugger kann man dann in den Assembler-Modus schalten und zum Simulator verbinden:
```gdb
layout asm
tar rem :1234
```

Mit dem GDB-Kommando `stepi` kann dann schrittweise der Programmablauf kontrolliert werden. Die Inhalte der Register kann man sich mit `info all-registers` ausgeben lassen. `quit` beendet das Debugging.

War der Programmablauf fehlerfrei, kann man nun das Programm auf den ASURO flashen, z.B.:
```bash
asuro-flashtool -ttyS0 aufgabe3.hex
```
