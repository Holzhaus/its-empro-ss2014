#include "asuro.h"
#include <inttypes.h>

void TatueTata(void)
{
	//Der Asuro soll stehen bleiben, 5x die "Martinshorn" Tonfolge abspielen, dabei alle verfügbaren LEDs rot blinken lassen und den String "Tatue Tata" über die Infrarot-Schnitstelle versenden. 
	// Eine Iterations des Martinshorns soll so programmiert werden, dass für 500ms ein Ton mit einer Frequenz von 410Hz und dann für 500ms ein Ton mit einer Frequenz von 547Hz abgespielt wird.
	// Beide Töne sollen mit maximaler Amplitude 	abgespielt werden. Wiederholen Sie die Tonfolge 5x.
	// 1x Abspielen + 5x Wiederholen = 6x Abspielen 
	int i;
	for(i=0; i<6; i++)
	{
		StatusLED(RED);
		BackLED(ON,ON);
		FrontLED(ON);
		Sound(410,500,255);
		StatusLED(OFF);
		BackLED(OFF,OFF);
		FrontLED(OFF);
		Sound(547,500,255);
	}

}

int main()
{
	uint16_t n;
	unsigned char direction=FWD,inv_direction=RWD;
	// ASURO initialisieren
	Init();
	
	//Text aus FLASH ausgeben
	SerPrint_p(PSTR("Hello World!\n"));

	//Puffer im SRAM für Kommandos
	uint8_t buff;
	
	StatusLED(OFF);//GREEN,RED,YELLOW,OFF

	unsigned char tmpdir; // Temporäre Variable für den Richtungswechsel

	while(1)
	{
		SerRead(&buff,1,0);

		if(buff=='1')
		{
			StatusLED(RED);
		}
		else if(buff=='2')
		{
			StatusLED(GREEN);
		}
		else if(buff=='3')
		{
			StatusLED(YELLOW);
		}
		// Bei Eingabe von 'x':
		// Richtung vertauschen
		else if(buff=='x')
		{
			tmpdir = direction;
			direction = inv_direction;
			inv_direction = tmpdir;
		}
		// Bei Eingabe von 'w':
		// Vorwärts in Standardrichtung fahren
		else if(buff=='w')
		{
			MotorDir(direction,direction);
			MotorSpeed(255,255);
			Msleep(300);
			MotorSpeed(0,0);
		}
		// Bei Eingabe von 'a':
		// Linkskurve fahren
		else if(buff=='a')
		{
			MotorDir(direction,direction);
			MotorSpeed(0,255);
			Msleep(200);
			MotorSpeed(0,0);
		}
		// Bei Eingabe von 'd':
		// Rechtskurve fahren
		else if(buff=='d')
		{
			MotorDir(direction,direction);
			MotorSpeed(255,0);
			Msleep(200);
			MotorSpeed(0,0);
		}
		// Bei Eingabe von 's':
		// Rückwärts fahren
		else if(buff=='s')
		{
			MotorDir(inv_direction,inv_direction);
			MotorSpeed(255,255);
			Msleep(300);
			MotorSpeed(0,0);
		}
		// Bei Eingabe von 'h':
		// Stehen bleiben, sowie 6x Martinshorn abspielen und LEDs rot blinken. Dann 'Tatue Tata!' auf der seriellen Konsole abspielen
		else if(buff=='h')
		{
			MotorDir(BREAK, BREAK);
			MotorSpeed(0,0);
			TatueTata();
			SerPrint_p(PSTR("Tatue Tata!\n"));
		}
		// Sonst chill0rn
		else
		{
			StatusLED(OFF);
		}
	}	
	while(1); //Megasinnlos
	return 0;
}
