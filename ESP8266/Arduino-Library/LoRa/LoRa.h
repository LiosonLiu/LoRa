
/*
Hardware-ESP8266:

    				 	------------
	RST				-|				|-TXD
	A0		ADC		-|				|-RXD
	EN				-|				|-IO5
	IO16			-|				|-IO4 	humidity_sensor 4
	IO14/SCLK		-|				|-IO0/PROG-BOOT		
LED G IO12/MISO		-|				|-IO2
LED B	IO13/MOSI	-|				|-IO15/CS	LED R
	VCC				-|				|-GND
						------------
						| | | | | |
						C M I I M S
						S I O O O C
						0 S 9 1 S L
				  		  O   0 I K

	a.TX Ind	DIO0		GPIO16							-TX/RX indication	
	b.ANT_EN	PIN1		GPIO4							-
	c.			PIN4		GPIO5

*/



#ifndef LoRa_h
#define LoRa_h
#include "Arduino.h"	
#include <inttypes.h>	
class LoRa
{
public:
	int 	m_SPI_CS_PIN;	//15
	int 	m_SPI_MISO_PIN;	//12
 	int 	m_SPI_MOSI_PIN;	//13
 	int 	m_SPI_SCK_PIN;	//14	
	int 	m_DIO0_PIN; 	//16
	int 	m_ANT_EN_PIN; 	//4
	int 	m_RESET_PIN;	//5

	uint8_t	m_TXLength;		//32
	uint8_t m_RXLength;		//32
	char m_TXData[128]; 	//= "EXOSITE0000000000000000000000000";
	char m_RXData[128];	//= "00000000000000000000000000000000";
	//char m_TXData[] 	= "EXOSITE0000000000000000000000000";
	//char m_RXData[]		= "00000000000000000000000000000000";
	LoRa(void);	
	void Initial(uint8_t SPI_CS_PIN,uint8_t SPI_MISO_PIN,uint8_t SPI_MOSI_PIN,uint8_t SPI_SCK_PIN,uint8_t ANT_EN_PIN,uint8_t RESET_PIN,uint8_t DIO0_PIN);
	void InitialSend(uint8_t TX_Length);
	void Send(char buffer[]);
	void InitialReceive(uint8_t RX_Length);
	unsigned Receive(unsigned long Duration);
};
// REGISTER
#define REG_FIFO                    0x00
#define REG_OPMODE                  0x01
#define REG_FREQ23_16				0x06
#define REG_FREQ15_8				0x07
#define REG_FREQ7_0					0x08
#define REG_PA_CONFIG               0x09	// POWER AMPLIFIER CONFIG
#define REG_PA_RAMP					0x0A
#define REG_OCP						0x0B	//Over load current protection
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
#define REG_RX_TIME_OUT				0x1F
#define REG_PREAMBLE_LENGTH_H		0x20
#define REG_PREAMBLE_LENGTH_L		0x21
#define REG_PAYLOAD_LENGTH          0x22
#define REG_HOP_PERIOD              0x24
#define REG_DIO_MAPPING_1           0x40
#define REG_DIO_MAPPING_2           0x41
#define REG_LR_PADAC				0x4D
// MODES
#define LORA_SLEEP             		0x08
#define LORA_STANDBY           		0x09
#define LORA_TX				        0x8B
#define LORA_RX_CONTINUOS      		0x8D
// LOW NOISE AMPLIFIER
#define REG_LNA                     0x0C
#define LNA_MAX_GAIN                0x23  // 0010 0011
#define LNA_OFF_GAIN                0x00
#define CR							1			//1=>4/5,2=>4/6,3=>4/7,4=>4/8
#define Lora_Rate_Sel				6
#define BandWidth_Sel				7
// INT
//#define u8 unsigned char

const unsigned char Freq433Table[3] 			= {0x85,0x3b,0x13};	//433Mhz
const unsigned char sx1278PowerTable[16]		= {0xF0,0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF};    //FF=20dbm,FC=17dbm,F9=14dbm,F6=11dbm 
const unsigned char sx1278SpreadFactorTable[7] = {6,7,8,9,10,11,12};	//64/128/256/512/1024/2048/4096 chips/symble
const unsigned char sx1278LoRaBwTable[10] 		= {0,1,2,3,4,5,6,7,8,9};	//7.8KHz,10.4KHz,15.6KHz,20.8KHz,31.2KHz,41.7KHz,62.5KHz,125KHz,250KHz,500KHz

#endif

