#include "asuro.h"

int main()
{
	int engineLeft, engineRight;

	// do ASURO initialization
	Init();

  // loop forever
	while (1)
	{
		// generate new speed levels for left and right engine
		engineLeft = 80;
		engineRight = 70;
		MotorDir(FWD,FWD);
		MotorSpeed(engineLeft,engineRight);
		// drive for the number of milliseconds specified by five-fold ctl
	
		
	}

	return -1;
}
