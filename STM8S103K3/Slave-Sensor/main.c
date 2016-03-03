/**********************************************
Title:						sx1278 demo code
Current version:	v1.0
Company:					Exosite
Function:					Master/Slave device
Processor:				STM8S103K3
Clock: 						internal 16MHz
Operate freqency:	433MHZ band
Work mode: 				LoRa
LoRa Xctal:				26MHz
Date:2016-03-03

Note: Check IO.h for pin config
*************************************************/

#include "main.h" 
u16 SysTime;
u16 time2_count;
u8 rf_rx_packet_length;
u8 mode;//lora--1/FSK--0
u8 Freq_Sel;
u8 Power_Sel;
u8 Lora_Rate_Sel;
u8 BandWide_Sel;
u8 Fsk_Rate_Sel;
u8 time_flag;
/*{
bit0 time_1s;
bit1 time_2s;
bit2 time_50ms;
bit3 ;
bit4 ;
bit5 ;
bit6 ;
bit7 ;
}*/
u8	SystemFlag;
#define	PreviousOptionBit	(1<<0)
/*typedef struct
{
	uchar	:RxPacketReceived-0;
	uchar	:
	uchar	:
	uchar	:
	uchar	:
	uchar	:
	uchar	:
	uchar	;
}*/

u8 MasterModeFlag;
void mcu_init(void);
void GPIO_Init(void);
void CLK_Init(void);
void power_on_delay(void); //Power on delay
void TIM_Init(void);
void power_on_config_read(void);
/******delay*************/
void delay_ms(unsigned int ms);
void delay_us(unsigned int us);

#define Transmit=1;
#define Receive=0;
#define WorkingMode=Transmit;

//=====================================
void main()
//=====================================
{
	u16 i,j,k=0,g;
	SysTime 				= 0;
	SystemFlag 			= 0x00;
	mode 						= 0x01;//lora mode
	Freq_Sel 				= 0x00;//433M
	Power_Sel 			= 0x00;//
	Lora_Rate_Sel 	= 0x06;//
	BandWide_Sel 		= 0x07;
	Fsk_Rate_Sel 		= 0x00;
	
	_asm("sim");               //Disable interrupts.
	mcu_init();
	ITC_SPR4 = 0xf3;//time2 interrupt priority 2¡¢level13
	ITC_SPR5 = 0x3c;//UART1_RX ¡¢UART_TX interrupt priority 2
	ITC_SPR6 = 0x00;//UART3_RX ¡¢UART_TX interrupt priority 2
	_asm("rim");              //Enable interrupts.
	
	GREEN_LED_L();
	RED_LED_L();
	delay_ms(500);
	GREEN_LED_H();
	RED_LED_H();
	sx1278_Config();
  sx1278_LoRaEntryRx();
	TIM1_CR1 |= 0x01;			//enable time1
	MasterModeFlag=0;
	while(1)
	{
	if(GetOption())	//Slave
		{
		if(SystemFlag&PreviousOptionBit)
			{
			sx1278_LoRaEntryRx();
			SystemFlag&=(!PreviousOptionBit);
			}
		if(sx1278_LoRaRxPacket())
			{
			GREEN_LED_L();
			delay_ms(100);
			GREEN_LED_H();
			RED_LED_L();
			sx1278_LoRaEntryTx();
			sx1278_LoRaTxPacket();
			RED_LED_H();
			sx1278_LoRaEntryRx();
			}		
		}
	else					//Master
		{
		if((SystemFlag&PreviousOptionBit)==0)
			{
			MasterModeFlag=0;
			SystemFlag|=PreviousOptionBit;
			}			
		switch(MasterModeFlag)
			{
			case 0:
				if(time_flag==1)
				{
				time_flag=0;
				RED_LED_L();
				sx1278_LoRaEntryTx();
				sx1278_LoRaTxPacket();
				RED_LED_H();
				MasterModeFlag++;
				}
				break;
			case 1:
				sx1278_LoRaEntryRx();
				for(i=0;i<30;i++)
					{
					delay_ms(100);
					if(sx1278_LoRaRxPacket())
						{
						i=50;
						GREEN_LED_L();
						delay_ms(100);
						GREEN_LED_H();			
						}
					}
				MasterModeFlag++;
				break;
			case 2:
				if(time_flag==1)
					{
					time_flag=0;
					MasterModeFlag=0;
					}
				break;
			}
		}
	}
}
	
	


//=====================================
void mcu_init(void)
//=====================================
{
	CLK_Init();// base clock
	power_on_delay(); //Power on delay
	GPIO_Init();
	TIM_Init();
	//reset LoRa
	PD_ODR=0b00000000;
	delay_ms(20);
	PD_ODR=0b00000100;
	delay_ms(20);	
	FLASH_DeInit();
	FLASH_Unlock(FLASH_MEMTYPE_DATA);
}
//=====================================
void GPIO_Init(void) 
//=====================================
{
		PA_DDR = 0b00000000;	
    PA_CR1 = 0b11111111;             
		PA_CR2 = 0b00000000;
		PA_ODR = 0b00000000;
		
		PB_DDR = 0b01000001;         
    PB_CR1 = 0b11111111;               
		PB_CR2 = 0b01000001;
		PB_ODR = 0b01000001;
		
    PC_DDR = 0b11010100;
    PC_CR1 = 0b11111111;             
		PC_CR2 = 0b11010100;
		PC_ODR = 0b10000110;
		
		PD_DDR = 0b00000100;
		PD_CR1 = 0b11111111;
		PD_CR2 = 0b00000100;
		PD_ODR = 0b00000000;

		PE_DDR = 0b00100000;
		PE_CR1 = 0b11111111;
		PE_CR2 = 0b00100000;
		PE_ODR = 0b00100000;
	
		PF_DDR = 0b00000000;							
		PF_CR1 = 0b11111111;	 			
		PF_CR2 = 0b00000000;							
		PF_ODR = 0b00000000;
	
		EXTI_CR1 |= 0b00000000;			
}
//=====================================
void CLK_Init(void)
//=====================================
{
		CLK_ECKR = 0x00;		//Internal RC OSC
    CLK_CKDIVR = 0b00000000; //devide by 1
}

//=====================================
void power_on_delay(void)
//=====================================
{
	u16 i;
	for(i = 0; i<500; i++)//500MS
	{
		delay_ms(1);
	}	
}

//=====================================
void TIM_Init(void)
//=====================================
{
   /* TIM1 function for system clock */
		//TIM1_EGR		|= 0x01;
    TIM1_ARRH   = 0x03;
    TIM1_ARRL   = 0xe8;           /* Freq control register: ARR automatic reload 1ms */
		
    TIM1_PSCRH  = 0x00;           /* Configure TIM1 prescaler_H       */
		TIM1_PSCRL  = 0x0f;           /* Configure TIM1 prescaler_L   16 frequency divier     */
		TIM1_IER   |= 0x01;						//enable refresh interrupt
    TIM1_CR1    |= 0x80;
		
		/* TIM4 function for system clock */
		TIM4_ARR   = 0xa0;           	// Freq control register: ARR automatic reload 10us

    TIM4_PSCR   = 0x00;          	// Configure TIM4 prescaler =128  Base clockÎª8us 
		TIM4_IER   |= 0x01;						//enable refresh interrupt
		TIM4_CR1   |= 0x80;						//bit ARPE set to 1 enable automatic reload \URS set to 1 refresh interrupt only whne counter is overflowed*/
		
}

//=====================================
void delay_ms(unsigned int ms)
//=====================================
{
	unsigned int i,j;
	
	for(j=0;j<ms;j++)
	{
		for(i=0;i<650;i++)
		{
			delay_us(1);
		}
	}
}

//=====================================
void delay_us(unsigned int us)
//=====================================
{
	NOP();
}