CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  ' Define pins and BAUD rate
  comRx = 11
  comTx = 12
  comBaud = 115_200
  Estop = 17

  ' Define Commands
  comStart = $7A
  comForward = $01
  comReverse = $02
  comTurnLeft = $03
  comTurnRight = $04
  comTopLeft = $06
  comTopRight = $07
  comBotLeft = $09
  comBotRight = $08
  comClockWise = $10
  comCountClockWise = $11
  comSideLeft = $12
  comSideRight = $13
  comStopAll = $0A

  ' Spd
  comSPDlow = $20
  comSPDmed = $25
  comSPDhigh = $30

  startspd = 30

  lowspd = 33
  medspd = 40
  highspd = 46
  staspd = 30

VAR
  long _Ms_001
  long CommCogID, CommCogStack[64]
  BYTE reply[4]
  BYTE cs
  long flag

OBJ
  Comm  : "FullDuplexSerial.spin"  ' UART Communication for control
  Term  : "FullDuplexSerial.spin"

' Declarations for the New Vision Sub-System and Mobility Sub-System

' Insert the actual code for the Vision Sub-System below
' Includes Pixy2CMU5/Tx Unit + MCU (Cortex-M)/Rx Unit
' MCU (Cortex-M) + Tx Unit

' Declarations for the New Mobility Sub-System

' Insert the actual code for the Mobility Sub-System below
' Includes MCU (Parallax P1) + Rx Unit
' Incorporates 4 x Ultrasonic & 2 x ToF Sensors + MUX + Controls
' Equipped with Mecanum Wheels + Encoders + Controls

PUB Main | receivedData[4], i
  Comm.start(comRx, comTx, 0, comBaud)
  Term.start(31, staspd, 0, comBaud)

  repeat
    Term.Str(String(13, 13, "Waiting"))
    reply[0] := Comm.Rx
    cs := 0
    flag := TRUE
    if(reply[0] == comStart)
      repeat while(flag == TRUE)
        reply[1] := Comm.Rx
        case reply[1]
          comForward:
            Term.Str(String(13, 13, "Move: Forward"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comReverse:
            Term.Str(String(13, 13, "Move: Reverse"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comTurnLeft:
            Term.Str(String(13, 13, "Move: TurnLeft"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comTurnRight:
            Term.Str(String(13, 13, "Move: TurnRight"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comTopLeft:
            Term.Str(String(13, 13, "Move: TopLeft"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comTopRight:
            Term.Str(String(13, 13, "Move: TopRight"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comBotLeft:
            Term.Str(String(13, 13, "Move: BotLeft"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comBotRight:
            Term.Str(String(13, 13, "Move: BotRight"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comClockWise:
            Term.Str(String(13, 13, "Move: ClockWise"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comCountClockWise:
            Term.Str(String(13, 13, "Move: CountClockWise"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comSideLeft:
            Term.Str(String(13, 13, "Move: SideLeft"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comSideRight:
            Term.Str(String(13, 13, "Move: SideRight"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE
          comStopAll:
            Term.Str(String(13, 13, "Move: StopAll"))
            Term.Dec(reply[1])
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                Term.Str(String(13, 13, "Speed: "))
                Term.Dec(reply[2])
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Term.Str(String(13, 13, "CheckSum: "))
                  Term.Dec(cs)
                  Comm.Tx(cs)
                  reply[0] := 0
                  flag := FALSE


PUB Dec(value) | i, x
{{
   Transmit the ASCII string equivalent of a decimal value

   Parameters: dec = the numeric value to be transmitted
   return:     none

   example usage: serial.Dec(-1_234_567_890)

   expected outcome of example usage call: Will print the string "-1234567890" to a listening terminal.
}}

  x := value == NEGX                                    'Check for max negative
  if value < 0
    value := ||(value+x)                                'If negative, make positive; adjust for max negative

  i := 1_000_000_000                                    'Initialize divisor

  repeat 10                                             'Loop for 10 digits
    if value => i
      value //= i                                       'and digit from value
      result~~                                          'flag non-zero found
    elseif result or i == 1
    i /= 10                                             'Update divisor

PUB Init(DirPtr, Spd, MsVal)  ' Initialise Core for Communications
  _Ms_001 := MsVal
  StopCore  ' Prevent stacking drivers

' Initialize the Vision Sub-System
' Place the code for initializing the Vision Sub-System below this comment

' Initialize the Mobility Sub-System
' Place the code for initializing the Mobility Sub-System below this comment

  CommCogID := cognew(Start(DirPtr, Spd), @CommCogStack)  ' Initialise new cog with Start method
  return CommCogID

PUB Start(DirPtr, Spd) | receivedData

  BYTE[DirPtr] := 0
  ' Initialize communication
  Comm.start(comRx, comTx, 0, comBaud)

  repeat
    reply[0] := Comm.Rx
    cs := 0
    flag := TRUE
    if(reply[0] == comStart)
      repeat while(flag == TRUE)
        reply[1] := Comm.Rx
        case reply[1]
          comForward:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 1
                  reply[0] := 0
                  flag := FALSE
          comReverse:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 2
                  reply[0] := 0
                  flag := FALSE
          comTurnLeft:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 3
                  reply[0] := 0
                  flag := FALSE
          comTurnRight:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 4
                  reply[0] := 0
                  flag := FALSE
          comTopLeft:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 5
                  reply[0] := 0
                  flag := FALSE
          comTopRight:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 6
                  reply[0] := 0
                  flag := FALSE
          comBotLeft:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 7
                  reply[0] := 0
                  flag := FALSE
          comBotRight:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 8
                  reply[0] := 0
                  flag := FALSE
          comClockWise:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 9
                  reply[0] := 0
                  flag := FALSE
          comCountClockWise:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 10
                  reply[0] := 0
                  flag := FALSE
          comSideLeft:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 11
                  reply[0] := 0
                  flag := FALSE
          comSideRight:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 12
                  reply[0] := 0
                  flag := FALSE
          comStopAll:
            repeat while(flag == TRUE)
              reply[2] := Comm.Rx
              if(reply[2] => 0 AND reply[2] =< 100)
                if(reply[2] == comSPDlow)
                  LONG[Spd] := lowspd
                elseif(reply[2] == comSPDmed)
                  LONG[Spd] := medspd
                elseif(reply[2] == comSPDhigh)
                  LONG[Spd] := highspd
                cs := reply[0] ^ reply[1] ^ reply[2]
                reply[3] := Comm.Rx
                if(cs == reply[3])
                  Comm.Tx(cs)
                  BYTE[DirPtr] := 0
                  reply[0] := 0
                  flag := FALSE

PUB StopCore  ' Stop active cog
  if CommCogID  ' Check for an active cog
    cogStop(CommCogID~)  ' Stop the cog and zero out ID
  return CommCogID

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return