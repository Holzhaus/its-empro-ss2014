#include "asuro.h"
#include <inttypes.h>

void TestAllLEDs(void)
{
	// ToDo: Lassen Sie alle LEDs hintereinander aufblinken. Nur eine LED soll pro Zeiteinheit aktiviert sein und für 750ms aufleuchten. 
	// Reihenfolge:
	// FrontLED
	// BackLED links
	// BackLED rechts
	// StatusLED rot
	// StatusLED grün
	// StatusLED gelb
	
}

void sendSOS(const int timeslot)
{
	// ToDo: Alle LEDs sollen in roter Farbe ein SOS-Signal in Morse-Code (. . . - - - . . .) aussenden.
	// Im Morse-Code wird zwischen Punkten und Strichen unterschieden, die unterschiedlich lange dauern.
	// Ein Punkt dauert eine Zeiteinheit, ein Strich dauert drei Zeiteinheiten.
	// Die Punkte bzw. Striche, die jeweils ein Zeichen darstellen, werden durch eine Pause von einer Zeiteinheit getrennt.
	// Die Pause zwischen den Darstellungen zweier verschiedener Zeichen beträgt drei Zeiteinheiten.
	// S: . . . 
	// O: - - -
	// S: . . .
	
}

int main(void)
{
	// Morse-Zeiteinheit auf 240ms setzen
	const int timeslot=240;

	//Asuro initialisieren
	Init();

	TestAllLEDs();

	sendSOS(timeslot);

	while(1);
	return 0;
}
