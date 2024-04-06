{{

  File: Definition File / Header

  Developer: Kenichi Kato
  Copyright (c) 2021, Singapore Institute of Technology
  Platform: Parallax USB Project Board (P1)
  Date: 09 Sep 2021
    2022-01-10: Connection changed to add TCA9548A & Pixy2

}}
CON
  '' RC Signals
  rc_1    = 13
  rc_2    = 14
  rc_3    = 15
  rc_4    = 16
  rc_5    = 17
  rc_6    = 18


  '' Pixy2CMU5
  pixyRx      = 0
  pixyTx      = 1
  pixyBaud    = 19_200  '57_600  '115_200
  ''-- Tracking Constants
  pixyHeadSize  = 6
  pixySigMax    = 5
  pixyBlkMax    = 10


  '' TCA - Actual pin def in TCA9548A file
  '' ToF1=0, ToF2=1, UltraFront=2, UltraBack=3, UltraLeft=4, UltraRight=5
  tcaSCL    = 8
  tcaSDA    = 9
  tcaRST    = 10
  tcaAdd    = $70

  '' Motor
  ' RoboClaw 1
  R1S1    = 3 '2 '10
  R1S2    = 2 '3 '11
  ' RoboClaw 2
  R2S1    = 5 '4 '12
  R2S2    = 4 '5 '13
  ' Simple Serial
  SSBaud  = 57_600

  '' Comm / XBee
  STM_Rx    = 11 'XBeeRx    = 4
  STM_Tx    = 12 'XBeeTx    = 5
  STM_Baud  = 115_200 'XBeeBaud  = 9600
  STM_CSKey = $7F


  '' Debug LED
  dbgLED  = 27


  '' [ Hardware Definitions ]
  '' ToF - (Old & Not Used except for RST pins)
  ToF1SCL = 0
  ToF1SDA = 1
  ToF2SCL = 2
  ToF2SDA = 3
  ToF1RST = 6 '12   '14
  ToF2RST = 7 '13   '15
  ToFAdd  = $29

  '' Ultrasonic - (Old & Not Used)
  UltraAdd   = $57
  Ultra1Trig = 6  ' SCL
  Ultra1Echo = 7  ' SDA
  Ultra2Trig = 8  ' SCL
  Ultra2Echo = 9  ' SDA




PUB EmptySub
  return