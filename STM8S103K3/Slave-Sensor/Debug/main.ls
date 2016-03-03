   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2616                     ; 67 void main()
2616                     ; 68 //=====================================
2616                     ; 69 {
2618                     	switch	.text
2619  0000               _main:
2621  0000 5204          	subw	sp,#4
2622       00000004      OFST:	set	4
2625                     ; 70 	u16 i,j,k=0,g;
2627  0002 5f            	clrw	x
2628  0003 1f01          	ldw	(OFST-3,sp),x
2629                     ; 71 	SysTime 				= 0;
2631  0005 5f            	clrw	x
2632  0006 bf06          	ldw	_SysTime,x
2633                     ; 72 	SystemFlag 			= 0x00;
2635  0008 3f01          	clr	_SystemFlag
2636                     ; 73 	mode 						= 0x01;//lora mode
2638  000a 3501000d      	mov	_mode,#1
2639                     ; 74 	Freq_Sel 				= 0x00;//433M
2641  000e 3f0c          	clr	_Freq_Sel
2642                     ; 75 	Power_Sel 			= 0x00;//
2644  0010 3f0b          	clr	_Power_Sel
2645                     ; 76 	Lora_Rate_Sel 	= 0x06;//
2647  0012 3506000a      	mov	_Lora_Rate_Sel,#6
2648                     ; 77 	BandWide_Sel 		= 0x07;
2650  0016 35070009      	mov	_BandWide_Sel,#7
2651                     ; 78 	Fsk_Rate_Sel 		= 0x00;
2653  001a 3f08          	clr	_Fsk_Rate_Sel
2654                     ; 80 	_asm("sim");               //Disable interrupts.
2657  001c 9b            sim
2659                     ; 81 	mcu_init();
2661  001d cd010b        	call	_mcu_init
2663                     ; 82 	ITC_SPR4 = 0xf3;//time2 interrupt priority 2¡¢level13
2665  0020 35f37f73      	mov	_ITC_SPR4,#243
2666                     ; 83 	ITC_SPR5 = 0x3c;//UART1_RX ¡¢UART_TX interrupt priority 2
2668  0024 353c7f74      	mov	_ITC_SPR5,#60
2669                     ; 84 	ITC_SPR6 = 0x00;//UART3_RX ¡¢UART_TX interrupt priority 2
2671  0028 725f7f75      	clr	_ITC_SPR6
2672                     ; 85 	_asm("rim");              //Enable interrupts.
2675  002c 9a            rim
2677                     ; 87 	GREEN_LED_L();
2679  002d 721b5014      	bres	_PE_ODR,#5
2680                     ; 88 	RED_LED_L();
2682  0031 72115005      	bres	_PB_ODR,#0
2683                     ; 89 	delay_ms(500);
2685  0035 ae01f4        	ldw	x,#500
2686  0038 cd01e2        	call	_delay_ms
2688                     ; 90 	GREEN_LED_H();
2690  003b 721a5014      	bset	_PE_ODR,#5
2691                     ; 91 	RED_LED_H();
2693  003f 72105005      	bset	_PB_ODR,#0
2694                     ; 92 	sx1278_Config();
2696  0043 cd0000        	call	_sx1278_Config
2698                     ; 93   sx1278_LoRaEntryRx();
2700  0046 cd0000        	call	_sx1278_LoRaEntryRx
2702                     ; 94 	TIM1_CR1 |= 0x01;			//enable time1
2704  0049 72105250      	bset	_TIM1_CR1,#0
2705                     ; 95 	MasterModeFlag=0;
2707  004d 3f00          	clr	_MasterModeFlag
2708  004f               L1761:
2709                     ; 98 	if(GetOption())	//Slave
2711  004f c6500b        	ld	a,_PC_IDR
2712  0052 a402          	and	a,#2
2713  0054 a102          	cp	a,#2
2714  0056 2632          	jrne	L5761
2715                     ; 100 		if(SystemFlag&PreviousOptionBit)
2717  0058 b601          	ld	a,_SystemFlag
2718  005a a501          	bcp	a,#1
2719  005c 2705          	jreq	L7761
2720                     ; 102 			sx1278_LoRaEntryRx();
2722  005e cd0000        	call	_sx1278_LoRaEntryRx
2724                     ; 103 			SystemFlag&=(!PreviousOptionBit);
2726  0061 3f01          	clr	_SystemFlag
2727  0063               L7761:
2728                     ; 105 		if(sx1278_LoRaRxPacket())
2730  0063 cd0000        	call	_sx1278_LoRaRxPacket
2732  0066 4d            	tnz	a
2733  0067 27e6          	jreq	L1761
2734                     ; 107 			GREEN_LED_L();
2736  0069 721b5014      	bres	_PE_ODR,#5
2737                     ; 108 			delay_ms(100);
2739  006d ae0064        	ldw	x,#100
2740  0070 cd01e2        	call	_delay_ms
2742                     ; 109 			GREEN_LED_H();
2744  0073 721a5014      	bset	_PE_ODR,#5
2745                     ; 110 			RED_LED_L();
2747  0077 72115005      	bres	_PB_ODR,#0
2748                     ; 111 			sx1278_LoRaEntryTx();
2750  007b cd0000        	call	_sx1278_LoRaEntryTx
2752                     ; 112 			sx1278_LoRaTxPacket();
2754  007e cd0000        	call	_sx1278_LoRaTxPacket
2756                     ; 113 			RED_LED_H();
2758  0081 72105005      	bset	_PB_ODR,#0
2759                     ; 114 			sx1278_LoRaEntryRx();
2761  0085 cd0000        	call	_sx1278_LoRaEntryRx
2763  0088 20c5          	jra	L1761
2764  008a               L5761:
2765                     ; 119 		if((SystemFlag&PreviousOptionBit)==0)
2767  008a b601          	ld	a,_SystemFlag
2768  008c a501          	bcp	a,#1
2769  008e 2606          	jrne	L5071
2770                     ; 121 			MasterModeFlag=0;
2772  0090 3f00          	clr	_MasterModeFlag
2773                     ; 122 			SystemFlag|=PreviousOptionBit;
2775  0092 72100001      	bset	_SystemFlag,#0
2776  0096               L5071:
2777                     ; 124 		switch(MasterModeFlag)
2779  0096 b600          	ld	a,_MasterModeFlag
2781                     ; 158 				break;
2782  0098 4d            	tnz	a
2783  0099 2708          	jreq	L3361
2784  009b 4a            	dec	a
2785  009c 271f          	jreq	L5361
2786  009e 4a            	dec	a
2787  009f 2755          	jreq	L7361
2788  00a1 20ac          	jra	L1761
2789  00a3               L3361:
2790                     ; 126 			case 0:
2790                     ; 127 				if(time_flag==1)
2792  00a3 b602          	ld	a,_time_flag
2793  00a5 a101          	cp	a,#1
2794  00a7 26a6          	jrne	L1761
2795                     ; 129 				time_flag=0;
2797  00a9 3f02          	clr	_time_flag
2798                     ; 130 				RED_LED_L();
2800  00ab 72115005      	bres	_PB_ODR,#0
2801                     ; 131 				sx1278_LoRaEntryTx();
2803  00af cd0000        	call	_sx1278_LoRaEntryTx
2805                     ; 132 				sx1278_LoRaTxPacket();
2807  00b2 cd0000        	call	_sx1278_LoRaTxPacket
2809                     ; 133 				RED_LED_H();
2811  00b5 72105005      	bset	_PB_ODR,#0
2812                     ; 134 				MasterModeFlag++;
2814  00b9 3c00          	inc	_MasterModeFlag
2815  00bb 2092          	jra	L1761
2816  00bd               L5361:
2817                     ; 137 			case 1:
2817                     ; 138 				sx1278_LoRaEntryRx();
2819  00bd cd0000        	call	_sx1278_LoRaEntryRx
2821                     ; 139 				for(i=0;i<30;i++)
2823  00c0 5f            	clrw	x
2824  00c1 1f03          	ldw	(OFST-1,sp),x
2825  00c3               L5171:
2826                     ; 141 					delay_ms(100);
2828  00c3 ae0064        	ldw	x,#100
2829  00c6 cd01e2        	call	_delay_ms
2831                     ; 142 					if(sx1278_LoRaRxPacket())
2833  00c9 cd0000        	call	_sx1278_LoRaRxPacket
2835  00cc 4d            	tnz	a
2836  00cd 2713          	jreq	L3271
2837                     ; 144 						i=50;
2839  00cf ae0032        	ldw	x,#50
2840  00d2 1f03          	ldw	(OFST-1,sp),x
2841                     ; 145 						GREEN_LED_L();
2843  00d4 721b5014      	bres	_PE_ODR,#5
2844                     ; 146 						delay_ms(100);
2846  00d8 ae0064        	ldw	x,#100
2847  00db cd01e2        	call	_delay_ms
2849                     ; 147 						GREEN_LED_H();			
2851  00de 721a5014      	bset	_PE_ODR,#5
2852  00e2               L3271:
2853                     ; 139 				for(i=0;i<30;i++)
2855  00e2 1e03          	ldw	x,(OFST-1,sp)
2856  00e4 1c0001        	addw	x,#1
2857  00e7 1f03          	ldw	(OFST-1,sp),x
2860  00e9 1e03          	ldw	x,(OFST-1,sp)
2861  00eb a3001e        	cpw	x,#30
2862  00ee 25d3          	jrult	L5171
2863                     ; 150 				MasterModeFlag++;
2865  00f0 3c00          	inc	_MasterModeFlag
2866                     ; 151 				break;
2868  00f2 ac4f004f      	jpf	L1761
2869  00f6               L7361:
2870                     ; 152 			case 2:
2870                     ; 153 				if(time_flag==1)
2872  00f6 b602          	ld	a,_time_flag
2873  00f8 a101          	cp	a,#1
2874  00fa 2703          	jreq	L6
2875  00fc cc004f        	jp	L1761
2876  00ff               L6:
2877                     ; 155 					time_flag=0;
2879  00ff 3f02          	clr	_time_flag
2880                     ; 156 					MasterModeFlag=0;
2882  0101 3f00          	clr	_MasterModeFlag
2883  0103 ac4f004f      	jpf	L1761
2884  0107               L1171:
2885  0107 ac4f004f      	jpf	L1761
2916                     ; 168 void mcu_init(void)
2916                     ; 169 //=====================================
2916                     ; 170 {
2917                     	switch	.text
2918  010b               _mcu_init:
2922                     ; 171 	CLK_Init();// base clock
2924  010b cd0197        	call	_CLK_Init
2926                     ; 172 	power_on_delay(); //Power on delay
2928  010e cd01a0        	call	_power_on_delay
2930                     ; 173 	GPIO_Init();
2932  0111 ad20          	call	_GPIO_Init
2934                     ; 174 	TIM_Init();
2936  0113 cd01b9        	call	_TIM_Init
2938                     ; 176 	PD_ODR=0b00000000;
2940  0116 725f500f      	clr	_PD_ODR
2941                     ; 177 	delay_ms(20);
2943  011a ae0014        	ldw	x,#20
2944  011d cd01e2        	call	_delay_ms
2946                     ; 178 	PD_ODR=0b00000100;
2948  0120 3504500f      	mov	_PD_ODR,#4
2949                     ; 179 	delay_ms(20);	
2951  0124 ae0014        	ldw	x,#20
2952  0127 cd01e2        	call	_delay_ms
2954                     ; 180 	FLASH_DeInit();
2956  012a cd0000        	call	_FLASH_DeInit
2958                     ; 181 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
2960  012d a6f7          	ld	a,#247
2961  012f cd0000        	call	_FLASH_Unlock
2963                     ; 182 }
2966  0132 81            	ret
3014                     ; 184 void GPIO_Init(void) 
3014                     ; 185 //=====================================
3014                     ; 186 {
3015                     	switch	.text
3016  0133               _GPIO_Init:
3020                     ; 187 		PA_DDR = 0b00000000;	
3022  0133 725f5002      	clr	_PA_DDR
3023                     ; 188     PA_CR1 = 0b11111111;             
3025  0137 35ff5003      	mov	_PA_CR1,#255
3026                     ; 189 		PA_CR2 = 0b00000000;
3028  013b 725f5004      	clr	_PA_CR2
3029                     ; 190 		PA_ODR = 0b00000000;
3031  013f 725f5000      	clr	_PA_ODR
3032                     ; 192 		PB_DDR = 0b01000001;         
3034  0143 35415007      	mov	_PB_DDR,#65
3035                     ; 193     PB_CR1 = 0b11111111;               
3037  0147 35ff5008      	mov	_PB_CR1,#255
3038                     ; 194 		PB_CR2 = 0b01000001;
3040  014b 35415009      	mov	_PB_CR2,#65
3041                     ; 195 		PB_ODR = 0b01000001;
3043  014f 35415005      	mov	_PB_ODR,#65
3044                     ; 197     PC_DDR = 0b11010100;
3046  0153 35d4500c      	mov	_PC_DDR,#212
3047                     ; 198     PC_CR1 = 0b11111111;             
3049  0157 35ff500d      	mov	_PC_CR1,#255
3050                     ; 199 		PC_CR2 = 0b11010100;
3052  015b 35d4500e      	mov	_PC_CR2,#212
3053                     ; 200 		PC_ODR = 0b10000110;
3055  015f 3586500a      	mov	_PC_ODR,#134
3056                     ; 202 		PD_DDR = 0b00000100;
3058  0163 35045011      	mov	_PD_DDR,#4
3059                     ; 203 		PD_CR1 = 0b11111111;
3061  0167 35ff5012      	mov	_PD_CR1,#255
3062                     ; 204 		PD_CR2 = 0b00000100;
3064  016b 35045013      	mov	_PD_CR2,#4
3065                     ; 205 		PD_ODR = 0b00000000;
3067  016f 725f500f      	clr	_PD_ODR
3068                     ; 207 		PE_DDR = 0b00100000;
3070  0173 35205016      	mov	_PE_DDR,#32
3071                     ; 208 		PE_CR1 = 0b11111111;
3073  0177 35ff5017      	mov	_PE_CR1,#255
3074                     ; 209 		PE_CR2 = 0b00100000;
3076  017b 35205018      	mov	_PE_CR2,#32
3077                     ; 210 		PE_ODR = 0b00100000;
3079  017f 35205014      	mov	_PE_ODR,#32
3080                     ; 212 		PF_DDR = 0b00000000;							
3082  0183 725f501b      	clr	_PF_DDR
3083                     ; 213 		PF_CR1 = 0b11111111;	 			
3085  0187 35ff501c      	mov	_PF_CR1,#255
3086                     ; 214 		PF_CR2 = 0b00000000;							
3088  018b 725f501d      	clr	_PF_CR2
3089                     ; 215 		PF_ODR = 0b00000000;
3091  018f 725f5019      	clr	_PF_ODR
3092                     ; 217 		EXTI_CR1 |= 0b00000000;			
3094  0193 c650a0        	ld	a,_EXTI_CR1
3095                     ; 218 }
3098  0196 81            	ret
3123                     ; 220 void CLK_Init(void)
3123                     ; 221 //=====================================
3123                     ; 222 {
3124                     	switch	.text
3125  0197               _CLK_Init:
3129                     ; 223 		CLK_ECKR = 0x00;		//Internal RC OSC
3131  0197 725f50c1      	clr	_CLK_ECKR
3132                     ; 224     CLK_CKDIVR = 0b00000000; //devide by 1
3134  019b 725f50c6      	clr	_CLK_CKDIVR
3135                     ; 225 }
3138  019f 81            	ret
3173                     ; 228 void power_on_delay(void)
3173                     ; 229 //=====================================
3173                     ; 230 {
3174                     	switch	.text
3175  01a0               _power_on_delay:
3177  01a0 89            	pushw	x
3178       00000002      OFST:	set	2
3181                     ; 232 	for(i = 0; i<500; i++)//500MS
3183  01a1 5f            	clrw	x
3184  01a2 1f01          	ldw	(OFST-1,sp),x
3185  01a4               L5771:
3186                     ; 234 		delay_ms(1);
3188  01a4 ae0001        	ldw	x,#1
3189  01a7 ad39          	call	_delay_ms
3191                     ; 232 	for(i = 0; i<500; i++)//500MS
3193  01a9 1e01          	ldw	x,(OFST-1,sp)
3194  01ab 1c0001        	addw	x,#1
3195  01ae 1f01          	ldw	(OFST-1,sp),x
3198  01b0 1e01          	ldw	x,(OFST-1,sp)
3199  01b2 a301f4        	cpw	x,#500
3200  01b5 25ed          	jrult	L5771
3201                     ; 236 }
3204  01b7 85            	popw	x
3205  01b8 81            	ret
3238                     ; 239 void TIM_Init(void)
3238                     ; 240 //=====================================
3238                     ; 241 {
3239                     	switch	.text
3240  01b9               _TIM_Init:
3244                     ; 244     TIM1_ARRH   = 0x03;
3246  01b9 35035262      	mov	_TIM1_ARRH,#3
3247                     ; 245     TIM1_ARRL   = 0xe8;           /* Freq control register: ARR automatic reload 1ms */
3249  01bd 35e85263      	mov	_TIM1_ARRL,#232
3250                     ; 247     TIM1_PSCRH  = 0x00;           /* Configure TIM1 prescaler_H       */
3252  01c1 725f5260      	clr	_TIM1_PSCRH
3253                     ; 248 		TIM1_PSCRL  = 0x0f;           /* Configure TIM1 prescaler_L   16 frequency divier     */
3255  01c5 350f5261      	mov	_TIM1_PSCRL,#15
3256                     ; 249 		TIM1_IER   |= 0x01;						//enable refresh interrupt
3258  01c9 72105254      	bset	_TIM1_IER,#0
3259                     ; 250     TIM1_CR1    |= 0x80;
3261  01cd 721e5250      	bset	_TIM1_CR1,#7
3262                     ; 253 		TIM4_ARR   = 0xa0;           	// Freq control register: ARR automatic reload 10us
3264  01d1 35a05348      	mov	_TIM4_ARR,#160
3265                     ; 255     TIM4_PSCR   = 0x00;          	// Configure TIM4 prescaler =128  Base clockÎª8us 
3267  01d5 725f5347      	clr	_TIM4_PSCR
3268                     ; 256 		TIM4_IER   |= 0x01;						//enable refresh interrupt
3270  01d9 72105343      	bset	_TIM4_IER,#0
3271                     ; 257 		TIM4_CR1   |= 0x80;						//bit ARPE set to 1 enable automatic reload \URS set to 1 refresh interrupt only whne counter is overflowed*/
3273  01dd 721e5340      	bset	_TIM4_CR1,#7
3274                     ; 259 }
3277  01e1 81            	ret
3330                     ; 262 void delay_ms(unsigned int ms)
3330                     ; 263 //=====================================
3330                     ; 264 {
3331                     	switch	.text
3332  01e2               _delay_ms:
3334  01e2 89            	pushw	x
3335  01e3 5204          	subw	sp,#4
3336       00000004      OFST:	set	4
3339                     ; 267 	for(j=0;j<ms;j++)
3341  01e5 5f            	clrw	x
3342  01e6 1f01          	ldw	(OFST-3,sp),x
3344  01e8 201d          	jra	L5402
3345  01ea               L1402:
3346                     ; 269 		for(i=0;i<650;i++)
3348  01ea 5f            	clrw	x
3349  01eb 1f03          	ldw	(OFST-1,sp),x
3350  01ed               L1502:
3351                     ; 271 			delay_us(1);
3353  01ed ae0001        	ldw	x,#1
3354  01f0 ad1e          	call	_delay_us
3356                     ; 269 		for(i=0;i<650;i++)
3358  01f2 1e03          	ldw	x,(OFST-1,sp)
3359  01f4 1c0001        	addw	x,#1
3360  01f7 1f03          	ldw	(OFST-1,sp),x
3363  01f9 1e03          	ldw	x,(OFST-1,sp)
3364  01fb a3028a        	cpw	x,#650
3365  01fe 25ed          	jrult	L1502
3366                     ; 267 	for(j=0;j<ms;j++)
3368  0200 1e01          	ldw	x,(OFST-3,sp)
3369  0202 1c0001        	addw	x,#1
3370  0205 1f01          	ldw	(OFST-3,sp),x
3371  0207               L5402:
3374  0207 1e01          	ldw	x,(OFST-3,sp)
3375  0209 1305          	cpw	x,(OFST+1,sp)
3376  020b 25dd          	jrult	L1402
3377                     ; 274 }
3380  020d 5b06          	addw	sp,#6
3381  020f 81            	ret
3416                     ; 277 void delay_us(unsigned int us)
3416                     ; 278 //=====================================
3416                     ; 279 {
3417                     	switch	.text
3418  0210               _delay_us:
3422                     ; 280 	NOP();
3425  0210 9d            nop
3427                     ; 281 }
3431  0211 81            	ret
3555                     	xdef	_main
3556                     	xdef	_TIM_Init
3557                     	xdef	_power_on_delay
3558                     	xdef	_CLK_Init
3559                     	xdef	_GPIO_Init
3560                     	xdef	_mcu_init
3561                     	switch	.ubsct
3562  0000               _MasterModeFlag:
3563  0000 00            	ds.b	1
3564                     	xdef	_MasterModeFlag
3565  0001               _SystemFlag:
3566  0001 00            	ds.b	1
3567                     	xdef	_SystemFlag
3568  0002               _time_flag:
3569  0002 00            	ds.b	1
3570                     	xdef	_time_flag
3571  0003               _rf_rx_packet_length:
3572  0003 00            	ds.b	1
3573                     	xdef	_rf_rx_packet_length
3574  0004               _time2_count:
3575  0004 0000          	ds.b	2
3576                     	xdef	_time2_count
3577                     	xref	_FLASH_DeInit
3578                     	xref	_FLASH_Unlock
3579                     	xref	_sx1278_LoRaTxPacket
3580                     	xref	_sx1278_LoRaEntryTx
3581                     	xref	_sx1278_LoRaRxPacket
3582                     	xref	_sx1278_LoRaEntryRx
3583                     	xref	_sx1278_Config
3584                     	xdef	_delay_us
3585                     	xdef	_delay_ms
3586  0006               _SysTime:
3587  0006 0000          	ds.b	2
3588                     	xdef	_SysTime
3589  0008               _Fsk_Rate_Sel:
3590  0008 00            	ds.b	1
3591                     	xdef	_Fsk_Rate_Sel
3592  0009               _BandWide_Sel:
3593  0009 00            	ds.b	1
3594                     	xdef	_BandWide_Sel
3595  000a               _Lora_Rate_Sel:
3596  000a 00            	ds.b	1
3597                     	xdef	_Lora_Rate_Sel
3598  000b               _Power_Sel:
3599  000b 00            	ds.b	1
3600                     	xdef	_Power_Sel
3601  000c               _Freq_Sel:
3602  000c 00            	ds.b	1
3603                     	xdef	_Freq_Sel
3604  000d               _mode:
3605  000d 00            	ds.b	1
3606                     	xdef	_mode
3626                     	end
