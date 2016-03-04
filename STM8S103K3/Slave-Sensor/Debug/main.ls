   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2621                     ; 70 void main()
2621                     ; 71 //=====================================
2621                     ; 72 {
2623                     	switch	.text
2624  0000               _main:
2626  0000 5204          	subw	sp,#4
2627       00000004      OFST:	set	4
2630                     ; 73 	u16 i,j,k=0,g;
2632  0002 5f            	clrw	x
2633  0003 1f01          	ldw	(OFST-3,sp),x
2634                     ; 74 	SysTime 				= 0;
2636  0005 5f            	clrw	x
2637  0006 bf06          	ldw	_SysTime,x
2638                     ; 75 	SystemFlag 			= 0x00;
2640  0008 3f01          	clr	_SystemFlag
2641                     ; 76 	mode 						= 0x01;//lora mode
2643  000a 3501000f      	mov	_mode,#1
2644                     ; 77 	Freq_Sel 				= 0x00;//433M
2646  000e 3f0e          	clr	_Freq_Sel
2647                     ; 88 	Power_Sel 			= 0;//PA power 0~15
2649  0010 3f0d          	clr	_Power_Sel
2650                     ; 89 	PA_Over_Current_Sel = 11;
2652  0012 350b000c      	mov	_PA_Over_Current_Sel,#11
2653                     ; 90 	Gain_Sel				=	1;
2655  0016 3501000b      	mov	_Gain_Sel,#1
2656                     ; 91 	Lora_Rate_Sel 	= 0x06;//
2658  001a 3506000a      	mov	_Lora_Rate_Sel,#6
2659                     ; 92 	BandWide_Sel 		= 0x07;
2661  001e 35070009      	mov	_BandWide_Sel,#7
2662                     ; 93 	Fsk_Rate_Sel 		= 0x00;
2664  0022 3f08          	clr	_Fsk_Rate_Sel
2665                     ; 95 	_asm("sim");               //Disable interrupts.
2668  0024 9b            sim
2670                     ; 96 	mcu_init();
2672  0025 cd011f        	call	_mcu_init
2674                     ; 97 	ITC_SPR4 = 0xf3;//time2 interrupt priority 2¡¢level13
2676  0028 35f37f73      	mov	_ITC_SPR4,#243
2677                     ; 98 	ITC_SPR5 = 0x3c;//UART1_RX ¡¢UART_TX interrupt priority 2
2679  002c 353c7f74      	mov	_ITC_SPR5,#60
2680                     ; 99 	ITC_SPR6 = 0x00;//UART3_RX ¡¢UART_TX interrupt priority 2
2682  0030 725f7f75      	clr	_ITC_SPR6
2683                     ; 100 	_asm("rim");              //Enable interrupts.
2686  0034 9a            rim
2688                     ; 102 	GREEN_LED_L();
2690  0035 721b5014      	bres	_PE_ODR,#5
2691                     ; 103 	RED_LED_L();
2693  0039 72115005      	bres	_PB_ODR,#0
2694                     ; 104 	delay_ms(500);
2696  003d ae01f4        	ldw	x,#500
2697  0040 cd036b        	call	_delay_ms
2699                     ; 105 	GREEN_LED_H();
2701  0043 721a5014      	bset	_PE_ODR,#5
2702                     ; 106 	RED_LED_H();
2704  0047 72105005      	bset	_PB_ODR,#0
2705                     ; 107 	sx1278_Config();
2707  004b cd0000        	call	_sx1278_Config
2709                     ; 108   sx1278_LoRaEntryRx();
2711  004e cd0000        	call	_sx1278_LoRaEntryRx
2713                     ; 109 	InitialMessageSlave();
2715  0051 cd01f7        	call	_InitialMessageSlave
2717                     ; 110 	TIM1_CR1 |= 0x01;			//enable time1
2719  0054 72105250      	bset	_TIM1_CR1,#0
2720                     ; 111 	MasterModeFlag=0;	
2722  0058 3f00          	clr	_MasterModeFlag
2723  005a               L1761:
2724                     ; 114 	if(GetOption())	//Slave
2726  005a c6500b        	ld	a,_PC_IDR
2727  005d a402          	and	a,#2
2728  005f a102          	cp	a,#2
2729  0061 2638          	jrne	L5761
2730                     ; 116 		if(SystemFlag&PreviousOptionBit)
2732  0063 b601          	ld	a,_SystemFlag
2733  0065 a501          	bcp	a,#1
2734  0067 2708          	jreq	L7761
2735                     ; 118 			sx1278_LoRaEntryRx();
2737  0069 cd0000        	call	_sx1278_LoRaEntryRx
2739                     ; 119 			InitialMessageSlave();
2741  006c cd01f7        	call	_InitialMessageSlave
2743                     ; 120 			SystemFlag&=(!PreviousOptionBit);
2745  006f 3f01          	clr	_SystemFlag
2746  0071               L7761:
2747                     ; 122 		if(sx1278_LoRaRxPacket())
2749  0071 cd0000        	call	_sx1278_LoRaRxPacket
2751  0074 4d            	tnz	a
2752  0075 271f          	jreq	L1071
2753                     ; 124 			GREEN_LED_L();
2755  0077 721b5014      	bres	_PE_ODR,#5
2756                     ; 125 			delay_ms(100);
2758  007b ae0064        	ldw	x,#100
2759  007e cd036b        	call	_delay_ms
2761                     ; 126 			GREEN_LED_H();
2763  0081 721a5014      	bset	_PE_ODR,#5
2764                     ; 127 			RED_LED_L();
2766  0085 72115005      	bres	_PB_ODR,#0
2767                     ; 128 			sx1278_LoRaEntryTx();
2769  0089 cd0000        	call	_sx1278_LoRaEntryTx
2771                     ; 129 			sx1278_LoRaTxPacket();
2773  008c cd0000        	call	_sx1278_LoRaTxPacket
2775                     ; 130 			RED_LED_H();
2777  008f 72105005      	bset	_PB_ODR,#0
2778                     ; 131 			sx1278_LoRaEntryRx();
2780  0093 cd0000        	call	_sx1278_LoRaEntryRx
2782  0096               L1071:
2783                     ; 133 		ReadDHT11();			//Read Temperature & Humidity
2785  0096 cd0000        	call	_ReadDHT11
2788  0099 20bf          	jra	L1761
2789  009b               L5761:
2790                     ; 137 		if((SystemFlag&PreviousOptionBit)==0)
2792  009b b601          	ld	a,_SystemFlag
2793  009d a501          	bcp	a,#1
2794  009f 2609          	jrne	L5071
2795                     ; 139 			MasterModeFlag=0;
2797  00a1 3f00          	clr	_MasterModeFlag
2798                     ; 140 			InitialMessageMaster();
2800  00a3 cd031f        	call	_InitialMessageMaster
2802                     ; 141 			SystemFlag|=PreviousOptionBit;
2804  00a6 72100001      	bset	_SystemFlag,#0
2805  00aa               L5071:
2806                     ; 143 		switch(MasterModeFlag)
2808  00aa b600          	ld	a,_MasterModeFlag
2810                     ; 177 				break;
2811  00ac 4d            	tnz	a
2812  00ad 2708          	jreq	L3361
2813  00af 4a            	dec	a
2814  00b0 271f          	jreq	L5361
2815  00b2 4a            	dec	a
2816  00b3 2755          	jreq	L7361
2817  00b5 20a3          	jra	L1761
2818  00b7               L3361:
2819                     ; 145 			case 0:
2819                     ; 146 				if(time_flag==1)
2821  00b7 b602          	ld	a,_time_flag
2822  00b9 a101          	cp	a,#1
2823  00bb 269d          	jrne	L1761
2824                     ; 148 				time_flag=0;
2826  00bd 3f02          	clr	_time_flag
2827                     ; 149 				RED_LED_L();
2829  00bf 72115005      	bres	_PB_ODR,#0
2830                     ; 150 				sx1278_LoRaEntryTx();
2832  00c3 cd0000        	call	_sx1278_LoRaEntryTx
2834                     ; 151 				sx1278_LoRaTxPacket();
2836  00c6 cd0000        	call	_sx1278_LoRaTxPacket
2838                     ; 152 				RED_LED_H();
2840  00c9 72105005      	bset	_PB_ODR,#0
2841                     ; 153 				MasterModeFlag++;
2843  00cd 3c00          	inc	_MasterModeFlag
2844  00cf 2089          	jra	L1761
2845  00d1               L5361:
2846                     ; 156 			case 1:
2846                     ; 157 				sx1278_LoRaEntryRx();
2848  00d1 cd0000        	call	_sx1278_LoRaEntryRx
2850                     ; 158 				for(i=0;i<30;i++)
2852  00d4 5f            	clrw	x
2853  00d5 1f03          	ldw	(OFST-1,sp),x
2854  00d7               L5171:
2855                     ; 160 					delay_ms(100);
2857  00d7 ae0064        	ldw	x,#100
2858  00da cd036b        	call	_delay_ms
2860                     ; 161 					if(sx1278_LoRaRxPacket())
2862  00dd cd0000        	call	_sx1278_LoRaRxPacket
2864  00e0 4d            	tnz	a
2865  00e1 2713          	jreq	L3271
2866                     ; 163 						i=50;
2868  00e3 ae0032        	ldw	x,#50
2869  00e6 1f03          	ldw	(OFST-1,sp),x
2870                     ; 164 						GREEN_LED_L();
2872  00e8 721b5014      	bres	_PE_ODR,#5
2873                     ; 165 						delay_ms(100);
2875  00ec ae0064        	ldw	x,#100
2876  00ef cd036b        	call	_delay_ms
2878                     ; 166 						GREEN_LED_H();			
2880  00f2 721a5014      	bset	_PE_ODR,#5
2881  00f6               L3271:
2882                     ; 158 				for(i=0;i<30;i++)
2884  00f6 1e03          	ldw	x,(OFST-1,sp)
2885  00f8 1c0001        	addw	x,#1
2886  00fb 1f03          	ldw	(OFST-1,sp),x
2889  00fd 1e03          	ldw	x,(OFST-1,sp)
2890  00ff a3001e        	cpw	x,#30
2891  0102 25d3          	jrult	L5171
2892                     ; 169 				MasterModeFlag++;
2894  0104 3c00          	inc	_MasterModeFlag
2895                     ; 170 				break;
2897  0106 ac5a005a      	jpf	L1761
2898  010a               L7361:
2899                     ; 171 			case 2:
2899                     ; 172 				if(time_flag==1)
2901  010a b602          	ld	a,_time_flag
2902  010c a101          	cp	a,#1
2903  010e 2703          	jreq	L6
2904  0110 cc005a        	jp	L1761
2905  0113               L6:
2906                     ; 174 					time_flag=0;
2908  0113 3f02          	clr	_time_flag
2909                     ; 175 					MasterModeFlag=0;
2911  0115 3f00          	clr	_MasterModeFlag
2912  0117 ac5a005a      	jpf	L1761
2913  011b               L1171:
2914  011b ac5a005a      	jpf	L1761
2945                     ; 187 void mcu_init(void)
2945                     ; 188 //=====================================
2945                     ; 189 {
2946                     	switch	.text
2947  011f               _mcu_init:
2951                     ; 190 	CLK_Init();// base clock
2953  011f cd01ab        	call	_CLK_Init
2955                     ; 191 	power_on_delay(); //Power on delay
2957  0122 cd01b4        	call	_power_on_delay
2959                     ; 192 	GPIO_Init();
2961  0125 ad20          	call	_GPIO_Init
2963                     ; 193 	TIM_Init();
2965  0127 cd01ce        	call	_TIM_Init
2967                     ; 195 	PD_ODR=0b00000000;
2969  012a 725f500f      	clr	_PD_ODR
2970                     ; 196 	delay_ms(20);
2972  012e ae0014        	ldw	x,#20
2973  0131 cd036b        	call	_delay_ms
2975                     ; 197 	PD_ODR=0b00000100;
2977  0134 3504500f      	mov	_PD_ODR,#4
2978                     ; 198 	delay_ms(20);	
2980  0138 ae0014        	ldw	x,#20
2981  013b cd036b        	call	_delay_ms
2983                     ; 199 	FLASH_DeInit();
2985  013e cd0000        	call	_FLASH_DeInit
2987                     ; 200 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
2989  0141 a6f7          	ld	a,#247
2990  0143 cd0000        	call	_FLASH_Unlock
2992                     ; 201 }
2995  0146 81            	ret
3043                     ; 203 void GPIO_Init(void) 
3043                     ; 204 //=====================================
3043                     ; 205 {
3044                     	switch	.text
3045  0147               _GPIO_Init:
3049                     ; 206 		PA_DDR = 0b00000000;	
3051  0147 725f5002      	clr	_PA_DDR
3052                     ; 207     PA_CR1 = 0b11111111;             
3054  014b 35ff5003      	mov	_PA_CR1,#255
3055                     ; 208 		PA_CR2 = 0b00000000;
3057  014f 725f5004      	clr	_PA_CR2
3058                     ; 209 		PA_ODR = 0b00000000;
3060  0153 725f5000      	clr	_PA_ODR
3061                     ; 211 		PB_DDR = 0b01000001;         
3063  0157 35415007      	mov	_PB_DDR,#65
3064                     ; 212     PB_CR1 = 0b11111111;               
3066  015b 35ff5008      	mov	_PB_CR1,#255
3067                     ; 213 		PB_CR2 = 0b01000001;
3069  015f 35415009      	mov	_PB_CR2,#65
3070                     ; 214 		PB_ODR = 0b01000001;
3072  0163 35415005      	mov	_PB_ODR,#65
3073                     ; 216     PC_DDR = 0b11010100;
3075  0167 35d4500c      	mov	_PC_DDR,#212
3076                     ; 217     PC_CR1 = 0b11111111;             
3078  016b 35ff500d      	mov	_PC_CR1,#255
3079                     ; 218 		PC_CR2 = 0b11010100;
3081  016f 35d4500e      	mov	_PC_CR2,#212
3082                     ; 219 		PC_ODR = 0b10000110;
3084  0173 3586500a      	mov	_PC_ODR,#134
3085                     ; 221 		PD_DDR = 0b00000100;
3087  0177 35045011      	mov	_PD_DDR,#4
3088                     ; 222 		PD_CR1 = 0b11111111;
3090  017b 35ff5012      	mov	_PD_CR1,#255
3091                     ; 223 		PD_CR2 = 0b00000100;
3093  017f 35045013      	mov	_PD_CR2,#4
3094                     ; 224 		PD_ODR = 0b00000000;
3096  0183 725f500f      	clr	_PD_ODR
3097                     ; 226 		PE_DDR = 0b00100000;
3099  0187 35205016      	mov	_PE_DDR,#32
3100                     ; 227 		PE_CR1 = 0b11111111;
3102  018b 35ff5017      	mov	_PE_CR1,#255
3103                     ; 228 		PE_CR2 = 0b00100000;
3105  018f 35205018      	mov	_PE_CR2,#32
3106                     ; 229 		PE_ODR = 0b00100000;
3108  0193 35205014      	mov	_PE_ODR,#32
3109                     ; 231 		PF_DDR = 0b00010000;							
3111  0197 3510501b      	mov	_PF_DDR,#16
3112                     ; 232 		PF_CR1 = 0b11111111;	 			
3114  019b 35ff501c      	mov	_PF_CR1,#255
3115                     ; 233 		PF_CR2 = 0b00000000;							
3117  019f 725f501d      	clr	_PF_CR2
3118                     ; 234 		PF_ODR = 0b00000000;
3120  01a3 725f5019      	clr	_PF_ODR
3121                     ; 236 		EXTI_CR1 |= 0b00000000;			
3123  01a7 c650a0        	ld	a,_EXTI_CR1
3124                     ; 237 }
3127  01aa 81            	ret
3152                     ; 239 void CLK_Init(void)
3152                     ; 240 //=====================================
3152                     ; 241 {
3153                     	switch	.text
3154  01ab               _CLK_Init:
3158                     ; 242 		CLK_ECKR = 0x00;		//Internal RC OSC
3160  01ab 725f50c1      	clr	_CLK_ECKR
3161                     ; 243     CLK_CKDIVR = 0b00000000; //devide by 1
3163  01af 725f50c6      	clr	_CLK_CKDIVR
3164                     ; 244 }
3167  01b3 81            	ret
3202                     ; 247 void power_on_delay(void)
3202                     ; 248 //=====================================
3202                     ; 249 {
3203                     	switch	.text
3204  01b4               _power_on_delay:
3206  01b4 89            	pushw	x
3207       00000002      OFST:	set	2
3210                     ; 251 	for(i = 0; i<500; i++)//500MS
3212  01b5 5f            	clrw	x
3213  01b6 1f01          	ldw	(OFST-1,sp),x
3214  01b8               L5771:
3215                     ; 253 		delay_ms(1);
3217  01b8 ae0001        	ldw	x,#1
3218  01bb cd036b        	call	_delay_ms
3220                     ; 251 	for(i = 0; i<500; i++)//500MS
3222  01be 1e01          	ldw	x,(OFST-1,sp)
3223  01c0 1c0001        	addw	x,#1
3224  01c3 1f01          	ldw	(OFST-1,sp),x
3227  01c5 1e01          	ldw	x,(OFST-1,sp)
3228  01c7 a301f4        	cpw	x,#500
3229  01ca 25ec          	jrult	L5771
3230                     ; 255 }
3233  01cc 85            	popw	x
3234  01cd 81            	ret
3267                     ; 258 void TIM_Init(void)
3267                     ; 259 //=====================================
3267                     ; 260 {
3268                     	switch	.text
3269  01ce               _TIM_Init:
3273                     ; 263     TIM1_ARRH   = 0x03;
3275  01ce 35035262      	mov	_TIM1_ARRH,#3
3276                     ; 264     TIM1_ARRL   = 0xe8;           /* Freq control register: ARR automatic reload 1ms */
3278  01d2 35e85263      	mov	_TIM1_ARRL,#232
3279                     ; 266     TIM1_PSCRH  = 0x00;           /* Configure TIM1 prescaler_H       */
3281  01d6 725f5260      	clr	_TIM1_PSCRH
3282                     ; 267 		TIM1_PSCRL  = 0x0f;           /* Configure TIM1 prescaler_L   16 frequency divier     */
3284  01da 350f5261      	mov	_TIM1_PSCRL,#15
3285                     ; 268 		TIM1_IER   |= 0x01;						//enable refresh interrupt
3287  01de 72105254      	bset	_TIM1_IER,#0
3288                     ; 269     TIM1_CR1    |= 0x80;
3290  01e2 721e5250      	bset	_TIM1_CR1,#7
3291                     ; 272 		TIM4_ARR   = 0xa0;           	// Freq control register: ARR automatic reload 10us
3293  01e6 35a05348      	mov	_TIM4_ARR,#160
3294                     ; 274     TIM4_PSCR   = 0x00;          	// Configure TIM4 prescaler =128  Base clockÎª8us 
3296  01ea 725f5347      	clr	_TIM4_PSCR
3297                     ; 275 		TIM4_IER   |= 0x01;						//enable refresh interrupt
3299  01ee 72105343      	bset	_TIM4_IER,#0
3300                     ; 276 		TIM4_CR1   |= 0x80;						//bit ARPE set to 1 enable automatic reload \URS set to 1 refresh interrupt only whne counter is overflowed*/
3302  01f2 721e5340      	bset	_TIM4_CR1,#7
3303                     ; 278 }
3306  01f6 81            	ret
3332                     ; 281 void InitialMessageSlave(void)
3332                     ; 282 //=====================================
3332                     ; 283 {
3333                     	switch	.text
3334  01f7               _InitialMessageSlave:
3338                     ; 284 	Message[0]='E';
3340  01f7 35450000      	mov	_Message,#69
3341                     ; 285 	Message[1]='X';
3343  01fb 35580001      	mov	_Message+1,#88
3344                     ; 286 	Message[2]='O';
3346  01ff 354f0002      	mov	_Message+2,#79
3347                     ; 287 	Message[3]='S';
3349  0203 35530003      	mov	_Message+3,#83
3350                     ; 288 	Message[4]='I';
3352  0207 35490004      	mov	_Message+4,#73
3353                     ; 289 	Message[5]='T';
3355  020b 35540005      	mov	_Message+5,#84
3356                     ; 290 	Message[6]='E';	
3358  020f 35450006      	mov	_Message+6,#69
3359                     ; 291 	Message[7]=FLASH_ReadByte(0x4870);	//ID
3361  0213 ae4870        	ldw	x,#18544
3362  0216 89            	pushw	x
3363  0217 ae0000        	ldw	x,#0
3364  021a 89            	pushw	x
3365  021b cd0000        	call	_FLASH_ReadByte
3367  021e 5b04          	addw	sp,#4
3368  0220 b707          	ld	_Message+7,a
3369                     ; 292 	Message[8]=FLASH_ReadByte(0x486f);
3371  0222 ae486f        	ldw	x,#18543
3372  0225 89            	pushw	x
3373  0226 ae0000        	ldw	x,#0
3374  0229 89            	pushw	x
3375  022a cd0000        	call	_FLASH_ReadByte
3377  022d 5b04          	addw	sp,#4
3378  022f b708          	ld	_Message+8,a
3379                     ; 293 	Message[9]=FLASH_ReadByte(0x486e);
3381  0231 ae486e        	ldw	x,#18542
3382  0234 89            	pushw	x
3383  0235 ae0000        	ldw	x,#0
3384  0238 89            	pushw	x
3385  0239 cd0000        	call	_FLASH_ReadByte
3387  023c 5b04          	addw	sp,#4
3388  023e b709          	ld	_Message+9,a
3389                     ; 294 	Message[10]=FLASH_ReadByte(0x486d);
3391  0240 ae486d        	ldw	x,#18541
3392  0243 89            	pushw	x
3393  0244 ae0000        	ldw	x,#0
3394  0247 89            	pushw	x
3395  0248 cd0000        	call	_FLASH_ReadByte
3397  024b 5b04          	addw	sp,#4
3398  024d b70a          	ld	_Message+10,a
3399                     ; 295 	Message[11]=FLASH_ReadByte(0x486c);
3401  024f ae486c        	ldw	x,#18540
3402  0252 89            	pushw	x
3403  0253 ae0000        	ldw	x,#0
3404  0256 89            	pushw	x
3405  0257 cd0000        	call	_FLASH_ReadByte
3407  025a 5b04          	addw	sp,#4
3408  025c b70b          	ld	_Message+11,a
3409                     ; 296 	Message[12]=FLASH_ReadByte(0x486b);
3411  025e ae486b        	ldw	x,#18539
3412  0261 89            	pushw	x
3413  0262 ae0000        	ldw	x,#0
3414  0265 89            	pushw	x
3415  0266 cd0000        	call	_FLASH_ReadByte
3417  0269 5b04          	addw	sp,#4
3418  026b b70c          	ld	_Message+12,a
3419                     ; 297 	Message[13]=FLASH_ReadByte(0x486a);
3421  026d ae486a        	ldw	x,#18538
3422  0270 89            	pushw	x
3423  0271 ae0000        	ldw	x,#0
3424  0274 89            	pushw	x
3425  0275 cd0000        	call	_FLASH_ReadByte
3427  0278 5b04          	addw	sp,#4
3428  027a b70d          	ld	_Message+13,a
3429                     ; 298 	Message[14]=FLASH_ReadByte(0x4869);
3431  027c ae4869        	ldw	x,#18537
3432  027f 89            	pushw	x
3433  0280 ae0000        	ldw	x,#0
3434  0283 89            	pushw	x
3435  0284 cd0000        	call	_FLASH_ReadByte
3437  0287 5b04          	addw	sp,#4
3438  0289 b70e          	ld	_Message+14,a
3439                     ; 299 	Message[15]=FLASH_ReadByte(0x4868);
3441  028b ae4868        	ldw	x,#18536
3442  028e 89            	pushw	x
3443  028f ae0000        	ldw	x,#0
3444  0292 89            	pushw	x
3445  0293 cd0000        	call	_FLASH_ReadByte
3447  0296 5b04          	addw	sp,#4
3448  0298 b70f          	ld	_Message+15,a
3449                     ; 300 	Message[16]=FLASH_ReadByte(0x4867);
3451  029a ae4867        	ldw	x,#18535
3452  029d 89            	pushw	x
3453  029e ae0000        	ldw	x,#0
3454  02a1 89            	pushw	x
3455  02a2 cd0000        	call	_FLASH_ReadByte
3457  02a5 5b04          	addw	sp,#4
3458  02a7 b710          	ld	_Message+16,a
3459                     ; 301 	Message[17]=FLASH_ReadByte(0x4866);
3461  02a9 ae4866        	ldw	x,#18534
3462  02ac 89            	pushw	x
3463  02ad ae0000        	ldw	x,#0
3464  02b0 89            	pushw	x
3465  02b1 cd0000        	call	_FLASH_ReadByte
3467  02b4 5b04          	addw	sp,#4
3468  02b6 b711          	ld	_Message+17,a
3469                     ; 302 	Message[18]=FLASH_ReadByte(0x4865);
3471  02b8 ae4865        	ldw	x,#18533
3472  02bb 89            	pushw	x
3473  02bc ae0000        	ldw	x,#0
3474  02bf 89            	pushw	x
3475  02c0 cd0000        	call	_FLASH_ReadByte
3477  02c3 5b04          	addw	sp,#4
3478  02c5 b712          	ld	_Message+18,a
3479                     ; 303 	Message[19]=FLASH_ReadByte(0x4864);
3481  02c7 ae4864        	ldw	x,#18532
3482  02ca 89            	pushw	x
3483  02cb ae0000        	ldw	x,#0
3484  02ce 89            	pushw	x
3485  02cf cd0000        	call	_FLASH_ReadByte
3487  02d2 5b04          	addw	sp,#4
3488  02d4 b713          	ld	_Message+19,a
3489                     ; 304 	Message[20]=FLASH_ReadByte(0x4863);
3491  02d6 ae4863        	ldw	x,#18531
3492  02d9 89            	pushw	x
3493  02da ae0000        	ldw	x,#0
3494  02dd 89            	pushw	x
3495  02de cd0000        	call	_FLASH_ReadByte
3497  02e1 5b04          	addw	sp,#4
3498  02e3 b714          	ld	_Message+20,a
3499                     ; 305 	Message[21]=FLASH_ReadByte(0x4862);
3501  02e5 ae4862        	ldw	x,#18530
3502  02e8 89            	pushw	x
3503  02e9 ae0000        	ldw	x,#0
3504  02ec 89            	pushw	x
3505  02ed cd0000        	call	_FLASH_ReadByte
3507  02f0 5b04          	addw	sp,#4
3508  02f2 b715          	ld	_Message+21,a
3509                     ; 306 	Message[22]=FLASH_ReadByte(0x4861);
3511  02f4 ae4861        	ldw	x,#18529
3512  02f7 89            	pushw	x
3513  02f8 ae0000        	ldw	x,#0
3514  02fb 89            	pushw	x
3515  02fc cd0000        	call	_FLASH_ReadByte
3517  02ff 5b04          	addw	sp,#4
3518  0301 b716          	ld	_Message+22,a
3519                     ; 307 	Message[23]=FLASH_ReadByte(0x4860); //ID
3521  0303 ae4860        	ldw	x,#18528
3522  0306 89            	pushw	x
3523  0307 ae0000        	ldw	x,#0
3524  030a 89            	pushw	x
3525  030b cd0000        	call	_FLASH_ReadByte
3527  030e 5b04          	addw	sp,#4
3528  0310 b717          	ld	_Message+23,a
3529                     ; 308 	Message[24]=0;
3531  0312 3f18          	clr	_Message+24
3532                     ; 309 	Message[25]=0;
3534  0314 3f19          	clr	_Message+25
3535                     ; 310 	Message[26]=0;
3537  0316 3f1a          	clr	_Message+26
3538                     ; 311 	Message[27]=0;
3540  0318 3f1b          	clr	_Message+27
3541                     ; 312 	Message[28]=0;
3543  031a 3f1c          	clr	_Message+28
3544                     ; 313 	Message[29]=0;
3546  031c 3f1d          	clr	_Message+29
3547                     ; 314 }
3550  031e 81            	ret
3575                     ; 317 void InitialMessageMaster(void)
3575                     ; 318 //=====================================
3575                     ; 319 {
3576                     	switch	.text
3577  031f               _InitialMessageMaster:
3581                     ; 320 	Message[0]='E';
3583  031f 35450000      	mov	_Message,#69
3584                     ; 321 	Message[1]='X';
3586  0323 35580001      	mov	_Message+1,#88
3587                     ; 322 	Message[2]='O';
3589  0327 354f0002      	mov	_Message+2,#79
3590                     ; 323 	Message[3]='S';
3592  032b 35530003      	mov	_Message+3,#83
3593                     ; 324 	Message[4]='I';
3595  032f 35490004      	mov	_Message+4,#73
3596                     ; 325 	Message[5]='T';
3598  0333 35540005      	mov	_Message+5,#84
3599                     ; 326 	Message[6]='E';	
3601  0337 35450006      	mov	_Message+6,#69
3602                     ; 327 	Message[7]=0;
3604  033b 3f07          	clr	_Message+7
3605                     ; 328 	Message[8]=0;
3607  033d 3f08          	clr	_Message+8
3608                     ; 329 	Message[9]=0;
3610  033f 3f09          	clr	_Message+9
3611                     ; 330 	Message[10]=0;
3613  0341 3f0a          	clr	_Message+10
3614                     ; 331 	Message[11]=0;
3616  0343 3f0b          	clr	_Message+11
3617                     ; 332 	Message[12]=0;
3619  0345 3f0c          	clr	_Message+12
3620                     ; 333 	Message[13]=0;
3622  0347 3f0d          	clr	_Message+13
3623                     ; 334 	Message[14]=0;
3625  0349 3f0e          	clr	_Message+14
3626                     ; 335 	Message[15]=0;
3628  034b 3f0f          	clr	_Message+15
3629                     ; 336 	Message[16]=0;
3631  034d 3f10          	clr	_Message+16
3632                     ; 337 	Message[17]=0;
3634  034f 3f11          	clr	_Message+17
3635                     ; 338 	Message[18]=0;
3637  0351 3f12          	clr	_Message+18
3638                     ; 339 	Message[19]=0;
3640  0353 3f13          	clr	_Message+19
3641                     ; 340 	Message[20]=0;
3643  0355 3f14          	clr	_Message+20
3644                     ; 341 	Message[21]=0;
3646  0357 3f15          	clr	_Message+21
3647                     ; 342 	Message[22]=0;
3649  0359 3f16          	clr	_Message+22
3650                     ; 343 	Message[23]=0;
3652  035b 3f17          	clr	_Message+23
3653                     ; 344 	Message[24]=0;
3655  035d 3f18          	clr	_Message+24
3656                     ; 345 	Message[25]=0;
3658  035f 3f19          	clr	_Message+25
3659                     ; 346 	Message[26]=0;
3661  0361 3f1a          	clr	_Message+26
3662                     ; 347 	Message[27]=0;
3664  0363 3f1b          	clr	_Message+27
3665                     ; 348 	Message[28]=0;
3667  0365 3f1c          	clr	_Message+28
3668                     ; 349 	Message[29]=0;	
3670  0367 3f1d          	clr	_Message+29
3671                     ; 350 }	
3674  0369 81            	ret
3697                     ; 353 u8 FunctionCheck(void)
3697                     ; 354 //=====================================
3697                     ; 355 #define Broadcast	1
3697                     ; 356 #define EERead		2
3697                     ; 357 #define EEWrite		3
3697                     ; 358 {
3698                     	switch	.text
3699  036a               _FunctionCheck:
3703                     ; 360 }
3706  036a 81            	ret
3759                     ; 364 void delay_ms(unsigned int ms)
3759                     ; 365 //=====================================
3759                     ; 366 {
3760                     	switch	.text
3761  036b               _delay_ms:
3763  036b 89            	pushw	x
3764  036c 5204          	subw	sp,#4
3765       00000004      OFST:	set	4
3768                     ; 369 	for(j=0;j<ms;j++)
3770  036e 5f            	clrw	x
3771  036f 1f01          	ldw	(OFST-3,sp),x
3773  0371 201d          	jra	L5702
3774  0373               L1702:
3775                     ; 371 		for(i=0;i<650;i++)
3777  0373 5f            	clrw	x
3778  0374 1f03          	ldw	(OFST-1,sp),x
3779  0376               L1012:
3780                     ; 373 			delay_us(1);
3782  0376 ae0001        	ldw	x,#1
3783  0379 ad1e          	call	_delay_us
3785                     ; 371 		for(i=0;i<650;i++)
3787  037b 1e03          	ldw	x,(OFST-1,sp)
3788  037d 1c0001        	addw	x,#1
3789  0380 1f03          	ldw	(OFST-1,sp),x
3792  0382 1e03          	ldw	x,(OFST-1,sp)
3793  0384 a3028a        	cpw	x,#650
3794  0387 25ed          	jrult	L1012
3795                     ; 369 	for(j=0;j<ms;j++)
3797  0389 1e01          	ldw	x,(OFST-3,sp)
3798  038b 1c0001        	addw	x,#1
3799  038e 1f01          	ldw	(OFST-3,sp),x
3800  0390               L5702:
3803  0390 1e01          	ldw	x,(OFST-3,sp)
3804  0392 1305          	cpw	x,(OFST+1,sp)
3805  0394 25dd          	jrult	L1702
3806                     ; 376 }
3809  0396 5b06          	addw	sp,#6
3810  0398 81            	ret
3845                     ; 379 void delay_us(unsigned int us)
3845                     ; 380 //=====================================
3845                     ; 381 {
3846                     	switch	.text
3847  0399               _delay_us:
3851                     ; 382 	NOP();
3854  0399 9d            nop
3856                     ; 383 }
3860  039a 81            	ret
4003                     	xdef	_FunctionCheck
4004                     	xdef	_main
4005                     	xdef	_InitialMessageMaster
4006                     	xdef	_InitialMessageSlave
4007                     	xdef	_TIM_Init
4008                     	xdef	_power_on_delay
4009                     	xdef	_CLK_Init
4010                     	xdef	_GPIO_Init
4011                     	xdef	_mcu_init
4012                     	switch	.ubsct
4013  0000               _MasterModeFlag:
4014  0000 00            	ds.b	1
4015                     	xdef	_MasterModeFlag
4016  0001               _SystemFlag:
4017  0001 00            	ds.b	1
4018                     	xdef	_SystemFlag
4019                     	xref	_ReadDHT11
4020  0002               _time_flag:
4021  0002 00            	ds.b	1
4022                     	xdef	_time_flag
4023  0003               _rf_rx_packet_length:
4024  0003 00            	ds.b	1
4025                     	xdef	_rf_rx_packet_length
4026  0004               _time2_count:
4027  0004 0000          	ds.b	2
4028                     	xdef	_time2_count
4029                     	xref	_FLASH_ReadByte
4030                     	xref	_FLASH_DeInit
4031                     	xref	_FLASH_Unlock
4032                     	xref	_sx1278_LoRaTxPacket
4033                     	xref	_sx1278_LoRaEntryTx
4034                     	xref	_sx1278_LoRaRxPacket
4035                     	xref	_sx1278_LoRaEntryRx
4036                     	xref	_sx1278_Config
4037                     	xref.b	_Message
4038                     	xdef	_delay_us
4039                     	xdef	_delay_ms
4040  0006               _SysTime:
4041  0006 0000          	ds.b	2
4042                     	xdef	_SysTime
4043  0008               _Fsk_Rate_Sel:
4044  0008 00            	ds.b	1
4045                     	xdef	_Fsk_Rate_Sel
4046  0009               _BandWide_Sel:
4047  0009 00            	ds.b	1
4048                     	xdef	_BandWide_Sel
4049  000a               _Lora_Rate_Sel:
4050  000a 00            	ds.b	1
4051                     	xdef	_Lora_Rate_Sel
4052  000b               _Gain_Sel:
4053  000b 00            	ds.b	1
4054                     	xdef	_Gain_Sel
4055  000c               _PA_Over_Current_Sel:
4056  000c 00            	ds.b	1
4057                     	xdef	_PA_Over_Current_Sel
4058  000d               _Power_Sel:
4059  000d 00            	ds.b	1
4060                     	xdef	_Power_Sel
4061  000e               _Freq_Sel:
4062  000e 00            	ds.b	1
4063                     	xdef	_Freq_Sel
4064  000f               _mode:
4065  000f 00            	ds.b	1
4066                     	xdef	_mode
4086                     	end
