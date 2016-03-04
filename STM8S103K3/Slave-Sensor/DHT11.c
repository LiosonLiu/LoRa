#include "IO.h"
#include "DHT11.h"
u16 DHT11Humi,DHT11Temp;
u8 DHT11Data[5];
#define MaxTimeValue	1000
#define High90Value		72
#define High60Value		48
#define High40Value		32
#define High10Value		8
u16 PulseHighRead(void);
u16 PulseLowRead(void);
u8 ReadData(void);
//=====================================
void ReadDHT11(void)
//=====================================
{
//Debug process
SET_DATA_PIN_OUTPUT();
SET_DEBUG_PIN_OUTPUT();
SET_DATA_PIN_L();	
SET_DEBUG_PIN_L();
delay_ms(20);
SET_DATA_PIN_H();
SET_DEBUG_PIN_H();
SET_DATA_PIN_INPUT();
//Wait Response
if(PulseHighRead()==MaxTimeValue)
	return;
if(PulseLowRead()==MaxTimeValue)
	return;	
//Read Data
DHT11Data[0]=ReadData();
DHT11Data[1]=ReadData();
DHT11Data[2]=ReadData();
DHT11Data[3]=ReadData();
DHT11Data[4]=ReadData();
if(DHT11Data[4]==(DHT11Data[0]+DHT11Data[1]+DHT11Data[2]+DHT11Data[3]))
	{
	DHT11Humi=(DHT11Data[1]<<8)+DHT11Data[0];
	DHT11Temp=(DHT11Data[3]<<8)+DHT11Data[2];
	}
}

//=====================================
u8 ReadData(void)
//=====================================
{
u8 i,counter,data;
data=0;
for(i=0;i<8;i++)
	{
	counter=PulseHighRead();
	if(counter<High40Value)	
		{
			if(counter>High10Value)
				data<<=1;
			else
				return 0;
		}
	else if(counter<High90Value)
		{
			if(counter>High60Value)
				{
					data|=0x01;
					data<<=1;
				}
			else
				return 0;		
		}
	if(PulseLowRead()==MaxTimeValue)
		return 0;		
	}		
return data;			
}

//=====================================
u16 PulseHighRead(void)
//=====================================
{
u16 high;
for(high=0;high<MaxTimeValue;high++)
	{
	if(GET_DATA_PIN()==0)	
		return high;
	}
SET_DEBUG_PIN_L();
}
//=====================================
u16 PulseLowRead(void)
//=====================================	
{
u16 low;
for(low=0;low<MaxTimeValue;low++)
	{
	if(GET_DATA_PIN()!=0)	
		return low;
	}
SET_DEBUG_PIN_L();	
}

