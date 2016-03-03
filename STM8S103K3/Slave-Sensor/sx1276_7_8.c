#include "sx1276_7_8.h"
/************************************************
//  RF module:           sx1278
//	Crystal:						 26MHz
//  FSK:
//  Carry Frequency:     433MHz
//  Bit Rate:            1.2Kbps/2.4Kbps/4.8Kbps/9.6Kbps
//  Tx Power Output:     20dbm/17dbm/14dbm/11dbm
//  Frequency Deviation: +/-35KHz
//  Receive Bandwidth:   83KHz
//  Coding:              NRZ
//  Packet Format:       0x5555555555+0xAA2DD4+"Mark1 Lora sx1278" (total: 29 bytes)
//  LoRa:
//  Carry Frequency:     433MHz
//  Spreading Factor:    6/7/8/9/10/11/12
//  Tx Power Output:     20dbm/17dbm/14dbm/11dbm
//  Receive Bandwidth:   7.8KHz/10.4KHz/15.6KHz/20.8KHz/31.2KHz/41.7KHz/62.5KHz/125KHz/250KHz/500KHz
//  Coding:              NRZ
//  Packet Format:       "Mark1 Lora sx1278" (total: 21 bytes)
//  Tx Current:          about 120mA  (RFOP=+20dBm,typ.)
//  Rx Current:          about 11.5mA  (typ.)       
**********************************************************/
//Table
const u8 sx1278FreqTable[1][3] 			= {{0x85, 0x3b, 0x13},};		//433MHz with 26MHz crystal	
const u8 sx1278PowerTable[4] 				= {0xFF,0xFC,0xF9,0xF6};    //20dbm,17dbm,14dbm,11dbm 
const u8 sx1278SpreadFactorTable[7] =	{6,7,8,9,10,11,12};
const u8 sx1278LoRaBwTable[10] 			=	{0,1,2,3,4,5,6,7,8,9};		//7.8KHz,10.4KHz,15.6KHz,20.8KHz,31.2KHz,41.7KHz,62.5KHz,125KHz,250KHz,500KHz
const u8 sx1278Data[] 							= {"**Exosite LoRa Demo**"};
u8 RxData[64];

#define LoRa_Standby_Value	0x09
#define LoRa_Sleep_Value		0x08
#define LoRa_Entry_Value		0x88
#define LoRa_ClearIRQ_Value	0xff

void sx1278_Config(void);

//=====================================
u8 sx1278_LoRaEntryRx(void)
//=====================================
{
  u8 addr,temp; 
  ANT_EN_L();
	ANT_CTRL_RX();        
  sx1278_Config();                            //setting base parameter
  SPIWrite(REG_LR_PADAC,0x84);                    //Normal and Rx
  SPIWrite(LR_RegHopPeriod,0xFF);                 //RegHopPeriod NO FHSS
  SPIWrite(REG_LR_DIOMAPPING1,0x01);              //DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
  SPIWrite(LR_RegIrqFlagsMask,0x3F);              //Open RxDone interrupt & Timeout
  SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);     
  SPIWrite(LR_RegPayloadLength,21);               //RegPayloadLength  21byte(this register must difine when the data long of one byte in SF is 6)
  addr = SPIRead(LR_RegFifoRxBaseAddr);           //Read RxBaseAddr
  SPIWrite(LR_RegFifoAddrPtr,addr);               //RxBaseAddr -> FiFoAddrPtr�� 
  SPIWrite(LR_RegOpMode,0x8d);                    //Continuous Rx Mode//Low Frequency Mode
	//SPIWrite(LR_RegOpMode,0x05);                  //Continuous Rx Mode//High Frequency Mode
	SysTime = 0;
	while(1)
	{
		if((SPIRead(LR_RegModemStat)&0x04)==0x04)   	//Rx-on going RegModemStat
			break;
		if(SysTime>=3)	
			return 0;                                   //over time for error
	}
}

//=====================================
u8 sx1278_LoRaReadRSSI(void)
//=====================================
{
  u16 temp=10;
  temp=SPIRead(LR_RegRssiValue);                  //Read RegRssiValue��Rssi value
  temp=temp+127-137;                              //127:Max RSSI, 137:RSSI offset
  return (u8)temp;
}

//=====================================
u8 sx1278_LoRaRxPacket(void)
//=====================================
{
  u8 i; 
  u8 addr;
  u8 packet_size; 
  if(Get_NIRQ())
  {
    for(i=0;i<32;i++) 
      RxData[i] = 0x00;    
    addr = SPIRead(LR_RegFifoRxCurrentaddr);      //last packet addr
    SPIWrite(LR_RegFifoAddrPtr,addr);             //RxBaseAddr -> FiFoAddrPtr    
    if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)	//When SpreadFactor is six��will used Implicit Header mode(Excluding internal packet length)
      packet_size=21;
    else
      packet_size = SPIRead(LR_RegRxNbBytes);     //Number for received bytes    
    SPIBurstRead(0x00, RxData, packet_size);    
    SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
    for(i=0;i<17;i++)
    {
      if(RxData[i]!=sx1278Data[i])
        break;  
    }    
    if(i>=17)                                     //Rx success
      return(1);
    else
      return(0);
  }
  else
    return(0);
}

//=====================================
u8 sx1278_LoRaEntryTx(void)
//=====================================
{
  u8 addr,temp;    
  sx1278_Config();                            //setting base parameter
  ANT_EN_H();
	ANT_CTRL_TX();    
  SPIWrite(REG_LR_PADAC,0x87);                    //Tx for 20dBm
  SPIWrite(LR_RegHopPeriod,0x00);                 //RegHopPeriod NO FHSS
  SPIWrite(REG_LR_DIOMAPPING1,0x41);              //DIO0=01, DIO1=00, DIO2=00, DIO3=01  
  SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
  SPIWrite(LR_RegIrqFlagsMask,0xF7);              //Open TxDone interrupt
  SPIWrite(LR_RegPayloadLength,21);               //RegPayloadLength  21byte  
  addr = SPIRead(LR_RegFifoTxBaseAddr);           //RegFiFoTxBaseAddr
  SPIWrite(LR_RegFifoAddrPtr,addr);               //RegFifoAddrPtr
	SysTime = 0;
	while(1)
	{
		temp=SPIRead(LR_RegPayloadLength);
		if(temp==21)
		{
			break; 
		}
		if(SysTime>=3)	
			return 0;
	}
}

//=====================================
u8 sx1278_LoRaTxPacket(void)
//=====================================
{ 
  u8 TxFlag=0;
  u8 addr;
  
	BurstWrite(0x00, (u8 *)sx1278Data, 21);
	SPIWrite(LR_RegOpMode,0x8b);                    	//Tx Mode           
	while(1)
	{
		if(Get_NIRQ())                      						//Packet send over
		{      
			SPIRead(LR_RegIrqFlags);
			SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);	//Clear irq				
			SPIWrite(LR_RegOpMode,LoRa_Standby_Value);    //Entry Standby mode   
			break;
		}
	} 
}

//=====================================
u8 sx1278_ReadRSSI(void)
//=====================================
{
  u8 temp=0xff;	
  temp=SPIRead(0x11);
  temp>>=1;
  temp=127-temp;		                     					//127:Max RSSI
  return temp;
}

//=====================================
void sx1278_Config(void)
//=====================================
{
  u8 i;
  SPIWrite(LR_RegOpMode,LoRa_Sleep_Value);   			//Change modem mode Must in Sleep mode 
  for(i=250;i!=0;i--)                             //Delay
    NOP();
	delay_ms(15);

  //lora mode
	SPIWrite(LR_RegOpMode,LoRa_Entry_Value);     
	BurstWrite(LR_RegFrMsb,sx1278FreqTable[Freq_Sel],3);  //setting frequency parameter

	//setting base parameter 
	SPIWrite(LR_RegPaConfig,sx1278PowerTable[Power_Sel]); //Setting output power parameter  
	SPIWrite(LR_RegOcp,0x0B);                              	//RegOcp,Close Ocp
	SPIWrite(LR_RegLna,0x23);                              	//RegLNA,High & LNA Enable
	if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)         //SFactor=6
	{
		u8 tmp;
		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x01));//Implicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));
		tmp = SPIRead(0x31);
		tmp &= 0xF8;
		tmp |= 0x05;
		SPIWrite(0x31,tmp);
		SPIWrite(0x37,0x0C);
	} 
	else
	{
		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x00));//Explicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));  //SFactor &  LNA gain set by the internal AGC loop 
	}
	SPIWrite(LR_RegSymbTimeoutLsb,0xFF);                  //RegSymbTimeoutLsb Timeout = 0x3FF(Max)    
	SPIWrite(LR_RegPreambleMsb,0x00);                     //RegPreambleMsb 
	SPIWrite(LR_RegPreambleLsb,12);                      	//RegPreambleLsb 8+4=12byte Preamble    
	SPIWrite(REG_LR_DIOMAPPING2,0x01);                    //RegDioMapping2 DIO5=00, DIO4=01	
  SPIWrite(LR_RegOpMode,LoRa_Standby_Value);            //Entry standby mode
}