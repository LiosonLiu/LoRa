   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
   4                     ; Optimizer V4.3.6 - 29 Nov 2011
2619                     ; 67 void main()
2619                     ; 68 //=====================================
2619                     ; 69 {
2621                     	switch	.text
2622  0000               _main:
2624  0000 5204          	subw	sp,#4
2625       00000004      OFST:	set	4
2628                     ; 70 	u16 i,j,k=0,g;
2630  0002 5f            	clrw	x
2631  0003 1f01          	ldw	(OFST-3,sp),x
2632                     ; 71 	SysTime 				= 0;
2634  0005 bf06          	ldw	_SysTime,x
2635                     ; 72 	SystemFlag 			= 0x00;
2637  0007 3f01          	clr	_SystemFlag
2638                     ; 73 	mode 						= 0x01;//lora mode
2640  0009 3501000d      	mov	_mode,#1
2641                     ; 74 	Freq_Sel 				= 0x00;//433M
2643  000d 3f0c          	clr	_Freq_Sel
2644                     ; 75 	Power_Sel 			= 0x00;//
2646  000f 3f0b          	clr	_Power_Sel
2647                     ; 76 	Lora_Rate_Sel 	= 0x06;//
2649  0011 3506000a      	mov	_Lora_Rate_Sel,#6
2650                     ; 77 	BandWide_Sel 		= 0x07;
2652  0015 35070009      	mov	_BandWide_Sel,#7
2653                     ; 78 	Fsk_Rate_Sel 		= 0x00;
2655  0019 3f08          	clr	_Fsk_Rate_Sel
2656                     ; 80 	_asm("sim");               //Disable interrupts.
2659  001b 9b            	sim	
2661                     ; 81 	mcu_init();
2663  001c cd00ee        	call	_mcu_init
2665                     ; 82 	ITC_SPR4 = 0xf3;//time2 interrupt priority 2¡¢level13
2667  001f 35f37f73      	mov	_ITC_SPR4,#243
2668                     ; 83 	ITC_SPR5 = 0x3c;//UART1_RX ¡¢UART_TX interrupt priority 2
2670  0023 353c7f74      	mov	_ITC_SPR5,#60
2671                     ; 84 	ITC_SPR6 = 0x00;//UART3_RX ¡¢UART_TX interrupt priority 2
2673  0027 725f7f75      	clr	_ITC_SPR6
2674                     ; 85 	_asm("rim");              //Enable interrupts.
2677  002b 9a            	rim	
2679                     ; 87 	GREEN_LED_L();
2681  002c 721b5014      	bres	_PE_ODR,#5
2682                     ; 88 	RED_LED_L();
2684                     ; 89 	delay_ms(500);
2686  0030 ae01f4        	ldw	x,#500
2687  0033 72115005      	bres	_PB_ODR,#0
2688  0037 cd01c0        	call	_delay_ms
2690                     ; 90 	GREEN_LED_H();
2692  003a 721a5014      	bset	_PE_ODR,#5
2693                     ; 91 	RED_LED_H();
2695  003e 72105005      	bset	_PB_ODR,#0
2696                     ; 92 	sx1278_Config();
2698  0042 cd0000        	call	_sx1278_Config
2700                     ; 93   sx1278_LoRaEntryRx();
2702  0045 cd0000        	call	_sx1278_LoRaEntryRx
2704                     ; 94 	TIM1_CR1 |= 0x01;			//enable time1
2706  0048 72105250      	bset	_TIM1_CR1,#0
2707                     ; 95 	MasterModeFlag=0;
2709  004c               LC001:
2711  004c 3f00          	clr	_MasterModeFlag
2712  004e               L1761:
2713                     ; 98 	if(GetOption())	//Slave
2715  004e 7203500b31    	btjf	_PC_IDR,#1,L5761
2716                     ; 100 		if(SystemFlag&PreviousOptionBit)
2718  0053 7201000105    	btjf	_SystemFlag,#0,L7761
2719                     ; 102 			sx1278_LoRaEntryRx();
2721  0058 cd0000        	call	_sx1278_LoRaEntryRx
2723                     ; 103 			SystemFlag&=(!PreviousOptionBit);
2725  005b 3f01          	clr	_SystemFlag
2726  005d               L7761:
2727                     ; 105 		if(sx1278_LoRaRxPacket())
2729  005d cd0000        	call	_sx1278_LoRaRxPacket
2731  0060 4d            	tnz	a
2732  0061 27eb          	jreq	L1761
2733                     ; 107 			GREEN_LED_L();
2735  0063 721b5014      	bres	_PE_ODR,#5
2736                     ; 108 			delay_ms(100);
2738  0067 ae0064        	ldw	x,#100
2739  006a cd01c0        	call	_delay_ms
2741                     ; 109 			GREEN_LED_H();
2743  006d 721a5014      	bset	_PE_ODR,#5
2744                     ; 110 			RED_LED_L();
2746  0071 72115005      	bres	_PB_ODR,#0
2747                     ; 111 			sx1278_LoRaEntryTx();
2749  0075 cd0000        	call	_sx1278_LoRaEntryTx
2751                     ; 112 			sx1278_LoRaTxPacket();
2753  0078 cd0000        	call	_sx1278_LoRaTxPacket
2755                     ; 113 			RED_LED_H();
2757  007b 72105005      	bset	_PB_ODR,#0
2758                     ; 114 			sx1278_LoRaEntryRx();
2760  007f cd0000        	call	_sx1278_LoRaEntryRx
2762  0082 20ca          	jra	L1761
2763  0084               L5761:
2764                     ; 119 		if((SystemFlag&PreviousOptionBit)==0)
2766  0084 7200000106    	btjt	_SystemFlag,#0,L5071
2767                     ; 121 			MasterModeFlag=0;
2769  0089 3f00          	clr	_MasterModeFlag
2770                     ; 122 			SystemFlag|=PreviousOptionBit;
2772  008b 72100001      	bset	_SystemFlag,#0
2773  008f               L5071:
2774                     ; 124 		switch(MasterModeFlag)
2776  008f b600          	ld	a,_MasterModeFlag
2778                     ; 158 				break;
2779  0091 2708          	jreq	L3361
2780  0093 4a            	dec	a
2781  0094 271c          	jreq	L5361
2782  0096 4a            	dec	a
2783  0097 274b          	jreq	L7361
2784  0099 20b3          	jra	L1761
2785  009b               L3361:
2786                     ; 126 			case 0:
2786                     ; 127 				if(time_flag==1)
2788  009b b602          	ld	a,_time_flag
2789  009d 4a            	dec	a
2790  009e 26ae          	jrne	L1761
2791                     ; 129 				time_flag=0;
2793  00a0 b702          	ld	_time_flag,a
2794                     ; 130 				RED_LED_L();
2796  00a2 72115005      	bres	_PB_ODR,#0
2797                     ; 131 				sx1278_LoRaEntryTx();
2799  00a6 cd0000        	call	_sx1278_LoRaEntryTx
2801                     ; 132 				sx1278_LoRaTxPacket();
2803  00a9 cd0000        	call	_sx1278_LoRaTxPacket
2805                     ; 133 				RED_LED_H();
2807  00ac 72105005      	bset	_PB_ODR,#0
2808                     ; 134 				MasterModeFlag++;
2809  00b0 202d          	jp	LC002
2810  00b2               L5361:
2811                     ; 137 			case 1:
2811                     ; 138 				sx1278_LoRaEntryRx();
2813  00b2 cd0000        	call	_sx1278_LoRaEntryRx
2815                     ; 139 				for(i=0;i<30;i++)
2817  00b5 5f            	clrw	x
2818  00b6 1f03          	ldw	(OFST-1,sp),x
2819  00b8               L5171:
2820                     ; 141 					delay_ms(100);
2822  00b8 ae0064        	ldw	x,#100
2823  00bb cd01c0        	call	_delay_ms
2825                     ; 142 					if(sx1278_LoRaRxPacket())
2827  00be cd0000        	call	_sx1278_LoRaRxPacket
2829  00c1 4d            	tnz	a
2830  00c2 2711          	jreq	L3271
2831                     ; 144 						i=50;
2833  00c4 ae0032        	ldw	x,#50
2834  00c7 1f03          	ldw	(OFST-1,sp),x
2835                     ; 145 						GREEN_LED_L();
2837                     ; 146 						delay_ms(100);
2839  00c9 58            	sllw	x
2840  00ca 721b5014      	bres	_PE_ODR,#5
2841  00ce cd01c0        	call	_delay_ms
2843                     ; 147 						GREEN_LED_H();			
2845  00d1 721a5014      	bset	_PE_ODR,#5
2846  00d5               L3271:
2847                     ; 139 				for(i=0;i<30;i++)
2849  00d5 1e03          	ldw	x,(OFST-1,sp)
2850  00d7 5c            	incw	x
2851  00d8 1f03          	ldw	(OFST-1,sp),x
2854  00da a3001e        	cpw	x,#30
2855  00dd 25d9          	jrult	L5171
2856                     ; 150 				MasterModeFlag++;
2858  00df               LC002:
2860  00df 3c00          	inc	_MasterModeFlag
2861                     ; 151 				break;
2863  00e1 cc004e        	jra	L1761
2864  00e4               L7361:
2865                     ; 152 			case 2:
2865                     ; 153 				if(time_flag==1)
2867  00e4 b602          	ld	a,_time_flag
2868  00e6 4a            	dec	a
2869  00e7 26f8          	jrne	L1761
2870                     ; 155 					time_flag=0;
2872  00e9 b702          	ld	_time_flag,a
2873                     ; 156 					MasterModeFlag=0;
2874  00eb cc004c        	jp	LC001
2905                     ; 168 void mcu_init(void)
2905                     ; 169 //=====================================
2905                     ; 170 {
2906                     	switch	.text
2907  00ee               _mcu_init:
2911                     ; 171 	CLK_Init();// base clock
2913  00ee cd0179        	call	_CLK_Init
2915                     ; 172 	power_on_delay(); //Power on delay
2917  00f1 cd0182        	call	_power_on_delay
2919                     ; 173 	GPIO_Init();
2921  00f4 ad1f          	call	_GPIO_Init
2923                     ; 174 	TIM_Init();
2925  00f6 cd0197        	call	_TIM_Init
2927                     ; 176 	PD_ODR=0b00000000;
2929  00f9 725f500f      	clr	_PD_ODR
2930                     ; 177 	delay_ms(20);
2932  00fd ae0014        	ldw	x,#20
2933  0100 cd01c0        	call	_delay_ms
2935                     ; 178 	PD_ODR=0b00000100;
2937  0103 3504500f      	mov	_PD_ODR,#4
2938                     ; 179 	delay_ms(20);	
2940  0107 ae0014        	ldw	x,#20
2941  010a cd01c0        	call	_delay_ms
2943                     ; 180 	FLASH_DeInit();
2945  010d cd0000        	call	_FLASH_DeInit
2947                     ; 181 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
2949  0110 a6f7          	ld	a,#247
2951                     ; 182 }
2954  0112 cc0000        	jp	_FLASH_Unlock
3002                     ; 184 void GPIO_Init(void) 
3002                     ; 185 //=====================================
3002                     ; 186 {
3003                     	switch	.text
3004  0115               _GPIO_Init:
3008                     ; 187 		PA_DDR = 0b00000000;	
3010  0115 725f5002      	clr	_PA_DDR
3011                     ; 188     PA_CR1 = 0b11111111;             
3013  0119 35ff5003      	mov	_PA_CR1,#255
3014                     ; 189 		PA_CR2 = 0b00000000;
3016  011d 725f5004      	clr	_PA_CR2
3017                     ; 190 		PA_ODR = 0b00000000;
3019  0121 725f5000      	clr	_PA_ODR
3020                     ; 192 		PB_DDR = 0b01000001;         
3022  0125 35415007      	mov	_PB_DDR,#65
3023                     ; 193     PB_CR1 = 0b11111111;               
3025  0129 35ff5008      	mov	_PB_CR1,#255
3026                     ; 194 		PB_CR2 = 0b01000001;
3028  012d 35415009      	mov	_PB_CR2,#65
3029                     ; 195 		PB_ODR = 0b01000001;
3031  0131 35415005      	mov	_PB_ODR,#65
3032                     ; 197     PC_DDR = 0b11010100;
3034  0135 35d4500c      	mov	_PC_DDR,#212
3035                     ; 198     PC_CR1 = 0b11111111;             
3037  0139 35ff500d      	mov	_PC_CR1,#255
3038                     ; 199 		PC_CR2 = 0b11010100;
3040  013d 35d4500e      	mov	_PC_CR2,#212
3041                     ; 200 		PC_ODR = 0b10000110;
3043  0141 3586500a      	mov	_PC_ODR,#134
3044                     ; 202 		PD_DDR = 0b00000100;
3046  0145 35045011      	mov	_PD_DDR,#4
3047                     ; 203 		PD_CR1 = 0b11111111;
3049  0149 35ff5012      	mov	_PD_CR1,#255
3050                     ; 204 		PD_CR2 = 0b00000100;
3052  014d 35045013      	mov	_PD_CR2,#4
3053                     ; 205 		PD_ODR = 0b00000000;
3055  0151 725f500f      	clr	_PD_ODR
3056                     ; 207 		PE_DDR = 0b00100000;
3058  0155 35205016      	mov	_PE_DDR,#32
3059                     ; 208 		PE_CR1 = 0b11111111;
3061  0159 35ff5017      	mov	_PE_CR1,#255
3062                     ; 209 		PE_CR2 = 0b00100000;
3064  015d 35205018      	mov	_PE_CR2,#32
3065                     ; 210 		PE_ODR = 0b00100000;
3067  0161 35205014      	mov	_PE_ODR,#32
3068                     ; 212 		PF_DDR = 0b00000000;							
3070  0165 725f501b      	clr	_PF_DDR
3071                     ; 213 		PF_CR1 = 0b11111111;	 			
3073  0169 35ff501c      	mov	_PF_CR1,#255
3074                     ; 214 		PF_CR2 = 0b00000000;							
3076  016d 725f501d      	clr	_PF_CR2
3077                     ; 215 		PF_ODR = 0b00000000;
3079  0171 725f5019      	clr	_PF_ODR
3080                     ; 217 		EXTI_CR1 |= 0b00000000;			
3082  0175 c650a0        	ld	a,_EXTI_CR1
3083                     ; 218 }
3086  0178 81            	ret	
3111                     ; 220 void CLK_Init(void)
3111                     ; 221 //=====================================
3111                     ; 222 {
3112                     	switch	.text
3113  0179               _CLK_Init:
3117                     ; 223 		CLK_ECKR = 0x00;		//Internal RC OSC
3119  0179 725f50c1      	clr	_CLK_ECKR
3120                     ; 224     CLK_CKDIVR = 0b00000000; //devide by 1
3122  017d 725f50c6      	clr	_CLK_CKDIVR
3123                     ; 225 }
3126  0181 81            	ret	
3161                     ; 228 void power_on_delay(void)
3161                     ; 229 //=====================================
3161                     ; 230 {
3162                     	switch	.text
3163  0182               _power_on_delay:
3165  0182 89            	pushw	x
3166       00000002      OFST:	set	2
3169                     ; 232 	for(i = 0; i<500; i++)//500MS
3171  0183 5f            	clrw	x
3172  0184 1f01          	ldw	(OFST-1,sp),x
3173  0186               L5771:
3174                     ; 234 		delay_ms(1);
3176  0186 ae0001        	ldw	x,#1
3177  0189 ad35          	call	_delay_ms
3179                     ; 232 	for(i = 0; i<500; i++)//500MS
3181  018b 1e01          	ldw	x,(OFST-1,sp)
3182  018d 5c            	incw	x
3183  018e 1f01          	ldw	(OFST-1,sp),x
3186  0190 a301f4        	cpw	x,#500
3187  0193 25f1          	jrult	L5771
3188                     ; 236 }
3191  0195 85            	popw	x
3192  0196 81            	ret	
3225                     ; 239 void TIM_Init(void)
3225                     ; 240 //=====================================
3225                     ; 241 {
3226                     	switch	.text
3227  0197               _TIM_Init:
3231                     ; 244     TIM1_ARRH   = 0x03;
3233  0197 35035262      	mov	_TIM1_ARRH,#3
3234                     ; 245     TIM1_ARRL   = 0xe8;           /* Freq control register: ARR automatic reload 1ms */
3236  019b 35e85263      	mov	_TIM1_ARRL,#232
3237                     ; 247     TIM1_PSCRH  = 0x00;           /* Configure TIM1 prescaler_H       */
3239  019f 725f5260      	clr	_TIM1_PSCRH
3240                     ; 248 		TIM1_PSCRL  = 0x0f;           /* Configure TIM1 prescaler_L   16 frequency divier     */
3242  01a3 350f5261      	mov	_TIM1_PSCRL,#15
3243                     ; 249 		TIM1_IER   |= 0x01;						//enable refresh interrupt
3245  01a7 72105254      	bset	_TIM1_IER,#0
3246                     ; 250     TIM1_CR1    |= 0x80;
3248  01ab 721e5250      	bset	_TIM1_CR1,#7
3249                     ; 253 		TIM4_ARR   = 0xa0;           	// Freq control register: ARR automatic reload 10us
3251  01af 35a05348      	mov	_TIM4_ARR,#160
3252                     ; 255     TIM4_PSCR   = 0x00;          	// Configure TIM4 prescaler =128  Base clockÎª8us 
3254  01b3 725f5347      	clr	_TIM4_PSCR
3255                     ; 256 		TIM4_IER   |= 0x01;						//enable refresh interrupt
3257  01b7 72105343      	bset	_TIM4_IER,#0
3258                     ; 257 		TIM4_CR1   |= 0x80;						//bit ARPE set to 1 enable automatic reload \URS set to 1 refresh interrupt only whne counter is overflowed*/
3260  01bb 721e5340      	bset	_TIM4_CR1,#7
3261                     ; 259 }
3264  01bf 81            	ret	
3317                     ; 262 void delay_ms(unsigned int ms)
3317                     ; 263 //=====================================
3317                     ; 264 {
3318                     	switch	.text
3319  01c0               _delay_ms:
3321  01c0 89            	pushw	x
3322  01c1 5204          	subw	sp,#4
3323       00000004      OFST:	set	4
3326                     ; 267 	for(j=0;j<ms;j++)
3328  01c3 5f            	clrw	x
3330  01c4 2015          	jra	L5402
3331  01c6               L1402:
3332                     ; 269 		for(i=0;i<650;i++)
3334  01c6 5f            	clrw	x
3335  01c7 1f03          	ldw	(OFST-1,sp),x
3336  01c9               L1502:
3337                     ; 271 			delay_us(1);
3339  01c9 ae0001        	ldw	x,#1
3340  01cc ad16          	call	_delay_us
3342                     ; 269 		for(i=0;i<650;i++)
3344  01ce 1e03          	ldw	x,(OFST-1,sp)
3345  01d0 5c            	incw	x
3346  01d1 1f03          	ldw	(OFST-1,sp),x
3349  01d3 a3028a        	cpw	x,#650
3350  01d6 25f1          	jrult	L1502
3351                     ; 267 	for(j=0;j<ms;j++)
3353  01d8 1e01          	ldw	x,(OFST-3,sp)
3354  01da 5c            	incw	x
3355  01db               L5402:
3356  01db 1f01          	ldw	(OFST-3,sp),x
3359  01dd 1305          	cpw	x,(OFST+1,sp)
3360  01df 25e5          	jrult	L1402
3361                     ; 274 }
3364  01e1 5b06          	addw	sp,#6
3365  01e3 81            	ret	
3400                     ; 277 void delay_us(unsigned int us)
3400                     ; 278 //=====================================
3400                     ; 279 {
3401                     	switch	.text
3402  01e4               _delay_us:
3406                     ; 280 	NOP();
3409  01e4 9d            	nop	
3411                     ; 281 }
3415  01e5 81            	ret	
3539                     	xdef	_main
3540                     	xdef	_TIM_Init
3541                     	xdef	_power_on_delay
3542                     	xdef	_CLK_Init
3543                     	xdef	_GPIO_Init
3544                     	xdef	_mcu_init
3545                     	switch	.ubsct
3546  0000               _MasterModeFlag:
3547  0000 00            	ds.b	1
3548                     	xdef	_MasterModeFlag
3549  0001               _SystemFlag:
3550  0001 00            	ds.b	1
3551                     	xdef	_SystemFlag
3552  0002               _time_flag:
3553  0002 00            	ds.b	1
3554                     	xdef	_time_flag
3555  0003               _rf_rx_packet_length:
3556  0003 00            	ds.b	1
3557                     	xdef	_rf_rx_packet_length
3558  0004               _time2_count:
3559  0004 0000          	ds.b	2
3560                     	xdef	_time2_count
3561                     	xref	_FLASH_DeInit
3562                     	xref	_FLASH_Unlock
3563                     	xref	_sx1278_LoRaTxPacket
3564                     	xref	_sx1278_LoRaEntryTx
3565                     	xref	_sx1278_LoRaRxPacket
3566                     	xref	_sx1278_LoRaEntryRx
3567                     	xref	_sx1278_Config
3568                     	xdef	_delay_us
3569                     	xdef	_delay_ms
3570  0006               _SysTime:
3571  0006 0000          	ds.b	2
3572                     	xdef	_SysTime
3573  0008               _Fsk_Rate_Sel:
3574  0008 00            	ds.b	1
3575                     	xdef	_Fsk_Rate_Sel
3576  0009               _BandWide_Sel:
3577  0009 00            	ds.b	1
3578                     	xdef	_BandWide_Sel
3579  000a               _Lora_Rate_Sel:
3580  000a 00            	ds.b	1
3581                     	xdef	_Lora_Rate_Sel
3582  000b               _Power_Sel:
3583  000b 00            	ds.b	1
3584                     	xdef	_Power_Sel
3585  000c               _Freq_Sel:
3586  000c 00            	ds.b	1
3587                     	xdef	_Freq_Sel
3588  000d               _mode:
3589  000d 00            	ds.b	1
3590                     	xdef	_mode
3610                     	end
