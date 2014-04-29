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
	MotorSpeed(left,right);
}

void StopDriving(void)
{
	// kurz stehen bleiben
	MotorDir(BREAK, BREAK);
	MotorSpeed(255,255);
	Msleep(500);
	MotorSpeed(0,0);
}

void DriveTriangle(void)
{
	int i;
	MotorDir(FWD, FWD);
	for(i=0; i<3; i++) {
		// Fahren
		MotorSpeedSet(100,100);
		Msleep(1000);
		// Drehen
		MotorDir(BREAK,FWD);
		MotorSpeedSet(0,100);
		Msleep(1000);
	}
	StopDriving();
}

void DriveRectangle(void)
{
	int i;
	MotorDir(FWD, FWD);
	for(i=0; i<4; i++) {
		// Fahren
		MotorSpeedSet(100,100);
		Msleep(1000);
		// Drehen
		MotorSpeedSet(0,100);
		Msleep(800);
	}
	StopDriving();
}

void blink(int i)
{
	int j;
	for (j=0;j<i;j++) {
		Msleep(500);
		BackLED(ON,OFF);
		Msleep(500);
		BackLED(OFF,OFF);
	}
}

int main(void)
{
	//Asuro initialisieren
	Init();

	
	MotorDir(FWD,FWD);
	//MotorSpeed(80,65);
	int i;
	for(i=5; i<=10; i++) {
		MotorSpeed(0,0);
		Msleep(250);
		blink(i);
		MotorSpeed(i*10,70);
		Msleep(2000);
	}
	
	//DriveTriangle();

	//DriveRectangle();

	while(1);
	return 0;
}
