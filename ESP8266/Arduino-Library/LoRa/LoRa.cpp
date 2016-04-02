
// For Arduino 1.0 and earlier
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

#include "LoRa.h"

LoRa::LoRa(void)
{
}
//===========================
void LoRa::InitialSend(uint8_t TX_Length)
//===========================
{
u8 addr=0;
m_TXLength  = TX_Length; 
//Serial.print("Send: ");
//Serial.println(buffer); 
digitalWrite(m_ANT_EN_PIN,HIGH);
SPIWrite(REG_OPMODE,LORA_STANDBY);
SPIWrite(REG_DIO_MAPPING_1,0x41); 			 // Change the DIO0_PIN mapping to 01 so we can listen for TxDone on the interrupt
SPIWrite(REG_DIO_MAPPING_2,0x00);				 //DIO5=00 (ModeReady), DIO4=01(pllLock)	
SPIWrite(REG_PAYLOAD_LENGTH,m_TXLength);	 //TXData length
SPIWrite(REG_LR_PADAC,0X87);				     //Tx for 20dBm 0x87
SPIWrite(REG_HOP_PERIOD,0X00);			     //Disabled
SPIWrite(REG_IRQ_FLAGS,0xFF);				     //Clear Irq
SPIWrite(REG_IRQ_FLAGS_MASK,0xF7);	     //Open TxDone interrupt	  
addr=SPIRead(REG_FIFO_TX_BASE_ADDR);
SPIWrite(REG_FIFO_ADDR_PTR,addr);
while(m_TXLength!=SPIRead(REG_PAYLOAD_LENGTH))
	{
	}
}
//===========================
void LoRa::Send(char buffer[])
//===========================
{
u8 i;
buffer[m_TXLength-1]=0;
for(i=0;i<(m_TXLength-2);i++)
	{
	buffer[m_TXLength-1]^=buffer[i];
	}	
SPIBurstWrite(0,buffer,m_TXLength);	  
SPIWrite(REG_OPMODE,LORA_TX);
while(digitalRead(m_DIO0_PIN) == 0)			// once TxDone has flipped, everything has been sent
	{
  	delay(100);	
  } 
SPIRead(REG_IRQ_FLAGS);  
SPIWrite(REG_IRQ_FLAGS, 0xff); 		// clear the flags 0x08 is the TxDone flag
SPIWrite(REG_OPMODE,LORA_STANDBY);  
digitalWrite(m_ANT_EN_PIN,LOW);	
}

//===========================
void LoRa::InitialReceive(uint8_t RX_Length)
//===========================
{
	u8 addr;
	//Serial.println("====Initial Receive====");
  m_RXLength  = RX_Length;
	digitalWrite(m_ANT_EN_PIN,LOW);
  SPIWrite(REG_LR_PADAC,0X84);                    //Tx for 20dBm 0x84
  SPIWrite(REG_HOP_PERIOD,0xFF);                 	//RegHopPeriod NO FHSS
  SPIWrite(REG_DIO_MAPPING_1,0x01);            		//DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
  SPIWrite(REG_IRQ_FLAGS_MASK,0x3F);             	//Open RxDone interrupt & Timeout
  SPIWrite(REG_IRQ_FLAGS,0xFF);     
  SPIWrite(REG_PAYLOAD_LENGTH,m_RXLength);    	 //RegPayloadLength  30byte(this register must difine when the data long of one byte in SF is 6)
  addr = SPIRead(REG_FIFO_RX_BASE_ADDR);         	//Read RxBaseAddr
  SPIWrite(REG_FIFO_ADDR_PTR,addr);             	//RxBaseAddr -> FiFoAddrPtr�� 
  SPIWrite(REG_OPMODE,0x8d);                    	//Continuous Rx Mode//Low Frequency Mode
	while((SPIRead(REG_MODEM_STAT)&0x04)!=0x04)
	{
	}
}
//===========================
unsigned LoRa::Receive(unsigned long Duration)
//===========================
{
u8 i,j,addr,packet_size;
unsigned long timer;
m_Duration  = Duration;
//Serial.print("Waiting");
for(timer=0;timer<m_Duration;timer++)
  {
  if(digitalRead(m_DIO0_PIN)==0)
    {
    delay_ms(1);
    //Serial.print(".");  
    }
  else 
	  {
    //Serial.println(" ");
    //Serial.print("Received data = ");
    for(i=0;i<m_RXLength;i++) 
  	  {RXData[i] = 0x00;}
    addr = SPIRead(REG_FIFO_RX_CURRENT_ADDR);     //last packet addr
    SPIWrite(REG_FIFO_ADDR_PTR,addr);           //RxBaseAddr -> FiFoAddrPtr    
    packet_size = SPIRead(REG_RX_NB_BYTES);     //Number for received bytes    
    SPIBurstRead(0x00, RXData, packet_size);    
    SPIWrite(REG_IRQ_FLAGS,0xFF);	
    j=0;
    for(i=0;i<m_RXLength;i++)
      {
      j^=RXData[i];	
      //Serial.print(RXData[i],HEX);      
      //Serial.print(" ");
      }   
	  }						
  }
if(timer==m_Duration)
  {
  //Serial.print("Time out");
  //Serial.println(" ");
  return 0;
  }
if(j!=0)
	{
	//Serial.print("CheckSum Error");
  //Serial.println(" ");
  return 0;	
	}  
//Serial.println(" ");  
return 1;    
}

//=================
void SPIBurstRead(u8 addr,char *ptr,u8 length)
//=================
{
	u8 i;
	if(length==0)
		return;
  digitalWrite(m_SPI_CS_PIN, LOW);
  SPI.transfer(addr & 0x7F);
  for(i=0;i<length;i++)
  	{
  	ptr[i] = SPI.transfer(0);
  	}
  digitalWrite(m_SPI_CS_PIN, HIGH);
}

//=================
void SPIBurstWrite(u8 addr,char *ptr,u8 length)
//=================
{
	u8 i;
	if(length==0)
		return;
  digitalWrite(m_SPI_CS_PIN, LOW);
  SPI.transfer(addr | 0x80); // OR address with 10000000 to indicate write enable;
  for(i=0;i<length;i++)
  	{
  	SPI.transfer(ptr[i]);
  	}
  digitalWrite(m_SPI_CS_PIN, HIGH);
}

//=================
byte SPIRead(byte addr)
//=================
{
  digitalWrite(m_SPI_CS_PIN, LOW);
  SPI.transfer(addr & 0x7F);
  byte regval = SPI.transfer(0);
  digitalWrite(m_SPI_CS_PIN, HIGH);
  return regval;
}

//=================
void SPIWrite(byte addr, byte value)
//=================
{
  digitalWrite(m_SPI_CS_PIN, LOW);
  SPI.transfer(addr | 0x80); // OR address with 10000000 to indicate write enable;
  SPI.transfer(value);
  digitalWrite(m_SPI_CS_PIN, HIGH);
}


//===========================
void LoRa::Initial(uint8_t SPI_CS_PIN,uint8_t ANT_EN_PIN,uint8_t RESET_PIN,uint8_t DIO0_PIN)
//===========================
{
m_SPI_CS_PIN  = SPI_CS_PIN;
m_ANT_EN_PIN  = ANT_EN_PIN;
m_RESET_PIN   = RESET_PIN;
m_DIO0_PIN    = DIO0_PIN;
// initialize the pins
pinMode(m_SPI_CS_PIN, OUTPUT); 
pinMode(m_ANT_EN_PIN, OUTPUT);
pinMode(m_RESET_PIN, OUTPUT);
pinMode(m_DIO0_PIN, INPUT);  
digitalWrite(m_DIO0_PIN, LOW);
digitalWrite(m_RESET_PIN,LOW);
delay(100);
digitalWrite(m_RESET_PIN,HIGH);
delay(100);		
//Serial.println("Setting Low Frequency LoRa Mode");	
SPIWrite(REG_OPMODE,0x08);										//Sleep//Low Frequency Mode
delay(100);
SPIWrite(REG_OPMODE,0X88);										//Set LoRa mode
SPIWrite(REG_FREQ23_16,Freq433Table[0]);			//Set FR Frequency 433MHz
SPIWrite(REG_FREQ15_8,Freq433Table[1]);
SPIWrite(REG_FREQ7_0,Freq433Table[2]);
SPIWrite(REG_PA_CONFIG,0xF0);						      //PA low, 11dbm
SPIWrite(REG_PA_RAMP,0x09);										//40uS
SPIWrite(REG_OCP,0x2B);												//Over current protection, 100mA
SPIWrite(REG_LNA,0x20);												//
SPIWrite(REG_MODEM_CONFIG1,(sx1278LoRaBwTable[BandWidth_Sel]<<4) + (CR<<1) + 0x00);		//
SPIWrite(REG_MODEM_CONFIG2,(sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+0x07);			//2048
SPIWrite(REG_RX_TIME_OUT,0xFF);
SPIWrite(REG_PREAMBLE_LENGTH_H,00);						//Preamble length 12
SPIWrite(REG_PREAMBLE_LENGTH_L,12);
SPIWrite(REG_OPMODE,0X09);										//Standby
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






