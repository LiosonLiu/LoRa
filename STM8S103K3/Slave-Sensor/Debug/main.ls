   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2613                     ; 72 void main()
2613                     ; 73 //=====================================
2613                     ; 74 {
2615                     	switch	.text
2616  0000               _main:
2618  0000 5204          	subw	sp,#4
2619       00000004      OFST:	set	4
2622                     ; 75 	u16 i,j,k=0,g;
2624  0002 5f            	clrw	x
2625  0003 1f01          	ldw	(OFST-3,sp),x
2626                     ; 76 	InitialRAM();	
2628  0005 cd0378        	call	_InitialRAM
2630                     ; 77 	_asm("sim");               //Disable interrupts.
2633  0008 9b            sim
2635                     ; 78 	mcu_init();
2637  0009 cd00fb        	call	_mcu_init
2639                     ; 79 	ITC_SPR4 = 0xf3;//time2 interrupt priority 2¡¢level13
2641  000c 35f37f73      	mov	_ITC_SPR4,#243
2642                     ; 80 	ITC_SPR5 = 0x3c;//UART1_RX ¡¢UART_TX interrupt priority 2
2644  0010 353c7f74      	mov	_ITC_SPR5,#60
2645                     ; 81 	ITC_SPR6 = 0x00;//UART3_RX ¡¢UART_TX interrupt priority 2
2647  0014 725f7f75      	clr	_ITC_SPR6
2648                     ; 82 	_asm("rim");              //Enable interrupts.
2651  0018 9a            rim
2653                     ; 84 	GREEN_LED_L();
2655  0019 721b5014      	bres	_PE_ODR,#5
2656                     ; 85 	RED_LED_L();
2658  001d 72115005      	bres	_PB_ODR,#0
2659                     ; 86 	delay_ms(500);
2661  0021 ae01f4        	ldw	x,#500
2662  0024 cd0348        	call	_delay_ms
2664                     ; 87 	GREEN_LED_H();
2666  0027 721a5014      	bset	_PE_ODR,#5
2667                     ; 88 	RED_LED_H();
2669  002b 72105005      	bset	_PB_ODR,#0
2670                     ; 89 	sx1278_Config();
2672  002f cd0000        	call	_sx1278_Config
2674                     ; 90   sx1278_LoRaEntryRx();
2676  0032 cd0000        	call	_sx1278_LoRaEntryRx
2678                     ; 91 	InitialMessageSlave();
2680  0035 cd01d3        	call	_InitialMessageSlave
2682                     ; 92 	TIM1_CR1 |= 0x01;			//enable time1
2684  0038 72105250      	bset	_TIM1_CR1,#0
2685                     ; 93 	MasterModeFlag=0;	
2687  003c 3f00          	clr	_MasterModeFlag
2688  003e               L1761:
2689                     ; 96 	if(GetOption())	//Slave
2691  003e c6500b        	ld	a,_PC_IDR
2692  0041 a402          	and	a,#2
2693  0043 a102          	cp	a,#2
2694  0045 2630          	jrne	L5761
2695                     ; 98 		if(SystemFlag&PreviousOptionBit)
2697  0047 b601          	ld	a,_SystemFlag
2698  0049 a501          	bcp	a,#1
2699  004b 2708          	jreq	L7761
2700                     ; 100 			sx1278_LoRaEntryRx();
2702  004d cd0000        	call	_sx1278_LoRaEntryRx
2704                     ; 101 			InitialMessageSlave();
2706  0050 cd01d3        	call	_InitialMessageSlave
2708                     ; 102 			SystemFlag&=(!PreviousOptionBit);
2710  0053 3f01          	clr	_SystemFlag
2711  0055               L7761:
2712                     ; 104 		if(sx1278_LoRaRxPacket())
2714  0055 cd0000        	call	_sx1278_LoRaRxPacket
2716  0058 4d            	tnz	a
2717  0059 2717          	jreq	L1071
2718                     ; 106 			GREEN_LED_L();
2720  005b 721b5014      	bres	_PE_ODR,#5
2721                     ; 107 			delay_ms(100);
2723  005f ae0064        	ldw	x,#100
2724  0062 cd0348        	call	_delay_ms
2726                     ; 108 			GREEN_LED_H();
2728  0065 721a5014      	bset	_PE_ODR,#5
2729                     ; 110 			sx1278_LoRaEntryTx();			
2731  0069 cd0000        	call	_sx1278_LoRaEntryTx
2733                     ; 111 			sx1278_LoRaTxPacket();
2735  006c cd0000        	call	_sx1278_LoRaTxPacket
2737                     ; 113 			sx1278_LoRaEntryRx();
2739  006f cd0000        	call	_sx1278_LoRaEntryRx
2741  0072               L1071:
2742                     ; 115 		ReadDHT11();			//Read Temperature & Humidity
2744  0072 cd0000        	call	_ReadDHT11
2747  0075 20c7          	jra	L1761
2748  0077               L5761:
2749                     ; 119 		if((SystemFlag&PreviousOptionBit)==0)
2751  0077 b601          	ld	a,_SystemFlag
2752  0079 a501          	bcp	a,#1
2753  007b 2609          	jrne	L5071
2754                     ; 121 			MasterModeFlag=0;
2756  007d 3f00          	clr	_MasterModeFlag
2757                     ; 122 			InitialMessageMaster();
2759  007f cd02fb        	call	_InitialMessageMaster
2761                     ; 123 			SystemFlag|=PreviousOptionBit;
2763  0082 72100001      	bset	_SystemFlag,#0
2764  0086               L5071:
2765                     ; 125 		switch(MasterModeFlag)
2767  0086 b600          	ld	a,_MasterModeFlag
2769                     ; 159 				break;
2770  0088 4d            	tnz	a
2771  0089 2708          	jreq	L3361
2772  008b 4a            	dec	a
2773  008c 271f          	jreq	L5361
2774  008e 4a            	dec	a
2775  008f 2755          	jreq	L7361
2776  0091 20ab          	jra	L1761
2777  0093               L3361:
2778                     ; 127 			case 0:
2778                     ; 128 				if(time_flag==1)
2780  0093 b602          	ld	a,_time_flag
2781  0095 a101          	cp	a,#1
2782  0097 26a5          	jrne	L1761
2783                     ; 130 				time_flag=0;
2785  0099 3f02          	clr	_time_flag
2786                     ; 131 				RED_LED_L();
2788  009b 72115005      	bres	_PB_ODR,#0
2789                     ; 132 				sx1278_LoRaEntryTx();			
2791  009f cd0000        	call	_sx1278_LoRaEntryTx
2793                     ; 133 				sx1278_LoRaTxPacket();
2795  00a2 cd0000        	call	_sx1278_LoRaTxPacket
2797                     ; 134 				RED_LED_H();					
2799  00a5 72105005      	bset	_PB_ODR,#0
2800                     ; 135 				MasterModeFlag++;
2802  00a9 3c00          	inc	_MasterModeFlag
2803  00ab 2091          	jra	L1761
2804  00ad               L5361:
2805                     ; 138 			case 1:
2805                     ; 139 				sx1278_LoRaEntryRx();
2807  00ad cd0000        	call	_sx1278_LoRaEntryRx
2809                     ; 140 				for(i=0;i<30;i++)
2811  00b0 5f            	clrw	x
2812  00b1 1f03          	ldw	(OFST-1,sp),x
2813  00b3               L5171:
2814                     ; 142 					delay_ms(100);
2816  00b3 ae0064        	ldw	x,#100
2817  00b6 cd0348        	call	_delay_ms
2819                     ; 143 					if(sx1278_LoRaRxPacket())
2821  00b9 cd0000        	call	_sx1278_LoRaRxPacket
2823  00bc 4d            	tnz	a
2824  00bd 2713          	jreq	L3271
2825                     ; 145 						i=50;
2827  00bf ae0032        	ldw	x,#50
2828  00c2 1f03          	ldw	(OFST-1,sp),x
2829                     ; 146 						GREEN_LED_L();
2831  00c4 721b5014      	bres	_PE_ODR,#5
2832                     ; 147 						delay_ms(100);
2834  00c8 ae0064        	ldw	x,#100
2835  00cb cd0348        	call	_delay_ms
2837                     ; 148 						GREEN_LED_H();			
2839  00ce 721a5014      	bset	_PE_ODR,#5
2840  00d2               L3271:
2841                     ; 140 				for(i=0;i<30;i++)
2843  00d2 1e03          	ldw	x,(OFST-1,sp)
2844  00d4 1c0001        	addw	x,#1
2845  00d7 1f03          	ldw	(OFST-1,sp),x
2848  00d9 1e03          	ldw	x,(OFST-1,sp)
2849  00db a3001e        	cpw	x,#30
2850  00de 25d3          	jrult	L5171
2851                     ; 151 				MasterModeFlag++;
2853  00e0 3c00          	inc	_MasterModeFlag
2854                     ; 152 				break;
2856  00e2 ac3e003e      	jpf	L1761
2857  00e6               L7361:
2858                     ; 153 			case 2:
2858                     ; 154 				if(time_flag==1)
2860  00e6 b602          	ld	a,_time_flag
2861  00e8 a101          	cp	a,#1
2862  00ea 2703          	jreq	L6
2863  00ec cc003e        	jp	L1761
2864  00ef               L6:
2865                     ; 156 					time_flag=0;
2867  00ef 3f02          	clr	_time_flag
2868                     ; 157 					MasterModeFlag=0;
2870  00f1 3f00          	clr	_MasterModeFlag
2871  00f3 ac3e003e      	jpf	L1761
2872  00f7               L1171:
2873  00f7 ac3e003e      	jpf	L1761
2904                     ; 169 void mcu_init(void)
2904                     ; 170 //=====================================
2904                     ; 171 {
2905                     	switch	.text
2906  00fb               _mcu_init:
2910                     ; 172 	CLK_Init();// base clock
2912  00fb cd0187        	call	_CLK_Init
2914                     ; 173 	power_on_delay(); //Power on delay
2916  00fe cd0190        	call	_power_on_delay
2918                     ; 174 	GPIO_Init();
2920  0101 ad20          	call	_GPIO_Init
2922                     ; 175 	TIM_Init();
2924  0103 cd01aa        	call	_TIM_Init
2926                     ; 177 	PD_ODR=0b00000000;
2928  0106 725f500f      	clr	_PD_ODR
2929                     ; 178 	delay_ms(20);
2931  010a ae0014        	ldw	x,#20
2932  010d cd0348        	call	_delay_ms
2934                     ; 179 	PD_ODR=0b00000100;
2936  0110 3504500f      	mov	_PD_ODR,#4
2937                     ; 180 	delay_ms(20);	
2939  0114 ae0014        	ldw	x,#20
2940  0117 cd0348        	call	_delay_ms
2942                     ; 181 	FLASH_DeInit();
2944  011a cd0000        	call	_FLASH_DeInit
2946                     ; 182 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
2948  011d a6f7          	ld	a,#247
2949  011f cd0000        	call	_FLASH_Unlock
2951                     ; 183 }
2954  0122 81            	ret
3002                     ; 185 void GPIO_Init(void) 
3002                     ; 186 //=====================================
3002                     ; 187 {
3003                     	switch	.text
3004  0123               _GPIO_Init:
3008                     ; 188 		PA_DDR = 0b00000000;	
3010  0123 725f5002      	clr	_PA_DDR
3011                     ; 189     PA_CR1 = 0b11111111;             
3013  0127 35ff5003      	mov	_PA_CR1,#255
3014                     ; 190 		PA_CR2 = 0b00000000;
3016  012b 725f5004      	clr	_PA_CR2
3017                     ; 191 		PA_ODR = 0b00000000;
3019  012f 725f5000      	clr	_PA_ODR
3020                     ; 193 		PB_DDR = 0b01000001;         
3022  0133 35415007      	mov	_PB_DDR,#65
3023                     ; 194     PB_CR1 = 0b11111111;               
3025  0137 35ff5008      	mov	_PB_CR1,#255
3026                     ; 195 		PB_CR2 = 0b01000001;
3028  013b 35415009      	mov	_PB_CR2,#65
3029                     ; 196 		PB_ODR = 0b01000001;
3031  013f 35415005      	mov	_PB_ODR,#65
3032                     ; 198     PC_DDR = 0b11010100;
3034  0143 35d4500c      	mov	_PC_DDR,#212
3035                     ; 199     PC_CR1 = 0b11111111;             
3037  0147 35ff500d      	mov	_PC_CR1,#255
3038                     ; 200 		PC_CR2 = 0b11010100;
3040  014b 35d4500e      	mov	_PC_CR2,#212
3041                     ; 201 		PC_ODR = 0b10000110;
3043  014f 3586500a      	mov	_PC_ODR,#134
3044                     ; 203 		PD_DDR = 0b00000100;
3046  0153 35045011      	mov	_PD_DDR,#4
3047                     ; 204 		PD_CR1 = 0b11111111;
3049  0157 35ff5012      	mov	_PD_CR1,#255
3050                     ; 205 		PD_CR2 = 0b00000100;
3052  015b 35045013      	mov	_PD_CR2,#4
3053                     ; 206 		PD_ODR = 0b00000000;
3055  015f 725f500f      	clr	_PD_ODR
3056                     ; 208 		PE_DDR = 0b00100000;
3058  0163 35205016      	mov	_PE_DDR,#32
3059                     ; 209 		PE_CR1 = 0b11111111;
3061  0167 35ff5017      	mov	_PE_CR1,#255
3062                     ; 210 		PE_CR2 = 0b00100000;
3064  016b 35205018      	mov	_PE_CR2,#32
3065                     ; 211 		PE_ODR = 0b00100000;
3067  016f 35205014      	mov	_PE_ODR,#32
3068                     ; 213 		PF_DDR = 0b00010000;							
3070  0173 3510501b      	mov	_PF_DDR,#16
3071                     ; 214 		PF_CR1 = 0b11111111;	 			
3073  0177 35ff501c      	mov	_PF_CR1,#255
3074                     ; 215 		PF_CR2 = 0b00000000;							
3076  017b 725f501d      	clr	_PF_CR2
3077                     ; 216 		PF_ODR = 0b00000000;
3079  017f 725f5019      	clr	_PF_ODR
3080                     ; 218 		EXTI_CR1 |= 0b00000000;			
3082  0183 c650a0        	ld	a,_EXTI_CR1
3083                     ; 219 }
3086  0186 81            	ret
3111                     ; 221 void CLK_Init(void)
3111                     ; 222 //=====================================
3111                     ; 223 {
3112                     	switch	.text
3113  0187               _CLK_Init:
3117                     ; 224 		CLK_ECKR = 0x00;		//Internal RC OSC
3119  0187 725f50c1      	clr	_CLK_ECKR
3120                     ; 225     CLK_CKDIVR = 0b00000000; //devide by 1
3122  018b 725f50c6      	clr	_CLK_CKDIVR
3123                     ; 226 }
3126  018f 81            	ret
3161                     ; 229 void power_on_delay(void)
3161                     ; 230 //=====================================
3161                     ; 231 {
3162                     	switch	.text
3163  0190               _power_on_delay:
3165  0190 89            	pushw	x
3166       00000002      OFST:	set	2
3169                     ; 233 	for(i = 0; i<500; i++)//500MS
3171  0191 5f            	clrw	x
3172  0192 1f01          	ldw	(OFST-1,sp),x
3173  0194               L5771:
3174                     ; 235 		delay_ms(1);
3176  0194 ae0001        	ldw	x,#1
3177  0197 cd0348        	call	_delay_ms
3179                     ; 233 	for(i = 0; i<500; i++)//500MS
3181  019a 1e01          	ldw	x,(OFST-1,sp)
3182  019c 1c0001        	addw	x,#1
3183  019f 1f01          	ldw	(OFST-1,sp),x
3186  01a1 1e01          	ldw	x,(OFST-1,sp)
3187  01a3 a301f4        	cpw	x,#500
3188  01a6 25ec          	jrult	L5771
3189                     ; 237 }
3192  01a8 85            	popw	x
3193  01a9 81            	ret
3226                     ; 240 void TIM_Init(void)
3226                     ; 241 //=====================================
3226                     ; 242 {
3227                     	switch	.text
3228  01aa               _TIM_Init:
3232                     ; 245     TIM1_ARRH   = 0x03;
3234  01aa 35035262      	mov	_TIM1_ARRH,#3
3235                     ; 246     TIM1_ARRL   = 0xe8;           /* Freq control register: ARR automatic reload 1ms */
3237  01ae 35e85263      	mov	_TIM1_ARRL,#232
3238                     ; 248     TIM1_PSCRH  = 0x00;           /* Configure TIM1 prescaler_H       */
3240  01b2 725f5260      	clr	_TIM1_PSCRH
3241                     ; 249 		TIM1_PSCRL  = 0x0f;           /* Configure TIM1 prescaler_L   16 frequency divier     */
3243  01b6 350f5261      	mov	_TIM1_PSCRL,#15
3244                     ; 250 		TIM1_IER   |= 0x01;						//enable refresh interrupt
3246  01ba 72105254      	bset	_TIM1_IER,#0
3247                     ; 251     TIM1_CR1    |= 0x80;
3249  01be 721e5250      	bset	_TIM1_CR1,#7
3250                     ; 254 		TIM4_ARR   = 0xa0;           	// Freq control register: ARR automatic reload 10us
3252  01c2 35a05348      	mov	_TIM4_ARR,#160
3253                     ; 256     TIM4_PSCR   = 0x00;          	// Configure TIM4 prescaler =128  Base clockÎª8us 
3255  01c6 725f5347      	clr	_TIM4_PSCR
3256                     ; 257 		TIM4_IER   |= 0x01;						//enable refresh interrupt
3258  01ca 72105343      	bset	_TIM4_IER,#0
3259                     ; 258 		TIM4_CR1   |= 0x80;						//bit ARPE set to 1 enable automatic reload \URS set to 1 refresh interrupt only whne counter is overflowed*/
3261  01ce 721e5340      	bset	_TIM4_CR1,#7
3262                     ; 260 }
3265  01d2 81            	ret
3291                     ; 263 void InitialMessageSlave(void)
3291                     ; 264 //=====================================
3291                     ; 265 {
3292                     	switch	.text
3293  01d3               _InitialMessageSlave:
3297                     ; 266 	Message[0]='E';
3299  01d3 35450000      	mov	_Message,#69
3300                     ; 267 	Message[1]='X';
3302  01d7 35580001      	mov	_Message+1,#88
3303                     ; 268 	Message[2]='O';
3305  01db 354f0002      	mov	_Message+2,#79
3306                     ; 269 	Message[3]='S';
3308  01df 35530003      	mov	_Message+3,#83
3309                     ; 270 	Message[4]='I';
3311  01e3 35490004      	mov	_Message+4,#73
3312                     ; 271 	Message[5]='T';
3314  01e7 35540005      	mov	_Message+5,#84
3315                     ; 272 	Message[6]='E';	
3317  01eb 35450006      	mov	_Message+6,#69
3318                     ; 273 	Message[7]=FLASH_ReadByte(0x4870);	//ID
3320  01ef ae4870        	ldw	x,#18544
3321  01f2 89            	pushw	x
3322  01f3 ae0000        	ldw	x,#0
3323  01f6 89            	pushw	x
3324  01f7 cd0000        	call	_FLASH_ReadByte
3326  01fa 5b04          	addw	sp,#4
3327  01fc b707          	ld	_Message+7,a
3328                     ; 274 	Message[8]=FLASH_ReadByte(0x486f);
3330  01fe ae486f        	ldw	x,#18543
3331  0201 89            	pushw	x
3332  0202 ae0000        	ldw	x,#0
3333  0205 89            	pushw	x
3334  0206 cd0000        	call	_FLASH_ReadByte
3336  0209 5b04          	addw	sp,#4
3337  020b b708          	ld	_Message+8,a
3338                     ; 275 	Message[9]=FLASH_ReadByte(0x486e);
3340  020d ae486e        	ldw	x,#18542
3341  0210 89            	pushw	x
3342  0211 ae0000        	ldw	x,#0
3343  0214 89            	pushw	x
3344  0215 cd0000        	call	_FLASH_ReadByte
3346  0218 5b04          	addw	sp,#4
3347  021a b709          	ld	_Message+9,a
3348                     ; 276 	Message[10]=FLASH_ReadByte(0x486d);
3350  021c ae486d        	ldw	x,#18541
3351  021f 89            	pushw	x
3352  0220 ae0000        	ldw	x,#0
3353  0223 89            	pushw	x
3354  0224 cd0000        	call	_FLASH_ReadByte
3356  0227 5b04          	addw	sp,#4
3357  0229 b70a          	ld	_Message+10,a
3358                     ; 277 	Message[11]=FLASH_ReadByte(0x486c);
3360  022b ae486c        	ldw	x,#18540
3361  022e 89            	pushw	x
3362  022f ae0000        	ldw	x,#0
3363  0232 89            	pushw	x
3364  0233 cd0000        	call	_FLASH_ReadByte
3366  0236 5b04          	addw	sp,#4
3367  0238 b70b          	ld	_Message+11,a
3368                     ; 278 	Message[12]=FLASH_ReadByte(0x486b);
3370  023a ae486b        	ldw	x,#18539
3371  023d 89            	pushw	x
3372  023e ae0000        	ldw	x,#0
3373  0241 89            	pushw	x
3374  0242 cd0000        	call	_FLASH_ReadByte
3376  0245 5b04          	addw	sp,#4
3377  0247 b70c          	ld	_Message+12,a
3378                     ; 279 	Message[13]=FLASH_ReadByte(0x486a);
3380  0249 ae486a        	ldw	x,#18538
3381  024c 89            	pushw	x
3382  024d ae0000        	ldw	x,#0
3383  0250 89            	pushw	x
3384  0251 cd0000        	call	_FLASH_ReadByte
3386  0254 5b04          	addw	sp,#4
3387  0256 b70d          	ld	_Message+13,a
3388                     ; 280 	Message[14]=FLASH_ReadByte(0x4869);
3390  0258 ae4869        	ldw	x,#18537
3391  025b 89            	pushw	x
3392  025c ae0000        	ldw	x,#0
3393  025f 89            	pushw	x
3394  0260 cd0000        	call	_FLASH_ReadByte
3396  0263 5b04          	addw	sp,#4
3397  0265 b70e          	ld	_Message+14,a
3398                     ; 281 	Message[15]=FLASH_ReadByte(0x4868);
3400  0267 ae4868        	ldw	x,#18536
3401  026a 89            	pushw	x
3402  026b ae0000        	ldw	x,#0
3403  026e 89            	pushw	x
3404  026f cd0000        	call	_FLASH_ReadByte
3406  0272 5b04          	addw	sp,#4
3407  0274 b70f          	ld	_Message+15,a
3408                     ; 282 	Message[16]=FLASH_ReadByte(0x4867);
3410  0276 ae4867        	ldw	x,#18535
3411  0279 89            	pushw	x
3412  027a ae0000        	ldw	x,#0
3413  027d 89            	pushw	x
3414  027e cd0000        	call	_FLASH_ReadByte
3416  0281 5b04          	addw	sp,#4
3417  0283 b710          	ld	_Message+16,a
3418                     ; 283 	Message[17]=FLASH_ReadByte(0x4866);
3420  0285 ae4866        	ldw	x,#18534
3421  0288 89            	pushw	x
3422  0289 ae0000        	ldw	x,#0
3423  028c 89            	pushw	x
3424  028d cd0000        	call	_FLASH_ReadByte
3426  0290 5b04          	addw	sp,#4
3427  0292 b711          	ld	_Message+17,a
3428                     ; 284 	Message[18]=FLASH_ReadByte(0x4865);
3430  0294 ae4865        	ldw	x,#18533
3431  0297 89            	pushw	x
3432  0298 ae0000        	ldw	x,#0
3433  029b 89            	pushw	x
3434  029c cd0000        	call	_FLASH_ReadByte
3436  029f 5b04          	addw	sp,#4
3437  02a1 b712          	ld	_Message+18,a
3438                     ; 285 	Message[19]=FLASH_ReadByte(0x4864);
3440  02a3 ae4864        	ldw	x,#18532
3441  02a6 89            	pushw	x
3442  02a7 ae0000        	ldw	x,#0
3443  02aa 89            	pushw	x
3444  02ab cd0000        	call	_FLASH_ReadByte
3446  02ae 5b04          	addw	sp,#4
3447  02b0 b713          	ld	_Message+19,a
3448                     ; 286 	Message[20]=FLASH_ReadByte(0x4863);
3450  02b2 ae4863        	ldw	x,#18531
3451  02b5 89            	pushw	x
3452  02b6 ae0000        	ldw	x,#0
3453  02b9 89            	pushw	x
3454  02ba cd0000        	call	_FLASH_ReadByte
3456  02bd 5b04          	addw	sp,#4
3457  02bf b714          	ld	_Message+20,a
3458                     ; 287 	Message[21]=FLASH_ReadByte(0x4862);
3460  02c1 ae4862        	ldw	x,#18530
3461  02c4 89            	pushw	x
3462  02c5 ae0000        	ldw	x,#0
3463  02c8 89            	pushw	x
3464  02c9 cd0000        	call	_FLASH_ReadByte
3466  02cc 5b04          	addw	sp,#4
3467  02ce b715          	ld	_Message+21,a
3468                     ; 288 	Message[22]=FLASH_ReadByte(0x4861);
3470  02d0 ae4861        	ldw	x,#18529
3471  02d3 89            	pushw	x
3472  02d4 ae0000        	ldw	x,#0
3473  02d7 89            	pushw	x
3474  02d8 cd0000        	call	_FLASH_ReadByte
3476  02db 5b04          	addw	sp,#4
3477  02dd b716          	ld	_Message+22,a
3478                     ; 289 	Message[23]=FLASH_ReadByte(0x4860); //ID
3480  02df ae4860        	ldw	x,#18528
3481  02e2 89            	pushw	x
3482  02e3 ae0000        	ldw	x,#0
3483  02e6 89            	pushw	x
3484  02e7 cd0000        	call	_FLASH_ReadByte
3486  02ea 5b04          	addw	sp,#4
3487  02ec b717          	ld	_Message+23,a
3488                     ; 290 	Message[24]=0;
3490  02ee 3f18          	clr	_Message+24
3491                     ; 291 	Message[25]=0;
3493  02f0 3f19          	clr	_Message+25
3494                     ; 292 	Message[26]=0;
3496  02f2 3f1a          	clr	_Message+26
3497                     ; 293 	Message[27]=0;
3499  02f4 3f1b          	clr	_Message+27
3500                     ; 294 	Message[28]=0;
3502  02f6 3f1c          	clr	_Message+28
3503                     ; 295 	Message[29]=0;
3505  02f8 3f1d          	clr	_Message+29
3506                     ; 296 }
3509  02fa 81            	ret
3534                     ; 299 void InitialMessageMaster(void)
3534                     ; 300 //=====================================
3534                     ; 301 {
3535                     	switch	.text
3536  02fb               _InitialMessageMaster:
3540                     ; 302 	Message[0]='E';
3542  02fb 35450000      	mov	_Message,#69
3543                     ; 303 	Message[1]='X';
3545  02ff 35580001      	mov	_Message+1,#88
3546                     ; 304 	Message[2]='O';
3548  0303 354f0002      	mov	_Message+2,#79
3549                     ; 305 	Message[3]='S';
3551  0307 35530003      	mov	_Message+3,#83
3552                     ; 306 	Message[4]='I';
3554  030b 35490004      	mov	_Message+4,#73
3555                     ; 307 	Message[5]='T';
3557  030f 35540005      	mov	_Message+5,#84
3558                     ; 308 	Message[6]='E';	
3560  0313 35450006      	mov	_Message+6,#69
3561                     ; 309 	Message[7]=0;
3563  0317 3f07          	clr	_Message+7
3564                     ; 310 	Message[8]=0;
3566  0319 3f08          	clr	_Message+8
3567                     ; 311 	Message[9]=0;
3569  031b 3f09          	clr	_Message+9
3570                     ; 312 	Message[10]=0;
3572  031d 3f0a          	clr	_Message+10
3573                     ; 313 	Message[11]=0;
3575  031f 3f0b          	clr	_Message+11
3576                     ; 314 	Message[12]=0;
3578  0321 3f0c          	clr	_Message+12
3579                     ; 315 	Message[13]=0;
3581  0323 3f0d          	clr	_Message+13
3582                     ; 316 	Message[14]=0;
3584  0325 3f0e          	clr	_Message+14
3585                     ; 317 	Message[15]=0;
3587  0327 3f0f          	clr	_Message+15
3588                     ; 318 	Message[16]=0;
3590  0329 3f10          	clr	_Message+16
3591                     ; 319 	Message[17]=0;
3593  032b 3f11          	clr	_Message+17
3594                     ; 320 	Message[18]=0;
3596  032d 3f12          	clr	_Message+18
3597                     ; 321 	Message[19]=0;
3599  032f 3f13          	clr	_Message+19
3600                     ; 322 	Message[20]=0;
3602  0331 3f14          	clr	_Message+20
3603                     ; 323 	Message[21]=0;
3605  0333 3f15          	clr	_Message+21
3606                     ; 324 	Message[22]=0;
3608  0335 3f16          	clr	_Message+22
3609                     ; 325 	Message[23]=0;
3611  0337 3f17          	clr	_Message+23
3612                     ; 326 	Message[24]=0;
3614  0339 3f18          	clr	_Message+24
3615                     ; 327 	Message[25]=0;
3617  033b 3f19          	clr	_Message+25
3618                     ; 328 	Message[26]=0;
3620  033d 3f1a          	clr	_Message+26
3621                     ; 329 	Message[27]=0;
3623  033f 3f1b          	clr	_Message+27
3624                     ; 330 	Message[28]=0;
3626  0341 3f1c          	clr	_Message+28
3627                     ; 331 	Message[29]=0;	
3629  0343 3f1d          	clr	_Message+29
3630                     ; 332 }	
3633  0345 81            	ret
3656                     ; 334 void Encryption(void)
3656                     ; 335 //=====================================
3656                     ; 336 {
3657                     	switch	.text
3658  0346               _Encryption:
3662                     ; 337 }
3665  0346 81            	ret
3688                     ; 339 u8 FunctionCheck(void)
3688                     ; 340 //=====================================
3688                     ; 341 //Function
3688                     ; 342 #define Broadcast		1
3688                     ; 343 #define EERead			2
3688                     ; 344 #define EEWrite			3
3688                     ; 345 #define StructRead	4
3688                     ; 346 #define StructWrite 5
3688                     ; 347 #define IOWrite			6
3688                     ; 348 #define IORead			7
3688                     ; 349 #define SleepOption	8
3688                     ; 350 #define PWS					9
3688                     ; 351 #define ResetSYS		10
3688                     ; 352 {
3689                     	switch	.text
3690  0347               _FunctionCheck:
3694                     ; 354 }
3697  0347 81            	ret
3750                     ; 358 void delay_ms(unsigned int ms)
3750                     ; 359 //=====================================
3750                     ; 360 {
3751                     	switch	.text
3752  0348               _delay_ms:
3754  0348 89            	pushw	x
3755  0349 5204          	subw	sp,#4
3756       00000004      OFST:	set	4
3759                     ; 363 	for(j=0;j<ms;j++)
3761  034b 5f            	clrw	x
3762  034c 1f01          	ldw	(OFST-3,sp),x
3764  034e 201d          	jra	L5012
3765  0350               L1012:
3766                     ; 365 		for(i=0;i<650;i++)
3768  0350 5f            	clrw	x
3769  0351 1f03          	ldw	(OFST-1,sp),x
3770  0353               L1112:
3771                     ; 367 			delay_us(1);
3773  0353 ae0001        	ldw	x,#1
3774  0356 ad1e          	call	_delay_us
3776                     ; 365 		for(i=0;i<650;i++)
3778  0358 1e03          	ldw	x,(OFST-1,sp)
3779  035a 1c0001        	addw	x,#1
3780  035d 1f03          	ldw	(OFST-1,sp),x
3783  035f 1e03          	ldw	x,(OFST-1,sp)
3784  0361 a3028a        	cpw	x,#650
3785  0364 25ed          	jrult	L1112
3786                     ; 363 	for(j=0;j<ms;j++)
3788  0366 1e01          	ldw	x,(OFST-3,sp)
3789  0368 1c0001        	addw	x,#1
3790  036b 1f01          	ldw	(OFST-3,sp),x
3791  036d               L5012:
3794  036d 1e01          	ldw	x,(OFST-3,sp)
3795  036f 1305          	cpw	x,(OFST+1,sp)
3796  0371 25dd          	jrult	L1012
3797                     ; 370 }
3800  0373 5b06          	addw	sp,#6
3801  0375 81            	ret
3836                     ; 373 void delay_us(unsigned int us)
3836                     ; 374 //=====================================
3836                     ; 375 {
3837                     	switch	.text
3838  0376               _delay_us:
3842                     ; 376 	NOP();
3845  0376 9d            nop
3847                     ; 377 }
3851  0377 81            	ret
3898                     ; 379 void InitialRAM(void)
3898                     ; 380 //=====================================
3898                     ; 381 {
3899                     	switch	.text
3900  0378               _InitialRAM:
3902  0378 88            	push	a
3903       00000001      OFST:	set	1
3906                     ; 382 	u8 action=0x00;
3908  0379 0f01          	clr	(OFST+0,sp)
3909                     ; 383 	SysTime 				= 0;
3911  037b 5f            	clrw	x
3912  037c bf06          	ldw	_SysTime,x
3913                     ; 384 	SystemFlag 			= 0x00;
3915  037e 3f01          	clr	_SystemFlag
3916                     ; 385 	mode 						= 0x01;//lora mode
3918  0380 3501000f      	mov	_mode,#1
3919                     ; 386 	Freq_Sel 				= 0x00;//433M
3921  0384 3f0e          	clr	_Freq_Sel
3922                     ; 387 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
3924  0386 a6f7          	ld	a,#247
3925  0388 cd0000        	call	_FLASH_Unlock
3927                     ; 392 	Gain_Sel				=	FLASH_ReadByte(EEGain_Sel_Address);//1~6, 1 is Max
3929  038b ae4002        	ldw	x,#16386
3930  038e 89            	pushw	x
3931  038f ae0000        	ldw	x,#0
3932  0392 89            	pushw	x
3933  0393 cd0000        	call	_FLASH_ReadByte
3935  0396 5b04          	addw	sp,#4
3936  0398 b70b          	ld	_Gain_Sel,a
3937                     ; 393 	if(Gain_Sel==0)	//0 & 0xff  mean first time run
3939  039a 3d0b          	tnz	_Gain_Sel
3940  039c 2604          	jrne	L3512
3941                     ; 394 		action=0xff;
3943  039e a6ff          	ld	a,#255
3944  03a0 6b01          	ld	(OFST+0,sp),a
3945  03a2               L3512:
3946                     ; 395 	if(Gain_Sel>6)
3948  03a2 b60b          	ld	a,_Gain_Sel
3949  03a4 a107          	cp	a,#7
3950  03a6 2504          	jrult	L5512
3951                     ; 396 		action=0xff;
3953  03a8 a6ff          	ld	a,#255
3954  03aa 6b01          	ld	(OFST+0,sp),a
3955  03ac               L5512:
3956                     ; 397 	if(action!=0)
3958  03ac 0d01          	tnz	(OFST+0,sp)
3959  03ae 273b          	jreq	L7512
3960                     ; 399 		Gain_Sel=1; 
3962  03b0 3501000b      	mov	_Gain_Sel,#1
3963                     ; 400 		PA_Over_Current_Sel=11; 
3965  03b4 350b000c      	mov	_PA_Over_Current_Sel,#11
3966                     ; 401 		Power_Sel=0;		
3968  03b8 3f0d          	clr	_Power_Sel
3969                     ; 402 		FLASH_ProgramByte(EEGain_Sel_Address,Gain_Sel);
3971  03ba 4b01          	push	#1
3972  03bc ae4002        	ldw	x,#16386
3973  03bf 89            	pushw	x
3974  03c0 ae0000        	ldw	x,#0
3975  03c3 89            	pushw	x
3976  03c4 cd0000        	call	_FLASH_ProgramByte
3978  03c7 5b05          	addw	sp,#5
3979                     ; 403 		FLASH_ProgramByte(EEPA_OC_Sel_Address,PA_Over_Current_Sel); 
3981  03c9 3b000c        	push	_PA_Over_Current_Sel
3982  03cc ae4001        	ldw	x,#16385
3983  03cf 89            	pushw	x
3984  03d0 ae0000        	ldw	x,#0
3985  03d3 89            	pushw	x
3986  03d4 cd0000        	call	_FLASH_ProgramByte
3988  03d7 5b05          	addw	sp,#5
3989                     ; 404 		FLASH_ProgramByte(EEPower_Sel_Address,Power_Sel);
3991  03d9 3b000d        	push	_Power_Sel
3992  03dc ae4000        	ldw	x,#16384
3993  03df 89            	pushw	x
3994  03e0 ae0000        	ldw	x,#0
3995  03e3 89            	pushw	x
3996  03e4 cd0000        	call	_FLASH_ProgramByte
3998  03e7 5b05          	addw	sp,#5
4000  03e9 201e          	jra	L1612
4001  03eb               L7512:
4002                     ; 408 		Power_Sel 		= FLASH_ReadByte(EEPower_Sel_Address);//PA power 0~15
4004  03eb ae4000        	ldw	x,#16384
4005  03ee 89            	pushw	x
4006  03ef ae0000        	ldw	x,#0
4007  03f2 89            	pushw	x
4008  03f3 cd0000        	call	_FLASH_ReadByte
4010  03f6 5b04          	addw	sp,#4
4011  03f8 b70d          	ld	_Power_Sel,a
4012                     ; 409 		PA_Over_Current_Sel = FLASH_ReadByte(EEPA_OC_Sel_Address);//100mA 0~15 =>45+(5*Value), 15~37=>(10*Value)-30
4014  03fa ae4001        	ldw	x,#16385
4015  03fd 89            	pushw	x
4016  03fe ae0000        	ldw	x,#0
4017  0401 89            	pushw	x
4018  0402 cd0000        	call	_FLASH_ReadByte
4020  0405 5b04          	addw	sp,#4
4021  0407 b70c          	ld	_PA_Over_Current_Sel,a
4022  0409               L1612:
4023                     ; 412 	Lora_Rate_Sel 	= 0x06;//
4025  0409 3506000a      	mov	_Lora_Rate_Sel,#6
4026                     ; 413 	BandWide_Sel 		= 0x07;
4028  040d 35070009      	mov	_BandWide_Sel,#7
4029                     ; 414 	Fsk_Rate_Sel 		= 0x00;	
4031  0411 3f08          	clr	_Fsk_Rate_Sel
4032                     ; 415 }
4035  0413 84            	pop	a
4036  0414 81            	ret
4061                     ; 417 void Test(void)
4061                     ; 418 //=====================================
4061                     ; 419 {
4062                     	switch	.text
4063  0415               _Test:
4067                     ; 420 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
4069  0415 a6f7          	ld	a,#247
4070  0417 cd0000        	call	_FLASH_Unlock
4072                     ; 421 	FLASH_ProgramByte(EEPA_OC_Sel_Address,11);
4074  041a 4b0b          	push	#11
4075  041c ae4001        	ldw	x,#16385
4076  041f 89            	pushw	x
4077  0420 ae0000        	ldw	x,#0
4078  0423 89            	pushw	x
4079  0424 cd0000        	call	_FLASH_ProgramByte
4081  0427 5b05          	addw	sp,#5
4082                     ; 422 }
4085  0429 81            	ret
4228                     	xdef	_FunctionCheck
4229                     	xdef	_Encryption
4230                     	xdef	_main
4231                     	xdef	_InitialMessageMaster
4232                     	xdef	_InitialMessageSlave
4233                     	xdef	_Test
4234                     	xdef	_InitialRAM
4235                     	xdef	_TIM_Init
4236                     	xdef	_power_on_delay
4237                     	xdef	_CLK_Init
4238                     	xdef	_GPIO_Init
4239                     	xdef	_mcu_init
4240                     	switch	.ubsct
4241  0000               _MasterModeFlag:
4242  0000 00            	ds.b	1
4243                     	xdef	_MasterModeFlag
4244  0001               _SystemFlag:
4245  0001 00            	ds.b	1
4246                     	xdef	_SystemFlag
4247                     	xref	_ReadDHT11
4248  0002               _time_flag:
4249  0002 00            	ds.b	1
4250                     	xdef	_time_flag
4251  0003               _rf_rx_packet_length:
4252  0003 00            	ds.b	1
4253                     	xdef	_rf_rx_packet_length
4254  0004               _time2_count:
4255  0004 0000          	ds.b	2
4256                     	xdef	_time2_count
4257                     	xref	_FLASH_ReadByte
4258                     	xref	_FLASH_ProgramByte
4259                     	xref	_FLASH_DeInit
4260                     	xref	_FLASH_Unlock
4261                     	xref	_sx1278_LoRaTxPacket
4262                     	xref	_sx1278_LoRaEntryTx
4263                     	xref	_sx1278_LoRaRxPacket
4264                     	xref	_sx1278_LoRaEntryRx
4265                     	xref	_sx1278_Config
4266                     	xref.b	_Message
4267                     	xdef	_delay_us
4268                     	xdef	_delay_ms
4269  0006               _SysTime:
4270  0006 0000          	ds.b	2
4271                     	xdef	_SysTime
4272  0008               _Fsk_Rate_Sel:
4273  0008 00            	ds.b	1
4274                     	xdef	_Fsk_Rate_Sel
4275  0009               _BandWide_Sel:
4276  0009 00            	ds.b	1
4277                     	xdef	_BandWide_Sel
4278  000a               _Lora_Rate_Sel:
4279  000a 00            	ds.b	1
4280                     	xdef	_Lora_Rate_Sel
4281  000b               _Gain_Sel:
4282  000b 00            	ds.b	1
4283                     	xdef	_Gain_Sel
4284  000c               _PA_Over_Current_Sel:
4285  000c 00            	ds.b	1
4286                     	xdef	_PA_Over_Current_Sel
4287  000d               _Power_Sel:
4288  000d 00            	ds.b	1
4289                     	xdef	_Power_Sel
4290  000e               _Freq_Sel:
4291  000e 00            	ds.b	1
4292                     	xdef	_Freq_Sel
4293  000f               _mode:
4294  000f 00            	ds.b	1
4295                     	xdef	_mode
4315                     	end
