   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2619                     ; 70 void main()
2619                     ; 71 //=====================================
2619                     ; 72 {
2621                     	switch	.text
2622  0000               _main:
2624  0000 5204          	subw	sp,#4
2625       00000004      OFST:	set	4
2628                     ; 73 	u16 i,j,k=0,g;
2630  0002 5f            	clrw	x
2631  0003 1f01          	ldw	(OFST-3,sp),x
2632                     ; 74 	SysTime 				= 0;
2634  0005 5f            	clrw	x
2635  0006 bf06          	ldw	_SysTime,x
2636                     ; 75 	SystemFlag 			= 0x00;
2638  0008 3f01          	clr	_SystemFlag
2639                     ; 76 	mode 						= 0x01;//lora mode
2641  000a 3501000d      	mov	_mode,#1
2642                     ; 77 	Freq_Sel 				= 0x00;//433M
2644  000e 3f0c          	clr	_Freq_Sel
2645                     ; 78 	Power_Sel 			= 0x00;//
2647  0010 3f0b          	clr	_Power_Sel
2648                     ; 79 	Lora_Rate_Sel 	= 0x06;//
2650  0012 3506000a      	mov	_Lora_Rate_Sel,#6
2651                     ; 80 	BandWide_Sel 		= 0x07;
2653  0016 35070009      	mov	_BandWide_Sel,#7
2654                     ; 81 	Fsk_Rate_Sel 		= 0x00;
2656  001a 3f08          	clr	_Fsk_Rate_Sel
2657                     ; 83 	_asm("sim");               //Disable interrupts.
2660  001c 9b            sim
2662                     ; 84 	mcu_init();
2664  001d cd0114        	call	_mcu_init
2666                     ; 85 	ITC_SPR4 = 0xf3;//time2 interrupt priority 2¡¢level13
2668  0020 35f37f73      	mov	_ITC_SPR4,#243
2669                     ; 86 	ITC_SPR5 = 0x3c;//UART1_RX ¡¢UART_TX interrupt priority 2
2671  0024 353c7f74      	mov	_ITC_SPR5,#60
2672                     ; 87 	ITC_SPR6 = 0x00;//UART3_RX ¡¢UART_TX interrupt priority 2
2674  0028 725f7f75      	clr	_ITC_SPR6
2675                     ; 88 	_asm("rim");              //Enable interrupts.
2678  002c 9a            rim
2680                     ; 90 	GREEN_LED_L();
2682  002d 721b5014      	bres	_PE_ODR,#5
2683                     ; 91 	RED_LED_L();
2685  0031 72115005      	bres	_PB_ODR,#0
2686                     ; 92 	delay_ms(500);
2688  0035 ae01f4        	ldw	x,#500
2689  0038 cd035f        	call	_delay_ms
2691                     ; 93 	GREEN_LED_H();
2693  003b 721a5014      	bset	_PE_ODR,#5
2694                     ; 94 	RED_LED_H();
2696  003f 72105005      	bset	_PB_ODR,#0
2697                     ; 95 	sx1278_Config();
2699  0043 cd0000        	call	_sx1278_Config
2701                     ; 96   sx1278_LoRaEntryRx();
2703  0046 cd0000        	call	_sx1278_LoRaEntryRx
2705                     ; 97 	TIM1_CR1 |= 0x01;			//enable time1
2707  0049 72105250      	bset	_TIM1_CR1,#0
2708                     ; 98 	MasterModeFlag=0;	
2710  004d 3f00          	clr	_MasterModeFlag
2711  004f               L1761:
2712                     ; 101 	if(GetOption())	//Slave
2714  004f c6500b        	ld	a,_PC_IDR
2715  0052 a402          	and	a,#2
2716  0054 a102          	cp	a,#2
2717  0056 2638          	jrne	L5761
2718                     ; 103 		if(SystemFlag&PreviousOptionBit)
2720  0058 b601          	ld	a,_SystemFlag
2721  005a a501          	bcp	a,#1
2722  005c 2708          	jreq	L7761
2723                     ; 105 			sx1278_LoRaEntryRx();
2725  005e cd0000        	call	_sx1278_LoRaEntryRx
2727                     ; 106 			InitialMessageSlave();
2729  0061 cd01ec        	call	_InitialMessageSlave
2731                     ; 107 			SystemFlag&=(!PreviousOptionBit);
2733  0064 3f01          	clr	_SystemFlag
2734  0066               L7761:
2735                     ; 109 		if(sx1278_LoRaRxPacket())
2737  0066 cd0000        	call	_sx1278_LoRaRxPacket
2739  0069 4d            	tnz	a
2740  006a 271f          	jreq	L1071
2741                     ; 111 			GREEN_LED_L();
2743  006c 721b5014      	bres	_PE_ODR,#5
2744                     ; 112 			delay_ms(100);
2746  0070 ae0064        	ldw	x,#100
2747  0073 cd035f        	call	_delay_ms
2749                     ; 113 			GREEN_LED_H();
2751  0076 721a5014      	bset	_PE_ODR,#5
2752                     ; 114 			RED_LED_L();
2754  007a 72115005      	bres	_PB_ODR,#0
2755                     ; 115 			sx1278_LoRaEntryTx();
2757  007e cd0000        	call	_sx1278_LoRaEntryTx
2759                     ; 116 			sx1278_LoRaTxPacket();
2761  0081 cd0000        	call	_sx1278_LoRaTxPacket
2763                     ; 117 			RED_LED_H();
2765  0084 72105005      	bset	_PB_ODR,#0
2766                     ; 118 			sx1278_LoRaEntryRx();
2768  0088 cd0000        	call	_sx1278_LoRaEntryRx
2770  008b               L1071:
2771                     ; 120 		ReadDHT11();			//Read Temperature & Humidity
2773  008b cd0000        	call	_ReadDHT11
2776  008e 20bf          	jra	L1761
2777  0090               L5761:
2778                     ; 124 		if((SystemFlag&PreviousOptionBit)==0)
2780  0090 b601          	ld	a,_SystemFlag
2781  0092 a501          	bcp	a,#1
2782  0094 2609          	jrne	L5071
2783                     ; 126 			MasterModeFlag=0;
2785  0096 3f00          	clr	_MasterModeFlag
2786                     ; 127 			InitialMessageMaster();
2788  0098 cd0314        	call	_InitialMessageMaster
2790                     ; 128 			SystemFlag|=PreviousOptionBit;
2792  009b 72100001      	bset	_SystemFlag,#0
2793  009f               L5071:
2794                     ; 130 		switch(MasterModeFlag)
2796  009f b600          	ld	a,_MasterModeFlag
2798                     ; 164 				break;
2799  00a1 4d            	tnz	a
2800  00a2 2708          	jreq	L3361
2801  00a4 4a            	dec	a
2802  00a5 271f          	jreq	L5361
2803  00a7 4a            	dec	a
2804  00a8 2755          	jreq	L7361
2805  00aa 20a3          	jra	L1761
2806  00ac               L3361:
2807                     ; 132 			case 0:
2807                     ; 133 				if(time_flag==1)
2809  00ac b602          	ld	a,_time_flag
2810  00ae a101          	cp	a,#1
2811  00b0 269d          	jrne	L1761
2812                     ; 135 				time_flag=0;
2814  00b2 3f02          	clr	_time_flag
2815                     ; 136 				RED_LED_L();
2817  00b4 72115005      	bres	_PB_ODR,#0
2818                     ; 137 				sx1278_LoRaEntryTx();
2820  00b8 cd0000        	call	_sx1278_LoRaEntryTx
2822                     ; 138 				sx1278_LoRaTxPacket();
2824  00bb cd0000        	call	_sx1278_LoRaTxPacket
2826                     ; 139 				RED_LED_H();
2828  00be 72105005      	bset	_PB_ODR,#0
2829                     ; 140 				MasterModeFlag++;
2831  00c2 3c00          	inc	_MasterModeFlag
2832  00c4 2089          	jra	L1761
2833  00c6               L5361:
2834                     ; 143 			case 1:
2834                     ; 144 				sx1278_LoRaEntryRx();
2836  00c6 cd0000        	call	_sx1278_LoRaEntryRx
2838                     ; 145 				for(i=0;i<30;i++)
2840  00c9 5f            	clrw	x
2841  00ca 1f03          	ldw	(OFST-1,sp),x
2842  00cc               L5171:
2843                     ; 147 					delay_ms(100);
2845  00cc ae0064        	ldw	x,#100
2846  00cf cd035f        	call	_delay_ms
2848                     ; 148 					if(sx1278_LoRaRxPacket())
2850  00d2 cd0000        	call	_sx1278_LoRaRxPacket
2852  00d5 4d            	tnz	a
2853  00d6 2713          	jreq	L3271
2854                     ; 150 						i=50;
2856  00d8 ae0032        	ldw	x,#50
2857  00db 1f03          	ldw	(OFST-1,sp),x
2858                     ; 151 						GREEN_LED_L();
2860  00dd 721b5014      	bres	_PE_ODR,#5
2861                     ; 152 						delay_ms(100);
2863  00e1 ae0064        	ldw	x,#100
2864  00e4 cd035f        	call	_delay_ms
2866                     ; 153 						GREEN_LED_H();			
2868  00e7 721a5014      	bset	_PE_ODR,#5
2869  00eb               L3271:
2870                     ; 145 				for(i=0;i<30;i++)
2872  00eb 1e03          	ldw	x,(OFST-1,sp)
2873  00ed 1c0001        	addw	x,#1
2874  00f0 1f03          	ldw	(OFST-1,sp),x
2877  00f2 1e03          	ldw	x,(OFST-1,sp)
2878  00f4 a3001e        	cpw	x,#30
2879  00f7 25d3          	jrult	L5171
2880                     ; 156 				MasterModeFlag++;
2882  00f9 3c00          	inc	_MasterModeFlag
2883                     ; 157 				break;
2885  00fb ac4f004f      	jpf	L1761
2886  00ff               L7361:
2887                     ; 158 			case 2:
2887                     ; 159 				if(time_flag==1)
2889  00ff b602          	ld	a,_time_flag
2890  0101 a101          	cp	a,#1
2891  0103 2703          	jreq	L6
2892  0105 cc004f        	jp	L1761
2893  0108               L6:
2894                     ; 161 					time_flag=0;
2896  0108 3f02          	clr	_time_flag
2897                     ; 162 					MasterModeFlag=0;
2899  010a 3f00          	clr	_MasterModeFlag
2900  010c ac4f004f      	jpf	L1761
2901  0110               L1171:
2902  0110 ac4f004f      	jpf	L1761
2933                     ; 174 void mcu_init(void)
2933                     ; 175 //=====================================
2933                     ; 176 {
2934                     	switch	.text
2935  0114               _mcu_init:
2939                     ; 177 	CLK_Init();// base clock
2941  0114 cd01a0        	call	_CLK_Init
2943                     ; 178 	power_on_delay(); //Power on delay
2945  0117 cd01a9        	call	_power_on_delay
2947                     ; 179 	GPIO_Init();
2949  011a ad20          	call	_GPIO_Init
2951                     ; 180 	TIM_Init();
2953  011c cd01c3        	call	_TIM_Init
2955                     ; 182 	PD_ODR=0b00000000;
2957  011f 725f500f      	clr	_PD_ODR
2958                     ; 183 	delay_ms(20);
2960  0123 ae0014        	ldw	x,#20
2961  0126 cd035f        	call	_delay_ms
2963                     ; 184 	PD_ODR=0b00000100;
2965  0129 3504500f      	mov	_PD_ODR,#4
2966                     ; 185 	delay_ms(20);	
2968  012d ae0014        	ldw	x,#20
2969  0130 cd035f        	call	_delay_ms
2971                     ; 186 	FLASH_DeInit();
2973  0133 cd0000        	call	_FLASH_DeInit
2975                     ; 187 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
2977  0136 a6f7          	ld	a,#247
2978  0138 cd0000        	call	_FLASH_Unlock
2980                     ; 188 }
2983  013b 81            	ret
3031                     ; 190 void GPIO_Init(void) 
3031                     ; 191 //=====================================
3031                     ; 192 {
3032                     	switch	.text
3033  013c               _GPIO_Init:
3037                     ; 193 		PA_DDR = 0b00000000;	
3039  013c 725f5002      	clr	_PA_DDR
3040                     ; 194     PA_CR1 = 0b11111111;             
3042  0140 35ff5003      	mov	_PA_CR1,#255
3043                     ; 195 		PA_CR2 = 0b00000000;
3045  0144 725f5004      	clr	_PA_CR2
3046                     ; 196 		PA_ODR = 0b00000000;
3048  0148 725f5000      	clr	_PA_ODR
3049                     ; 198 		PB_DDR = 0b01000001;         
3051  014c 35415007      	mov	_PB_DDR,#65
3052                     ; 199     PB_CR1 = 0b11111111;               
3054  0150 35ff5008      	mov	_PB_CR1,#255
3055                     ; 200 		PB_CR2 = 0b01000001;
3057  0154 35415009      	mov	_PB_CR2,#65
3058                     ; 201 		PB_ODR = 0b01000001;
3060  0158 35415005      	mov	_PB_ODR,#65
3061                     ; 203     PC_DDR = 0b11010100;
3063  015c 35d4500c      	mov	_PC_DDR,#212
3064                     ; 204     PC_CR1 = 0b11111111;             
3066  0160 35ff500d      	mov	_PC_CR1,#255
3067                     ; 205 		PC_CR2 = 0b11010100;
3069  0164 35d4500e      	mov	_PC_CR2,#212
3070                     ; 206 		PC_ODR = 0b10000110;
3072  0168 3586500a      	mov	_PC_ODR,#134
3073                     ; 208 		PD_DDR = 0b00000100;
3075  016c 35045011      	mov	_PD_DDR,#4
3076                     ; 209 		PD_CR1 = 0b11111111;
3078  0170 35ff5012      	mov	_PD_CR1,#255
3079                     ; 210 		PD_CR2 = 0b00000100;
3081  0174 35045013      	mov	_PD_CR2,#4
3082                     ; 211 		PD_ODR = 0b00000000;
3084  0178 725f500f      	clr	_PD_ODR
3085                     ; 213 		PE_DDR = 0b00100000;
3087  017c 35205016      	mov	_PE_DDR,#32
3088                     ; 214 		PE_CR1 = 0b11111111;
3090  0180 35ff5017      	mov	_PE_CR1,#255
3091                     ; 215 		PE_CR2 = 0b00100000;
3093  0184 35205018      	mov	_PE_CR2,#32
3094                     ; 216 		PE_ODR = 0b00100000;
3096  0188 35205014      	mov	_PE_ODR,#32
3097                     ; 218 		PF_DDR = 0b00010000;							
3099  018c 3510501b      	mov	_PF_DDR,#16
3100                     ; 219 		PF_CR1 = 0b11111111;	 			
3102  0190 35ff501c      	mov	_PF_CR1,#255
3103                     ; 220 		PF_CR2 = 0b00000000;							
3105  0194 725f501d      	clr	_PF_CR2
3106                     ; 221 		PF_ODR = 0b00000000;
3108  0198 725f5019      	clr	_PF_ODR
3109                     ; 223 		EXTI_CR1 |= 0b00000000;			
3111  019c c650a0        	ld	a,_EXTI_CR1
3112                     ; 224 }
3115  019f 81            	ret
3140                     ; 226 void CLK_Init(void)
3140                     ; 227 //=====================================
3140                     ; 228 {
3141                     	switch	.text
3142  01a0               _CLK_Init:
3146                     ; 229 		CLK_ECKR = 0x00;		//Internal RC OSC
3148  01a0 725f50c1      	clr	_CLK_ECKR
3149                     ; 230     CLK_CKDIVR = 0b00000000; //devide by 1
3151  01a4 725f50c6      	clr	_CLK_CKDIVR
3152                     ; 231 }
3155  01a8 81            	ret
3190                     ; 234 void power_on_delay(void)
3190                     ; 235 //=====================================
3190                     ; 236 {
3191                     	switch	.text
3192  01a9               _power_on_delay:
3194  01a9 89            	pushw	x
3195       00000002      OFST:	set	2
3198                     ; 238 	for(i = 0; i<500; i++)//500MS
3200  01aa 5f            	clrw	x
3201  01ab 1f01          	ldw	(OFST-1,sp),x
3202  01ad               L5771:
3203                     ; 240 		delay_ms(1);
3205  01ad ae0001        	ldw	x,#1
3206  01b0 cd035f        	call	_delay_ms
3208                     ; 238 	for(i = 0; i<500; i++)//500MS
3210  01b3 1e01          	ldw	x,(OFST-1,sp)
3211  01b5 1c0001        	addw	x,#1
3212  01b8 1f01          	ldw	(OFST-1,sp),x
3215  01ba 1e01          	ldw	x,(OFST-1,sp)
3216  01bc a301f4        	cpw	x,#500
3217  01bf 25ec          	jrult	L5771
3218                     ; 242 }
3221  01c1 85            	popw	x
3222  01c2 81            	ret
3255                     ; 245 void TIM_Init(void)
3255                     ; 246 //=====================================
3255                     ; 247 {
3256                     	switch	.text
3257  01c3               _TIM_Init:
3261                     ; 250     TIM1_ARRH   = 0x03;
3263  01c3 35035262      	mov	_TIM1_ARRH,#3
3264                     ; 251     TIM1_ARRL   = 0xe8;           /* Freq control register: ARR automatic reload 1ms */
3266  01c7 35e85263      	mov	_TIM1_ARRL,#232
3267                     ; 253     TIM1_PSCRH  = 0x00;           /* Configure TIM1 prescaler_H       */
3269  01cb 725f5260      	clr	_TIM1_PSCRH
3270                     ; 254 		TIM1_PSCRL  = 0x0f;           /* Configure TIM1 prescaler_L   16 frequency divier     */
3272  01cf 350f5261      	mov	_TIM1_PSCRL,#15
3273                     ; 255 		TIM1_IER   |= 0x01;						//enable refresh interrupt
3275  01d3 72105254      	bset	_TIM1_IER,#0
3276                     ; 256     TIM1_CR1    |= 0x80;
3278  01d7 721e5250      	bset	_TIM1_CR1,#7
3279                     ; 259 		TIM4_ARR   = 0xa0;           	// Freq control register: ARR automatic reload 10us
3281  01db 35a05348      	mov	_TIM4_ARR,#160
3282                     ; 261     TIM4_PSCR   = 0x00;          	// Configure TIM4 prescaler =128  Base clockÎª8us 
3284  01df 725f5347      	clr	_TIM4_PSCR
3285                     ; 262 		TIM4_IER   |= 0x01;						//enable refresh interrupt
3287  01e3 72105343      	bset	_TIM4_IER,#0
3288                     ; 263 		TIM4_CR1   |= 0x80;						//bit ARPE set to 1 enable automatic reload \URS set to 1 refresh interrupt only whne counter is overflowed*/
3290  01e7 721e5340      	bset	_TIM4_CR1,#7
3291                     ; 265 }
3294  01eb 81            	ret
3320                     ; 268 void InitialMessageSlave(void)
3320                     ; 269 //=====================================
3320                     ; 270 {
3321                     	switch	.text
3322  01ec               _InitialMessageSlave:
3326                     ; 271 	Message[0]='E';
3328  01ec 35450000      	mov	_Message,#69
3329                     ; 272 	Message[1]='X';
3331  01f0 35580001      	mov	_Message+1,#88
3332                     ; 273 	Message[2]='O';
3334  01f4 354f0002      	mov	_Message+2,#79
3335                     ; 274 	Message[3]='S';
3337  01f8 35530003      	mov	_Message+3,#83
3338                     ; 275 	Message[4]='I';
3340  01fc 35490004      	mov	_Message+4,#73
3341                     ; 276 	Message[5]='T';
3343  0200 35540005      	mov	_Message+5,#84
3344                     ; 277 	Message[6]='E';	
3346  0204 35450006      	mov	_Message+6,#69
3347                     ; 278 	Message[7]=FLASH_ReadByte(0x4870);	//ID
3349  0208 ae4870        	ldw	x,#18544
3350  020b 89            	pushw	x
3351  020c ae0000        	ldw	x,#0
3352  020f 89            	pushw	x
3353  0210 cd0000        	call	_FLASH_ReadByte
3355  0213 5b04          	addw	sp,#4
3356  0215 b707          	ld	_Message+7,a
3357                     ; 279 	Message[8]=FLASH_ReadByte(0x486f);
3359  0217 ae486f        	ldw	x,#18543
3360  021a 89            	pushw	x
3361  021b ae0000        	ldw	x,#0
3362  021e 89            	pushw	x
3363  021f cd0000        	call	_FLASH_ReadByte
3365  0222 5b04          	addw	sp,#4
3366  0224 b708          	ld	_Message+8,a
3367                     ; 280 	Message[9]=FLASH_ReadByte(0x486e);
3369  0226 ae486e        	ldw	x,#18542
3370  0229 89            	pushw	x
3371  022a ae0000        	ldw	x,#0
3372  022d 89            	pushw	x
3373  022e cd0000        	call	_FLASH_ReadByte
3375  0231 5b04          	addw	sp,#4
3376  0233 b709          	ld	_Message+9,a
3377                     ; 281 	Message[10]=FLASH_ReadByte(0x486d);
3379  0235 ae486d        	ldw	x,#18541
3380  0238 89            	pushw	x
3381  0239 ae0000        	ldw	x,#0
3382  023c 89            	pushw	x
3383  023d cd0000        	call	_FLASH_ReadByte
3385  0240 5b04          	addw	sp,#4
3386  0242 b70a          	ld	_Message+10,a
3387                     ; 282 	Message[11]=FLASH_ReadByte(0x486c);
3389  0244 ae486c        	ldw	x,#18540
3390  0247 89            	pushw	x
3391  0248 ae0000        	ldw	x,#0
3392  024b 89            	pushw	x
3393  024c cd0000        	call	_FLASH_ReadByte
3395  024f 5b04          	addw	sp,#4
3396  0251 b70b          	ld	_Message+11,a
3397                     ; 283 	Message[12]=FLASH_ReadByte(0x486b);
3399  0253 ae486b        	ldw	x,#18539
3400  0256 89            	pushw	x
3401  0257 ae0000        	ldw	x,#0
3402  025a 89            	pushw	x
3403  025b cd0000        	call	_FLASH_ReadByte
3405  025e 5b04          	addw	sp,#4
3406  0260 b70c          	ld	_Message+12,a
3407                     ; 284 	Message[13]=FLASH_ReadByte(0x486a);
3409  0262 ae486a        	ldw	x,#18538
3410  0265 89            	pushw	x
3411  0266 ae0000        	ldw	x,#0
3412  0269 89            	pushw	x
3413  026a cd0000        	call	_FLASH_ReadByte
3415  026d 5b04          	addw	sp,#4
3416  026f b70d          	ld	_Message+13,a
3417                     ; 285 	Message[14]=FLASH_ReadByte(0x4869);
3419  0271 ae4869        	ldw	x,#18537
3420  0274 89            	pushw	x
3421  0275 ae0000        	ldw	x,#0
3422  0278 89            	pushw	x
3423  0279 cd0000        	call	_FLASH_ReadByte
3425  027c 5b04          	addw	sp,#4
3426  027e b70e          	ld	_Message+14,a
3427                     ; 286 	Message[15]=FLASH_ReadByte(0x4868);
3429  0280 ae4868        	ldw	x,#18536
3430  0283 89            	pushw	x
3431  0284 ae0000        	ldw	x,#0
3432  0287 89            	pushw	x
3433  0288 cd0000        	call	_FLASH_ReadByte
3435  028b 5b04          	addw	sp,#4
3436  028d b70f          	ld	_Message+15,a
3437                     ; 287 	Message[16]=FLASH_ReadByte(0x4867);
3439  028f ae4867        	ldw	x,#18535
3440  0292 89            	pushw	x
3441  0293 ae0000        	ldw	x,#0
3442  0296 89            	pushw	x
3443  0297 cd0000        	call	_FLASH_ReadByte
3445  029a 5b04          	addw	sp,#4
3446  029c b710          	ld	_Message+16,a
3447                     ; 288 	Message[17]=FLASH_ReadByte(0x4866);
3449  029e ae4866        	ldw	x,#18534
3450  02a1 89            	pushw	x
3451  02a2 ae0000        	ldw	x,#0
3452  02a5 89            	pushw	x
3453  02a6 cd0000        	call	_FLASH_ReadByte
3455  02a9 5b04          	addw	sp,#4
3456  02ab b711          	ld	_Message+17,a
3457                     ; 289 	Message[18]=FLASH_ReadByte(0x4865);
3459  02ad ae4865        	ldw	x,#18533
3460  02b0 89            	pushw	x
3461  02b1 ae0000        	ldw	x,#0
3462  02b4 89            	pushw	x
3463  02b5 cd0000        	call	_FLASH_ReadByte
3465  02b8 5b04          	addw	sp,#4
3466  02ba b712          	ld	_Message+18,a
3467                     ; 290 	Message[19]=FLASH_ReadByte(0x4864);
3469  02bc ae4864        	ldw	x,#18532
3470  02bf 89            	pushw	x
3471  02c0 ae0000        	ldw	x,#0
3472  02c3 89            	pushw	x
3473  02c4 cd0000        	call	_FLASH_ReadByte
3475  02c7 5b04          	addw	sp,#4
3476  02c9 b713          	ld	_Message+19,a
3477                     ; 291 	Message[20]=FLASH_ReadByte(0x4863);
3479  02cb ae4863        	ldw	x,#18531
3480  02ce 89            	pushw	x
3481  02cf ae0000        	ldw	x,#0
3482  02d2 89            	pushw	x
3483  02d3 cd0000        	call	_FLASH_ReadByte
3485  02d6 5b04          	addw	sp,#4
3486  02d8 b714          	ld	_Message+20,a
3487                     ; 292 	Message[21]=FLASH_ReadByte(0x4862);
3489  02da ae4862        	ldw	x,#18530
3490  02dd 89            	pushw	x
3491  02de ae0000        	ldw	x,#0
3492  02e1 89            	pushw	x
3493  02e2 cd0000        	call	_FLASH_ReadByte
3495  02e5 5b04          	addw	sp,#4
3496  02e7 b715          	ld	_Message+21,a
3497                     ; 293 	Message[22]=FLASH_ReadByte(0x4861);
3499  02e9 ae4861        	ldw	x,#18529
3500  02ec 89            	pushw	x
3501  02ed ae0000        	ldw	x,#0
3502  02f0 89            	pushw	x
3503  02f1 cd0000        	call	_FLASH_ReadByte
3505  02f4 5b04          	addw	sp,#4
3506  02f6 b716          	ld	_Message+22,a
3507                     ; 294 	Message[23]=FLASH_ReadByte(0x4860); //ID
3509  02f8 ae4860        	ldw	x,#18528
3510  02fb 89            	pushw	x
3511  02fc ae0000        	ldw	x,#0
3512  02ff 89            	pushw	x
3513  0300 cd0000        	call	_FLASH_ReadByte
3515  0303 5b04          	addw	sp,#4
3516  0305 b717          	ld	_Message+23,a
3517                     ; 295 	Message[24]=0;
3519  0307 3f18          	clr	_Message+24
3520                     ; 296 	Message[25]=0;
3522  0309 3f19          	clr	_Message+25
3523                     ; 297 	Message[26]=0;
3525  030b 3f1a          	clr	_Message+26
3526                     ; 298 	Message[27]=0;
3528  030d 3f1b          	clr	_Message+27
3529                     ; 299 	Message[28]=0;
3531  030f 3f1c          	clr	_Message+28
3532                     ; 300 	Message[29]=0;
3534  0311 3f1d          	clr	_Message+29
3535                     ; 301 }
3538  0313 81            	ret
3563                     ; 304 void InitialMessageMaster(void)
3563                     ; 305 //=====================================
3563                     ; 306 {
3564                     	switch	.text
3565  0314               _InitialMessageMaster:
3569                     ; 307 	Message[0]='E';
3571  0314 35450000      	mov	_Message,#69
3572                     ; 308 	Message[1]='X';
3574  0318 35580001      	mov	_Message+1,#88
3575                     ; 309 	Message[2]='O';
3577  031c 354f0002      	mov	_Message+2,#79
3578                     ; 310 	Message[3]='S';
3580  0320 35530003      	mov	_Message+3,#83
3581                     ; 311 	Message[4]='I';
3583  0324 35490004      	mov	_Message+4,#73
3584                     ; 312 	Message[5]='T';
3586  0328 35540005      	mov	_Message+5,#84
3587                     ; 313 	Message[6]='E';	
3589  032c 35450006      	mov	_Message+6,#69
3590                     ; 314 	Message[7]=0;
3592  0330 3f07          	clr	_Message+7
3593                     ; 315 	Message[8]=0;
3595  0332 3f08          	clr	_Message+8
3596                     ; 316 	Message[9]=0;
3598  0334 3f09          	clr	_Message+9
3599                     ; 317 	Message[10]=0;
3601  0336 3f0a          	clr	_Message+10
3602                     ; 318 	Message[11]=0;
3604  0338 3f0b          	clr	_Message+11
3605                     ; 319 	Message[12]=0;
3607  033a 3f0c          	clr	_Message+12
3608                     ; 320 	Message[13]=0;
3610  033c 3f0d          	clr	_Message+13
3611                     ; 321 	Message[14]=0;
3613  033e 3f0e          	clr	_Message+14
3614                     ; 322 	Message[15]=0;
3616  0340 3f0f          	clr	_Message+15
3617                     ; 323 	Message[16]=0;
3619  0342 3f10          	clr	_Message+16
3620                     ; 324 	Message[17]=0;
3622  0344 3f11          	clr	_Message+17
3623                     ; 325 	Message[18]=0;
3625  0346 3f12          	clr	_Message+18
3626                     ; 326 	Message[19]=0;
3628  0348 3f13          	clr	_Message+19
3629                     ; 327 	Message[20]=0;
3631  034a 3f14          	clr	_Message+20
3632                     ; 328 	Message[21]=0;
3634  034c 3f15          	clr	_Message+21
3635                     ; 329 	Message[22]=0;
3637  034e 3f16          	clr	_Message+22
3638                     ; 330 	Message[23]=0;
3640  0350 3f17          	clr	_Message+23
3641                     ; 331 	Message[24]=0;
3643  0352 3f18          	clr	_Message+24
3644                     ; 332 	Message[25]=0;
3646  0354 3f19          	clr	_Message+25
3647                     ; 333 	Message[26]=0;
3649  0356 3f1a          	clr	_Message+26
3650                     ; 334 	Message[27]=0;
3652  0358 3f1b          	clr	_Message+27
3653                     ; 335 	Message[28]=0;
3655  035a 3f1c          	clr	_Message+28
3656                     ; 336 	Message[29]=0;	
3658  035c 3f1d          	clr	_Message+29
3659                     ; 337 }	
3662  035e 81            	ret
3715                     ; 340 void delay_ms(unsigned int ms)
3715                     ; 341 //=====================================
3715                     ; 342 {
3716                     	switch	.text
3717  035f               _delay_ms:
3719  035f 89            	pushw	x
3720  0360 5204          	subw	sp,#4
3721       00000004      OFST:	set	4
3724                     ; 345 	for(j=0;j<ms;j++)
3726  0362 5f            	clrw	x
3727  0363 1f01          	ldw	(OFST-3,sp),x
3729  0365 201d          	jra	L5602
3730  0367               L1602:
3731                     ; 347 		for(i=0;i<650;i++)
3733  0367 5f            	clrw	x
3734  0368 1f03          	ldw	(OFST-1,sp),x
3735  036a               L1702:
3736                     ; 349 			delay_us(1);
3738  036a ae0001        	ldw	x,#1
3739  036d ad1e          	call	_delay_us
3741                     ; 347 		for(i=0;i<650;i++)
3743  036f 1e03          	ldw	x,(OFST-1,sp)
3744  0371 1c0001        	addw	x,#1
3745  0374 1f03          	ldw	(OFST-1,sp),x
3748  0376 1e03          	ldw	x,(OFST-1,sp)
3749  0378 a3028a        	cpw	x,#650
3750  037b 25ed          	jrult	L1702
3751                     ; 345 	for(j=0;j<ms;j++)
3753  037d 1e01          	ldw	x,(OFST-3,sp)
3754  037f 1c0001        	addw	x,#1
3755  0382 1f01          	ldw	(OFST-3,sp),x
3756  0384               L5602:
3759  0384 1e01          	ldw	x,(OFST-3,sp)
3760  0386 1305          	cpw	x,(OFST+1,sp)
3761  0388 25dd          	jrult	L1602
3762                     ; 352 }
3765  038a 5b06          	addw	sp,#6
3766  038c 81            	ret
3801                     ; 355 void delay_us(unsigned int us)
3801                     ; 356 //=====================================
3801                     ; 357 {
3802                     	switch	.text
3803  038d               _delay_us:
3807                     ; 358 	NOP();
3810  038d 9d            nop
3812                     ; 359 }
3816  038e 81            	ret
3940                     	xdef	_main
3941                     	xdef	_InitialMessageMaster
3942                     	xdef	_InitialMessageSlave
3943                     	xdef	_TIM_Init
3944                     	xdef	_power_on_delay
3945                     	xdef	_CLK_Init
3946                     	xdef	_GPIO_Init
3947                     	xdef	_mcu_init
3948                     	switch	.ubsct
3949  0000               _MasterModeFlag:
3950  0000 00            	ds.b	1
3951                     	xdef	_MasterModeFlag
3952  0001               _SystemFlag:
3953  0001 00            	ds.b	1
3954                     	xdef	_SystemFlag
3955                     	xref	_ReadDHT11
3956  0002               _time_flag:
3957  0002 00            	ds.b	1
3958                     	xdef	_time_flag
3959  0003               _rf_rx_packet_length:
3960  0003 00            	ds.b	1
3961                     	xdef	_rf_rx_packet_length
3962  0004               _time2_count:
3963  0004 0000          	ds.b	2
3964                     	xdef	_time2_count
3965                     	xref	_FLASH_ReadByte
3966                     	xref	_FLASH_DeInit
3967                     	xref	_FLASH_Unlock
3968                     	xref	_sx1278_LoRaTxPacket
3969                     	xref	_sx1278_LoRaEntryTx
3970                     	xref	_sx1278_LoRaRxPacket
3971                     	xref	_sx1278_LoRaEntryRx
3972                     	xref	_sx1278_Config
3973                     	xref.b	_Message
3974                     	xdef	_delay_us
3975                     	xdef	_delay_ms
3976  0006               _SysTime:
3977  0006 0000          	ds.b	2
3978                     	xdef	_SysTime
3979  0008               _Fsk_Rate_Sel:
3980  0008 00            	ds.b	1
3981                     	xdef	_Fsk_Rate_Sel
3982  0009               _BandWide_Sel:
3983  0009 00            	ds.b	1
3984                     	xdef	_BandWide_Sel
3985  000a               _Lora_Rate_Sel:
3986  000a 00            	ds.b	1
3987                     	xdef	_Lora_Rate_Sel
3988  000b               _Power_Sel:
3989  000b 00            	ds.b	1
3990                     	xdef	_Power_Sel
3991  000c               _Freq_Sel:
3992  000c 00            	ds.b	1
3993                     	xdef	_Freq_Sel
3994  000d               _mode:
3995  000d 00            	ds.b	1
3996                     	xdef	_mode
4016                     	end
