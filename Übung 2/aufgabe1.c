#include "asuro.h"
#include <inttypes.h>

//Geben Sie hier die ermittelten Offsets aus der ersten Übung an
#define MOTOR_OFFSET_LINKS 80
#define MOTOR_OFFSET_RECHTS 65

//Rufen Sie in dieser Funktion MotorSpeed() mit korrgierten Parametern auf
//Ziel ist, dass ein Aufruf von bspw. MotorSpeedSet(100,100) den Asuro geradeaus fahren lässt
void MotorSpeedSet(uint8_t left, uint8_t right)
{
	float l,r;
	l = ((float)left/255)*(255-MOTOR_OFFSET_LINKS);
	r = ((float)right/255)*(255-MOTOR_OFFSET_LINKS);
	left = l + MOTOR_OFFSET_LINKS;
	right = r + MOTOR_OFFSET_RECHTS;
	MotorSpeed(left,right)
}

void DriveTriangle()
{
	int i;
	MotorDir(FWD, FWD);
	for(i=0; i<3; i++) {
		// Fahren
		MotorSpeedSet(100,100);
		msleep(1000);
		// Drehen
		MotorSpeedSet(0,100);
		msleep(1000);
	Break();
}

void DriveRectangle()
{
	int i;
	MotorDir(FWD, FWD);
	for(i=0; i<4; i++) {
		// Fahren
		MotorSpeedSet(100,100);
		msleep(1000);
		// Drehen
		MotorSpeedSet(0,100);
		msleep(800);
	Break();
}

void Break()
	// kurz stehen bleiben
	MotorDir(BREAK, BREAK);
	MotorSpeed(255,255);
	Msleep(500);
	MotorSpeed(0,0);

int main(void)
{
	//Asuro initialisieren
	Init();
	
	DriveTriangle();

	DriveRectangle();

	while(1);
	return 0;
}
