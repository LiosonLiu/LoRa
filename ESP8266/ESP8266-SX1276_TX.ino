/*
Hardware-ESP8266:
1.SPI 
    Definition 	SX1276		ESP8266			ESP8266 cuttrnt
	a.MISO		PIN10		GPIO12		-	LED GREEN		-SPI
	b.MOSI		PIN11		GPIO13		-	LED BLUE		-SPI
	c.SCK		PIN9		GPIO14(SCL)	-					-SPI
	d.CS		PIN12		GPIO16		-					-SPI , GPIO15 - DEAD
	***Note:
			SX1276 MISO patch to ESP8266 MISO, so does MOSI, do not exchange. 
			GPIO15 as CS pin, but not functinal for ESP8266
2.Indication	
	a.TX Ind	DIO0		GPIO0							-TXD indication	

*/
#include <SPI.h>
//int led 			= 13;
int SPI_CS_PIN 		= 16; 
String content 		= "";
char character;
int DIO0_PIN 		= 0;
int DIO5_PIN 		= 5;
int DEBUG_PIN		= 10;
byte currentMode 	= 0x81;
byte msgBase 		= 1;
char payload[] 		= "EXOSITE00000000000000000000000";

#define REG_FIFO                    0x00
#define REG_OPMODE                  0x01
#define REG_FIFO_ADDR_PTR           0x0D 
#define REG_FIFO_TX_BASE_ADDR       0x0E
#define REG_FIFO_RX_BASE_ADDR       0x0F
#define REG_FIFO_RX_CURRENT_ADDR    0x10
#define REG_IRQ_FLAGS_MASK          0x11
#define REG_IRQ_FLAGS               0x12
#define REG_RX_NB_BYTES             0x13
#define REG_RX_TIME_OUT				0x1F
#define REG_PREAMBLE_LENGTH_H		0x20
#define REG_PREAMBLE_LENGTH_L		0x21
#define REG_PAYLOAD_LENGTH          0x22
#define REG_HOP_PERIOD              0x24
#define REG_DIO_MAPPING_1           0x40
#define REG_DIO_MAPPING_2           0x41
#define REG_LR_PADAC				0x4D


// MODES
#define LoRa_MODE_SLEEP             0x80
#define LoRa_MODE_STANDBY           0x81
#define LoRa_MODE_FSTX				0x82
#define LoRa_MODE_TX                0x83
#define LoRa_MODE_FSRX				0x84
#define LoRa_MODE_RX_CONTINUOS      0x85
#define LoRa_MODE_RX_SINGLE		    0x86

#define IMPLICIT_MODE               0x0C

//RF Frequency
#define	FREQ23_16					0x06
#define	FREQ15_8					0x07
#define	FREQ7_0						0x08
// POWER AMPLIFIER CONFIG
#define REG_PA_CONFIG               0x09
#define PA_MAX_BOOST                0xFF
#define PA_MED_BOOST                0xF9
#define PA_LOW_BOOST                0xF6
#define PA_OFF_BOOST                0x80

//Over load current protection
#define REG_OCP						0x0A

// LOW NOISE AMPLIFIER
#define REG_LNA                     0x0C
#define LNA_MAX_GAIN                0x23  // 0010 0011
#define LNA_OFF_GAIN                0x00

//Bandwidth &Coding rate
#define REG_MODEM_CONFIG1           0x1D
const unsigned char BandwidthTable[10] =	{0,1,2,3,4,5,6,7,8,9};	//7.8KHz,10.4KHz,15.6KHz,20.8KHz,31.2KHz,41.7KHz,62.5KHz,125KHz,250KHz,500KHz
const unsigned char CodingRateTable[4] =	{1,2,3,4};				//4/5,4/6,4/7,4/8
#define Bandwidth (BandwidthTable[7]<<4)
#define CodingRate (CodingRateTable[1]<<1)

//SpreadingFactor
#define REG_MODEM_CONFIG2           0x1E
#define SpreadingFactor				6
const unsigned char SpreadingFactorTable[7] =	{6,7,8,9,10,11,12};	//64/128/256/512/1024/2048/4096 chips/symble
const unsigned char Freq433Table[3] = {0x85,0x3b,0x13};	//433Mhz

//Globale Variable
unsigned char PayloadLength=30;

//===========================
void setup() 
//===========================
{                
  // initialize the pins
  pinMode(SPI_CS_PIN, OUTPUT);
  //pinMode(led, OUTPUT);  
  pinMode(DEBUG_PIN, OUTPUT);
  pinMode(DIO0_PIN, INPUT);
  Serial.begin(115200);
  SPI.setFrequency(1000000);
  SPI.begin();  
  delay(3000); 										// Wait for me to open serial monitor
  setLoRaMode();									// LoRa mode   
}

//===========================
void loop()
//===========================
 {
// 	setLoRaMode();
// 	delay(500);
// 	readLoRaMode();
// 	delay(500);

/*
char tmp[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
for(byte i = 0;i<msgBase;i++)
  	{
    tmp[i] = payload[i]; 
  	}
  msgBase++;
  if(msgBase>PayloadLength)
  	msgBase = 1;   	
*/  	
  sendData(payload);
  delay(1000);
}

//===========================
void sendData(char buffer[])
//===========================
{
Serial.print("Sending: ");
Serial.println(buffer);  

setMode(LoRa_MODE_STANDBY);	
writeRegister(REG_LR_PADAC,0X87);			//Tx for 20dBm
writeRegister(REG_HOP_PERIOD,0X00);			//Disabled
writeRegister(REG_IRQ_FLAGS,0xFF);			//Clear Irq
writeRegister(REG_IRQ_FLAGS_MASK,0xF7);		//Open TxDone interrupt	  
writeRegister(REG_FIFO_TX_BASE_ADDR, 0x00); //Update the address ptr to the current tx base address
writeRegister(REG_FIFO_ADDR_PTR, 0x00);  

digitalWrite(SPI_CS_PIN, LOW);  
SPI.transfer(REG_FIFO | 0x80);				// tell SPI which address you want to write to 
for (int i = 0; i < (PayloadLength-1); i++)				// loop over the payload and put it on the buffer 
	{
    SPI.transfer(buffer[i]);
  	}
  digitalWrite(SPI_CS_PIN, HIGH);  
  setMode(LoRa_MODE_TX);					// go into transmit mode  
  
  while(digitalRead(DIO0_PIN) == 0)			// once TxDone has flipped, everything has been sent
  	{
  	delay(100);	
  	} 
  writeRegister(REG_IRQ_FLAGS, 0x08); 		// clear the flags 0x08 is the TxDone flag
 
}

//===========================
byte readRegister(byte addr)
//===========================
{
  digitalWrite(SPI_CS_PIN, LOW);
  SPI.transfer(addr & 0x7F);
  byte regval = SPI.transfer(0);
  digitalWrite(SPI_CS_PIN, HIGH);
  return regval;
}

//===========================
void writeRegister(byte addr, byte value)
//===========================
{
  digitalWrite(SPI_CS_PIN, LOW);
  SPI.transfer(addr | 0x80); // OR address with 10000000 to indicate write enable;
  SPI.transfer(value);
  digitalWrite(SPI_CS_PIN, HIGH);
}

//===========================
void setMode(byte newMode)
//===========================
{
if(newMode == currentMode)
	return;    
switch (newMode) 
	{
    case LoRa_MODE_SLEEP:
    	Serial.println("Changing to Sleep Mode"); 
      	writeRegister(REG_OPMODE, newMode);
      	currentMode = newMode; 
      	break;  
    case LoRa_MODE_STANDBY:
    	Serial.println("Changing to Standby Mode");
    	writeRegister(REG_OPMODE, newMode);
    	currentMode = newMode; 
    	break;      		      	
    case LoRa_MODE_RX_CONTINUOS:
    	Serial.println("Changing to Receive Continous Mode");
    	writeRegister(REG_PAYLOAD_LENGTH,PayloadLength);
    	writeRegister(REG_PA_CONFIG, PA_OFF_BOOST);  	// TURN PA OFF FOR RECIEVE??
    	writeRegister(REG_LNA, LNA_MAX_GAIN);  			// MAX GAIN FOR RECIEVE
    	writeRegister(REG_OPMODE, newMode);
    	currentMode = newMode; 
    	break;
    case LoRa_MODE_TX: 
    	Serial.println("Changing to Transmit Mode");
    	writeRegister(REG_PAYLOAD_LENGTH,PayloadLength);
    	writeRegister(REG_LNA, LNA_OFF_GAIN);  				// TURN LNA OFF FOR TRANSMITT
    	writeRegister(REG_PA_CONFIG, PA_MAX_BOOST);   		// TURN PA TO MAX POWER
    	writeRegister(REG_OPMODE, newMode);
    	currentMode = newMode; 
    	break;
    default: return;
  	} 
if(newMode != LoRa_MODE_SLEEP)
	{
    while(digitalRead(DIO5_PIN) == 0)
    	{Serial.print(".");} 
  	}
return;
}

//===========================
void setLoRaMode()
//===========================
{
Serial.println("Setting Low Frequency LoRa Mode");	
writeRegister(REG_OPMODE,0x08);										//Sleep//Low Frequency Mode
delay(100);
writeRegister(REG_OPMODE,0x88);										//Set LoRa mode
writeRegister(FREQ23_16,Freq433Table[0]);							//Set FR Frequency 433MHz
writeRegister(FREQ15_8,Freq433Table[1]);
writeRegister(FREQ7_0,Freq433Table[2]);
writeRegister(REG_PA_CONFIG,PA_LOW_BOOST);							//PA low, 11dbm
writeRegister(REG_OCP,0x2B);										//Over current protection, 100mA
writeRegister(REG_LNA,0x23);										//Maximun gain
writeRegister(REG_MODEM_CONFIG1,(Bandwidth||CodingRate||0x01));		//
writeRegister(REG_MODEM_CONFIG2,((SpreadingFactorTable[SpreadingFactor]<<4)||0x07));			//2048
writeRegister(REG_RX_TIME_OUT,0xFF);
writeRegister(REG_PREAMBLE_LENGTH_H,00);							//Preamble length 12
writeRegister(REG_PREAMBLE_LENGTH_H,12);
writeRegister(REG_DIO_MAPPING_1,0x40); 								// Change the DIO0_PIN mapping to 01 so we can listen for TxDone on the interrupt
writeRegister(REG_DIO_MAPPING_2,0x00);								//DIO5=00 (ModeReady), DIO4=01(pllLock)
writeRegister(REG_OPMODE,0x09);  									//Standby
Serial.println("Set LoRa Mode has done");
return;
}
  
  
  
  
  
//===========================
void readAllRegs( )
//===========================
{
  byte regVal;
        
  for (byte regAddr = 1; regAddr <= 0x46; regAddr++)
  {
    digitalWrite(SPI_CS_PIN, LOW);
    SPI.transfer(regAddr & 0x7f);        // send address + r/w bit
    regVal = SPI.transfer(0);
    digitalWrite(SPI_CS_PIN, HIGH);
  
    Serial.print(regAddr, HEX);
    Serial.print(" - ");
    Serial.print(regVal,HEX);
    Serial.print(" - ");
    Serial.println(regVal,BIN);
  }
}

