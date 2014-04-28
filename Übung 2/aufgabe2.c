#include "asuro.h"
#include <inttypes.h>

void TestAllLEDs(void)
{
	// Alle LEDs hintereinander aufblinken. Nur eine LED soll pro Zeiteinheit aktiviert sein und für 750ms aufleuchten. 
	FrontLED(ON);
	Msleep(750);
	FrontLED(OFF);
	BackLED(ON, OFF);
	Msleep(750);
	BackLED(OFF, ON);
	Msleep(750);
	BackLED(OFF, OFF);
	StatusLED(RED);
	Msleep(750);
	StatusLED(GREEN);
	Msleep(750);
	StatusLED(YELLOW);
	Msleep(750);
	StatusLED(OFF);
}

void allLEDs(unsigned char status)
{
	if ( status == ON )
	{
		FrontLED(ON);
		BackLED(ON, ON);
		StatusLED(RED);
	}
	else
	{
		FrontLED(OFF);
		BackLED(OFF, OFF);
		StatusLED(OFF);
	}
}
#define DOT blink(1, timeslot)
#define DASH blink(0, timeslot)

void blink(int status, const int timeslot) {
	allLEDs(ON);
	if ( status )
		Msleep(timeslot);
	else
		Msleep(3*timeslot);
	allLEDs(OFF);
	Msleep(timeslot);
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
	DOT; DOT; DOT;
	DASH; DASH; DASH;
	DOT; DOT; DOT;	
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
