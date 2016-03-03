#include "sx1276_7_8.h"
#include "stm8s_flash.h"

extern u16 SysTime;
extern u16 time2_count;
extern u8 rf_rx_packet_length;

extern u8 time_flag;
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
extern u8	operation_flag;
/*typedef struct
{
	uchar	:0;
	uchar	:1;
	uchar	:2;
	uchar	:3;
	uchar	:1;
	uchar	:1;
	uchar	:1;
	uchar	uart1_busy:1;
} operation_flag;*/

extern void delay_ms(unsigned int ms);
extern void delay_us(unsigned int us);