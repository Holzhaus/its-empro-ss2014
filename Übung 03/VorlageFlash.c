#include <avr/io.h>
#include <avr/pgmspace.h>
#include <inttypes.h>

//korrigieren Sie diese Deklaration, so dass das Array im Flash-Speicher und nicht im SRAM des Mikrocontrollers abgelegt wird
const uint8_t abc[8]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};

int main(void){
	uint8_t i;
	uint8_t sum=0;

	//ToDo: lesen Sie die Werte aus dem Array im Flashspeicher aus und XORieren Sie die Werte wie in der vorherigen Aufgabe auf


	//Diese Zuweisung verhindert, dass sum durch den Compiler "wegoptimiert" wird
	PORTB=sum;
	while(1);
	return 0;
}
