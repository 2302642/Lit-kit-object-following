{{
Author: Kenichi Kato
Copyright: Singapore Institute of Technology
2022-Jan: Converted to TCA9548A 
Derived from original code: PCA9548Av1 in OBEX. Original copyright below. Adopting MIT Licensing
  24-Jan-2022:
    TCA9548A Library,
Information on Original Author moved to bottom of this code   
}}
CON
  '' To keep for bus clock calculation
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000                                      'use 5MHz crystal
   
  clk_freq = (_clkmode >> 6) * _xinfreq                     'system freq as a constant
  mSec     = clk_freq / 1_000                               'ticks in 1ms
  uSec     = clk_freq / 1_000_000                           'ticks in 1us
   
CON
  '*** *** *** *** PLEASE TAKE NOTE *** *** *** ***  
  '*** Please change the value to your setup
  '*** *** *** *** PLEASE TAKE NOTE *** *** *** ***  
  _PCA9548A_SCL   = 8   'SCL
  _PCA9548A_SDA   = 9   'SDA (must be increment of SCL            
  _PCA9548A_Rst   = 10   'Reset line, Usually is High, 
  _totI2CDevices  = 6
  _addPCA9548A    = $70         'Address of PCA9548A - Hardwired A0, A1, A2
                                'Refer to datasheet, fixed MSB 1110 & A2, A1, A0 (L,L,L)
  '*** *** *** *** PLEASE TAKE NOTE *** *** *** ***  
 
CON
  'Originals from Basic_I2C_Driver v1.1
   ACK      = 0                        ' I2C Acknowledge
   NAK      = 1                        ' I2C No Acknowledge
   Xmit     = 0                        ' I2C Direction Transmit
   Recv     = 1                        ' I2C Direction Receive
   BootPin  = 28                       ' I2C Boot EEPROM SCL Pin
   EEPROM   = $A0                      ' I2C EEPROM Device Address

CON
 'VL6180X REGISTERS (not complete)
 '=======================================================
  ID_MODEL_ID                          = $00
  IDENTIFICATION_MODEL_ID              = $B4    ' VL6180X

  SYSTEM_MODE_GPIO0                    = $10
  SYSTEM_MODE_GPIO1                    = $11
  SYSTEM_HISTORY_CTR                   = $12
  SYSTEM_INTERRUPT_CONFIG_GPIO         = $14
  SYSTEM_INTERRUPT_CLEAR               = $15
  SYSTEM_FRESH_OUT_OF_RESET            = $16
  SYSTEM_GROUPED_PARAMETER_HOLD        = $17

  SYSRG_START                          = $18
  SYSRG_THRESH_HIGH                    = $19
  SYSRG_THRESH_LOW                     = $1A
  SYSRG_INTERMEASUREMENT_PERIOD        = $1B
  SYSRG_MAX_CONVERGENCE_TIME           = $1C
  SYSRG_XTALK_COMPENSATION_RATE        = $1E
  SYSRG_XTALK_VALID_HEIGHT             = $21
  SYSRG_EARLY_CONVERGENCE_EST          = $22
  SYSRG_PART_TO_PART_RNG_OFFSET        = $24
  SYSRG_RNG_IGNORE_VALID_HEIGHT        = $25
  SYSRG_RANGE_IGNORE_THRESHOLD         = $26
  SYSRG_MAX_AMBIENT_LEVEL_MULT         = $2C
  SYSRG_RANGE_CHECK_ENABLES            = $2D
  SYSRG_VHV_RECALIBRATE                = $2E
  SYSRG_VHV_REPEAT_RATE                = $31

  SYSALS_START                         = $38
  SYSALS_THRESH_HIGH                   = $3A
  SYSALS_THRESH_LOW                    = $3C
  SYSALS_ANALOGUE_GAIN                 = $3F
  SYSALS_INTEGRATION_PERIOD            = $40
  SYSALS_INTERMEASUREMENT_PERIOD       = $3E

  RESULT_RANGE_STATUS                  = $4D

  RESULT_INT_STATUS_GPIO               = $4F
  RESULT_ALS_VAL                       = $50
  READOUT_AVERAGE_SAMPLE_PERIOD        = $10A
  RESULT_RANGE_VAL                     = $62

  FIRMWARE_RESULT_SCALER               = $120

  SLAVE_DEVICE_ADDRESS                 = $212           'For setting new chip address

  INTERLEAVED_MODE_ENABLE              = $2A3

PUB PInit2
  return Initialize(_PCA9548A_SCL) 

PUB PReset : ackbit
{{If you're using the Reset Pin, else Pull-Up this pin with a resistor}}
  'Reseting the PCA9548A
  OUTA[_PCA9548A_Rst]~~
  DIRA[_PCA9548A_Rst]~~
  OUTA[_PCA9548A_Rst]~
  OUTA[_PCA9548A_Rst]~~
  return

PUB PInit
{{Initialise the I2C devices}}
  'Reseting the PCA9548A
  OUTA[_PCA9548A_Rst]~
  DIRA[_PCA9548A_Rst]~~
  DIRA[_PCA9548A_Rst]~
  'Init the PCA9548A 
  Initialize(_PCA9548A_SCL)
  waitcnt(cnt + clkfreq/100)
  return  

DAT 'ToF-VL6180X
PUB initVL6180X(_PINrs)
{{ Init I2C & reset toggle pins }}  
  OUTA[_PINrs]~
  waitcnt(cnt + clkfreq/100)
  DIRA[_PINrs]~~
  waitcnt(cnt + clkfreq/100)
  DIRA[_PINrs]~
  return
PUB FreshReset(iChipAddr) | testVal
{{ Reset prior to loading setting - based on Standard Ranging }}
{{ Mod to TCA9548A }}
  testVal := ReadWord(_PCA9548A_SCL, iChipAddr, SYSTEM_FRESH_OUT_OF_RESET)
  return

PUB SetFreshReset(iChipAddr)
{{ Mod to TCA9548A }}
  WriteWord(_PCA9548A_SCL, iChipAddr, SYSTEM_FRESH_OUT_OF_RESET, $00)
  return

PUB MandatoryLoad(iChipAddr)
{{ Mandatory register loads, ref Application Notes }}
{{ Mod to TCA9548A }}
  WriteByteA16(iChipAddr,$0207, $01)
  WriteByteA16(iChipAddr,$0208, $01)
  WriteByteA16(iChipAddr,$0096, $00)
  WriteByteA16(iChipAddr,$0097, $fd)
  WriteByteA16(iChipAddr,$00e3, $00)
  WriteByteA16(iChipAddr,$00e4, $04)
  WriteByteA16(iChipAddr,$00e5, $02)
  WriteByteA16(iChipAddr,$00e6, $01)
  WriteByteA16(iChipAddr,$00e7, $03)
  WriteByteA16(iChipAddr,$00f5, $02)
  WriteByteA16(iChipAddr,$00d9, $05)
  WriteByteA16(iChipAddr,$00db, $ce)
  WriteByteA16(iChipAddr,$00dc, $03)
  WriteByteA16(iChipAddr,$00dd, $f8)
  WriteByteA16(iChipAddr,$009f, $00)
  WriteByteA16(iChipAddr,$00a3, $3c)
  WriteByteA16(iChipAddr,$00b7, $00)
  WriteByteA16(iChipAddr,$00bb, $3c)
  WriteByteA16(iChipAddr,$00b2, $09)
  WriteByteA16(iChipAddr,$00ca, $09)
  WriteByteA16(iChipAddr,$0198, $01)
  WriteByteA16(iChipAddr,$01b0, $17)
  WriteByteA16(iChipAddr,$01ad, $00)
  WriteByteA16(iChipAddr,$00ff, $05)
  WriteByteA16(iChipAddr,$0100, $05)
  WriteByteA16(iChipAddr,$0199, $05)
  WriteByteA16(iChipAddr,$01a6, $1b)
  WriteByteA16(iChipAddr,$01ac, $3e)
  WriteByteA16(iChipAddr,$01a7, $1f)
  WriteByteA16(iChipAddr,$0030, $00)
  return

PUB RecommendedLoad(iChipAddr)
{{ 'Recommended register loads }}
{{ Mod to TCA9548A }}
'Interrupts on Conversion Complete
  WriteByteA16(iChipAddr, SYSTEM_INTERRUPT_CONFIG_GPIO, $24 )                   'Set GPIO1 high when sample complete
  WriteByteA16(iChipAddr, SYSTEM_MODE_GPIO1, $10)                               'Set GPIO1 high when sample complete
  WriteByteA16(iChipAddr, READOUT_AVERAGE_SAMPLE_PERIOD, $30)                   'Set Avg sample period
  WriteByteA16(iChipAddr, SYSALS_ANALOGUE_GAIN, $46)                            'Set the ALS gain
  WriteByteA16(iChipAddr, SYSRG_VHV_REPEAT_RATE, $FF)                           'Set auto calibration period (Max = 255)/(OFF = 0)
  WriteByteA16(iChipAddr, SYSALS_INTEGRATION_PERIOD, $63)                       'Set ALS integration time to 100ms
  WriteByteA16(iChipAddr, SYSRG_VHV_RECALIBRATE, $01)                           'Perform a single temperature calibration

'Interval of continuos sampling, and sample ready signal
  WriteByteA16(iChipAddr, SYSRG_INTERMEASUREMENT_PERIOD, $09)                   'Set default ranging inter-measurement period to 100ms
  WriteByteA16(iChipAddr, SYSALS_INTERMEASUREMENT_PERIOD, $0A)                  'Set default ALS inter-measurement period to 100ms
  WriteByteA16(iChipAddr, SYSTEM_INTERRUPT_CONFIG_GPIO, $24)                    'Configures interrupt on New Sample Ready threshold event

'Convergence, integration, gain, range, ans stuff
  WriteByteA16(iChipAddr, SYSRG_MAX_CONVERGENCE_TIME, $32)
  WriteByteA16(iChipAddr, SYSRG_RANGE_CHECK_ENABLES, $10 | $01)
  WriteByteA16(iChipAddr, SYSRG_EARLY_CONVERGENCE_EST + 1, $7B )
  WriteByteA16(iChipAddr, SYSALS_INTEGRATION_PERIOD + 1, $64)                   'Limit to 255 milliseconds since only writing the LSB
  WriteByteA16(iChipAddr, READOUT_AVERAGE_SAMPLE_PERIOD, $30)
  WriteByteA16(iChipAddr, SYSALS_ANALOGUE_GAIN, $40)                            'ALS gain= 20
  WriteByteA16(iChipAddr, FIRMWARE_RESULT_SCALER, $01)
  return

PUB RecommendedLoad2(iChipAddr)
{{ Beta Testing Settings }}
{{ Mod to TCA9548A }}
  WriteByteA16(iChipAddr, $0011, $10)   ' Enables polling for (New Sample ready) when measurement completes
  WriteByteA16(iChipAddr, $010a, $30)   ' Set the averaging sample peroid
  WriteByteA16(iChipAddr, $003f, $46)   ' Sets the light and dark gain (upper nibble)
  WriteByteA16(iChipAddr, $0031, $FF)   ' Sets the # of range measurements after which auto calibration
  WriteByteA16(iChipAddr, $0034, $63)   ' Sets ALS integration time 100 ms
  WriteByteA16(iChipAddr, $002e, $01)   ' perform a single temperature calibration of the ranging sensor
  '' Optional
  WriteByteA16(iChipAddr, $001b, $09)   ' Set default ranging inter-measurement peroid to 100 ms
  WriteByteA16(iChipAddr, $003e, $31)   ' Set default ALS inter-measurement peroid to 500 ms
  WriteByteA16(iChipAddr, $0014, $24)   ' Configures interrupt on (New Sample Ready threshold event)
  return

PUB ChipReset(EndState, rstPin)
{{ 'Reset this chip and give it time to wake up }}
{{ Mod to TCA9548A }}
  'OUTA[PINrs]:= 0
  OUTA[rstPin]:= 0
  WAITCNT((clkfreq/1000) + cnt)
  'OUTA[PINrs]:= EndState
  OUTA[rstPin]:= EndState
  return

PUB IsThere(iChipAddr)
{{ Verify that the particular chip is responding to it's address on the bus}}
{{ Mod to TCA9548A }}
  return ReadByte(_PCA9548A_SCL, iChipAddr, ID_MODEL_ID)

PUB GetSingleRange(iChipAddr) | status
{{ Set and start single shot ranging }}
{{ Mod to TCA9548A }}
  status:= 0
  WriteByteA16(iChipAddr, SYSRG_START, $01)

  repeat until status == $04                                                        'Repeat until ranging status equals New Sample Ready (bit2=1)
    status:= (ReadByteA16(iChipAddr, RESULT_INT_STATUS_GPIO) & $07)              'Check the result interrupt status, and extract the ranging status

  result:= ReadByteA16(iChipAddr, RESULT_RANGE_VAL)                             'Return value
  WriteByteA16(iChipAddr, SYSTEM_INTERRUPT_CLEAR, $07)                          'Clear the 3 interrupt flags, make ready for next
  Stop(_PCA9548A_SCL) 
  
  return result

PUB GetRange(iChipAddr)
{{ Mod to TCA9548A }}
  result := ReadByte(_PCA9548A_SCL, iChipAddr, RESULT_RANGE_VAL)
  return result

PUB RangeErrors(iChipAddr)
{{ Mod to TCA9548A }}
  return ReadByte(_PCA9548A_SCL, iChipAddr, RESULT_RANGE_STATUS)
  
  
DAT     'Actual gainx10 lookup table
          ALSgain LONG 200, 103, 52, 26, 17, 13, 10, 400                             
    
DAT     'HC-SR05
PUB readHCSR04(I2CDevice, I2CDeviceAdd) | ackbit
  ifnot PSelect(I2CDevice, 0) > 0     '<- Start,SlaveAdd,CtrReg,Stop 
    Start(_PCA9548A_SCL)          'Start Condition
    ackbit := Write(_PCA9548A_SCL, I2CDeviceAdd<<1)
    ackbit := Write(_PCA9548A_SCL, $00)
    Stop(_PCA9548A_SCL)           'Stop Condition
    result := PIn(I2CDevice, I2CDeviceAdd)
  else
    result := -1
  return result

PUB resetHCSR04(I2CDevice, I2CDeviceAdd) | ackbit
  ifnot PSelect(I2CDevice, 0) > 0     '<- Start,SlaveAdd,CtrReg,Stop 
    Start(_PCA9548A_SCL)          'Start Condition
    ackbit := Write(_PCA9548A_SCL, I2CDeviceAdd<<1)
    ackbit := Write(_PCA9548A_SCL, $01)
    Stop(_PCA9548A_SCL)           'Stop Condition
    result := PIn(I2CDevice, I2CDeviceAdd)
  else
    result := -1
  return


DAT     '3AD Related
PUB PWriteAccelReg(I2CDevice, I2CDeviceAdd, cmdReg, data) | ackbit 
  PSelect(I2CDevice, 0)     '<- Start,SlaveAdd,CtrReg,Stop
  
  Start(_PCA9548A_SCL)          'Start Condition
  ackbit := Write(_PCA9548A_SCL, I2CDeviceAdd<<1)
  ackbit := (ackbit << 1) | ackbit:=Write(_PCA9548A_SCL, cmdReg)
  ackbit := (ackbit << 1) | ackbit:=Write(_PCA9548A_SCL, data)
  return ackbit
  Stop(_PCA9548A_SCL)           'Stop Condition

PUB Debug_PWriteAccelReg(I2CDeviceAdd, cmdReg, data) | ackbit
  Start(_PCA9548A_SCL)          'Start Condition
  ackbit := Write(_PCA9548A_SCL, I2CDeviceAdd<<1)
  'ackbit := (ackbit << 1) | ackbit:=Write(_PCA9548A_SCL, cmdReg)
  ackbit := (ackbit << 1) | Write(_PCA9548A_SCL, cmdReg)
  'ackbit := (ackbit << 1) | ackbit:=Write(_PCA9548A_SCL, data)
  ackbit := (ackbit << 1) | Write(_PCA9548A_SCL, data)
  'return (ackbit==ACK)
  return ackbit   'I want to see the ackbit  
  Stop(_PCA9548A_SCL)           'Stop Condition


PUB Get3AD_X8(I2CDevice, I2CDeviceAdd)
  return Get3AD_1Byte(I2CDevice, I2CDeviceAdd, $06)
  

PUB Get3AD_1Byte(I2CDevice, I2CDeviceAdd, cmdReg) | v, m
  m := Get3AD(I2CDevice, I2CDeviceAdd, cmdReg)
  v := m>>8
  return (v<<24)~>24  'result is signed 8 bit...

PUB Get3AD(I2CDevice, I2CDeviceAdd, cmdReg) | ackbit, x
  'Debugging
  DIRA[19..20]~~
  
  ifnot PSelect(I2CDevice, 0)>0     '<- Start,SlaveAdd,CtrReg,Stop 
    Start(_PCA9548A_SCL)          'Start Condition
    ackbit := Write(_PCA9548A_SCL, I2CDeviceAdd<<1)

    ackbit := Write(_PCA9548A_SCL, cmdReg)
    if ackbit > 0
      OUTA[19]~~
    else
      OUTA[19]~
    
    Stop(_PCA9548A_SCL)           'Stop Condition
     
    x := PIn(I2CDevice, I2CDeviceAdd)
    'Debugging
    OUTA[20]~

  else
    'Debugging
    OUTA[20]~~
    
    x := -1
  return x

PUB PIn(I2CDevice, I2CDeviceAdd):data|ackbit
  PSelect(I2CDevice, 0)    '<- Function for Start,SlaveAdd,CtrReg,Stop

  Start(_PCA9548A_SCL)          'Start Condition
  ackbit:=Write(_PCA9548A_SCL, (I2CDeviceAdd<<1)+1)
    if (ackbit==ACK)  
      data:=Read3AD(_PCA9548A_SCL, ACK)   '<--NOTE
    else
      data:=-1   'return negative to indicate read failure
  Stop(_PCA9548A_SCL)           'Stop Condition
  return data


PUB Read3AD(SCL, ackbit): data | SDA
'' Read in i2c data, Data byte is output MSB first, SDA data line is
'' valid only while the SCL line is HIGH.  SCL and SDA left in LOW state.

   SDA := SCL + 1
   data := 0
   dira[SDA]~                          ' Make SDA an input
   repeat 8                            ' Receive data from SDA
      outa[SCL]~~                      ' Sample SDA when SCL is HIGH
      data := (data << 1) | ina[SDA]
      outa[SCL]~
   outa[SDA] := ackbit                 ' Output ACK/NAK to SDA
   dira[SDA]~~
   outa[SCL]~~                         ' Toggle SCL from LOW to HIGH to LOW
   outa[SCL]~
   dira[SDA]~
   repeat 8                            ' Receive data from SDA
      outa[SCL]~~                      ' Sample SDA when SCL is HIGH
      data := (data << 1) | ina[SDA]
      outa[SCL]~
   outa[SDA] := NAK'ackbit                 ' Output ACK/NAK to SDA
   
   dira[SDA]~~
   outa[SCL]~~                         ' Toggle SCL from LOW to HIGH to LOW
   outa[SCL]~
   outa[SDA]~                          ' Leave SDA driven LOW

DAT     'Tried Objectising PCA9548A
PUB PReadByte(I2CDevice, I2CDeviceAdd, ackbit)
{{I2CDevice = Number from 0 to 7
Data = Byte-sized}}

  Start(_PCA9548A_SCL)          'Start Condition
  PAddress(1)                   'Slave Address, ReadWriteBit: 1=Read, 0=Write
  PWriteDeviceSel(I2CDevice)    'Control Register
  result := Read(_PCA9548A_SCL, ackbit)        'Read from Device  
  Stop(_PCA9548A_SCL)          'Stop Condition
  return result

PUB PReadLong(I2CDevice, I2CDeviceAdd, ackbit)
{{I2CDevice = Number from 0 to 7
Data = Long}}

  Start(_PCA9548A_SCL)          'Start Condition
  PAddress(1)                   'Slave Address, ReadWriteBit: 1=Read, 0=Write
  PWriteDeviceSel(I2CDevice)    'Control Register
  'result := Read(_PCA9548A_SCL, ackbit)        'Read from Device
  result := ReadLong(_PCA9548A_SCL, I2CDeviceAdd, ackbit)
  Stop(_PCA9548A_SCL)          'Stop Condition
  return result


PUB PSelect(I2CDevice, RWBit) : ackByte
{{I2CDevice = Number from 0 to 7}}

  ackByte := 0
  
  Start(_PCA9548A_SCL)          'Start Condition
  ackByte := ackByte<<1 | PAddress(RWBit)               'Slave Address, ReadWriteBit: 1=Read, 0=Write
  ackByte := ackByte<<1 | PWriteDeviceSel(I2CDevice)    'Control Register
  Stop(_PCA9548A_SCL)           'Stop Condition


''------------ Debugging Use Only ------------  
PUB PSelect_SlaveAdd(RWBit) : ackbit
  Start(_PCA9548A_SCL)          'Start Condition
  ackbit := PAddress(RWBit)               'Slave Address, ReadWriteBit: 1=Read, 0=Write
  Stop(_PCA9548A_SCL)           'Stop Condition


''------------ Debugging Use Only ------------ 
PUB PWriteByte(I2CDevice, I2CDeviceAdd, Data)
{{I2CDevice = Number from 0 to 7
Data = Byte-sized}}

  Start(_PCA9548A_SCL)          'Start Condition
  PAddress(0)                   'Slave Address, ReadWriteBit: 1=Read, 0=Write
  PWriteDeviceSel(I2CDevice)    'Control Register
  Write(_PCA9548A_SCL, Data)    'Write to Device
  Stop(_PCA9548A_SCL)          'Stop Condition

PUB PWriteWord(I2CDevice, Data)
{{I2CDevice = Number from 0 to 7
Data = Word-sized}}

  Start(_PCA9548A_SCL)          'Start Condition
  PAddress(0)                   'Slave Address, ReadWriteBit: 1=Read, 0=Write
  PWriteDeviceSel(I2CDevice)    'Control Register
  Write(_PCA9548A_SCL, Data)    'Write to Device
  Stop(_PCA9548A_SCL)          'Stop Condition
 
PUB PAddress(ReadWriteBit)
{{ReadWriteBit: 1=Read, 0=Write}}
  return Write(_PCA9548A_SCL, _addPCA9548A<<1 | ReadWriteBit)

PUB PWriteDeviceSel(I2C_Device)
{{I2C_Device is from 0 to 7, which are 1 to 8 devices connected to PCA9548A}}
  return Write(_PCA9548A_SCL, 1<<I2C_Device)

DAT     'Original Basic_I2C_Driver
PUB Initialize(SCL) | SDA              ' An I2C device may be left in an
   SDA := SCL + 1                      '  invalid state and may need to be
   outa[SCL] := 1                       '   reinitialized.  Drive SCL high.
   dira[SCL] := 1
   dira[SDA] := 0                       ' Set SDA as input
   repeat 9
      outa[SCL] := 0                    ' Put out up to 9 clock pulses
      outa[SCL] := 1
      if ina[SDA]                      ' Repeat if SDA not driven high
         quit                          '  by the EEPROM

PUB Start(SCL) | SDA                   ' SDA goes HIGH to LOW with SCL HIGH
   SDA := SCL + 1
   outa[SCL]~~                         ' Initially drive SCL HIGH
   dira[SCL]~~
   outa[SDA]~~                         ' Initially drive SDA HIGH
   dira[SDA]~~
   outa[SDA]~                          ' Now drive SDA LOW
   outa[SCL]~                          ' Leave SCL LOW
  
PUB Stop(SCL) | SDA                    ' SDA goes LOW to HIGH with SCL High
   SDA := SCL + 1
   outa[SCL]~~                         ' Drive SCL HIGH
   outa[SDA]~~                         '  then SDA HIGH
   dira[SCL]~                          ' Now let them float
   dira[SDA]~                          ' If pullups present, they'll stay HIGH

PUB Write(SCL, data) : ackbit | SDA
'' Write i2c data.  Data byte is output MSB first, SDA data line is valid
'' only while the SCL line is HIGH.  Data is always 8 bits (+ ACK/NAK).
'' SDA is assumed LOW and SCL and SDA are both left in the LOW state.
   SDA := SCL + 1
   ackbit := 0 
   data <<= 24
   repeat 8                            ' Output data to SDA
      outa[SDA] := (data <-= 1) & 1
      outa[SCL]~~                      ' Toggle SCL from LOW to HIGH to LOW
      outa[SCL]~
   dira[SDA]~                          ' Set SDA to input for ACK/NAK
   outa[SCL]~~
   ackbit := ina[SDA]                  ' Sample SDA when SCL is HIGH
   outa[SCL]~
   outa[SDA]~                          ' Leave SDA driven LOW
   dira[SDA]~~

PUB Read(SCL, ackbit): data | SDA
'' Read in i2c data, Data byte is output MSB first, SDA data line is
'' valid only while the SCL line is HIGH.  SCL and SDA left in LOW state.
   SDA := SCL + 1
   data := 0
   dira[SDA]~                          ' Make SDA an input
   repeat 8                            ' Receive data from SDA
      outa[SCL]~~                      ' Sample SDA when SCL is HIGH
      data := (data << 1) | ina[SDA]
      outa[SCL]~
   outa[SDA] := ackbit                 ' Output ACK/NAK to SDA
   dira[SDA]~~
   outa[SCL]~~                         ' Toggle SCL from LOW to HIGH to LOW
   outa[SCL]~
   outa[SDA]~                          ' Leave SDA driven LOW

PUB ReadPage(SCL, devSel, addrReg, dataPtr, count) : ackbit
'' Read in a block of i2c data.  Device select code is devSel.  Device starting
'' address is addrReg.  Data address is at dataPtr.  Number of bytes is count.
'' The device select code is modified using the upper 3 bits of the 19 bit addrReg.
'' Return zero if no errors or the acknowledge bits if an error occurred.
   devSel |= addrReg >> 15 & %1110
   Start(SCL)                          ' Select the device & send address
   ackbit := Write(SCL, devSel | Xmit)
   ackbit := (ackbit << 1) | Write(SCL, addrReg >> 8 & $FF)
   ackbit := (ackbit << 1) | Write(SCL, addrReg & $FF)          
   Start(SCL)                          ' Reselect the device for reading
   ackbit := (ackbit << 1) | Write(SCL, devSel | Recv)
   repeat count - 1
      byte[dataPtr++] := Read(SCL, ACK)
   byte[dataPtr++] := Read(SCL, NAK)
   Stop(SCL)
   return ackbit

PUB ReadByte(SCL, devSel, addrReg) : data
'' Read in a single byte of i2c data.  Device select code is devSel.  Device
'' starting address is addrReg.  The device select code is modified using the
'' upper 3 bits of the 19 bit addrReg.  This returns true if an error occurred.
   if ReadPage(SCL, devSel, addrReg, @data, 1)
      return -1

PUB ReadWord(SCL, devSel, addrReg) : data
'' Read in a single word of i2c data.  Device select code is devSel.  Device
'' starting address is addrReg.  The device select code is modified using the
'' upper 3 bits of the 19 bit addrReg.  This returns true if an error occurred.
   if ReadPage(SCL, devSel, addrReg, @data, 2)
      return -1

PUB ReadLong(SCL, devSel, addrReg) : data
'' Read in a single long of i2c data.  Device select code is devSel.  Device
'' starting address is addrReg.  The device select code is modified using the
'' upper 3 bits of the 19 bit addrReg.  This returns true if an error occurred.
'' Note that you can't distinguish between a return value of -1 and true error.
   if ReadPage(SCL, devSel, addrReg, @data, 4)
      return -1

PUB WritePage(SCL, devSel, addrReg, dataPtr, count) : ackbit
'' Write out a block of i2c data.  Device select code is devSel.  Device starting
'' address is addrReg.  Data address is at dataPtr.  Number of bytes is count.
'' The device select code is modified using the upper 3 bits of the 19 bit addrReg.
'' Most devices have a page size of at least 32 bytes, some as large as 256 bytes.
'' Return zero if no errors or the acknowledge bits if an error occurred.  If
'' more than 31 bytes are transmitted, the sign bit is "sticky" and is the
'' logical "or" of the acknowledge bits of any bytes past the 31st.
   devSel |= addrReg >> 15 & %1110
   Start(SCL)                          ' Select the device & send address
   ackbit := Write(SCL, devSel | Xmit)
   ackbit := (ackbit << 1) | Write(SCL, addrReg >> 8 & $FF)
   ackbit := (ackbit << 1) | Write(SCL, addrReg & $FF)          
   repeat count                        ' Now send the data
      ackbit := ackbit << 1 | ackbit & $80000000 ' "Sticky" sign bit         
      ackbit |= Write(SCL, byte[dataPtr++])
   Stop(SCL)
   return ackbit

PUB WriteByte(SCL, devSel, addrReg, data)
'' Write out a single byte of i2c data.  Device select code is devSel.  Device
'' starting address is addrReg.  The device select code is modified using the
'' upper 3 bits of the 19 bit addrReg.  This returns true if an error occurred.
   if WritePage(SCL, devSel, addrReg, @data, 1)
      return true
   ' james edit - wait for 5ms for page write to complete (80_000 * 5 = 400_000)      
   waitcnt(400_000 + cnt)      
   return false

PUB WriteWord(SCL, devSel, addrReg, data)
'' Write out a single word of i2c data.  Device select code is devSel.  Device
'' starting address is addrReg.  The device select code is modified using the
'' upper 3 bits of the 19 bit addrReg.  This returns true if an error occurred.
'' Note that the word value may not span an EEPROM page boundary.
   if WritePage(SCL, devSel, addrReg, @data, 2)
      return true
   ' james edit - wait for 5ms for page write to complete (80_000 * 5 = 400_000)
   waitcnt(400_000 + cnt)      
   return false

PUB WriteLong(SCL, devSel, addrReg, data)
'' Write out a single long of i2c data.  Device select code is devSel.  Device
'' starting address is addrReg.  The device select code is modified using the
'' upper 3 bits of the 19 bit addrReg.  This returns true if an error occurred.
'' Note that the long word value may not span an EEPROM page boundary.
   if WritePage(SCL, devSel, addrReg, @data, 4)
      return true
   ' james edit - wait for 5ms for page write to complete (80_000 * 5 = 400_000)      
   waitcnt(400_000 + cnt)      
   return false

PUB WriteWait(SCL, devSel, addrReg) : ackbit
'' Wait for a previous write to complete.  Device select code is devSel.  Device
'' starting address is addrReg.  The device will not respond if it is busy.
'' The device select code is modified using the upper 3 bits of the 18 bit addrReg.
'' This returns zero if no error occurred or one if the device didn't respond.
   devSel |= addrReg >> 15 & %1110
   Start(SCL)
   ackbit := Write(SCL, devSel | Xmit)
   Stop(SCL)
   return ackbit


' *************** JAMES'S Extra BITS *********************
   
PUB devicePresent(SCL,deviceAddress) : ackbit
  ' send the deviceAddress and listen for the ACK
   Start(SCL)
   ackbit := Write(SCL,deviceAddress | 0)
   Stop(SCL)
   if ackbit == ACK
     return true
   else
     return false

PUB writeLocation(SCL,device_address, register, value)
  start(SCL)
  write(SCL,device_address)
  write(SCL,register)
  write(SCL,value)  
  stop (SCL)

PUB readLocation(SCL,device_address, register) : value
  start(SCL)
  write(SCL,device_address | 0)
  write(SCL,register)
  start(SCL)
  write(SCL,device_address | 1)  
  value := read(SCL,NAK)
  stop(SCL)
  return value     

DAT     ' Extracted from standard i2c
PUB WriteByteA16(ChipAddr, RegAddr, Value)                          'Write a byte to specified chip and 16bit register address

   IF CallChip(ChipAddr << 1)== ACK                                 'Shift left 1 to add on the read/write bit, default 0 (write)
     WriteBus(RegAddr.BYTE[1])                                      'MSB
     WriteBus(RegAddr.BYTE[0])                                      'LSB
     WriteBus(Value)
     Stop(_PCA9548A_SCL)

PUB ReadByteA16(ChipAddr, RegAddr) | Value                          'Read a byte from specified chip and 16bit register address

   IF CallChip(ChipAddr << 1)== ACK                                 'Check if chip responded
     WriteBus(RegAddr.BYTE[1])                                      'MSB
     WriteBus(RegAddr.BYTE[0])                                      'LSB
     Start(_PCA9548A_SCL)                                                          'Restart for reading
     WriteBus(ChipAddr << 1 | 1 )                                   'address again, but with the read/write bit set to 1 (read)
     Value:= ReadBus(NAK)
     Stop(_PCA9548A_SCL)
     RETURN Value
   ELSE
     RETURN FALSE

PUB CallChip(ChipAddr) | acknak, t                                  'Address the chip until it acknowledges or timeout

  t:= CNT                                                           'Set start time
  REPEAT
     Start(_PCA9548A_SCL)                                                          'Prepare chips for responding
     acknak:= WriteBus(ChipAddr)                                    'Address the chip
     IF CNT > t+ 10*mSec                                            'and break if timeout
       RETURN NAK
  UNTIL acknak == ACK                                               'or until it acknowledges
  RETURN ACK

PUB ReadBus(acknak) | BusByte                                       'Clock in  8 bits from the bus

  DIRA[_PCA9548A_SCL+1] := 0                                                 'Float SDA to read input bits

  REPEAT 8
    DIRA[_PCA9548A_SCL] := 0                                               'clock the bus
    WAITPEQ(|<_PCA9548A_SCL,|<_PCA9548A_SCL, 0)                                   'check/ wait for SCL to be released
    BusByte := (BusByte << 1) | INA[_PCA9548A_SCL+1]                         'read the bit
    DIRA[_PCA9548A_SCL] := 1                                               'and leave SCL low

  DIRA[_PCA9548A_SCL+1] := !acknak                                           'output nak if finished, ack if more reads
  DIRA[_PCA9548A_SCL] := 0                                                 'clock the bus
  DIRA[_PCA9548A_SCL] := 1                                                 'and leave SCL low

  RETURN BusByte
  
PUB WriteBus(BusByte) | acknak                                      'Clock out 8 bits to the bus

   BusByte := (BusByte ^ $FF) << 24                                 'XOR all bits with '1' to invert them, then shift left to bit 31
   REPEAT 8                                                         '(output the bits as inverted because DIRA:= 1 gives pin= '0')
     DIRA[_PCA9548A_SCL+1] := BusByte <-= 1                                  'send msb first and bitwise rotate left to send the next bits
     DIRA[_PCA9548A_SCL] := 0                                              'clock the bus
     DIRA[_PCA9548A_SCL] := 1                                              'and leave SCL low

   DIRA[_PCA9548A_SCL+1] := 0                                                'Float SDA to read ack bit
   DIRA[_PCA9548A_SCL] := 0                                                'clock the bus
   acknak := INA[_PCA9548A_SCL+1]                                            'read ack bit
   DIRA[_PCA9548A_SCL] := 1                                                'and leave SCL low

   RETURN acknak

DAT     'Original Author & Terms of Use: MIT License
{{
=================================================================================================
  File....... PCA9548Av1 (8-Channel I2C Switch with Reset)
  Purpose.... Propeller to control up to 8 I2C Devices
  Author..... MacTuxLin
                Copyright (c) 2011 
                -- see below for terms of use
  E-mail..... MacTuxLin@gmil.com
  Started.... 08 Feb 2011
  Updated....
        v0.1    Started designing this code for use to comm with 5 accelerometers in my current project.
                Using the original Basic_I2C_Driver v1.1, I've basically added another layer to
                work with this I2C switch with reset
=================================================================================================
}}
{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

}}