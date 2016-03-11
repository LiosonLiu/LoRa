/*
Hardware-ESP8266:
1.SPI 
    Definition 	SX1276		ESP8266			ESP8266 cuttrnt
	a.MISO		PIN10		GPIO12		-	LED GREEN		-SPI
	b.MOSI		PIN11		GPIO13		-	LED BLUE		-SPI
	c.SCK			PIN9		GPIO14(SCL)	-						-SPI
	d.CS			PIN12		GPIO16		-							-SPI , GPIO15 - DEAD
	***Note:
			SX1276 MISO patch to ESP8266 MISO, so does MOSI, do not exchange. 
			GPIO15 as CS pin, but not functinal for ESP8266
2.Indication	
	a.TX Ind	DIO0		GPIO0							-TX/RX indication	
3.Antena control
	a.ANT_EN	PIN1		GPIO4							-
4.RESET			PIN4		GPIO5

*/
#include <SPI.h>
#define u8 unsigned char
//int led 			= 13;
int SPI_CS_PIN 	= 16; 
int DIO0_PIN 		= 0;
int ANT_EN_PIN 	= 4;
int RESET_PIN		= 5;
int DEBUG_PIN		= 10;

#define REG_FIFO                    0x00
#define REG_OPMODE                  0x01
#define REG_FREQ23_16								0x06
#define REG_FREQ15_8								0x07
#define REG_FREQ7_0									0x08
#define REG_PA_CONFIG               0x09	// POWER AMPLIFIER CONFIG
#define REG_PA_RAMP									0x0A
#define REG_OCP											0x0B	//Over load current protection
#define REG_FIFO_ADDR_PTR           0x0D 
#define REG_FIFO_TX_BASE_ADDR       0x0E
#define REG_FIFO_RX_BASE_ADDR       0x0F
#define REG_FIFO_RX_CURRENT_ADDR    0x10
#define REG_IRQ_FLAGS_MASK          0x11
#define REG_IRQ_FLAGS               0x12
#define REG_RX_NB_BYTES             0x13	
#define REG_MODEM_STAT              0x18
#define REG_MODEM_CONFIG1           0x1D	//Bandwidth &Coding rate
#define REG_MODEM_CONFIG2           0x1E	//SpreadingFactor
#define REG_RX_TIME_OUT							0x1F
#define REG_PREAMBLE_LENGTH_H				0x20
#define REG_PREAMBLE_LENGTH_L				0x21
#define REG_PAYLOAD_LENGTH          0x22
#define REG_HOP_PERIOD              0x24
#define REG_DIO_MAPPING_1           0x40
#define REG_DIO_MAPPING_2           0x41
#define REG_LR_PADAC								0x4D

char TXData[] 		= "EXOSITE00000000000000000000000";
char RXData[]			=	"000000000000000000000000000000";

// MODES
#define LORA_SLEEP             			0x08
#define LORA_STANDBY           			0x09
#define LORA_TX				              0x8B
#define LORA_RX_CONTINUOS      			0x8D

// LOW NOISE AMPLIFIER
#define REG_LNA                     0x0C
#define LNA_MAX_GAIN                0x23  // 0010 0011
#define LNA_OFF_GAIN                0x00
		
#define CR													1			//1=>4/5,2=>4/6,3=>4/7,4=>4/8
#define Lora_Rate_Sel								6
#define BandWidth_Sel								7

const u8 Freq433Table[3] 						= {0x85,0x3b,0x13};	//433Mhz
const u8 sx1278PowerTable[16]				= {0xF0,0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF};    //FF=20dbm,FC=17dbm,F9=14dbm,F6=11dbm 
const u8 sx1278SpreadFactorTable[7] = {6,7,8,9,10,11,12};	//64/128/256/512/1024/2048/4096 chips/symble
const u8 sx1278LoRaBwTable[10] 			= {0,1,2,3,4,5,6,7,8,9};	//7.8KHz,10.4KHz,15.6KHz,20.8KHz,31.2KHz,41.7KHz,62.5KHz,125KHz,250KHz,500KHz

//Globale Variable
u8 TXDataLength=30;
u8 RXDataLength=30;
//===========================
void setup() 
//===========================
{                
  // initialize the pins
  pinMode(SPI_CS_PIN, OUTPUT); 
//  pinMode(DEBUG_PIN, OUTPUT);
  pinMode(DIO0_PIN, INPUT);
  pinMode(ANT_EN_PIN, OUTPUT);
  pinMode(RESET_PIN, OUTPUT);
  Serial.begin(115200);
  SPI.setFrequency(1000000);
  SPI.begin();  
  delay(3000); 										// Wait for me to open serial monitor  
}

//===========================
void loop()
//===========================
 {
  setLoRaMode();									// LoRa mode 
  //TXData[] 		= "EXOSITE00000000000000000000000"; 	
  sendData(TXData);
  delay(1000);
}

//===========================
void sendData(char buffer[])
//===========================
{
u8 addr;
Serial.print("Send: ");
Serial.println(buffer);  
digitalWrite(ANT_EN_PIN,HIGH);
SPIWrite(REG_OPMODE,LORA_STANDBY);
SPIWrite(REG_DIO_MAPPING_1,0x41); 						// Change the DIO0_PIN mapping to 01 so we can listen for TxDone on the interrupt
SPIWrite(REG_DIO_MAPPING_2,0x00);							//DIO5=00 (ModeReady), DIO4=01(pllLock)	
SPIWrite(REG_PAYLOAD_LENGTH,TXDataLength);	//TXData length
SPIWrite(REG_LR_PADAC,0X87);				//Tx for 20dBm
SPIWrite(REG_HOP_PERIOD,0X00);			//Disabled
SPIWrite(REG_IRQ_FLAGS,0xFF);				//Clear Irq
SPIWrite(REG_IRQ_FLAGS_MASK,0xF7);	//Open TxDone interrupt	  
addr=SPIRead(REG_FIFO_TX_BASE_ADDR);
SPIWrite(REG_FIFO_ADDR_PTR,addr);
while(TXDataLength!=SPIRead(REG_PAYLOAD_LENGTH))
	{
	}
SPIBurstWrite(0,buffer,TXDataLength);	  
SPIWrite(REG_OPMODE,LORA_TX);
DebugLoRa();
while(digitalRead(DIO0_PIN) == 0)			// once TxDone has flipped, everything has been sent
	{
  	delay(100);	
  } 
SPIRead(REG_IRQ_FLAGS);  
SPIWrite(REG_IRQ_FLAGS, 0xff); 		// clear the flags 0x08 is the TxDone flag
SPIWrite(REG_OPMODE,LORA_STANDBY);  
digitalWrite(ANT_EN_PIN,LOW);	
}

//===========================
void InitialReceiveData(void)
//===========================
{
	u8 addr;
	Serial.print("Receive: ");
	digitalWrite(ANT_EN_PIN,LOW);
  SPIWrite(REG_LR_PADAC,0x84);                   	//Normal and Rx
  SPIWrite(REG_HOP_PERIOD,0xFF);                 	//RegHopPeriod NO FHSS
  SPIWrite(REG_DIO_MAPPING_1,0x01);            //DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
  SPIWrite(REG_IRQ_FLAGS_MASK,0x3F);             	//Open RxDone interrupt & Timeout
  SPIWrite(REG_IRQ_FLAGS,0xFF);     
  SPIWrite(REG_PAYLOAD_LENGTH,RXDataLength);    	//RegPayloadLength  30byte(this register must difine when the data long of one byte in SF is 6)
  addr = SPIRead(REG_FIFO_RX_BASE_ADDR);         	//Read RxBaseAddr
  SPIWrite(REG_FIFO_ADDR_PTR,addr);             	//RxBaseAddr -> FiFoAddrPtr¡¡ 
  SPIWrite(REG_OPMODE,0x8d);                    	//Continuous Rx Mode//Low Frequency Mode
	while((SPIRead(REG_MODEM_STAT)&0x04)!=0x04)
	{
	}
}
//===========================
void ReceiveData(void)
//===========================
{
u8 i,addr,packet_size;
if(digitalRead(DIO0_PIN) != 0)								// once RxDone has flipped, received
	{
  for(i=0;i<RXDataLength;i++) 
  	RXData[i] = 0x00;    
  addr = SPIRead(REG_FIFO_RX_CURRENT_ADDR);     //last packet addr
  SPIWrite(REG_FIFO_ADDR_PTR,addr);           //RxBaseAddr -> FiFoAddrPtr    
  packet_size = SPIRead(REG_RX_NB_BYTES);     //Number for received bytes    
  SPIBurstRead(0x00, RXData, packet_size);    
  SPIWrite(REG_IRQ_FLAGS,0xFF);							
}
}

//===========================
void SPIBurstRead(u8 addr,char *ptr,u8 length)
//===========================
{
	u8 i;
	if(length==0)
		return;
  digitalWrite(SPI_CS_PIN, LOW);
  SPI.transfer(addr & 0x7F);
  for(i=0;i<length;i++)
  	{
  	ptr[i] = SPI.transfer(0);
  	}
  digitalWrite(SPI_CS_PIN, HIGH);
}

//===========================
void SPIBurstWrite(u8 addr,char *ptr,u8 length)
//===========================
{
	u8 i;
	if(length==0)
		return;
  digitalWrite(SPI_CS_PIN, LOW);
  SPI.transfer(addr | 0x80); // OR address with 10000000 to indicate write enable;
  for(i=0;i<length;i++)
  	{
  	SPI.transfer(ptr[i]);
  	}
  digitalWrite(SPI_CS_PIN, HIGH);
}

//===========================
byte SPIRead(byte addr)
//===========================
{
  digitalWrite(SPI_CS_PIN, LOW);
  SPI.transfer(addr & 0x7F);
  byte regval = SPI.transfer(0);
  digitalWrite(SPI_CS_PIN, HIGH);
  return regval;
}

//===========================
void SPIWrite(byte addr, byte value)
//===========================
{
  digitalWrite(SPI_CS_PIN, LOW);
  SPI.transfer(addr | 0x80); // OR address with 10000000 to indicate write enable;
  SPI.transfer(value);
  digitalWrite(SPI_CS_PIN, HIGH);
}


//===========================
void setLoRaMode()
//===========================
{
digitalWrite(RESET_PIN,LOW);
delay(100);
digitalWrite(RESET_PIN,HIGH);
delay(100);		
Serial.println("Setting Low Frequency LoRa Mode");	
SPIWrite(REG_OPMODE,0x08);										//Sleep//Low Frequency Mode
delay(100);
SPIWrite(REG_OPMODE,0X88);										//Set LoRa mode
SPIWrite(REG_FREQ23_16,Freq433Table[0]);			//Set FR Frequency 433MHz
SPIWrite(REG_FREQ15_8,Freq433Table[1]);
SPIWrite(REG_FREQ7_0,Freq433Table[2]);
SPIWrite(REG_PA_CONFIG,0xF0);									//PA low, 11dbm
SPIWrite(REG_PA_RAMP,0x09);										//40uS
SPIWrite(REG_OCP,0x2B);												//Over current protection, 100mA
SPIWrite(REG_LNA,0x20);												//
SPIWrite(REG_MODEM_CONFIG1,(sx1278LoRaBwTable[BandWidth_Sel]<<4) + (CR<<1) + 0x00);		//
SPIWrite(REG_MODEM_CONFIG2,(sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+0x07);			//2048
SPIWrite(REG_RX_TIME_OUT,0xFF);
SPIWrite(REG_PREAMBLE_LENGTH_H,00);						//Preamble length 12
SPIWrite(REG_PREAMBLE_LENGTH_L,12);
SPIWrite(REG_OPMODE,0X09);										//Standby
return;
}
  
//===========================
void DebugLoRa(void)
//===========================
{
u8 i,j;
for(i=0;i<20;i++)
	{
	j=SPIRead(i);
	Serial.print(j);
	Serial.print(" ");
	}
for(i=21;i<40;i++)
	{
	j=SPIRead(i);
	Serial.print(j);
	Serial.print(" ");
	}	
Serial.println("Set LoRa Mode has done");	
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

