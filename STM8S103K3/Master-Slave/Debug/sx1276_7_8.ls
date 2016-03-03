   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
   4                     ; Optimizer V4.3.6 - 29 Nov 2011
2548                     .const:	section	.text
2549  0000               _sx1278FreqTable:
2550  0000 85            	dc.b	133
2551  0001 3b            	dc.b	59
2552  0002 13            	dc.b	19
2553  0003               _sx1278PowerTable:
2554  0003 ff            	dc.b	255
2555  0004 fc            	dc.b	252
2556  0005 f9            	dc.b	249
2557  0006 f6            	dc.b	246
2558  0007               _sx1278SpreadFactorTable:
2559  0007 06            	dc.b	6
2560  0008 07            	dc.b	7
2561  0009 08            	dc.b	8
2562  000a 09            	dc.b	9
2563  000b 0a            	dc.b	10
2564  000c 0b            	dc.b	11
2565  000d 0c            	dc.b	12
2566  000e               _sx1278LoRaBwTable:
2567  000e 00            	dc.b	0
2568  000f 01            	dc.b	1
2569  0010 02            	dc.b	2
2570  0011 03            	dc.b	3
2571  0012 04            	dc.b	4
2572  0013 05            	dc.b	5
2573  0014 06            	dc.b	6
2574  0015 07            	dc.b	7
2575  0016 08            	dc.b	8
2576  0017 09            	dc.b	9
2577  0018               _sx1278Data:
2578  0018 2a2a45786f73  	dc.b	"**Exosite LoRa Dem"
2579  002a 6f2a2a00      	dc.b	"o**",0
2625                     ; 39 u8 sx1278_LoRaEntryRx(void)
2625                     ; 40 //=====================================
2625                     ; 41 {
2627                     	switch	.text
2628  0000               _sx1278_LoRaEntryRx:
2630       00000001      OFST:	set	1
2633                     ; 43   ANT_EN_L();
2635  0000 721d5005      	bres	_PB_ODR,#6
2636  0004 88            	push	a
2637                     ; 44 	ANT_CTRL_RX();        
2639  0005 7214500a      	bset	_PC_ODR,#2
2640                     ; 45   sx1278_Config();                            //setting base parameter
2642  0009 cd017a        	call	_sx1278_Config
2644                     ; 46   SPIWrite(REG_LR_PADAC,0x84);                    //Normal and Rx
2646  000c ae4d84        	ldw	x,#19844
2647  000f cd0000        	call	_SPIWrite
2649                     ; 47   SPIWrite(LR_RegHopPeriod,0xFF);                 //RegHopPeriod NO FHSS
2651  0012 ae24ff        	ldw	x,#9471
2652  0015 cd0000        	call	_SPIWrite
2654                     ; 48   SPIWrite(REG_LR_DIOMAPPING1,0x01);              //DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
2656  0018 ae4001        	ldw	x,#16385
2657  001b cd0000        	call	_SPIWrite
2659                     ; 49   SPIWrite(LR_RegIrqFlagsMask,0x3F);              //Open RxDone interrupt & Timeout
2661  001e ae113f        	ldw	x,#4415
2662  0021 cd0000        	call	_SPIWrite
2664                     ; 50   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);     
2666  0024 ae12ff        	ldw	x,#4863
2667  0027 cd0000        	call	_SPIWrite
2669                     ; 51   SPIWrite(LR_RegPayloadLength,21);               //RegPayloadLength  21byte(this register must difine when the data long of one byte in SF is 6)
2671  002a ae2215        	ldw	x,#8725
2672  002d cd0000        	call	_SPIWrite
2674                     ; 52   addr = SPIRead(LR_RegFifoRxBaseAddr);           //Read RxBaseAddr
2676  0030 a60f          	ld	a,#15
2677  0032 cd0000        	call	_SPIRead
2679  0035 6b01          	ld	(OFST+0,sp),a
2680                     ; 53   SPIWrite(LR_RegFifoAddrPtr,addr);               //RxBaseAddr -> FiFoAddrPtr¡¡ 
2682  0037 97            	ld	xl,a
2683  0038 a60d          	ld	a,#13
2684  003a 95            	ld	xh,a
2685  003b cd0000        	call	_SPIWrite
2687                     ; 54   SPIWrite(LR_RegOpMode,0x8d);                    //Continuous Rx Mode//Low Frequency Mode
2689  003e ae018d        	ldw	x,#397
2690  0041 cd0000        	call	_SPIWrite
2692                     ; 56 	SysTime = 0;
2694  0044 5f            	clrw	x
2695  0045 bf00          	ldw	_SysTime,x
2696  0047               L7561:
2697                     ; 59 		if((SPIRead(LR_RegModemStat)&0x04)==0x04)   	//Rx-on going RegModemStat
2699  0047 a618          	ld	a,#24
2700  0049 cd0000        	call	_SPIRead
2702  004c a404          	and	a,#4
2703  004e 2703          	jreq	L3661
2704                     ; 60 			break;
2705                     ; 64 }
2708  0050 5b01          	addw	sp,#1
2709  0052 81            	ret	
2710  0053               L3661:
2711                     ; 61 		if(SysTime>=3)	
2713  0053 be00          	ldw	x,_SysTime
2714  0055 a30003        	cpw	x,#3
2715  0058 25ed          	jrult	L7561
2716                     ; 62 			return 0;                                   //over time for error
2720  005a 5b01          	addw	sp,#1
2721  005c 81            	ret	
2757                     ; 67 u8 sx1278_LoRaReadRSSI(void)
2757                     ; 68 //=====================================
2757                     ; 69 {
2758                     	switch	.text
2759  005d               _sx1278_LoRaReadRSSI:
2761  005d 89            	pushw	x
2762       00000002      OFST:	set	2
2765                     ; 70   u16 temp=10;
2767                     ; 71   temp=SPIRead(LR_RegRssiValue);                  //Read RegRssiValue£¬Rssi value
2769  005e a61b          	ld	a,#27
2770  0060 cd0000        	call	_SPIRead
2772  0063 5f            	clrw	x
2773  0064 97            	ld	xl,a
2774                     ; 72   temp=temp+127-137;                              //127:Max RSSI, 137:RSSI offset
2776  0065 1d000a        	subw	x,#10
2777  0068 1f01          	ldw	(OFST-1,sp),x
2778                     ; 73   return (u8)temp;
2780  006a 7b02          	ld	a,(OFST+0,sp)
2783  006c 85            	popw	x
2784  006d 81            	ret	
2845                     ; 77 u8 sx1278_LoRaRxPacket(void)
2845                     ; 78 //=====================================
2845                     ; 79 {
2846                     	switch	.text
2847  006e               _sx1278_LoRaRxPacket:
2849  006e 88            	push	a
2850       00000001      OFST:	set	1
2853                     ; 83   if(Get_NIRQ())
2855  006f 4f            	clr	a
2856  0070 720750106b    	btjf	_PD_IDR,#3,L3371
2857                     ; 85     for(i=0;i<32;i++) 
2859  0075 6b01          	ld	(OFST+0,sp),a
2860  0077               L5371:
2861                     ; 86       RxData[i] = 0x00;    
2863  0077 5f            	clrw	x
2864  0078 97            	ld	xl,a
2865  0079 6f00          	clr	(_RxData,x)
2866                     ; 85     for(i=0;i<32;i++) 
2868  007b 0c01          	inc	(OFST+0,sp)
2871  007d 7b01          	ld	a,(OFST+0,sp)
2872  007f a120          	cp	a,#32
2873  0081 25f4          	jrult	L5371
2874                     ; 87     addr = SPIRead(LR_RegFifoRxCurrentaddr);      //last packet addr
2876  0083 a610          	ld	a,#16
2877  0085 cd0000        	call	_SPIRead
2879  0088 6b01          	ld	(OFST+0,sp),a
2880                     ; 88     SPIWrite(LR_RegFifoAddrPtr,addr);             //RxBaseAddr -> FiFoAddrPtr    
2882  008a 97            	ld	xl,a
2883  008b a60d          	ld	a,#13
2884  008d 95            	ld	xh,a
2885  008e cd0000        	call	_SPIWrite
2887                     ; 89     if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)	//When SpreadFactor is six£¬will used Implicit Header mode(Excluding internal packet length)
2889  0091 b600          	ld	a,_Lora_Rate_Sel
2890  0093 5f            	clrw	x
2891  0094 97            	ld	xl,a
2892  0095 d60007        	ld	a,(_sx1278SpreadFactorTable,x)
2893  0098 a106          	cp	a,#6
2894  009a 2604          	jrne	L3471
2895                     ; 90       packet_size=21;
2897  009c a615          	ld	a,#21
2899  009e 2005          	jra	L5471
2900  00a0               L3471:
2901                     ; 92       packet_size = SPIRead(LR_RegRxNbBytes);     //Number for received bytes    
2903  00a0 a613          	ld	a,#19
2904  00a2 cd0000        	call	_SPIRead
2906  00a5               L5471:
2907  00a5 6b01          	ld	(OFST+0,sp),a
2908                     ; 93     SPIBurstRead(0x00, RxData, packet_size);    
2910  00a7 88            	push	a
2911  00a8 ae0000        	ldw	x,#_RxData
2912  00ab 89            	pushw	x
2913  00ac 4f            	clr	a
2914  00ad cd0000        	call	_SPIBurstRead
2916  00b0 5b03          	addw	sp,#3
2917                     ; 94     SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
2919  00b2 ae12ff        	ldw	x,#4863
2920  00b5 cd0000        	call	_SPIWrite
2922                     ; 95     for(i=0;i<17;i++)
2924  00b8 4f            	clr	a
2925  00b9 6b01          	ld	(OFST+0,sp),a
2926  00bb               L7471:
2927                     ; 97       if(RxData[i]!=sx1278Data[i])
2929  00bb 5f            	clrw	x
2930  00bc 97            	ld	xl,a
2931  00bd 905f          	clrw	y
2932  00bf 9097          	ld	yl,a
2933  00c1 90e600        	ld	a,(_RxData,y)
2934  00c4 d10018        	cp	a,(_sx1278Data,x)
2935  00c7 2608          	jrne	L3571
2936                     ; 98         break;  
2938                     ; 95     for(i=0;i<17;i++)
2940  00c9 0c01          	inc	(OFST+0,sp)
2943  00cb 7b01          	ld	a,(OFST+0,sp)
2944  00cd a111          	cp	a,#17
2945  00cf 25ea          	jrult	L7471
2946  00d1               L3571:
2947                     ; 100     if(i>=17)                                     //Rx success
2949  00d1 7b01          	ld	a,(OFST+0,sp)
2950  00d3 a111          	cp	a,#17
2951  00d5 2505          	jrult	L7571
2952                     ; 101       return(1);
2954  00d7 a601          	ld	a,#1
2957  00d9 5b01          	addw	sp,#1
2958  00db 81            	ret	
2959  00dc               L7571:
2960                     ; 103       return(0);
2962  00dc 4f            	clr	a
2965  00dd 5b01          	addw	sp,#1
2966  00df 81            	ret	
2967  00e0               L3371:
2968                     ; 106     return(0);
2972  00e0 5b01          	addw	sp,#1
2973  00e2 81            	ret	
3022                     ; 110 u8 sx1278_LoRaEntryTx(void)
3022                     ; 111 //=====================================
3022                     ; 112 {
3023                     	switch	.text
3024  00e3               _sx1278_LoRaEntryTx:
3026  00e3 88            	push	a
3027       00000001      OFST:	set	1
3030                     ; 114   sx1278_Config();                            //setting base parameter
3032  00e4 cd017a        	call	_sx1278_Config
3034                     ; 115   ANT_EN_H();
3036  00e7 721c5005      	bset	_PB_ODR,#6
3037                     ; 116 	ANT_CTRL_TX();    
3039                     ; 117   SPIWrite(REG_LR_PADAC,0x87);                    //Tx for 20dBm
3041  00eb ae4d87        	ldw	x,#19847
3042  00ee 7215500a      	bres	_PC_ODR,#2
3043  00f2 cd0000        	call	_SPIWrite
3045                     ; 118   SPIWrite(LR_RegHopPeriod,0x00);                 //RegHopPeriod NO FHSS
3047  00f5 ae2400        	ldw	x,#9216
3048  00f8 cd0000        	call	_SPIWrite
3050                     ; 119   SPIWrite(REG_LR_DIOMAPPING1,0x41);              //DIO0=01, DIO1=00, DIO2=00, DIO3=01  
3052  00fb ae4041        	ldw	x,#16449
3053  00fe cd0000        	call	_SPIWrite
3055                     ; 120   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
3057  0101 ae12ff        	ldw	x,#4863
3058  0104 cd0000        	call	_SPIWrite
3060                     ; 121   SPIWrite(LR_RegIrqFlagsMask,0xF7);              //Open TxDone interrupt
3062  0107 ae11f7        	ldw	x,#4599
3063  010a cd0000        	call	_SPIWrite
3065                     ; 122   SPIWrite(LR_RegPayloadLength,21);               //RegPayloadLength  21byte  
3067  010d ae2215        	ldw	x,#8725
3068  0110 cd0000        	call	_SPIWrite
3070                     ; 123   addr = SPIRead(LR_RegFifoTxBaseAddr);           //RegFiFoTxBaseAddr
3072  0113 a60e          	ld	a,#14
3073  0115 cd0000        	call	_SPIRead
3075  0118 6b01          	ld	(OFST+0,sp),a
3076                     ; 124   SPIWrite(LR_RegFifoAddrPtr,addr);               //RegFifoAddrPtr
3078  011a 97            	ld	xl,a
3079  011b a60d          	ld	a,#13
3080  011d 95            	ld	xh,a
3081  011e cd0000        	call	_SPIWrite
3083                     ; 125 	SysTime = 0;
3085  0121 5f            	clrw	x
3086  0122 bf00          	ldw	_SysTime,x
3087  0124               L7002:
3088                     ; 128 		temp=SPIRead(LR_RegPayloadLength);
3090  0124 a622          	ld	a,#34
3091  0126 cd0000        	call	_SPIRead
3093  0129 6b01          	ld	(OFST+0,sp),a
3094                     ; 129 		if(temp==21)
3096  012b a115          	cp	a,#21
3097  012d 2603          	jrne	L3102
3098                     ; 131 			break; 
3099                     ; 136 }
3102  012f 5b01          	addw	sp,#1
3103  0131 81            	ret	
3104  0132               L3102:
3105                     ; 133 		if(SysTime>=3)	
3107  0132 be00          	ldw	x,_SysTime
3108  0134 a30003        	cpw	x,#3
3109  0137 25eb          	jrult	L7002
3110                     ; 134 			return 0;
3112  0139 4f            	clr	a
3115  013a 5b01          	addw	sp,#1
3116  013c 81            	ret	
3156                     ; 139 u8 sx1278_LoRaTxPacket(void)
3156                     ; 140 //=====================================
3156                     ; 141 { 
3157                     	switch	.text
3158  013d               _sx1278_LoRaTxPacket:
3160  013d 88            	push	a
3161       00000001      OFST:	set	1
3164                     ; 142   u8 TxFlag=0;
3166  013e 0f01          	clr	(OFST+0,sp)
3167                     ; 145 	BurstWrite(0x00, (u8 *)sx1278Data, 21);
3169  0140 4b15          	push	#21
3170  0142 ae0018        	ldw	x,#_sx1278Data
3171  0145 89            	pushw	x
3172  0146 4f            	clr	a
3173  0147 cd0000        	call	_BurstWrite
3175  014a 5b03          	addw	sp,#3
3176                     ; 146 	SPIWrite(LR_RegOpMode,0x8b);                    	//Tx Mode           
3178  014c ae018b        	ldw	x,#395
3179  014f cd0000        	call	_SPIWrite
3181  0152               L5302:
3182                     ; 149 		if(Get_NIRQ())                      						//Packet send over
3184  0152 72075010fb    	btjf	_PD_IDR,#3,L5302
3185                     ; 151 			SPIRead(LR_RegIrqFlags);
3187  0157 a612          	ld	a,#18
3188  0159 cd0000        	call	_SPIRead
3190                     ; 152 			SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);	//Clear irq				
3192  015c ae12ff        	ldw	x,#4863
3193  015f cd0000        	call	_SPIWrite
3195                     ; 153 			SPIWrite(LR_RegOpMode,LoRa_Standby_Value);    //Entry Standby mode   
3197  0162 ae0109        	ldw	x,#265
3198  0165 cd0000        	call	_SPIWrite
3200                     ; 154 			break;
3201                     ; 157 }
3204  0168 84            	pop	a
3205  0169 81            	ret	
3240                     ; 160 u8 sx1278_ReadRSSI(void)
3240                     ; 161 //=====================================
3240                     ; 162 {
3241                     	switch	.text
3242  016a               _sx1278_ReadRSSI:
3244  016a 88            	push	a
3245       00000001      OFST:	set	1
3248                     ; 163   u8 temp=0xff;	
3250                     ; 164   temp=SPIRead(0x11);
3252  016b a611          	ld	a,#17
3253  016d cd0000        	call	_SPIRead
3255  0170 44            	srl	a
3256  0171 6b01          	ld	(OFST+0,sp),a
3257                     ; 165   temp>>=1;
3259                     ; 166   temp=127-temp;		                     					//127:Max RSSI
3261  0173 a67f          	ld	a,#127
3262  0175 1001          	sub	a,(OFST+0,sp)
3263                     ; 167   return temp;
3267  0177 5b01          	addw	sp,#1
3268  0179 81            	ret	
3324                     ; 171 void sx1278_Config(void)
3324                     ; 172 //=====================================
3324                     ; 173 {
3325                     	switch	.text
3326  017a               _sx1278_Config:
3328  017a 88            	push	a
3329       00000001      OFST:	set	1
3332                     ; 175   SPIWrite(LR_RegOpMode,LoRa_Sleep_Value);   			//Change modem mode Must in Sleep mode 
3334  017b ae0108        	ldw	x,#264
3335  017e cd0000        	call	_SPIWrite
3337                     ; 176   for(i=250;i!=0;i--)                             //Delay
3339  0181 a6fa          	ld	a,#250
3340  0183 6b01          	ld	(OFST+0,sp),a
3341  0185               L3012:
3342                     ; 177     NOP();
3345  0185 9d            	nop	
3347                     ; 176   for(i=250;i!=0;i--)                             //Delay
3349  0186 0a01          	dec	(OFST+0,sp)
3352  0188 26fb          	jrne	L3012
3353                     ; 178 	delay_ms(15);
3356  018a ae000f        	ldw	x,#15
3357  018d cd0000        	call	_delay_ms
3359                     ; 181 	SPIWrite(LR_RegOpMode,LoRa_Entry_Value);     
3361  0190 ae0188        	ldw	x,#392
3362  0193 cd0000        	call	_SPIWrite
3364                     ; 182 	BurstWrite(LR_RegFrMsb,sx1278FreqTable[Freq_Sel],3);  //setting frequency parameter
3366  0196 4b03          	push	#3
3367  0198 b600          	ld	a,_Freq_Sel
3368  019a 97            	ld	xl,a
3369  019b a603          	ld	a,#3
3370  019d 42            	mul	x,a
3371  019e 1c0000        	addw	x,#_sx1278FreqTable
3372  01a1 89            	pushw	x
3373  01a2 48            	sll	a
3374  01a3 cd0000        	call	_BurstWrite
3376  01a6 5b03          	addw	sp,#3
3377                     ; 185 	SPIWrite(LR_RegPaConfig,sx1278PowerTable[Power_Sel]); //Setting output power parameter  
3379  01a8 b600          	ld	a,_Power_Sel
3380  01aa 5f            	clrw	x
3381  01ab 97            	ld	xl,a
3382  01ac d60003        	ld	a,(_sx1278PowerTable,x)
3383  01af 97            	ld	xl,a
3384  01b0 a609          	ld	a,#9
3385  01b2 95            	ld	xh,a
3386  01b3 cd0000        	call	_SPIWrite
3388                     ; 186 	SPIWrite(LR_RegOcp,0x0B);                              	//RegOcp,Close Ocp
3390  01b6 ae0b0b        	ldw	x,#2827
3391  01b9 cd0000        	call	_SPIWrite
3393                     ; 187 	SPIWrite(LR_RegLna,0x23);                              	//RegLNA,High & LNA Enable
3395  01bc ae0c23        	ldw	x,#3107
3396  01bf cd0000        	call	_SPIWrite
3398                     ; 188 	if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)         //SFactor=6
3400  01c2 b600          	ld	a,_Lora_Rate_Sel
3401  01c4 5f            	clrw	x
3402  01c5 97            	ld	xl,a
3403  01c6 d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3404  01c9 a106          	cp	a,#6
3405  01cb 2641          	jrne	L1112
3406                     ; 191 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x01));//Implicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3408  01cd b600          	ld	a,_BandWide_Sel
3409  01cf 5f            	clrw	x
3410  01d0 97            	ld	xl,a
3411  01d1 d6000e        	ld	a,(_sx1278LoRaBwTable,x)
3412  01d4 97            	ld	xl,a
3413  01d5 a610          	ld	a,#16
3414  01d7 42            	mul	x,a
3415  01d8 9f            	ld	a,xl
3416  01d9 ab03          	add	a,#3
3417  01db 97            	ld	xl,a
3418  01dc a61d          	ld	a,#29
3419  01de 95            	ld	xh,a
3420  01df cd0000        	call	_SPIWrite
3422                     ; 192 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));
3424  01e2 b600          	ld	a,_Lora_Rate_Sel
3425  01e4 5f            	clrw	x
3426  01e5 97            	ld	xl,a
3427  01e6 d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3428  01e9 97            	ld	xl,a
3429  01ea a610          	ld	a,#16
3430  01ec 42            	mul	x,a
3431  01ed 9f            	ld	a,xl
3432  01ee ab07          	add	a,#7
3433  01f0 97            	ld	xl,a
3434  01f1 a61e          	ld	a,#30
3435  01f3 95            	ld	xh,a
3436  01f4 cd0000        	call	_SPIWrite
3438                     ; 193 		tmp = SPIRead(0x31);
3440  01f7 a631          	ld	a,#49
3441  01f9 cd0000        	call	_SPIRead
3443                     ; 194 		tmp &= 0xF8;
3445  01fc a4f8          	and	a,#248
3446                     ; 195 		tmp |= 0x05;
3448  01fe aa05          	or	a,#5
3449  0200 6b01          	ld	(OFST+0,sp),a
3450                     ; 196 		SPIWrite(0x31,tmp);
3452  0202 97            	ld	xl,a
3453  0203 a631          	ld	a,#49
3454  0205 95            	ld	xh,a
3455  0206 cd0000        	call	_SPIWrite
3457                     ; 197 		SPIWrite(0x37,0x0C);
3459  0209 ae370c        	ldw	x,#14092
3462  020c 2027          	jra	L3112
3463  020e               L1112:
3464                     ; 201 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x00));//Explicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3466  020e b600          	ld	a,_BandWide_Sel
3467  0210 5f            	clrw	x
3468  0211 97            	ld	xl,a
3469  0212 d6000e        	ld	a,(_sx1278LoRaBwTable,x)
3470  0215 97            	ld	xl,a
3471  0216 a610          	ld	a,#16
3472  0218 42            	mul	x,a
3473  0219 9f            	ld	a,xl
3474  021a ab02          	add	a,#2
3475  021c 97            	ld	xl,a
3476  021d a61d          	ld	a,#29
3477  021f 95            	ld	xh,a
3478  0220 cd0000        	call	_SPIWrite
3480                     ; 202 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));  //SFactor &  LNA gain set by the internal AGC loop 
3482  0223 b600          	ld	a,_Lora_Rate_Sel
3483  0225 5f            	clrw	x
3484  0226 97            	ld	xl,a
3485  0227 d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3486  022a 97            	ld	xl,a
3487  022b a610          	ld	a,#16
3488  022d 42            	mul	x,a
3489  022e 9f            	ld	a,xl
3490  022f ab07          	add	a,#7
3491  0231 97            	ld	xl,a
3492  0232 a61e          	ld	a,#30
3493  0234 95            	ld	xh,a
3495  0235               L3112:
3496  0235 cd0000        	call	_SPIWrite
3497                     ; 204 	SPIWrite(LR_RegSymbTimeoutLsb,0xFF);                  //RegSymbTimeoutLsb Timeout = 0x3FF(Max)    
3499  0238 ae1fff        	ldw	x,#8191
3500  023b cd0000        	call	_SPIWrite
3502                     ; 205 	SPIWrite(LR_RegPreambleMsb,0x00);                     //RegPreambleMsb 
3504  023e ae2000        	ldw	x,#8192
3505  0241 cd0000        	call	_SPIWrite
3507                     ; 206 	SPIWrite(LR_RegPreambleLsb,12);                      	//RegPreambleLsb 8+4=12byte Preamble    
3509  0244 ae210c        	ldw	x,#8460
3510  0247 cd0000        	call	_SPIWrite
3512                     ; 207 	SPIWrite(REG_LR_DIOMAPPING2,0x01);                    //RegDioMapping2 DIO5=00, DIO4=01	
3514  024a ae4101        	ldw	x,#16641
3515  024d cd0000        	call	_SPIWrite
3517                     ; 208   SPIWrite(LR_RegOpMode,LoRa_Standby_Value);            //Entry standby mode
3519  0250 ae0109        	ldw	x,#265
3520  0253 cd0000        	call	_SPIWrite
3522                     ; 209 }
3525  0256 84            	pop	a
3526  0257 81            	ret	
3603                     	xdef	_sx1278_ReadRSSI
3604                     	xdef	_sx1278Data
3605                     	xdef	_sx1278LoRaBwTable
3606                     	xdef	_sx1278SpreadFactorTable
3607                     	xdef	_sx1278PowerTable
3608                     	xdef	_sx1278FreqTable
3609                     	xdef	_sx1278_LoRaTxPacket
3610                     	xdef	_sx1278_LoRaEntryTx
3611                     	xdef	_sx1278_LoRaRxPacket
3612                     	xdef	_sx1278_LoRaReadRSSI
3613                     	xdef	_sx1278_LoRaEntryRx
3614                     	xdef	_sx1278_Config
3615                     	switch	.ubsct
3616  0000               _RxData:
3617  0000 000000000000  	ds.b	64
3618                     	xdef	_RxData
3619                     	xref	_delay_ms
3620                     	xref.b	_SysTime
3621                     	xref.b	_BandWide_Sel
3622                     	xref.b	_Lora_Rate_Sel
3623                     	xref.b	_Power_Sel
3624                     	xref.b	_Freq_Sel
3625                     	xref	_BurstWrite
3626                     	xref	_SPIBurstRead
3627                     	xref	_SPIWrite
3628                     	xref	_SPIRead
3648                     	end
