
// For Arduino 1.0 and earlier
/*
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif
*/
#include "LoRa.h"
  int   m_SPI_CS_PIN; //15
  int   m_SPI_MISO_PIN; //12
  int   m_SPI_MOSI_PIN; //13
  int   m_SPI_SCK_PIN;  //14  
  int   m_DIO0_PIN;   //16
  int   m_ANT_EN_PIN;   //4
  int   m_RESET_PIN;  //5
  uint8_t m_TXLength;   //32
  uint8_t m_RXLength;   //32
  char m_TXData[128];
  char m_RXData[128];
LoRa::LoRa(void)
{
}
/**********************************************************
**Name:     SPICmd8bit
**Function: SPI Write one byte
**Input:    WrPara
**Output:   none
**note:     use for burst mode
**********************************************************/
void SPICmd8bit(unsigned char WrPara)
{
  unsigned char bitcnt;
  for(bitcnt=8; bitcnt!=0; bitcnt--)
  {
    digitalWrite(m_SPI_SCK_PIN,LOW);
    if(WrPara&0x80)
      digitalWrite(m_SPI_MOSI_PIN,HIGH);
    else
      digitalWrite(m_SPI_MOSI_PIN,LOW);
    digitalWrite(m_SPI_SCK_PIN,HIGH);
    WrPara <<= 1;
  }
  digitalWrite(m_SPI_SCK_PIN,LOW);
}

/**********************************************************
**Name:     SPIRead8bit
**Function: SPI Read one byte
**Input:    None
**Output:   result byte
**Note:     use for burst mode
**********************************************************/
unsigned char SPIRead8bit(void)
{
 unsigned char RdPara = 0;
 unsigned char bitcnt;
 
  digitalWrite(m_SPI_CS_PIN,LOW);
  digitalWrite(m_SPI_MOSI_PIN,HIGH);                                                 //Read one byte data from FIFO, MOSI hold to High
  for(bitcnt=8; bitcnt!=0; bitcnt--)
  {
    digitalWrite(m_SPI_SCK_PIN,LOW);
    RdPara <<= 1;
    digitalWrite(m_SPI_SCK_PIN,HIGH);
    if(digitalRead(m_SPI_MISO_PIN))
      RdPara |= 0x01;
    else
      RdPara |= 0x00; 
  }
  digitalWrite(m_SPI_SCK_PIN,LOW);
  return(RdPara);
}

/**********************************************************
**Name:     SPIRead
**Function: SPI Read CMD
**Input:    adr -> address for read
**Output:   None
**********************************************************/
unsigned char SPIRead(unsigned char adr)
{
  unsigned char tmp; 
  digitalWrite(m_SPI_SCK_PIN,LOW);  
  digitalWrite(m_SPI_CS_PIN,LOW);  
  SPICmd8bit(adr&0x7f);                                         //Send address first
  tmp = SPIRead8bit();  
  digitalWrite(m_SPI_SCK_PIN,LOW);
  digitalWrite(m_SPI_CS_PIN,HIGH);
  return tmp;
}

/**********************************************************
**Name:     SPIWrite
**Function: SPI Write CMD
**Input:    unsigned char address & unsigned char data
**Output:   None
**********************************************************/
void SPIWrite(unsigned char adr, unsigned char WrPara)  
{
  digitalWrite(m_SPI_SCK_PIN,LOW);  
  digitalWrite(m_SPI_CS_PIN,LOW);            
  SPICmd8bit(adr|0x80);    
  SPICmd8bit(WrPara); 
  digitalWrite(m_SPI_SCK_PIN,LOW);
  digitalWrite(m_SPI_CS_PIN,HIGH);
}
/**********************************************************
**Name:     SPIBurstRead
**Function: SPI burst read mode
**Input:    adr-----address for read
**          ptr-----data buffer point for read
**          length--how many bytes for read
**Output:   None
**********************************************************/
void SPIBurstRead(unsigned char adr, char *ptr, unsigned char length)
{
  unsigned char i;
  if(length<=1)                                            //length must more than one
    return;
  else
  {
    digitalWrite(m_SPI_SCK_PIN,LOW);  
    digitalWrite(m_SPI_CS_PIN,LOW);
    SPICmd8bit(adr); 
    for(i=0;i<length;i++)
    ptr[i] = SPIRead8bit();
    digitalWrite(m_SPI_SCK_PIN,LOW);      
    digitalWrite(m_SPI_CS_PIN,HIGH);  
  }
}

/**********************************************************
**Name:     SPIBurstWrite
**Function: SPI burst write mode
**Input:    adr-----address for write
**          ptr-----data buffer point for write
**          length--how many bytes for write
**Output:   none
**********************************************************/
void SPIBurstWrite(unsigned char adr, unsigned char *ptr, unsigned char length)
{ 
  unsigned char i;
  if(length<=1)                                            //length must more than one
    return;
  else  
  {   
    digitalWrite(m_SPI_SCK_PIN,LOW);
    digitalWrite(m_SPI_CS_PIN,LOW);        
    SPICmd8bit(adr|0x80);
    for(i=0;i<length;i++)
      SPICmd8bit(ptr[i]);
    digitalWrite(m_SPI_SCK_PIN,LOW);        
    digitalWrite(m_SPI_CS_PIN,HIGH);  
  }
}

//===========================
void LoRa::Initial(uint8_t SPI_CS_PIN,uint8_t SPI_MISO_PIN,uint8_t SPI_MOSI_PIN,uint8_t SPI_SCK_PIN,uint8_t ANT_EN_PIN,uint8_t RESET_PIN,uint8_t DIO0_PIN)
//===========================
{
m_SPI_CS_PIN  = SPI_CS_PIN;
m_SPI_MISO_PIN  = SPI_MISO_PIN;
m_SPI_MOSI_PIN  = SPI_MOSI_PIN;
m_SPI_SCK_PIN  = SPI_SCK_PIN;
m_ANT_EN_PIN  = ANT_EN_PIN;
m_RESET_PIN   = RESET_PIN;
m_DIO0_PIN    = DIO0_PIN;
// initialize the pins
pinMode(m_SPI_CS_PIN, OUTPUT);
pinMode(m_SPI_MOSI_PIN, OUTPUT);
pinMode(m_SPI_MISO_PIN, INPUT);
pinMode(m_SPI_SCK_PIN, OUTPUT);
pinMode(m_ANT_EN_PIN, OUTPUT);
pinMode(m_RESET_PIN, OUTPUT);
pinMode(m_DIO0_PIN, INPUT);  
digitalWrite(m_DIO0_PIN, LOW);
digitalWrite(m_RESET_PIN,LOW);
delay(100);
digitalWrite(m_RESET_PIN,HIGH);
delay(100);   
//Serial.println("Setting Low Frequency LoRa Mode");  
SPIWrite(REG_OPMODE,0x08);                    //Sleep//Low Frequency Mode
delay(100);
SPIWrite(REG_OPMODE,0X88);                    //Set LoRa mode
SPIWrite(REG_FREQ23_16,Freq433Table[0]);      //Set FR Frequency 433MHz
SPIWrite(REG_FREQ15_8,Freq433Table[1]);
SPIWrite(REG_FREQ7_0,Freq433Table[2]);
SPIWrite(REG_PA_CONFIG,0xF0);                 //PA low, 11dbm
SPIWrite(REG_PA_RAMP,0x09);                   //40uS
SPIWrite(REG_OCP,0x2B);                       //Over current protection, 100mA
SPIWrite(REG_LNA,0x20);                       //
SPIWrite(REG_MODEM_CONFIG1,(sx1278LoRaBwTable[BandWidth_Sel]<<4) + (CR<<1) + 0x00);   //
SPIWrite(REG_MODEM_CONFIG2,(sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+0x07);     //2048
SPIWrite(REG_RX_TIME_OUT,0xFF);
SPIWrite(REG_PREAMBLE_LENGTH_H,00);           //Preamble length 12
SPIWrite(REG_PREAMBLE_LENGTH_L,12);
SPIWrite(REG_OPMODE,0X09);                    //Standby
}
//===========================
void LoRa::InitialSend(uint8_t TX_Length)
//===========================
{
unsigned char addr=0;
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
void Send(unsigned char buffer[])
//===========================
{
unsigned char i;
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
	unsigned char addr;
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
unsigned char i,j,addr,packet_size;
unsigned long timer,m_Duration;
m_Duration  = Duration;
//Serial.print("Waiting");
for(timer=0;timer<m_Duration;timer++)
  {
  if(digitalRead(m_DIO0_PIN)==0)
    {
    delay(1);
    //Serial.print(".");  
    }
  else 
	  {
    //Serial.println(" ");
    //Serial.print("Received data = ");
    for(i=0;i<m_RXLength;i++) 
  	  {m_RXData[i] = 0x00;}
    addr = SPIRead(REG_FIFO_RX_CURRENT_ADDR);     //last packet addr
    SPIWrite(REG_FIFO_ADDR_PTR,addr);           //RxBaseAddr -> FiFoAddrPtr    
    packet_size = SPIRead(REG_RX_NB_BYTES);     //Number for received bytes    
    SPIBurstRead(0x00, m_RXData, packet_size);    
    SPIWrite(REG_IRQ_FLAGS,0xFF);	
    j=0;
    for(i=0;i<m_RXLength;i++)
      {
      j^=m_RXData[i];	
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





  
//===========================
void DebugLoRa(void)
//===========================
{
unsigned char i,j;
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
  
  
  







