#include <avr/io.h>
#include <avr/pgmspace.h>
#include <inttypes.h>

//korrigieren Sie diese Deklaration, so dass das Array im Flash-Speicher und nicht im SRAM des Mikrocontrollers abgelegt wird
const uint8_t abc[8] PROGMEM ={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80}; //PROGMEM-Makro hinzugefügt

int main(void){
	uint8_t i;
	uint8_t sum=0;

	//ToDo: lesen Sie die Werte aus dem Array im Flashspeicher aus und XORieren Sie die Werte wie in der vorherigen Aufgabe auf
	int len = (sizeof(abc)/sizeof(abc[0])); //Business as usual
	for(i = 0; i < len; i++){
		sum ^= pgm_read_byte(&(abc[i])); //abc[i] aus dem Flash laden (anstatt aus dem SRAM)
	}

	//Diese Zuweisung verhindert, dass sum durch den Compiler "wegoptimiert" wird
	PORTB=sum;
	while(1);
	return 0;
}
