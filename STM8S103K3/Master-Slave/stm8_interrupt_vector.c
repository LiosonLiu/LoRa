/*	BASIC INTERRUPT VECTOR TABLE FOR STM8 devices
 *	Copyright (c) 2007 STMicroelectronics
 */
#include "STM8S103K3.h"
#include "STM8S_type.h"
#include "sx1276_7_8.h"

extern u16 SysTime;
extern u16 time2_count;


extern u8 time_flag;
/*{
bit0 time_1s;
bit1 
bit2 ;
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
	uchar	:1;
} operation_flag;*/


typedef void @far (*interrupt_handler_t)(void);

struct interrupt_vector {
	unsigned char interrupt_instruction;
	interrupt_handler_t interrupt_handler;
};

//===============================================
@far @interrupt void PBX_IO_Switch_HandledInterrupt (void)
//===============================================
{
	return;	
}
//===============================================
@far @interrupt void PDX_IO_Switch_HandledInterrupt (void)
//===============================================
{
		return;
}
//===============================================
@far @interrupt void Timer1_Overflow_HandledInterrupt (void)
//===============================================
{
	if(TIM1_SR1 & 0x01)
	{
		TIM1_SR1 &= 0xfe; //clear time1 overflow flag
		SysTime++;
		if(SysTime > 1500)
		{
			SysTime = 0;
			time_flag |= 0x01;
		}
	}
	return;
}
//===============================================
@far @interrupt void Timer2_Overflow_HandledInterrupt (void)
//===============================================
{
}
//===============================================
@far @interrupt void Uart1_TX_Data_HandledInterrupt (void)
//===============================================
{
	return;
}
//===============================================
@far @interrupt void Uart1_RX_Data_HandledInterrupt (void)
//===============================================
{
	return;
}
//===============================================
@far @interrupt void NonHandledInterrupt (void)
//===============================================
{
	return;
}



extern void _stext();     /* startup routine */

struct interrupt_vector const _vectab[] = {
	{0x82, (interrupt_handler_t)_stext}, /* reset */
	{0x82, NonHandledInterrupt}, /* trap  */
	{0x82, NonHandledInterrupt}, /* irq0  */
	{0x82, NonHandledInterrupt}, /* irq1  */
	{0x82, NonHandledInterrupt}, /* irq2  */
	{0x82, NonHandledInterrupt}, /* irq3  */
	{0x82, PBX_IO_Switch_HandledInterrupt}, /* irq4  */
	{0x82, NonHandledInterrupt}, /* irq5  */
	{0x82, PDX_IO_Switch_HandledInterrupt}, /* irq6  */
	{0x82, NonHandledInterrupt}, /* irq7  */
	{0x82, NonHandledInterrupt}, /* irq8  */
	{0x82, NonHandledInterrupt}, /* irq9  */
	{0x82, NonHandledInterrupt}, /* irq10 */
	{0x82, Timer1_Overflow_HandledInterrupt}, /* irq11 */
	{0x82, NonHandledInterrupt}, /* irq12 */
	{0x82, Timer2_Overflow_HandledInterrupt}, /* irq13 */
	{0x82, NonHandledInterrupt}, /* irq14 */
	{0x82, NonHandledInterrupt}, /* irq15 */
	{0x82, NonHandledInterrupt}, /* irq16 */
	{0x82, Uart1_TX_Data_HandledInterrupt}, /* irq17 */
	{0x82, Uart1_RX_Data_HandledInterrupt}, /* irq18 */
	{0x82, NonHandledInterrupt}, /* irq19 */
	{0x82, NonHandledInterrupt}, /* irq20 */
	{0x82, NonHandledInterrupt}, /* irq21 */
	{0x82, NonHandledInterrupt}, /* irq22 */
	{0x82, NonHandledInterrupt}, /* irq23 */
	{0x82, NonHandledInterrupt}, /* irq24 */
	{0x82, NonHandledInterrupt}, /* irq25 */
	{0x82, NonHandledInterrupt}, /* irq26 */
	{0x82, NonHandledInterrupt}, /* irq27 */
	{0x82, NonHandledInterrupt}, /* irq28 */
	{0x82, NonHandledInterrupt}, /* irq29 */
};
