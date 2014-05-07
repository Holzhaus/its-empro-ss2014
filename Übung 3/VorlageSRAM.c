#include <avr/io.h>
#include <inttypes.h>

int main(void){
	//Array mit 8 Werten der XOR Summe berechnet werden soll
	const uint8_t SRAMarray[8]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};

	uint8_t i;
	uint8_t sum=0;

	//ToDo: XORieren Sie hier die Werte aus SRAMarray in einer Schleife auf

	
	//Diese Zuweisung verhindert, dass sum durch den Compiler "wegoptimiert" wird
	PORTB=sum;
	
	while(1);
	return 0;
}
