#include "asuro.h"

int randomValue(int x)
{
	int a=57, b=113, m=256;
	x = (a * x + b) % m;
	return x;
}

int main()
{
	unsigned char ctl, engineLeft, engineRight;

	// do ASURO initialization
	Init();

	// initialize control value
	ctl = 100;

  // loop forever
	while (1)
	{
		// generate new speed levels for left and right engine
		engineLeft = (unsigned char)randomValue(ctl);
		engineRight = (unsigned char)randomValue(engineLeft);

		// go straight forward when ctl is between 0 and 31
		if (ctl <32)
		{
			MotorDir(FWD,FWD);
			MotorSpeed(engineLeft,engineLeft);
		}
		// go a curve in forward direction in case that ctl is between 32 and 63
		else if (ctl <64)
		{
			MotorDir(FWD,FWD);
			MotorSpeed(engineLeft,engineRight);
		}
		// cycle right when ctl between 64 and 127
		else if (ctl <128)
		{
			MotorDir(FWD, RWD);
			MotorSpeed(engineLeft,engineRight);
		}
		// cycle left when ctl is between 128 and 191
		else if (ctl <192)
		{
			MotorDir(RWD, FWD);
			MotorSpeed(engineLeft,engineRight);
		}
		// go straight back when ctl is between 192 and 223
		else if (ctl <224)
		{
			MotorDir(RWD,RWD);
			MotorSpeed(engineRight,engineRight);
		}
		// go straight back  in case that ctl is between 224 and 255
		else
		{
			MotorDir(RWD,RWD);
			MotorSpeed(engineRight,engineRight);
		}

		// drive for the number of milliseconds specified by five-fold ctl
		Msleep(5*ctl);

		// generate a new control word
		ctl = (unsigned char)randomValue(engineRight);
	}

	return -1;
}
