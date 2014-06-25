.include "m8def.inc"

#define GRUPPENNR ggg
#define SPEEDL lll
#define SPEEDR rrr

#define GRUPPENNR_ADDR 42
#define SPEEDL_ADDR 150
#define SPEEDR_ADDR 152

;Bitte tragen Sie hier das von readout.hex berechnete GEHEIMNIS ein. GEHEIMNIS = ???
.CSEG
to_main: rjmp main
data:
.DB GRUPPENNR,0,SPEEDL,SPEEDR
main:


<Fügen Sie hier ihren Code ein>


end:
   nop
   rjmp end

