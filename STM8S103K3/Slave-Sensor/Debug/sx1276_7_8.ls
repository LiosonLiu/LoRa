   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2545                     .const:	section	.text
2546  0000               _sx1278FreqTable:
2547  0000 85            	dc.b	133
2548  0001 3b            	dc.b	59
2549  0002 13            	dc.b	19
2550  0003               _sx1278PowerTable:
2551  0003 f0            	dc.b	240
2552  0004 f1            	dc.b	241
2553  0005 f2            	dc.b	242
2554  0006 f3            	dc.b	243
2555  0007 f4            	dc.b	244
2556  0008 f5            	dc.b	245
2557  0009 f6            	dc.b	246
2558  000a f7            	dc.b	247
2559  000b f8            	dc.b	248
2560  000c f9            	dc.b	249
2561  000d fa            	dc.b	250
2562  000e fb            	dc.b	251
2563  000f fc            	dc.b	252
2564  0010 fd            	dc.b	253
2565  0011 fe            	dc.b	254
2566  0012 ff            	dc.b	255
2567  0013               _sx1278SpreadFactorTable:
2568  0013 06            	dc.b	6
2569  0014 07            	dc.b	7
2570  0015 08            	dc.b	8
2571  0016 09            	dc.b	9
2572  0017 0a            	dc.b	10
2573  0018 0b            	dc.b	11
2574  0019 0c            	dc.b	12
2575  001a               _sx1278LoRaBwTable:
2576  001a 00            	dc.b	0
2577  001b 01            	dc.b	1
2578  001c 02            	dc.b	2
2579  001d 03            	dc.b	3
2580  001e 04            	dc.b	4
2581  001f 05            	dc.b	5
2582  0020 06            	dc.b	6
2583  0021 07            	dc.b	7
2584  0022 08            	dc.b	8
2585  0023 09            	dc.b	9
2586  0024               _sx1278Data:
2587  0024 2a2a45786f73  	dc.b	"**Exosite LoRa Dem"
2588  0036 6f2a2a00      	dc.b	"o**",0
2634                     ; 42 u8 sx1278_LoRaEntryRx(void)
2634                     ; 43 //=====================================
2634                     ; 44 {
2636                     	switch	.text
2637  0000               _sx1278_LoRaEntryRx:
2639  0000 88            	push	a
2640       00000001      OFST:	set	1
2643                     ; 46   ANT_EN_L();
2645  0001 721d5005      	bres	_PB_ODR,#6
2646                     ; 47 	ANT_CTRL_RX();        
2648  0005 7214500a      	bset	_PC_ODR,#2
2649                     ; 48   sx1278_Config();                            //setting base parameter
2651  0009 cd01a6        	call	_sx1278_Config
2653                     ; 49   SPIWrite(REG_LR_PADAC,0x84);                    //Normal and Rx
2655  000c ae4d84        	ldw	x,#19844
2656  000f cd0000        	call	_SPIWrite
2658                     ; 50   SPIWrite(LR_RegHopPeriod,0xFF);                 //RegHopPeriod NO FHSS
2660  0012 ae24ff        	ldw	x,#9471
2661  0015 cd0000        	call	_SPIWrite
2663                     ; 51   SPIWrite(REG_LR_DIOMAPPING1,0x01);              //DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
2665  0018 ae4001        	ldw	x,#16385
2666  001b cd0000        	call	_SPIWrite
2668                     ; 52   SPIWrite(LR_RegIrqFlagsMask,0x3F);              //Open RxDone interrupt & Timeout
2670  001e ae113f        	ldw	x,#4415
2671  0021 cd0000        	call	_SPIWrite
2673                     ; 53   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);     
2675  0024 ae12ff        	ldw	x,#4863
2676  0027 cd0000        	call	_SPIWrite
2678                     ; 54   SPIWrite(LR_RegPayloadLength,PayloadLengthValue);               //RegPayloadLength  30byte(this register must difine when the data long of one byte in SF is 6)
2680  002a ae221e        	ldw	x,#8734
2681  002d cd0000        	call	_SPIWrite
2683                     ; 55   addr = SPIRead(LR_RegFifoRxBaseAddr);           //Read RxBaseAddr
2685  0030 a60f          	ld	a,#15
2686  0032 cd0000        	call	_SPIRead
2688  0035 6b01          	ld	(OFST+0,sp),a
2689                     ; 56   SPIWrite(LR_RegFifoAddrPtr,addr);               //RxBaseAddr -> FiFoAddrPtr¡¡ 
2691  0037 7b01          	ld	a,(OFST+0,sp)
2692  0039 97            	ld	xl,a
2693  003a a60d          	ld	a,#13
2694  003c 95            	ld	xh,a
2695  003d cd0000        	call	_SPIWrite
2697                     ; 57   SPIWrite(LR_RegOpMode,0x8d);                    //Continuous Rx Mode//Low Frequency Mode
2699  0040 ae018d        	ldw	x,#397
2700  0043 cd0000        	call	_SPIWrite
2702                     ; 59 	SysTime = 0;
2704  0046 5f            	clrw	x
2705  0047 bf00          	ldw	_SysTime,x
2706  0049               L7561:
2707                     ; 62 		if((SPIRead(LR_RegModemStat)&0x04)==0x04)   	//Rx-on going RegModemStat
2709  0049 a618          	ld	a,#24
2710  004b cd0000        	call	_SPIRead
2712  004e a404          	and	a,#4
2713  0050 a104          	cp	a,#4
2714  0052 2603          	jrne	L3661
2715                     ; 63 			break;
2716                     ; 67 }
2719  0054 5b01          	addw	sp,#1
2720  0056 81            	ret
2721  0057               L3661:
2722                     ; 64 		if(SysTime>=3)	
2724  0057 be00          	ldw	x,_SysTime
2725  0059 a30003        	cpw	x,#3
2726  005c 25eb          	jrult	L7561
2727                     ; 65 			return 0;                                   //over time for error
2729  005e 4f            	clr	a
2732  005f 5b01          	addw	sp,#1
2733  0061 81            	ret
2769                     ; 70 u8 sx1278_LoRaReadRSSI(void)
2769                     ; 71 //=====================================
2769                     ; 72 {
2770                     	switch	.text
2771  0062               _sx1278_LoRaReadRSSI:
2773  0062 89            	pushw	x
2774       00000002      OFST:	set	2
2777                     ; 73   u16 temp=10;
2779                     ; 74   temp=SPIRead(LR_RegRssiValue);                  //Read RegRssiValue£¬Rssi value
2781  0063 a61b          	ld	a,#27
2782  0065 cd0000        	call	_SPIRead
2784  0068 5f            	clrw	x
2785  0069 97            	ld	xl,a
2786  006a 1f01          	ldw	(OFST-1,sp),x
2787                     ; 75   temp=temp+127-137;                              //127:Max RSSI, 137:RSSI offset
2789  006c 1e01          	ldw	x,(OFST-1,sp)
2790  006e 1d000a        	subw	x,#10
2791  0071 1f01          	ldw	(OFST-1,sp),x
2792                     ; 76   return (u8)temp;
2794  0073 7b02          	ld	a,(OFST+0,sp)
2797  0075 85            	popw	x
2798  0076 81            	ret
2859                     ; 80 u8 sx1278_LoRaRxPacket(void)
2859                     ; 81 //=====================================
2859                     ; 82 {
2860                     	switch	.text
2861  0077               _sx1278_LoRaRxPacket:
2863  0077 88            	push	a
2864       00000001      OFST:	set	1
2867                     ; 86   if(Get_NIRQ())
2869  0078 c65010        	ld	a,_PD_IDR
2870  007b a408          	and	a,#8
2871  007d a108          	cp	a,#8
2872  007f 2675          	jrne	L3371
2873                     ; 88     for(i=0;i<32;i++) 
2875  0081 0f01          	clr	(OFST+0,sp)
2876  0083               L5371:
2877                     ; 89       RxData[i] = 0x00;    
2879  0083 7b01          	ld	a,(OFST+0,sp)
2880  0085 5f            	clrw	x
2881  0086 97            	ld	xl,a
2882  0087 6f1e          	clr	(_RxData,x)
2883                     ; 88     for(i=0;i<32;i++) 
2885  0089 0c01          	inc	(OFST+0,sp)
2888  008b 7b01          	ld	a,(OFST+0,sp)
2889  008d a120          	cp	a,#32
2890  008f 25f2          	jrult	L5371
2891                     ; 90     addr = SPIRead(LR_RegFifoRxCurrentaddr);      //last packet addr
2893  0091 a610          	ld	a,#16
2894  0093 cd0000        	call	_SPIRead
2896  0096 6b01          	ld	(OFST+0,sp),a
2897                     ; 91     SPIWrite(LR_RegFifoAddrPtr,addr);             //RxBaseAddr -> FiFoAddrPtr    
2899  0098 7b01          	ld	a,(OFST+0,sp)
2900  009a 97            	ld	xl,a
2901  009b a60d          	ld	a,#13
2902  009d 95            	ld	xh,a
2903  009e cd0000        	call	_SPIWrite
2905                     ; 92     if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)	//When SpreadFactor is six£¬will used Implicit Header mode(Excluding internal packet length)
2907  00a1 b600          	ld	a,_Lora_Rate_Sel
2908  00a3 5f            	clrw	x
2909  00a4 97            	ld	xl,a
2910  00a5 d60013        	ld	a,(_sx1278SpreadFactorTable,x)
2911  00a8 a106          	cp	a,#6
2912  00aa 2606          	jrne	L3471
2913                     ; 93       packet_size=PayloadLengthValue;
2915  00ac a61e          	ld	a,#30
2916  00ae 6b01          	ld	(OFST+0,sp),a
2918  00b0 2007          	jra	L5471
2919  00b2               L3471:
2920                     ; 95       packet_size = SPIRead(LR_RegRxNbBytes);     //Number for received bytes    
2922  00b2 a613          	ld	a,#19
2923  00b4 cd0000        	call	_SPIRead
2925  00b7 6b01          	ld	(OFST+0,sp),a
2926  00b9               L5471:
2927                     ; 96     SPIBurstRead(0x00, RxData, packet_size);    
2929  00b9 7b01          	ld	a,(OFST+0,sp)
2930  00bb 88            	push	a
2931  00bc ae001e        	ldw	x,#_RxData
2932  00bf 89            	pushw	x
2933  00c0 4f            	clr	a
2934  00c1 cd0000        	call	_SPIBurstRead
2936  00c4 5b03          	addw	sp,#3
2937                     ; 97     SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);	//Word "EXOSITE" received?
2939  00c6 ae12ff        	ldw	x,#4863
2940  00c9 cd0000        	call	_SPIWrite
2942                     ; 98     for(i=0;i<(HeadLengthValue-1);i++)
2944  00cc 0f01          	clr	(OFST+0,sp)
2945  00ce               L7471:
2946                     ; 100       if(RxData[i]!=Message[i])
2948  00ce 7b01          	ld	a,(OFST+0,sp)
2949  00d0 5f            	clrw	x
2950  00d1 97            	ld	xl,a
2951  00d2 7b01          	ld	a,(OFST+0,sp)
2952  00d4 905f          	clrw	y
2953  00d6 9097          	ld	yl,a
2954  00d8 90e61e        	ld	a,(_RxData,y)
2955  00db e100          	cp	a,(_Message,x)
2956  00dd 2608          	jrne	L3571
2957                     ; 101         break;  
2959                     ; 98     for(i=0;i<(HeadLengthValue-1);i++)
2961  00df 0c01          	inc	(OFST+0,sp)
2964  00e1 7b01          	ld	a,(OFST+0,sp)
2965  00e3 a106          	cp	a,#6
2966  00e5 25e7          	jrult	L7471
2967  00e7               L3571:
2968                     ; 103     if(i>=(HeadLengthValue-1))                    //Rx success
2970  00e7 7b01          	ld	a,(OFST+0,sp)
2971  00e9 a106          	cp	a,#6
2972  00eb 2505          	jrult	L7571
2973                     ; 104       return(1);
2975  00ed a601          	ld	a,#1
2978  00ef 5b01          	addw	sp,#1
2979  00f1 81            	ret
2980  00f2               L7571:
2981                     ; 106       return(0);
2983  00f2 4f            	clr	a
2986  00f3 5b01          	addw	sp,#1
2987  00f5 81            	ret
2988  00f6               L3371:
2989                     ; 109     return(0);
2991  00f6 4f            	clr	a
2994  00f7 5b01          	addw	sp,#1
2995  00f9 81            	ret
3044                     ; 113 u8 sx1278_LoRaEntryTx(void)
3044                     ; 114 //=====================================
3044                     ; 115 {
3045                     	switch	.text
3046  00fa               _sx1278_LoRaEntryTx:
3048  00fa 88            	push	a
3049       00000001      OFST:	set	1
3052                     ; 117   sx1278_Config();                            //setting base parameter
3054  00fb cd01a6        	call	_sx1278_Config
3056                     ; 118   ANT_EN_H();
3058  00fe 721c5005      	bset	_PB_ODR,#6
3059                     ; 119 	ANT_CTRL_TX();    
3061  0102 7215500a      	bres	_PC_ODR,#2
3062                     ; 120   SPIWrite(REG_LR_PADAC,0x87);                    //Tx for 20dBm
3064  0106 ae4d87        	ldw	x,#19847
3065  0109 cd0000        	call	_SPIWrite
3067                     ; 121   SPIWrite(LR_RegHopPeriod,0x00);                 //RegHopPeriod NO FHSS
3069  010c ae2400        	ldw	x,#9216
3070  010f cd0000        	call	_SPIWrite
3072                     ; 122   SPIWrite(REG_LR_DIOMAPPING1,0x41);              //DIO0=01, DIO1=00, DIO2=00, DIO3=01  
3074  0112 ae4041        	ldw	x,#16449
3075  0115 cd0000        	call	_SPIWrite
3077                     ; 123   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
3079  0118 ae12ff        	ldw	x,#4863
3080  011b cd0000        	call	_SPIWrite
3082                     ; 124   SPIWrite(LR_RegIrqFlagsMask,0xF7);              //Open TxDone interrupt
3084  011e ae11f7        	ldw	x,#4599
3085  0121 cd0000        	call	_SPIWrite
3087                     ; 125   SPIWrite(LR_RegPayloadLength,PayloadLengthValue);               //RegPayloadLength  30byte  
3089  0124 ae221e        	ldw	x,#8734
3090  0127 cd0000        	call	_SPIWrite
3092                     ; 126   addr = SPIRead(LR_RegFifoTxBaseAddr);           //RegFiFoTxBaseAddr
3094  012a a60e          	ld	a,#14
3095  012c cd0000        	call	_SPIRead
3097  012f 6b01          	ld	(OFST+0,sp),a
3098                     ; 127   SPIWrite(LR_RegFifoAddrPtr,addr);               //RegFifoAddrPtr
3100  0131 7b01          	ld	a,(OFST+0,sp)
3101  0133 97            	ld	xl,a
3102  0134 a60d          	ld	a,#13
3103  0136 95            	ld	xh,a
3104  0137 cd0000        	call	_SPIWrite
3106                     ; 128 	SysTime = 0;
3108  013a 5f            	clrw	x
3109  013b bf00          	ldw	_SysTime,x
3110  013d               L7002:
3111                     ; 131 		temp=SPIRead(LR_RegPayloadLength);
3113  013d a622          	ld	a,#34
3114  013f cd0000        	call	_SPIRead
3116  0142 6b01          	ld	(OFST+0,sp),a
3117                     ; 132 		if(temp==PayloadLengthValue)
3119  0144 7b01          	ld	a,(OFST+0,sp)
3120  0146 a11e          	cp	a,#30
3121  0148 2603          	jrne	L3102
3122                     ; 134 			break; 
3123                     ; 139 }
3126  014a 5b01          	addw	sp,#1
3127  014c 81            	ret
3128  014d               L3102:
3129                     ; 136 		if(SysTime>=3)	
3131  014d be00          	ldw	x,_SysTime
3132  014f a30003        	cpw	x,#3
3133  0152 25e9          	jrult	L7002
3134                     ; 137 			return 0;
3136  0154 4f            	clr	a
3139  0155 5b01          	addw	sp,#1
3140  0157 81            	ret
3181                     ; 142 u8 sx1278_LoRaTxPacket(void)
3181                     ; 143 //=====================================
3181                     ; 144 { 
3182                     	switch	.text
3183  0158               _sx1278_LoRaTxPacket:
3185  0158 88            	push	a
3186       00000001      OFST:	set	1
3189                     ; 145   u8 TxFlag=0;
3191  0159 0f01          	clr	(OFST+0,sp)
3192                     ; 149 	BurstWrite(0x00, Message, PayloadLengthValue);
3194  015b 4b1e          	push	#30
3195  015d ae0000        	ldw	x,#_Message
3196  0160 89            	pushw	x
3197  0161 4f            	clr	a
3198  0162 cd0000        	call	_BurstWrite
3200  0165 5b03          	addw	sp,#3
3201                     ; 150 	SPIWrite(LR_RegOpMode,0x8b);                    	//Tx Mode           
3203  0167 ae018b        	ldw	x,#395
3204  016a cd0000        	call	_SPIWrite
3206                     ; 151 RED_LED_L();
3208  016d 72115005      	bres	_PB_ODR,#0
3209  0171               L5302:
3210                     ; 154 		if(Get_NIRQ())                      						//Packet send over
3212  0171 c65010        	ld	a,_PD_IDR
3213  0174 a408          	and	a,#8
3214  0176 a108          	cp	a,#8
3215  0178 26f7          	jrne	L5302
3216                     ; 156 			SPIRead(LR_RegIrqFlags);
3218  017a a612          	ld	a,#18
3219  017c cd0000        	call	_SPIRead
3221                     ; 157 			SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);	//Clear irq				
3223  017f ae12ff        	ldw	x,#4863
3224  0182 cd0000        	call	_SPIWrite
3226                     ; 158 			SPIWrite(LR_RegOpMode,LoRa_Standby_Value);    //Entry Standby mode   
3228  0185 ae0109        	ldw	x,#265
3229  0188 cd0000        	call	_SPIWrite
3231                     ; 159 			break;
3232                     ; 162 	RED_LED_H();
3234  018b 72105005      	bset	_PB_ODR,#0
3235                     ; 163 }
3238  018f 84            	pop	a
3239  0190 81            	ret
3274                     ; 166 u8 sx1278_ReadRSSI(void)
3274                     ; 167 //=====================================
3274                     ; 168 {
3275                     	switch	.text
3276  0191               _sx1278_ReadRSSI:
3278  0191 88            	push	a
3279       00000001      OFST:	set	1
3282                     ; 169   u8 temp=0xff;	
3284                     ; 170   temp=SPIRead(0x11);
3286  0192 a611          	ld	a,#17
3287  0194 cd0000        	call	_SPIRead
3289  0197 6b01          	ld	(OFST+0,sp),a
3290                     ; 171   temp>>=1;
3292  0199 0401          	srl	(OFST+0,sp)
3293                     ; 172   temp=127-temp;		                     					//127:Max RSSI
3295  019b a67f          	ld	a,#127
3296  019d 1001          	sub	a,(OFST+0,sp)
3297  019f 6b01          	ld	(OFST+0,sp),a
3298                     ; 173   return temp;
3300  01a1 7b01          	ld	a,(OFST+0,sp)
3303  01a3 5b01          	addw	sp,#1
3304  01a5 81            	ret
3362                     ; 177 void sx1278_Config(void)
3362                     ; 178 //=====================================
3362                     ; 179 {
3363                     	switch	.text
3364  01a6               _sx1278_Config:
3366  01a6 88            	push	a
3367       00000001      OFST:	set	1
3370                     ; 181   SPIWrite(LR_RegOpMode,LoRa_Sleep_Value);   			//Change modem mode Must in Sleep mode 
3372  01a7 ae0108        	ldw	x,#264
3373  01aa cd0000        	call	_SPIWrite
3375                     ; 182   for(i=250;i!=0;i--)                             //Delay
3377  01ad a6fa          	ld	a,#250
3378  01af 6b01          	ld	(OFST+0,sp),a
3379  01b1               L3012:
3380                     ; 183     NOP();
3383  01b1 9d            nop
3385                     ; 182   for(i=250;i!=0;i--)                             //Delay
3387  01b2 0a01          	dec	(OFST+0,sp)
3390  01b4 0d01          	tnz	(OFST+0,sp)
3391  01b6 26f9          	jrne	L3012
3392                     ; 184 	delay_ms(15);
3395  01b8 ae000f        	ldw	x,#15
3396  01bb cd0000        	call	_delay_ms
3398                     ; 187 	SPIWrite(LR_RegOpMode,LoRa_Entry_Value);     
3400  01be ae0188        	ldw	x,#392
3401  01c1 cd0000        	call	_SPIWrite
3403                     ; 188 	BurstWrite(LR_RegFrMsb,sx1278FreqTable[Freq_Sel],3);  //setting frequency parameter
3405  01c4 4b03          	push	#3
3406  01c6 b600          	ld	a,_Freq_Sel
3407  01c8 97            	ld	xl,a
3408  01c9 a603          	ld	a,#3
3409  01cb 42            	mul	x,a
3410  01cc 1c0000        	addw	x,#_sx1278FreqTable
3411  01cf 89            	pushw	x
3412  01d0 a606          	ld	a,#6
3413  01d2 cd0000        	call	_BurstWrite
3415  01d5 5b03          	addw	sp,#3
3416                     ; 191 	SPIWrite(LR_RegPaConfig,sx1278PowerTable[Power_Sel]); //Setting output power parameter  
3418  01d7 b600          	ld	a,_Power_Sel
3419  01d9 5f            	clrw	x
3420  01da 97            	ld	xl,a
3421  01db d60003        	ld	a,(_sx1278PowerTable,x)
3422  01de 97            	ld	xl,a
3423  01df a609          	ld	a,#9
3424  01e1 95            	ld	xh,a
3425  01e2 cd0000        	call	_SPIWrite
3427                     ; 192 	SPIWrite(LR_RegOcp,(PA_Over_Current_Sel|0b00100000));            //Protect PA 100mA
3429  01e5 b600          	ld	a,_PA_Over_Current_Sel
3430  01e7 aa20          	or	a,#32
3431  01e9 97            	ld	xl,a
3432  01ea a60b          	ld	a,#11
3433  01ec 95            	ld	xh,a
3434  01ed cd0000        	call	_SPIWrite
3436                     ; 193 	SPIWrite(LR_RegLna,(Gain_Sel<<5));                       //Gain G1
3438  01f0 b600          	ld	a,_Gain_Sel
3439  01f2 97            	ld	xl,a
3440  01f3 a620          	ld	a,#32
3441  01f5 42            	mul	x,a
3442  01f6 9f            	ld	a,xl
3443  01f7 97            	ld	xl,a
3444  01f8 a60c          	ld	a,#12
3445  01fa 95            	ld	xh,a
3446  01fb cd0000        	call	_SPIWrite
3448                     ; 194 	if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)         //SFactor=6
3450  01fe b600          	ld	a,_Lora_Rate_Sel
3451  0200 5f            	clrw	x
3452  0201 97            	ld	xl,a
3453  0202 d60013        	ld	a,(_sx1278SpreadFactorTable,x)
3454  0205 a106          	cp	a,#6
3455  0207 264e          	jrne	L1112
3456                     ; 197 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x01));//Implicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3458  0209 b600          	ld	a,_BandWide_Sel
3459  020b 5f            	clrw	x
3460  020c 97            	ld	xl,a
3461  020d d6001a        	ld	a,(_sx1278LoRaBwTable,x)
3462  0210 97            	ld	xl,a
3463  0211 a610          	ld	a,#16
3464  0213 42            	mul	x,a
3465  0214 9f            	ld	a,xl
3466  0215 ab03          	add	a,#3
3467  0217 97            	ld	xl,a
3468  0218 a61d          	ld	a,#29
3469  021a 95            	ld	xh,a
3470  021b cd0000        	call	_SPIWrite
3472                     ; 198 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));
3474  021e b600          	ld	a,_Lora_Rate_Sel
3475  0220 5f            	clrw	x
3476  0221 97            	ld	xl,a
3477  0222 d60013        	ld	a,(_sx1278SpreadFactorTable,x)
3478  0225 97            	ld	xl,a
3479  0226 a610          	ld	a,#16
3480  0228 42            	mul	x,a
3481  0229 9f            	ld	a,xl
3482  022a ab07          	add	a,#7
3483  022c 97            	ld	xl,a
3484  022d a61e          	ld	a,#30
3485  022f 95            	ld	xh,a
3486  0230 cd0000        	call	_SPIWrite
3488                     ; 199 		tmp = SPIRead(0x31);
3490  0233 a631          	ld	a,#49
3491  0235 cd0000        	call	_SPIRead
3493  0238 6b01          	ld	(OFST+0,sp),a
3494                     ; 200 		tmp &= 0xF8;
3496  023a 7b01          	ld	a,(OFST+0,sp)
3497  023c a4f8          	and	a,#248
3498  023e 6b01          	ld	(OFST+0,sp),a
3499                     ; 201 		tmp |= 0x05;
3501  0240 7b01          	ld	a,(OFST+0,sp)
3502  0242 aa05          	or	a,#5
3503  0244 6b01          	ld	(OFST+0,sp),a
3504                     ; 202 		SPIWrite(0x31,tmp);
3506  0246 7b01          	ld	a,(OFST+0,sp)
3507  0248 97            	ld	xl,a
3508  0249 a631          	ld	a,#49
3509  024b 95            	ld	xh,a
3510  024c cd0000        	call	_SPIWrite
3512                     ; 203 		SPIWrite(0x37,0x0C);
3514  024f ae370c        	ldw	x,#14092
3515  0252 cd0000        	call	_SPIWrite
3518  0255 202a          	jra	L3112
3519  0257               L1112:
3520                     ; 207 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x00));//Explicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3522  0257 b600          	ld	a,_BandWide_Sel
3523  0259 5f            	clrw	x
3524  025a 97            	ld	xl,a
3525  025b d6001a        	ld	a,(_sx1278LoRaBwTable,x)
3526  025e 97            	ld	xl,a
3527  025f a610          	ld	a,#16
3528  0261 42            	mul	x,a
3529  0262 9f            	ld	a,xl
3530  0263 ab02          	add	a,#2
3531  0265 97            	ld	xl,a
3532  0266 a61d          	ld	a,#29
3533  0268 95            	ld	xh,a
3534  0269 cd0000        	call	_SPIWrite
3536                     ; 208 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));  //SFactor &  LNA gain set by the internal AGC loop 
3538  026c b600          	ld	a,_Lora_Rate_Sel
3539  026e 5f            	clrw	x
3540  026f 97            	ld	xl,a
3541  0270 d60013        	ld	a,(_sx1278SpreadFactorTable,x)
3542  0273 97            	ld	xl,a
3543  0274 a610          	ld	a,#16
3544  0276 42            	mul	x,a
3545  0277 9f            	ld	a,xl
3546  0278 ab07          	add	a,#7
3547  027a 97            	ld	xl,a
3548  027b a61e          	ld	a,#30
3549  027d 95            	ld	xh,a
3550  027e cd0000        	call	_SPIWrite
3552  0281               L3112:
3553                     ; 210 	SPIWrite(LR_RegSymbTimeoutLsb,0xFF);                  //RegSymbTimeoutLsb Timeout = 0x3FF(Max)    
3555  0281 ae1fff        	ldw	x,#8191
3556  0284 cd0000        	call	_SPIWrite
3558                     ; 211 	SPIWrite(LR_RegPreambleMsb,0x00);                     //RegPreambleMsb 
3560  0287 ae2000        	ldw	x,#8192
3561  028a cd0000        	call	_SPIWrite
3563                     ; 212 	SPIWrite(LR_RegPreambleLsb,12);                      	//RegPreambleLsb 8+4=12byte Preamble    
3565  028d ae210c        	ldw	x,#8460
3566  0290 cd0000        	call	_SPIWrite
3568                     ; 213 	SPIWrite(REG_LR_DIOMAPPING2,0x01);                    //RegDioMapping2 DIO5=00, DIO4=01	
3570  0293 ae4101        	ldw	x,#16641
3571  0296 cd0000        	call	_SPIWrite
3573                     ; 214   SPIWrite(LR_RegOpMode,LoRa_Standby_Value);            //Entry standby mode
3575  0299 ae0109        	ldw	x,#265
3576  029c cd0000        	call	_SPIWrite
3578                     ; 215 }
3581  029f 84            	pop	a
3582  02a0 81            	ret
3669                     	xdef	_sx1278_ReadRSSI
3670                     	xdef	_sx1278Data
3671                     	xdef	_sx1278LoRaBwTable
3672                     	xdef	_sx1278SpreadFactorTable
3673                     	xdef	_sx1278PowerTable
3674                     	xdef	_sx1278FreqTable
3675                     	xdef	_sx1278_LoRaTxPacket
3676                     	xdef	_sx1278_LoRaEntryTx
3677                     	xdef	_sx1278_LoRaRxPacket
3678                     	xdef	_sx1278_LoRaReadRSSI
3679                     	xdef	_sx1278_LoRaEntryRx
3680                     	xdef	_sx1278_Config
3681                     	switch	.ubsct
3682  0000               _Message:
3683  0000 000000000000  	ds.b	30
3684                     	xdef	_Message
3685  001e               _RxData:
3686  001e 000000000000  	ds.b	64
3687                     	xdef	_RxData
3688                     	xref	_delay_ms
3689                     	xref.b	_SysTime
3690                     	xref.b	_BandWide_Sel
3691                     	xref.b	_Lora_Rate_Sel
3692                     	xref.b	_Gain_Sel
3693                     	xref.b	_PA_Over_Current_Sel
3694                     	xref.b	_Power_Sel
3695                     	xref.b	_Freq_Sel
3696                     	xref	_BurstWrite
3697                     	xref	_SPIBurstRead
3698                     	xref	_SPIWrite
3699                     	xref	_SPIRead
3719                     	end
