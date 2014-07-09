#include "asuro.h"
#include <inttypes.h>

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
		// Fügen Sie hier die noch fehlenden Kommandos ein
		// Für das Martinshorn Kommando verwenden Sie bitte die Funktion Sound() der AsuroLib. Schauen Sie sich die Dokumentation dieser Funktion an.
		// Eine Iterations des Martinshorns soll so programmiert werden, dass für 500ms ein Ton mit einer Frequenz von 410Hz und dann für 500ms ein Ton mit einer Frequenz von 547Hz abgespielt wird.
		// Beide Töne sollen mit maximaler Amplitude abgespielt werden. Wiederholen Sie die Tonfolge 5x.
		
		
		
		
		else
		{
			StatusLED(OFF);
		}
	}	
	while(1);
	return 0;
}
