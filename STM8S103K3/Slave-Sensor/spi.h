#ifndef __DK_SPI_h__
#define __DK_SPI_h__

#include "STM8S103K3.h"
#include "STM8S_type.h"
#include "io.h"

#define NOP()                {_asm("nop\n");}

void SPICmd8bit(u8 WrPara);
u8 SPIRead(u8 adr);
u8 SPIRead8bit(void);
void SPIWrite(u8 adr, u8 WrPara);
void SPIBurstRead(u8 adr, u8 *ptr, u8 length);
void BurstWrite(u8 adr, u8 *ptr, u8 length);

#endif







