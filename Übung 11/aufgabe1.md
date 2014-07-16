# Übung 11
## Frage 1 (20 Punkte)

*Einzelaufgabe:*

Bitte beantworten Sie kurz die folgenden Fragen. Sie benötigen hierfür das AVR Handbuch (welches Sie in den Kursunterlagen im Blackboard ﬁnden).
 
Nehmen Sie an, dass eine PWM-Einheit so konﬁguriert wurde, dass über eine regelmäßige, interruptbasierte Aktualisierung des OCR2-Referenzregisters das folgende periodische Signal am Pin OC2 generiert wird (siehe [dutycycle.jpg](dutycycle.jpg)):
 
Berechnen Sie den duty cycle und die Effektivspannung U<sub>eff</sub> unter der Annahme, dass t<sub>ein1</sub>=t<sub>aus1</sub>=28µs und t<sub>ein2</sub>=t<sub>aus2</sub>=14µs, sowie U<sub>IN</sub>=5V gegeben seien.

### Lösung

τ = 2*t<sub>ein1</sub> + 2*t<sub>ein2</sub>
  = 2*28µs + 2*14µs
  = 56µs + 28µs
  = 84µs
T = 2*t<sub>ein1</sub> + 2*t<sub>ein2</sub> + 2*t<sub>aus1</sub> + 2*t<sub>aus2</sub>
  = 4*28µs + 4*14µs
  = 112µs + 56µs
  = 168µs

Duty Cycle:
τ / T = 84µs/168µs
      = 0.5
U<sub>eff</sub> = U<sub>IN</sub> * τ / T
                = 5V * 0.5
                = 2.5V
