// ========================================================
/// @file       SPI.c
/// @brief      Software simulation SPI performance function
/// @version    V1.0
/// @date       2014/08/04
/// @company    .
/// @website    
/// @author     ISA
/// @mobile     
/// @tel        
// ========================================================
#include "spi.h"


/**********************************************************
**Name:     SPICmd8bit
**Function: SPI Write one byte
**Input:    WrPara
**Output:   none
**note:     use for burst mode
**********************************************************/
void SPICmd8bit(u8 WrPara)
{
  u8 bitcnt;
  for(bitcnt=8; bitcnt!=0; bitcnt--)
  {
    SCK_L();
    if(WrPara&0x80)
      MOSI_H();
    else
      MOSI_L();
    SCK_H();
    WrPara <<= 1;
  }
  SCK_L();
}

/**********************************************************
**Name:     SPIRead8bit
**Function: SPI Read one byte
**Input:    None
**Output:   result byte
**Note:     use for burst mode
**********************************************************/
u8 SPIRead8bit(void)
{
 u8 RdPara = 0;
 u8 bitcnt;
 
  NSS_L();
  MOSI_H();                                                 //Read one byte data from FIFO, MOSI hold to High
	for(bitcnt=8; bitcnt!=0; bitcnt--)
  {
    SCK_L();
    RdPara <<= 1;
    SCK_H();
    if(Get_MISO())
      RdPara |= 0x01;
    else
      RdPara |= 0x00;	
  }
  SCK_L();
  return(RdPara);
}

/**********************************************************
**Name:     SPIRead
**Function: SPI Read CMD
**Input:    adr -> address for read
**Output:   None
**********************************************************/
u8 SPIRead(u8 adr)
{
  u8 tmp; 
	SCK_L();	
	NSS_L();	
  SPICmd8bit(adr&0x7f);                                         //Send address first
  tmp = SPIRead8bit();  
	SCK_L();
  NSS_H();
  return tmp;
}

/**********************************************************
**Name:     SPIWrite
**Function: SPI Write CMD
**Input:    u8 address & u8 data
**Output:   None
**********************************************************/
void SPIWrite(u8 adr, u8 WrPara)  
{
	SCK_L();	
	NSS_L();						
	SPICmd8bit(adr|0x80);		 
	SPICmd8bit(WrPara);	
	SCK_L();
  NSS_H();
}
/**********************************************************
**Name:     SPIBurstRead
**Function: SPI burst read mode
**Input:    adr-----address for read
**          ptr-----data buffer point for read
**          length--how many bytes for read
**Output:   None
**********************************************************/
void SPIBurstRead(u8 adr, u8 *ptr, u8 length)
{
  u8 i;
  if(length<=1)                                            //length must more than one
    return;
  else
  {
    SCK_L();	
    NSS_L();
    SPICmd8bit(adr); 
    for(i=0;i<length;i++)
    ptr[i] = SPIRead8bit();
    SCK_L();			
    NSS_H();  
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
void BurstWrite(u8 adr, u8 *ptr, u8 length)
{ 
  u8 i;
  if(length<=1)                                            //length must more than one
    return;
  else  
  {   
    SCK_L();
    NSS_L();        
    SPICmd8bit(adr|0x80);
    for(i=0;i<length;i++)
			SPICmd8bit(ptr[i]);
    SCK_L();				
    NSS_H();  
  }
}





