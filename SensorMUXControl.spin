{
  File:         SensorMUXControl

  Developer:    Kenichi Kato
  Platform:     Parallax USB Project Board (P1)
  Date:         09 Sep 2021
  V2:           19 Jan 2022
  Copyright (c) 2021, Singapore Institute of Technology
}

CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001   = _ConClkFreq / 1_000

CON
  _maxI2CDevice = 6             ' 0 to 7

  ACK = 0                       'Tx/Rx ready for more
  NAK = 1                       'Tx/Rx not ready for more
  stopConfirmTries = 3

OBJ
  ' Definition / Header files
  Def   : "RxBoardDef.spin"

  ' TCA9548A - I2C connection to ToF & Ultrasonic
  TCA   : "TCA9548Av2"   'I2C 1-to-8 Switch

  DBG   : "FullDuplexSerialExt.spin"

VAR
  long  cog, cogStack[128], stopConfirmCnt
  BYTE tof, ultra
PUB Main

    Start(1,0)
    TestallSensors

    return

PUB ActSC(tofMainMem, ultraMainMem, StopPtr)
  Stop
  cog := cognew(runAllSensors(tofMainMem, ultraMainMem, StopPtr), @cogStack) + 1

  return cog

PUB Start(tofMainMem, ultraMainMem)

' This function launches sensors units into new core

  Stop
  'cog := cognew(runAllSensors(tofMainMem, ultraMainMem), @cogStack) + 1

  return cog

PUB Stop

' Stop & Release Core

  if(cog)
    cogstop(~cog - 1 )    'stops and releases the cog used by the motor core

  return

PUB runAllSensors(tofMainMem, ultraMainMem, StopPtr) | i

' Main code running sensors retrieving & updating main memory
  stopConfirmCnt := 0
  ' Init TCA9548A
  TCA.PInit2
  Pause(100)

  ' Init ToF
  TCA.PSelect(0, 0)
  tofInit(0)
  Pause(500)

  TCA.PSelect(1, 0)
  tofInit(1)
  Pause(500)

  repeat

    ' ToF 1 - Front
    TCA.PSelect(0, 0)
    long[tofMainMem][0] := TCA.GetSingleRange(Def#ToFAdd)       'To get a one time distance measurement from the ToF Front
    Pause(1)
    if (long[tofMainMem][0] > 254)
      stopConfirmCnt += 1
      if stopConfirmCnt > stopConfirmTries                                       'Update Stop flag in Main OBJ
          BYTE[StopPtr] := TRUE

    ' ToF 1 - Back
    TCA.PSelect(1, 0)
    long[tofMainMem][1] := TCA.GetSingleRange(Def#ToFAdd)       'To get a one time distance measurement from the ToF Back
    Pause(1)
    if (long[tofMainMem][1] > 254)
      stopConfirmCnt += 1
      if stopConfirmCnt > stopConfirmTries                                       'Update Stop flag in Main OBJ
          BYTE[StopPtr] := TRUE

    ' Ultrasonic 1 - Front
    TCA.PSelect(2, 0)
    TCA.PWriteByte(2, Def#UltraAdd, $01)  '<-- Trigger Sensor
    Pause(30)
    long[ultraMainMem][0] := TCA.readHCSR04(2, Def#UltraAdd)*100/254
    Pause(1)
    TCA.resetHCSR04(2, Def#UltraAdd)
    if (long[ultraMainMem][0] < 300)
      stopConfirmCnt += 1
      if stopConfirmCnt > stopConfirmTries                                       'Update Stop flag in Main OBJ
          BYTE[StopPtr] := TRUE

    ' Ultrasonic 2 - Back
    TCA.PSelect(3, 0)
    TCA.PWriteByte(3, Def#UltraAdd, $01)  '<-- Trigger Sensor
    Pause(30)
    long[ultraMainMem][1] := TCA.readHCSR04(3, Def#UltraAdd)*100/254
    Pause(1)
    TCA.resetHCSR04(3, Def#UltraAdd)
    if (long[ultraMainMem][1] < 300)
      stopConfirmCnt += 1
      if stopConfirmCnt > stopConfirmTries                                       'Update Stop flag in Main OBJ
          BYTE[StopPtr] := TRUE


    ' Ultrasonic 3 - Left
    TCA.PSelect(4, 0)
    TCA.PWriteByte(4, Def#UltraAdd, $01)  '<-- Trigger Sensor
    Pause(30)
    long[ultraMainMem][2] := TCA.readHCSR04(4, Def#UltraAdd)*100/254
    Pause(1)
    TCA.resetHCSR04(4, Def#UltraAdd)
    if (long[ultraMainMem][2] < 300)
      stopConfirmCnt += 1
      if stopConfirmCnt > stopConfirmTries                                       'Update Stop flag in Main OBJ
          BYTE[StopPtr] := TRUE

    ' Ultrasonic 4 - Right
    TCA.PSelect(5, 0)
    TCA.PWriteByte(5, Def#UltraAdd, $01)  '<-- Trigger Sensor
    Pause(30)
    long[ultraMainMem][3] := TCA.readHCSR04(5, Def#UltraAdd)*100/254
    Pause(1)
    TCA.resetHCSR04(5, Def#UltraAdd)
     if (long[ultraMainMem][3] < 300)
      stopConfirmCnt += 1
      if stopConfirmCnt > stopConfirmTries                                       'Update Stop flag in Main OBJ
          BYTE[StopPtr] := TRUE

PRI tofInit(channel) | i

'Init ToF Sensors via TCP9548A

  case channel
    0:
      TCA.initVL6180X(Def#ToF1RST)
      TCA.ChipReset(1, Def#ToF1RST)
      Pause(500)
      TCA.FreshReset(Def#ToFAdd)
      TCA.MandatoryLoad(Def#ToFAdd)
      TCA.RecommendedLoad(Def#ToFAdd)
      TCA.FreshReset(Def#ToFAdd)

    1:
      TCA.initVL6180X(Def#ToF1RST)
      TCA.ChipReset(1, Def#ToF1RST)
      Pause(500)
      TCA.FreshReset(Def#ToFAdd)
      TCA.MandatoryLoad(Def#ToFAdd)
      TCA.RecommendedLoad(Def#ToFAdd)
      TCA.FreshReset(Def#ToFAdd)

  return

PUB readUltra(channel) | ackBit, clearBus

'Get a reading from Ultrasonic sensor

  TCA.PWriteByte(channel, Def#UltraAdd, $01)
  waitcnt(cnt + clkfreq/10)
  result := TCA.PReadLong(channel, Def#UltraAdd, $01)

  return result

PRI Pause(ms) | t

  t := cnt - 1088    ' sync with system counter
  repeat (ms #> 0)   ' delay must be > 0
    waitcnt(t += _Ms_001)

  return

PRI PauseMin(arg)

  repeat arg
    Pause(60000)

  return

PUB TestAllSensors | i


  DBG.Start(31, 30, 0, 115200)
  Pause(2000)

  ' Testing
  TCA.PInit2
  Pause(100)

  ' Testing both ToF & Ultrasonic
  ' Init ToF
  tofInit(0)
  tofInit(1)
  Pause(500)
  repeat
    DBG.Tx(0)

    repeat i from 0 to 1
      DBG.Str(String(13, 13, "Select Device: "))
      DBG.Dec(i)
      TCA.PSelect(i, 0)
      DBG.Str(String(13, "Init ToF... Reply: "))
      DBG.Bin(TCA.Debug_PWriteAccelReg(Def#ToFAdd, $16, %0101), 8)
      DBG.Str(String(13, "ToF Reading: "))
      DBG.Dec(TCA.GetSingleRange(Def#ToFAdd))

    repeat i from 2 to 5
      DBG.Str(String(13, 13, "Select Device: "))
      DBG.Dec(i)
      TCA.PSelect(i, 0)
      DBG.Str(String(13, "Init Ultra... Reply: "))
      DBG.Bin(TCA.Debug_PWriteAccelReg(Def#UltraAdd, $16, %0101), 8)
      DBG.Str(String(13, "Ultrasonic Reading:",13))
      TCA.PWriteByte(i, Def#UltraAdd, $01)  '<-- Trigger Sensor
      Pause(40)
      DBG.Dec(TCA.readHCSR04(i, Def#UltraAdd)*100/254)
      Pause(1)
      TCA.resetHCSR04(i, Def#UltraAdd)

    Pause(100)