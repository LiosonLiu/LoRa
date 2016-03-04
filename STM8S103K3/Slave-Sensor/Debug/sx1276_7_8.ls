   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2545                     .const:	section	.text
2546  0000               _sx1278FreqTable:
2547  0000 85            	dc.b	133
2548  0001 3b            	dc.b	59
2549  0002 13            	dc.b	19
2550  0003               _sx1278PowerTable:
2551  0003 ff            	dc.b	255
2552  0004 fc            	dc.b	252
2553  0005 f9            	dc.b	249
2554  0006 f6            	dc.b	246
2555  0007               _sx1278SpreadFactorTable:
2556  0007 06            	dc.b	6
2557  0008 07            	dc.b	7
2558  0009 08            	dc.b	8
2559  000a 09            	dc.b	9
2560  000b 0a            	dc.b	10
2561  000c 0b            	dc.b	11
2562  000d 0c            	dc.b	12
2563  000e               _sx1278LoRaBwTable:
2564  000e 00            	dc.b	0
2565  000f 01            	dc.b	1
2566  0010 02            	dc.b	2
2567  0011 03            	dc.b	3
2568  0012 04            	dc.b	4
2569  0013 05            	dc.b	5
2570  0014 06            	dc.b	6
2571  0015 07            	dc.b	7
2572  0016 08            	dc.b	8
2573  0017 09            	dc.b	9
2574  0018               _sx1278Data:
2575  0018 2a2a45786f73  	dc.b	"**Exosite LoRa Dem"
2576  002a 6f2a2a00      	dc.b	"o**",0
2622                     ; 40 u8 sx1278_LoRaEntryRx(void)
2622                     ; 41 //=====================================
2622                     ; 42 {
2624                     	switch	.text
2625  0000               _sx1278_LoRaEntryRx:
2627  0000 88            	push	a
2628       00000001      OFST:	set	1
2631                     ; 44   ANT_EN_L();
2633  0001 721d5005      	bres	_PB_ODR,#6
2634                     ; 45 	ANT_CTRL_RX();        
2636  0005 7214500a      	bset	_PC_ODR,#2
2637                     ; 46   sx1278_Config();                            //setting base parameter
2639  0009 cd019e        	call	_sx1278_Config
2641                     ; 47   SPIWrite(REG_LR_PADAC,0x84);                    //Normal and Rx
2643  000c ae4d84        	ldw	x,#19844
2644  000f cd0000        	call	_SPIWrite
2646                     ; 48   SPIWrite(LR_RegHopPeriod,0xFF);                 //RegHopPeriod NO FHSS
2648  0012 ae24ff        	ldw	x,#9471
2649  0015 cd0000        	call	_SPIWrite
2651                     ; 49   SPIWrite(REG_LR_DIOMAPPING1,0x01);              //DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
2653  0018 ae4001        	ldw	x,#16385
2654  001b cd0000        	call	_SPIWrite
2656                     ; 50   SPIWrite(LR_RegIrqFlagsMask,0x3F);              //Open RxDone interrupt & Timeout
2658  001e ae113f        	ldw	x,#4415
2659  0021 cd0000        	call	_SPIWrite
2661                     ; 51   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);     
2663  0024 ae12ff        	ldw	x,#4863
2664  0027 cd0000        	call	_SPIWrite
2666                     ; 52   SPIWrite(LR_RegPayloadLength,30);               //RegPayloadLength  30byte(this register must difine when the data long of one byte in SF is 6)
2668  002a ae221e        	ldw	x,#8734
2669  002d cd0000        	call	_SPIWrite
2671                     ; 53   addr = SPIRead(LR_RegFifoRxBaseAddr);           //Read RxBaseAddr
2673  0030 a60f          	ld	a,#15
2674  0032 cd0000        	call	_SPIRead
2676  0035 6b01          	ld	(OFST+0,sp),a
2677                     ; 54   SPIWrite(LR_RegFifoAddrPtr,addr);               //RxBaseAddr -> FiFoAddrPtr¡¡ 
2679  0037 7b01          	ld	a,(OFST+0,sp)
2680  0039 97            	ld	xl,a
2681  003a a60d          	ld	a,#13
2682  003c 95            	ld	xh,a
2683  003d cd0000        	call	_SPIWrite
2685                     ; 55   SPIWrite(LR_RegOpMode,0x8d);                    //Continuous Rx Mode//Low Frequency Mode
2687  0040 ae018d        	ldw	x,#397
2688  0043 cd0000        	call	_SPIWrite
2690                     ; 57 	SysTime = 0;
2692  0046 5f            	clrw	x
2693  0047 bf00          	ldw	_SysTime,x
2694  0049               L7561:
2695                     ; 60 		if((SPIRead(LR_RegModemStat)&0x04)==0x04)   	//Rx-on going RegModemStat
2697  0049 a618          	ld	a,#24
2698  004b cd0000        	call	_SPIRead
2700  004e a404          	and	a,#4
2701  0050 a104          	cp	a,#4
2702  0052 2603          	jrne	L3661
2703                     ; 61 			break;
2704                     ; 65 }
2707  0054 5b01          	addw	sp,#1
2708  0056 81            	ret
2709  0057               L3661:
2710                     ; 62 		if(SysTime>=3)	
2712  0057 be00          	ldw	x,_SysTime
2713  0059 a30003        	cpw	x,#3
2714  005c 25eb          	jrult	L7561
2715                     ; 63 			return 0;                                   //over time for error
2717  005e 4f            	clr	a
2720  005f 5b01          	addw	sp,#1
2721  0061 81            	ret
2757                     ; 68 u8 sx1278_LoRaReadRSSI(void)
2757                     ; 69 //=====================================
2757                     ; 70 {
2758                     	switch	.text
2759  0062               _sx1278_LoRaReadRSSI:
2761  0062 89            	pushw	x
2762       00000002      OFST:	set	2
2765                     ; 71   u16 temp=10;
2767                     ; 72   temp=SPIRead(LR_RegRssiValue);                  //Read RegRssiValue£¬Rssi value
2769  0063 a61b          	ld	a,#27
2770  0065 cd0000        	call	_SPIRead
2772  0068 5f            	clrw	x
2773  0069 97            	ld	xl,a
2774  006a 1f01          	ldw	(OFST-1,sp),x
2775                     ; 73   temp=temp+127-137;                              //127:Max RSSI, 137:RSSI offset
2777  006c 1e01          	ldw	x,(OFST-1,sp)
2778  006e 1d000a        	subw	x,#10
2779  0071 1f01          	ldw	(OFST-1,sp),x
2780                     ; 74   return (u8)temp;
2782  0073 7b02          	ld	a,(OFST+0,sp)
2785  0075 85            	popw	x
2786  0076 81            	ret
2847                     ; 78 u8 sx1278_LoRaRxPacket(void)
2847                     ; 79 //=====================================
2847                     ; 80 {
2848                     	switch	.text
2849  0077               _sx1278_LoRaRxPacket:
2851  0077 88            	push	a
2852       00000001      OFST:	set	1
2855                     ; 84   if(Get_NIRQ())
2857  0078 c65010        	ld	a,_PD_IDR
2858  007b a408          	and	a,#8
2859  007d a108          	cp	a,#8
2860  007f 2675          	jrne	L3371
2861                     ; 86     for(i=0;i<32;i++) 
2863  0081 0f01          	clr	(OFST+0,sp)
2864  0083               L5371:
2865                     ; 87       RxData[i] = 0x00;    
2867  0083 7b01          	ld	a,(OFST+0,sp)
2868  0085 5f            	clrw	x
2869  0086 97            	ld	xl,a
2870  0087 6f1e          	clr	(_RxData,x)
2871                     ; 86     for(i=0;i<32;i++) 
2873  0089 0c01          	inc	(OFST+0,sp)
2876  008b 7b01          	ld	a,(OFST+0,sp)
2877  008d a120          	cp	a,#32
2878  008f 25f2          	jrult	L5371
2879                     ; 88     addr = SPIRead(LR_RegFifoRxCurrentaddr);      //last packet addr
2881  0091 a610          	ld	a,#16
2882  0093 cd0000        	call	_SPIRead
2884  0096 6b01          	ld	(OFST+0,sp),a
2885                     ; 89     SPIWrite(LR_RegFifoAddrPtr,addr);             //RxBaseAddr -> FiFoAddrPtr    
2887  0098 7b01          	ld	a,(OFST+0,sp)
2888  009a 97            	ld	xl,a
2889  009b a60d          	ld	a,#13
2890  009d 95            	ld	xh,a
2891  009e cd0000        	call	_SPIWrite
2893                     ; 90     if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)	//When SpreadFactor is six£¬will used Implicit Header mode(Excluding internal packet length)
2895  00a1 b600          	ld	a,_Lora_Rate_Sel
2896  00a3 5f            	clrw	x
2897  00a4 97            	ld	xl,a
2898  00a5 d60007        	ld	a,(_sx1278SpreadFactorTable,x)
2899  00a8 a106          	cp	a,#6
2900  00aa 2606          	jrne	L3471
2901                     ; 91       packet_size=30;
2903  00ac a61e          	ld	a,#30
2904  00ae 6b01          	ld	(OFST+0,sp),a
2906  00b0 2007          	jra	L5471
2907  00b2               L3471:
2908                     ; 93       packet_size = SPIRead(LR_RegRxNbBytes);     //Number for received bytes    
2910  00b2 a613          	ld	a,#19
2911  00b4 cd0000        	call	_SPIRead
2913  00b7 6b01          	ld	(OFST+0,sp),a
2914  00b9               L5471:
2915                     ; 94     SPIBurstRead(0x00, RxData, packet_size);    
2917  00b9 7b01          	ld	a,(OFST+0,sp)
2918  00bb 88            	push	a
2919  00bc ae001e        	ldw	x,#_RxData
2920  00bf 89            	pushw	x
2921  00c0 4f            	clr	a
2922  00c1 cd0000        	call	_SPIBurstRead
2924  00c4 5b03          	addw	sp,#3
2925                     ; 95     SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
2927  00c6 ae12ff        	ldw	x,#4863
2928  00c9 cd0000        	call	_SPIWrite
2930                     ; 96     for(i=0;i<17;i++)
2932  00cc 0f01          	clr	(OFST+0,sp)
2933  00ce               L7471:
2934                     ; 98       if(RxData[i]!=Message[i])
2936  00ce 7b01          	ld	a,(OFST+0,sp)
2937  00d0 5f            	clrw	x
2938  00d1 97            	ld	xl,a
2939  00d2 7b01          	ld	a,(OFST+0,sp)
2940  00d4 905f          	clrw	y
2941  00d6 9097          	ld	yl,a
2942  00d8 90e61e        	ld	a,(_RxData,y)
2943  00db e100          	cp	a,(_Message,x)
2944  00dd 2608          	jrne	L3571
2945                     ; 99         break;  
2947                     ; 96     for(i=0;i<17;i++)
2949  00df 0c01          	inc	(OFST+0,sp)
2952  00e1 7b01          	ld	a,(OFST+0,sp)
2953  00e3 a111          	cp	a,#17
2954  00e5 25e7          	jrult	L7471
2955  00e7               L3571:
2956                     ; 101     if(i>=17)                                     //Rx success
2958  00e7 7b01          	ld	a,(OFST+0,sp)
2959  00e9 a111          	cp	a,#17
2960  00eb 2505          	jrult	L7571
2961                     ; 102       return(1);
2963  00ed a601          	ld	a,#1
2966  00ef 5b01          	addw	sp,#1
2967  00f1 81            	ret
2968  00f2               L7571:
2969                     ; 104       return(0);
2971  00f2 4f            	clr	a
2974  00f3 5b01          	addw	sp,#1
2975  00f5 81            	ret
2976  00f6               L3371:
2977                     ; 107     return(0);
2979  00f6 4f            	clr	a
2982  00f7 5b01          	addw	sp,#1
2983  00f9 81            	ret
3032                     ; 111 u8 sx1278_LoRaEntryTx(void)
3032                     ; 112 //=====================================
3032                     ; 113 {
3033                     	switch	.text
3034  00fa               _sx1278_LoRaEntryTx:
3036  00fa 88            	push	a
3037       00000001      OFST:	set	1
3040                     ; 115   sx1278_Config();                            //setting base parameter
3042  00fb cd019e        	call	_sx1278_Config
3044                     ; 116   ANT_EN_H();
3046  00fe 721c5005      	bset	_PB_ODR,#6
3047                     ; 117 	ANT_CTRL_TX();    
3049  0102 7215500a      	bres	_PC_ODR,#2
3050                     ; 118   SPIWrite(REG_LR_PADAC,0x87);                    //Tx for 20dBm
3052  0106 ae4d87        	ldw	x,#19847
3053  0109 cd0000        	call	_SPIWrite
3055                     ; 119   SPIWrite(LR_RegHopPeriod,0x00);                 //RegHopPeriod NO FHSS
3057  010c ae2400        	ldw	x,#9216
3058  010f cd0000        	call	_SPIWrite
3060                     ; 120   SPIWrite(REG_LR_DIOMAPPING1,0x41);              //DIO0=01, DIO1=00, DIO2=00, DIO3=01  
3062  0112 ae4041        	ldw	x,#16449
3063  0115 cd0000        	call	_SPIWrite
3065                     ; 121   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
3067  0118 ae12ff        	ldw	x,#4863
3068  011b cd0000        	call	_SPIWrite
3070                     ; 122   SPIWrite(LR_RegIrqFlagsMask,0xF7);              //Open TxDone interrupt
3072  011e ae11f7        	ldw	x,#4599
3073  0121 cd0000        	call	_SPIWrite
3075                     ; 123   SPIWrite(LR_RegPayloadLength,30);               //RegPayloadLength  30byte  
3077  0124 ae221e        	ldw	x,#8734
3078  0127 cd0000        	call	_SPIWrite
3080                     ; 124   addr = SPIRead(LR_RegFifoTxBaseAddr);           //RegFiFoTxBaseAddr
3082  012a a60e          	ld	a,#14
3083  012c cd0000        	call	_SPIRead
3085  012f 6b01          	ld	(OFST+0,sp),a
3086                     ; 125   SPIWrite(LR_RegFifoAddrPtr,addr);               //RegFifoAddrPtr
3088  0131 7b01          	ld	a,(OFST+0,sp)
3089  0133 97            	ld	xl,a
3090  0134 a60d          	ld	a,#13
3091  0136 95            	ld	xh,a
3092  0137 cd0000        	call	_SPIWrite
3094                     ; 126 	SysTime = 0;
3096  013a 5f            	clrw	x
3097  013b bf00          	ldw	_SysTime,x
3098  013d               L7002:
3099                     ; 129 		temp=SPIRead(LR_RegPayloadLength);
3101  013d a622          	ld	a,#34
3102  013f cd0000        	call	_SPIRead
3104  0142 6b01          	ld	(OFST+0,sp),a
3105                     ; 130 		if(temp==30)
3107  0144 7b01          	ld	a,(OFST+0,sp)
3108  0146 a11e          	cp	a,#30
3109  0148 2603          	jrne	L3102
3110                     ; 132 			break; 
3111                     ; 137 }
3114  014a 5b01          	addw	sp,#1
3115  014c 81            	ret
3116  014d               L3102:
3117                     ; 134 		if(SysTime>=3)	
3119  014d be00          	ldw	x,_SysTime
3120  014f a30003        	cpw	x,#3
3121  0152 25e9          	jrult	L7002
3122                     ; 135 			return 0;
3124  0154 4f            	clr	a
3127  0155 5b01          	addw	sp,#1
3128  0157 81            	ret
3168                     ; 140 u8 sx1278_LoRaTxPacket(void)
3168                     ; 141 //=====================================
3168                     ; 142 { 
3169                     	switch	.text
3170  0158               _sx1278_LoRaTxPacket:
3172  0158 88            	push	a
3173       00000001      OFST:	set	1
3176                     ; 143   u8 TxFlag=0;
3178  0159 0f01          	clr	(OFST+0,sp)
3179                     ; 147 	BurstWrite(0x00, Message, 30);
3181  015b 4b1e          	push	#30
3182  015d ae0000        	ldw	x,#_Message
3183  0160 89            	pushw	x
3184  0161 4f            	clr	a
3185  0162 cd0000        	call	_BurstWrite
3187  0165 5b03          	addw	sp,#3
3188                     ; 148 	SPIWrite(LR_RegOpMode,0x8b);                    	//Tx Mode           
3190  0167 ae018b        	ldw	x,#395
3191  016a cd0000        	call	_SPIWrite
3193  016d               L5302:
3194                     ; 151 		if(Get_NIRQ())                      						//Packet send over
3196  016d c65010        	ld	a,_PD_IDR
3197  0170 a408          	and	a,#8
3198  0172 a108          	cp	a,#8
3199  0174 26f7          	jrne	L5302
3200                     ; 153 			SPIRead(LR_RegIrqFlags);
3202  0176 a612          	ld	a,#18
3203  0178 cd0000        	call	_SPIRead
3205                     ; 154 			SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);	//Clear irq				
3207  017b ae12ff        	ldw	x,#4863
3208  017e cd0000        	call	_SPIWrite
3210                     ; 155 			SPIWrite(LR_RegOpMode,LoRa_Standby_Value);    //Entry Standby mode   
3212  0181 ae0109        	ldw	x,#265
3213  0184 cd0000        	call	_SPIWrite
3215                     ; 156 			break;
3216                     ; 159 }
3219  0187 84            	pop	a
3220  0188 81            	ret
3255                     ; 162 u8 sx1278_ReadRSSI(void)
3255                     ; 163 //=====================================
3255                     ; 164 {
3256                     	switch	.text
3257  0189               _sx1278_ReadRSSI:
3259  0189 88            	push	a
3260       00000001      OFST:	set	1
3263                     ; 165   u8 temp=0xff;	
3265                     ; 166   temp=SPIRead(0x11);
3267  018a a611          	ld	a,#17
3268  018c cd0000        	call	_SPIRead
3270  018f 6b01          	ld	(OFST+0,sp),a
3271                     ; 167   temp>>=1;
3273  0191 0401          	srl	(OFST+0,sp)
3274                     ; 168   temp=127-temp;		                     					//127:Max RSSI
3276  0193 a67f          	ld	a,#127
3277  0195 1001          	sub	a,(OFST+0,sp)
3278  0197 6b01          	ld	(OFST+0,sp),a
3279                     ; 169   return temp;
3281  0199 7b01          	ld	a,(OFST+0,sp)
3284  019b 5b01          	addw	sp,#1
3285  019d 81            	ret
3341                     ; 173 void sx1278_Config(void)
3341                     ; 174 //=====================================
3341                     ; 175 {
3342                     	switch	.text
3343  019e               _sx1278_Config:
3345  019e 88            	push	a
3346       00000001      OFST:	set	1
3349                     ; 177   SPIWrite(LR_RegOpMode,LoRa_Sleep_Value);   			//Change modem mode Must in Sleep mode 
3351  019f ae0108        	ldw	x,#264
3352  01a2 cd0000        	call	_SPIWrite
3354                     ; 178   for(i=250;i!=0;i--)                             //Delay
3356  01a5 a6fa          	ld	a,#250
3357  01a7 6b01          	ld	(OFST+0,sp),a
3358  01a9               L3012:
3359                     ; 179     NOP();
3362  01a9 9d            nop
3364                     ; 178   for(i=250;i!=0;i--)                             //Delay
3366  01aa 0a01          	dec	(OFST+0,sp)
3369  01ac 0d01          	tnz	(OFST+0,sp)
3370  01ae 26f9          	jrne	L3012
3371                     ; 180 	delay_ms(15);
3374  01b0 ae000f        	ldw	x,#15
3375  01b3 cd0000        	call	_delay_ms
3377                     ; 183 	SPIWrite(LR_RegOpMode,LoRa_Entry_Value);     
3379  01b6 ae0188        	ldw	x,#392
3380  01b9 cd0000        	call	_SPIWrite
3382                     ; 184 	BurstWrite(LR_RegFrMsb,sx1278FreqTable[Freq_Sel],3);  //setting frequency parameter
3384  01bc 4b03          	push	#3
3385  01be b600          	ld	a,_Freq_Sel
3386  01c0 97            	ld	xl,a
3387  01c1 a603          	ld	a,#3
3388  01c3 42            	mul	x,a
3389  01c4 1c0000        	addw	x,#_sx1278FreqTable
3390  01c7 89            	pushw	x
3391  01c8 a606          	ld	a,#6
3392  01ca cd0000        	call	_BurstWrite
3394  01cd 5b03          	addw	sp,#3
3395                     ; 187 	SPIWrite(LR_RegPaConfig,sx1278PowerTable[Power_Sel]); //Setting output power parameter  
3397  01cf b600          	ld	a,_Power_Sel
3398  01d1 5f            	clrw	x
3399  01d2 97            	ld	xl,a
3400  01d3 d60003        	ld	a,(_sx1278PowerTable,x)
3401  01d6 97            	ld	xl,a
3402  01d7 a609          	ld	a,#9
3403  01d9 95            	ld	xh,a
3404  01da cd0000        	call	_SPIWrite
3406                     ; 188 	SPIWrite(LR_RegOcp,0x0B);                              	//RegOcp,Close Ocp
3408  01dd ae0b0b        	ldw	x,#2827
3409  01e0 cd0000        	call	_SPIWrite
3411                     ; 189 	SPIWrite(LR_RegLna,0x23);                              	//RegLNA,High & LNA Enable
3413  01e3 ae0c23        	ldw	x,#3107
3414  01e6 cd0000        	call	_SPIWrite
3416                     ; 190 	if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)         //SFactor=6
3418  01e9 b600          	ld	a,_Lora_Rate_Sel
3419  01eb 5f            	clrw	x
3420  01ec 97            	ld	xl,a
3421  01ed d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3422  01f0 a106          	cp	a,#6
3423  01f2 264e          	jrne	L1112
3424                     ; 193 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x01));//Implicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3426  01f4 b600          	ld	a,_BandWide_Sel
3427  01f6 5f            	clrw	x
3428  01f7 97            	ld	xl,a
3429  01f8 d6000e        	ld	a,(_sx1278LoRaBwTable,x)
3430  01fb 97            	ld	xl,a
3431  01fc a610          	ld	a,#16
3432  01fe 42            	mul	x,a
3433  01ff 9f            	ld	a,xl
3434  0200 ab03          	add	a,#3
3435  0202 97            	ld	xl,a
3436  0203 a61d          	ld	a,#29
3437  0205 95            	ld	xh,a
3438  0206 cd0000        	call	_SPIWrite
3440                     ; 194 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));
3442  0209 b600          	ld	a,_Lora_Rate_Sel
3443  020b 5f            	clrw	x
3444  020c 97            	ld	xl,a
3445  020d d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3446  0210 97            	ld	xl,a
3447  0211 a610          	ld	a,#16
3448  0213 42            	mul	x,a
3449  0214 9f            	ld	a,xl
3450  0215 ab07          	add	a,#7
3451  0217 97            	ld	xl,a
3452  0218 a61e          	ld	a,#30
3453  021a 95            	ld	xh,a
3454  021b cd0000        	call	_SPIWrite
3456                     ; 195 		tmp = SPIRead(0x31);
3458  021e a631          	ld	a,#49
3459  0220 cd0000        	call	_SPIRead
3461  0223 6b01          	ld	(OFST+0,sp),a
3462                     ; 196 		tmp &= 0xF8;
3464  0225 7b01          	ld	a,(OFST+0,sp)
3465  0227 a4f8          	and	a,#248
3466  0229 6b01          	ld	(OFST+0,sp),a
3467                     ; 197 		tmp |= 0x05;
3469  022b 7b01          	ld	a,(OFST+0,sp)
3470  022d aa05          	or	a,#5
3471  022f 6b01          	ld	(OFST+0,sp),a
3472                     ; 198 		SPIWrite(0x31,tmp);
3474  0231 7b01          	ld	a,(OFST+0,sp)
3475  0233 97            	ld	xl,a
3476  0234 a631          	ld	a,#49
3477  0236 95            	ld	xh,a
3478  0237 cd0000        	call	_SPIWrite
3480                     ; 199 		SPIWrite(0x37,0x0C);
3482  023a ae370c        	ldw	x,#14092
3483  023d cd0000        	call	_SPIWrite
3486  0240 202a          	jra	L3112
3487  0242               L1112:
3488                     ; 203 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x00));//Explicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3490  0242 b600          	ld	a,_BandWide_Sel
3491  0244 5f            	clrw	x
3492  0245 97            	ld	xl,a
3493  0246 d6000e        	ld	a,(_sx1278LoRaBwTable,x)
3494  0249 97            	ld	xl,a
3495  024a a610          	ld	a,#16
3496  024c 42            	mul	x,a
3497  024d 9f            	ld	a,xl
3498  024e ab02          	add	a,#2
3499  0250 97            	ld	xl,a
3500  0251 a61d          	ld	a,#29
3501  0253 95            	ld	xh,a
3502  0254 cd0000        	call	_SPIWrite
3504                     ; 204 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));  //SFactor &  LNA gain set by the internal AGC loop 
3506  0257 b600          	ld	a,_Lora_Rate_Sel
3507  0259 5f            	clrw	x
3508  025a 97            	ld	xl,a
3509  025b d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3510  025e 97            	ld	xl,a
3511  025f a610          	ld	a,#16
3512  0261 42            	mul	x,a
3513  0262 9f            	ld	a,xl
3514  0263 ab07          	add	a,#7
3515  0265 97            	ld	xl,a
3516  0266 a61e          	ld	a,#30
3517  0268 95            	ld	xh,a
3518  0269 cd0000        	call	_SPIWrite
3520  026c               L3112:
3521                     ; 206 	SPIWrite(LR_RegSymbTimeoutLsb,0xFF);                  //RegSymbTimeoutLsb Timeout = 0x3FF(Max)    
3523  026c ae1fff        	ldw	x,#8191
3524  026f cd0000        	call	_SPIWrite
3526                     ; 207 	SPIWrite(LR_RegPreambleMsb,0x00);                     //RegPreambleMsb 
3528  0272 ae2000        	ldw	x,#8192
3529  0275 cd0000        	call	_SPIWrite
3531                     ; 208 	SPIWrite(LR_RegPreambleLsb,12);                      	//RegPreambleLsb 8+4=12byte Preamble    
3533  0278 ae210c        	ldw	x,#8460
3534  027b cd0000        	call	_SPIWrite
3536                     ; 209 	SPIWrite(REG_LR_DIOMAPPING2,0x01);                    //RegDioMapping2 DIO5=00, DIO4=01	
3538  027e ae4101        	ldw	x,#16641
3539  0281 cd0000        	call	_SPIWrite
3541                     ; 210   SPIWrite(LR_RegOpMode,LoRa_Standby_Value);            //Entry standby mode
3543  0284 ae0109        	ldw	x,#265
3544  0287 cd0000        	call	_SPIWrite
3546                     ; 211 }
3549  028a 84            	pop	a
3550  028b 81            	ret
3637                     	xdef	_sx1278_ReadRSSI
3638                     	xdef	_sx1278Data
3639                     	xdef	_sx1278LoRaBwTable
3640                     	xdef	_sx1278SpreadFactorTable
3641                     	xdef	_sx1278PowerTable
3642                     	xdef	_sx1278FreqTable
3643                     	xdef	_sx1278_LoRaTxPacket
3644                     	xdef	_sx1278_LoRaEntryTx
3645                     	xdef	_sx1278_LoRaRxPacket
3646                     	xdef	_sx1278_LoRaReadRSSI
3647                     	xdef	_sx1278_LoRaEntryRx
3648                     	xdef	_sx1278_Config
3649                     	switch	.ubsct
3650  0000               _Message:
3651  0000 000000000000  	ds.b	30
3652                     	xdef	_Message
3653  001e               _RxData:
3654  001e 000000000000  	ds.b	64
3655                     	xdef	_RxData
3656                     	xref	_delay_ms
3657                     	xref.b	_SysTime
3658                     	xref.b	_BandWide_Sel
3659                     	xref.b	_Lora_Rate_Sel
3660                     	xref.b	_Power_Sel
3661                     	xref.b	_Freq_Sel
3662                     	xref	_BurstWrite
3663                     	xref	_SPIBurstRead
3664                     	xref	_SPIWrite
3665                     	xref	_SPIRead
3685                     	end
