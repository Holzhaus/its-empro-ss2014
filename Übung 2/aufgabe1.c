#include "asuro.h"
#include <inttypes.h>

//Geben Sie hier die ermittelten Offsets aus der ersten �bung an
#define MOTOR_OFFSET_LINKS 0
#define MOTOR_OFFSET_RECHTS 0

//Rufen Sie in dieser Funktion MotorSpeed() mit korrgierten Parametern auf
//Ziel ist, dass ein Aufruf von bspw. MotorSpeedSet(100,100) den Asuro geradeaus fahren l�sst
void MotorSpeedSet(uint8_t left, uint8_t right)
{
	//ToDo

}

void DriveTriangle()
{
	//ToDo

}

void DriveRectangle()
{
	//ToDo

}

int main(void)
{
	//Asuro initialisieren
	Init();

	//ToDo: ein Dreieck und ein Rechteck fahren
	//Hinweis: um den Asuro f�r eine gewisse Dauer warten zu lassen, verwenden Sie bitte die Funktion
	//Msleep() aus der AsuroLib. Ein Aufruf von Msleep(1500) l�sst den Asuro bspw. 1500ms warten
	//bevor der n�chste Befehl ausgef�hrt wird.
	
	DriveTriangle();
	
	// Zwischen den beiden Figuren kurz stehen bleiben
	MotorDir(BREAK, BREAK);
	MotorSpeed(255,255);
	Msleep(500);
	MotorSpeed(0,0);

	DriveRectangle();

	while(1);
	return 0;
}
