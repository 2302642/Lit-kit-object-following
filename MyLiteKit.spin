{
  ***************************************
  Mobile Platform - Build 2 (Sensor Test)
  ***************************************

  Main Modules (Track 7):
  1. Platform Chassis X 1
  2. Roboclaw Motor Controllers X 2
  3. Power Regulator Board X 1
  4. Rechargable Batteries X 3
  5. Propeller Project Board USB X 1
  6. HC-SR04 X 1
  7. VL6180X X 1
  8. Driver: Servo32V9.spin, UltrasonicSensor.spin, ToFSensor.spin, i2cDriver.spin

  Revision: 1.0
  Author: SIT
  Date: 1st Nov 2023
  Log:
    Date: Desc
}
CON
  _clkmode = xtal1 + pll16x                                      'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001 = _ConClkFreq / 1_000

VAR
  long  MCID, SCID, CCID, Stop, Spd
  BYTE  Dir,tofMem,ultraMem
                                                                                'Stop flag

OBJ

  Sensor        : "SensorMUXControl.spin"                           ' Ultrasonic and ToF Sensors
  Motor         : "MecanumControl.spin"                            ' RoboClaw Controller
  Comm          : "Comm2Control.spin"
  'Term          : "FullDuplexSerial.spin"                       'Pins 31, 30 for Rx, Tx - For Debugging, use Term.Dec(var) to check value of a variable

PUB Main

  'Declaration & Initialisation
  'Term.Start(31, 30, 0, 115200)
  'Pause(2000)
  'SCID := Sensor.ActSC(@tofMem, @ultraMem,@Stop)                                     'Initialise Sensor Driver
  MCID := Motor.ActMC(_Ms_001, @Dir, @Spd)                                      'Initialise Motor Driver
  CCID := Comm.Init(@Dir, @Spd, _Ms_001)

  {Pause(100)

  repeat while Stop == False                                     'Wait until obstacle detected

  Motor.Stop                                                    'Disengage Motor cog
  Motor.AllMotorStop                                            'Ensure all motor stopped

  repeat}

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return