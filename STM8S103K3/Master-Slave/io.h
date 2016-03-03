
//=================LoRa========================
#define NSS_H() 						PC_ODR |= 0b10000000								//PC7
#define NSS_L() 						PC_ODR &= 0b01111111
#define SCK_H()							PC_ODR |= 0b00010000								//PC4
#define SCK_L()							PC_ODR &= 0b11101111
#define MOSI_H()						PC_ODR |= 0b01000000								//PC6
#define MOSI_L()						PC_ODR &= 0b10111111
#define Get_MISO()					(PC_IDR & 0b00100000) == 0b00100000	//PC5
#define Get_NIRQ()					(PD_IDR & 0b00001000) == 0b00001000 //PD3

//=================IO==========================
#define GREEN_LED_H()				PE_ODR |= 0b00100000								//PE5
#define GREEN_LED_L()				PE_ODR &= 0b11011111
#define RED_LED_H()					PB_ODR |= 0b00000001								//PB0
#define RED_LED_L()					PB_ODR &= 0b11111110
#define ANT_EN_H()					PB_ODR |= 0b01000000								//PB6
#define ANT_EN_L()					PB_ODR &= 0b10111111	
#define ANT_CTRL_RX()				PC_ODR |= 0b00000100								//PC2
#define ANT_CTRL_TX()				PC_ODR &= 0b11111011
#define GetOption()					(PC_IDR & 0b00000010) == 0b00000010	//PC1