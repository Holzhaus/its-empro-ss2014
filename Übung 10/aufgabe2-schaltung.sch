<Qucs Schematic 0.0.17>
<Properties>
  <View=-59,-69,967,710,0.7,0,0>
  <Grid=10,10,1>
  <DataSet=aaa.tmp.dat>
  <DataDisplay=aaa.tmp.dpl>
  <OpenDisplay=1>
  <Script=aaa.tmp.m>
  <RunScript=0>
  <showFrame=0>
  <FrameText0=Title>
  <FrameText1=Drawn By:>
  <FrameText2=Date:>
  <FrameText3=Revision:>
</Properties>
<Symbol>
</Symbol>
<Components>
  <AND Y7 1 680 300 -26 27 0 0 "2" 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <gatedDlatch Y8 1 430 270 -31 48 0 0 "6" 0 "5" 0 "1 ns" 0>
  <AND Y9 1 680 470 -26 27 0 0 "2" 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <gatedDlatch Y10 1 430 440 -31 48 0 0 "6" 0 "5" 0 "1 ns" 0>
  <AND Y11 1 670 640 -26 27 0 0 "2" 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <gatedDlatch Y12 1 420 610 -31 48 0 0 "6" 0 "5" 0 "1 ns" 0>
  <AND Y2 1 680 140 -26 27 0 0 "2" 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <gatedDlatch Y6 1 430 110 -31 48 0 0 "6" 0 "5" 0 "1 ns" 0>
  <Inv Y13 1 210 90 -26 27 0 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <Inv Y14 1 330 250 -26 27 0 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <Inv Y15 1 440 520 -26 27 0 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <Inv Y16 1 550 610 -26 27 0 0 "1 V" 0 "0" 0 "10" 0 "old" 0>
  <.Digi Digi1 1 740 -40 0 51 0 0 "TimeList" 1 "20ns" 1 "VHDL" 1>
  <DigiSource S1 1 -10 90 -35 16 0 0 "1" 1 "low" 0 "3ns; 5ns" 1 "1 V" 0>
  <DigiSource S2 1 130 130 -35 16 0 0 "2" 1 "low" 0 "1ns; 1ns" 1 "1 V" 0>
</Components>
<Wires>
  <710 300 790 300 "" 0 0 0 "">
  <480 250 480 270 "" 0 0 0 "">
  <640 290 650 290 "" 0 0 0 "">
  <480 270 640 270 "" 0 0 0 "">
  <640 270 640 290 "" 0 0 0 "">
  <710 470 790 470 "" 0 0 0 "">
  <480 420 480 440 "" 0 0 0 "">
  <640 460 650 460 "" 0 0 0 "">
  <480 440 640 440 "" 0 0 0 "">
  <640 440 640 460 "" 0 0 0 "">
  <330 420 380 420 "" 0 0 0 "">
  <330 420 330 520 "" 0 0 0 "">
  <330 520 410 520 "" 0 0 0 "">
  <560 480 560 520 "" 0 0 0 "">
  <560 480 650 480 "" 0 0 0 "">
  <700 640 780 640 "" 0 0 0 "">
  <470 590 470 610 "" 0 0 0 "">
  <630 630 640 630 "" 0 0 0 "">
  <470 610 520 610 "" 0 0 0 "">
  <630 610 630 630 "" 0 0 0 "">
  <320 590 370 590 "" 0 0 0 "">
  <320 590 320 690 "" 0 0 0 "">
  <320 690 550 690 "" 0 0 0 "">
  <550 650 550 690 "" 0 0 0 "">
  <550 650 640 650 "" 0 0 0 "">
  <710 140 790 140 "" 0 0 0 "">
  <480 90 480 110 "" 0 0 0 "">
  <640 130 650 130 "" 0 0 0 "">
  <480 110 640 110 "" 0 0 0 "">
  <640 110 640 130 "" 0 0 0 "">
  <210 130 380 130 "" 0 0 0 "">
  <330 90 380 90 "" 0 0 0 "">
  <330 90 330 190 "" 0 0 0 "">
  <330 190 560 190 "" 0 0 0 "">
  <560 150 560 190 "" 0 0 0 "">
  <560 150 650 150 "" 0 0 0 "">
  <210 130 210 310 "" 0 0 0 "">
  <210 460 380 460 "" 0 0 0 "">
  <210 460 210 630 "" 0 0 0 "">
  <210 630 370 630 "" 0 0 0 "">
  <80 90 80 250 "" 0 0 0 "">
  <80 250 300 250 "" 0 0 0 "">
  <80 250 80 420 "" 0 0 0 "">
  <80 420 330 420 "" 0 0 0 "">
  <80 420 80 590 "" 0 0 0 "">
  <80 590 320 590 "" 0 0 0 "">
  <80 90 180 90 "" 0 0 0 "">
  <240 90 330 90 "" 0 0 0 "">
  <360 250 380 250 "" 0 0 0 "">
  <650 310 650 340 "" 0 0 0 "">
  <300 250 300 340 "" 0 0 0 "">
  <300 340 650 340 "" 0 0 0 "">
  <470 520 560 520 "" 0 0 0 "">
  <580 610 630 610 "" 0 0 0 "">
  <-10 90 80 90 "" 0 0 0 "">
  <130 130 210 130 "" 0 0 0 "">
  <380 290 380 310 "" 0 0 0 "">
  <210 310 210 460 "" 0 0 0 "">
  <210 310 380 310 "" 0 0 0 "">
  <790 300 790 300 "OUT2" 820 270 0 "">
  <790 470 790 470 "OUT3" 820 440 0 "">
  <780 640 780 640 "OUT4" 810 610 0 "">
  <210 130 210 130 "CLK" 240 100 0 "">
  <80 90 80 90 "IN" 110 60 0 "">
  <790 140 790 140 "OUT1" 820 110 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
