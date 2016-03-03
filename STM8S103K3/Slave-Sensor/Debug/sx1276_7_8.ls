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
2622                     ; 39 u8 sx1278_LoRaEntryRx(void)
2622                     ; 40 //=====================================
2622                     ; 41 {
2624                     	switch	.text
2625  0000               _sx1278_LoRaEntryRx:
2627  0000 88            	push	a
2628       00000001      OFST:	set	1
2631                     ; 43   ANT_EN_L();
2633  0001 721d5005      	bres	_PB_ODR,#6
2634                     ; 44 	ANT_CTRL_RX();        
2636  0005 7214500a      	bset	_PC_ODR,#2
2637                     ; 45   sx1278_Config();                            //setting base parameter
2639  0009 cd019f        	call	_sx1278_Config
2641                     ; 46   SPIWrite(REG_LR_PADAC,0x84);                    //Normal and Rx
2643  000c ae4d84        	ldw	x,#19844
2644  000f cd0000        	call	_SPIWrite
2646                     ; 47   SPIWrite(LR_RegHopPeriod,0xFF);                 //RegHopPeriod NO FHSS
2648  0012 ae24ff        	ldw	x,#9471
2649  0015 cd0000        	call	_SPIWrite
2651                     ; 48   SPIWrite(REG_LR_DIOMAPPING1,0x01);              //DIO0=00, DIO1=00, DIO2=00, DIO3=01 Valid header      
2653  0018 ae4001        	ldw	x,#16385
2654  001b cd0000        	call	_SPIWrite
2656                     ; 49   SPIWrite(LR_RegIrqFlagsMask,0x3F);              //Open RxDone interrupt & Timeout
2658  001e ae113f        	ldw	x,#4415
2659  0021 cd0000        	call	_SPIWrite
2661                     ; 50   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);     
2663  0024 ae12ff        	ldw	x,#4863
2664  0027 cd0000        	call	_SPIWrite
2666                     ; 51   SPIWrite(LR_RegPayloadLength,21);               //RegPayloadLength  21byte(this register must difine when the data long of one byte in SF is 6)
2668  002a ae2215        	ldw	x,#8725
2669  002d cd0000        	call	_SPIWrite
2671                     ; 52   addr = SPIRead(LR_RegFifoRxBaseAddr);           //Read RxBaseAddr
2673  0030 a60f          	ld	a,#15
2674  0032 cd0000        	call	_SPIRead
2676  0035 6b01          	ld	(OFST+0,sp),a
2677                     ; 53   SPIWrite(LR_RegFifoAddrPtr,addr);               //RxBaseAddr -> FiFoAddrPtr¡¡ 
2679  0037 7b01          	ld	a,(OFST+0,sp)
2680  0039 97            	ld	xl,a
2681  003a a60d          	ld	a,#13
2682  003c 95            	ld	xh,a
2683  003d cd0000        	call	_SPIWrite
2685                     ; 54   SPIWrite(LR_RegOpMode,0x8d);                    //Continuous Rx Mode//Low Frequency Mode
2687  0040 ae018d        	ldw	x,#397
2688  0043 cd0000        	call	_SPIWrite
2690                     ; 56 	SysTime = 0;
2692  0046 5f            	clrw	x
2693  0047 bf00          	ldw	_SysTime,x
2694  0049               L7561:
2695                     ; 59 		if((SPIRead(LR_RegModemStat)&0x04)==0x04)   	//Rx-on going RegModemStat
2697  0049 a618          	ld	a,#24
2698  004b cd0000        	call	_SPIRead
2700  004e a404          	and	a,#4
2701  0050 a104          	cp	a,#4
2702  0052 2603          	jrne	L3661
2703                     ; 60 			break;
2704                     ; 64 }
2707  0054 5b01          	addw	sp,#1
2708  0056 81            	ret
2709  0057               L3661:
2710                     ; 61 		if(SysTime>=3)	
2712  0057 be00          	ldw	x,_SysTime
2713  0059 a30003        	cpw	x,#3
2714  005c 25eb          	jrult	L7561
2715                     ; 62 			return 0;                                   //over time for error
2717  005e 4f            	clr	a
2720  005f 5b01          	addw	sp,#1
2721  0061 81            	ret
2757                     ; 67 u8 sx1278_LoRaReadRSSI(void)
2757                     ; 68 //=====================================
2757                     ; 69 {
2758                     	switch	.text
2759  0062               _sx1278_LoRaReadRSSI:
2761  0062 89            	pushw	x
2762       00000002      OFST:	set	2
2765                     ; 70   u16 temp=10;
2767                     ; 71   temp=SPIRead(LR_RegRssiValue);                  //Read RegRssiValue£¬Rssi value
2769  0063 a61b          	ld	a,#27
2770  0065 cd0000        	call	_SPIRead
2772  0068 5f            	clrw	x
2773  0069 97            	ld	xl,a
2774  006a 1f01          	ldw	(OFST-1,sp),x
2775                     ; 72   temp=temp+127-137;                              //127:Max RSSI, 137:RSSI offset
2777  006c 1e01          	ldw	x,(OFST-1,sp)
2778  006e 1d000a        	subw	x,#10
2779  0071 1f01          	ldw	(OFST-1,sp),x
2780                     ; 73   return (u8)temp;
2782  0073 7b02          	ld	a,(OFST+0,sp)
2785  0075 85            	popw	x
2786  0076 81            	ret
2847                     ; 77 u8 sx1278_LoRaRxPacket(void)
2847                     ; 78 //=====================================
2847                     ; 79 {
2848                     	switch	.text
2849  0077               _sx1278_LoRaRxPacket:
2851  0077 88            	push	a
2852       00000001      OFST:	set	1
2855                     ; 83   if(Get_NIRQ())
2857  0078 c65010        	ld	a,_PD_IDR
2858  007b a408          	and	a,#8
2859  007d a108          	cp	a,#8
2860  007f 2676          	jrne	L3371
2861                     ; 85     for(i=0;i<32;i++) 
2863  0081 0f01          	clr	(OFST+0,sp)
2864  0083               L5371:
2865                     ; 86       RxData[i] = 0x00;    
2867  0083 7b01          	ld	a,(OFST+0,sp)
2868  0085 5f            	clrw	x
2869  0086 97            	ld	xl,a
2870  0087 6f00          	clr	(_RxData,x)
2871                     ; 85     for(i=0;i<32;i++) 
2873  0089 0c01          	inc	(OFST+0,sp)
2876  008b 7b01          	ld	a,(OFST+0,sp)
2877  008d a120          	cp	a,#32
2878  008f 25f2          	jrult	L5371
2879                     ; 87     addr = SPIRead(LR_RegFifoRxCurrentaddr);      //last packet addr
2881  0091 a610          	ld	a,#16
2882  0093 cd0000        	call	_SPIRead
2884  0096 6b01          	ld	(OFST+0,sp),a
2885                     ; 88     SPIWrite(LR_RegFifoAddrPtr,addr);             //RxBaseAddr -> FiFoAddrPtr    
2887  0098 7b01          	ld	a,(OFST+0,sp)
2888  009a 97            	ld	xl,a
2889  009b a60d          	ld	a,#13
2890  009d 95            	ld	xh,a
2891  009e cd0000        	call	_SPIWrite
2893                     ; 89     if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)	//When SpreadFactor is six£¬will used Implicit Header mode(Excluding internal packet length)
2895  00a1 b600          	ld	a,_Lora_Rate_Sel
2896  00a3 5f            	clrw	x
2897  00a4 97            	ld	xl,a
2898  00a5 d60007        	ld	a,(_sx1278SpreadFactorTable,x)
2899  00a8 a106          	cp	a,#6
2900  00aa 2606          	jrne	L3471
2901                     ; 90       packet_size=21;
2903  00ac a615          	ld	a,#21
2904  00ae 6b01          	ld	(OFST+0,sp),a
2906  00b0 2007          	jra	L5471
2907  00b2               L3471:
2908                     ; 92       packet_size = SPIRead(LR_RegRxNbBytes);     //Number for received bytes    
2910  00b2 a613          	ld	a,#19
2911  00b4 cd0000        	call	_SPIRead
2913  00b7 6b01          	ld	(OFST+0,sp),a
2914  00b9               L5471:
2915                     ; 93     SPIBurstRead(0x00, RxData, packet_size);    
2917  00b9 7b01          	ld	a,(OFST+0,sp)
2918  00bb 88            	push	a
2919  00bc ae0000        	ldw	x,#_RxData
2920  00bf 89            	pushw	x
2921  00c0 4f            	clr	a
2922  00c1 cd0000        	call	_SPIBurstRead
2924  00c4 5b03          	addw	sp,#3
2925                     ; 94     SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
2927  00c6 ae12ff        	ldw	x,#4863
2928  00c9 cd0000        	call	_SPIWrite
2930                     ; 95     for(i=0;i<17;i++)
2932  00cc 0f01          	clr	(OFST+0,sp)
2933  00ce               L7471:
2934                     ; 97       if(RxData[i]!=sx1278Data[i])
2936  00ce 7b01          	ld	a,(OFST+0,sp)
2937  00d0 5f            	clrw	x
2938  00d1 97            	ld	xl,a
2939  00d2 7b01          	ld	a,(OFST+0,sp)
2940  00d4 905f          	clrw	y
2941  00d6 9097          	ld	yl,a
2942  00d8 90e600        	ld	a,(_RxData,y)
2943  00db d10018        	cp	a,(_sx1278Data,x)
2944  00de 2608          	jrne	L3571
2945                     ; 98         break;  
2947                     ; 95     for(i=0;i<17;i++)
2949  00e0 0c01          	inc	(OFST+0,sp)
2952  00e2 7b01          	ld	a,(OFST+0,sp)
2953  00e4 a111          	cp	a,#17
2954  00e6 25e6          	jrult	L7471
2955  00e8               L3571:
2956                     ; 100     if(i>=17)                                     //Rx success
2958  00e8 7b01          	ld	a,(OFST+0,sp)
2959  00ea a111          	cp	a,#17
2960  00ec 2505          	jrult	L7571
2961                     ; 101       return(1);
2963  00ee a601          	ld	a,#1
2966  00f0 5b01          	addw	sp,#1
2967  00f2 81            	ret
2968  00f3               L7571:
2969                     ; 103       return(0);
2971  00f3 4f            	clr	a
2974  00f4 5b01          	addw	sp,#1
2975  00f6 81            	ret
2976  00f7               L3371:
2977                     ; 106     return(0);
2979  00f7 4f            	clr	a
2982  00f8 5b01          	addw	sp,#1
2983  00fa 81            	ret
3032                     ; 110 u8 sx1278_LoRaEntryTx(void)
3032                     ; 111 //=====================================
3032                     ; 112 {
3033                     	switch	.text
3034  00fb               _sx1278_LoRaEntryTx:
3036  00fb 88            	push	a
3037       00000001      OFST:	set	1
3040                     ; 114   sx1278_Config();                            //setting base parameter
3042  00fc cd019f        	call	_sx1278_Config
3044                     ; 115   ANT_EN_H();
3046  00ff 721c5005      	bset	_PB_ODR,#6
3047                     ; 116 	ANT_CTRL_TX();    
3049  0103 7215500a      	bres	_PC_ODR,#2
3050                     ; 117   SPIWrite(REG_LR_PADAC,0x87);                    //Tx for 20dBm
3052  0107 ae4d87        	ldw	x,#19847
3053  010a cd0000        	call	_SPIWrite
3055                     ; 118   SPIWrite(LR_RegHopPeriod,0x00);                 //RegHopPeriod NO FHSS
3057  010d ae2400        	ldw	x,#9216
3058  0110 cd0000        	call	_SPIWrite
3060                     ; 119   SPIWrite(REG_LR_DIOMAPPING1,0x41);              //DIO0=01, DIO1=00, DIO2=00, DIO3=01  
3062  0113 ae4041        	ldw	x,#16449
3063  0116 cd0000        	call	_SPIWrite
3065                     ; 120   SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);
3067  0119 ae12ff        	ldw	x,#4863
3068  011c cd0000        	call	_SPIWrite
3070                     ; 121   SPIWrite(LR_RegIrqFlagsMask,0xF7);              //Open TxDone interrupt
3072  011f ae11f7        	ldw	x,#4599
3073  0122 cd0000        	call	_SPIWrite
3075                     ; 122   SPIWrite(LR_RegPayloadLength,21);               //RegPayloadLength  21byte  
3077  0125 ae2215        	ldw	x,#8725
3078  0128 cd0000        	call	_SPIWrite
3080                     ; 123   addr = SPIRead(LR_RegFifoTxBaseAddr);           //RegFiFoTxBaseAddr
3082  012b a60e          	ld	a,#14
3083  012d cd0000        	call	_SPIRead
3085  0130 6b01          	ld	(OFST+0,sp),a
3086                     ; 124   SPIWrite(LR_RegFifoAddrPtr,addr);               //RegFifoAddrPtr
3088  0132 7b01          	ld	a,(OFST+0,sp)
3089  0134 97            	ld	xl,a
3090  0135 a60d          	ld	a,#13
3091  0137 95            	ld	xh,a
3092  0138 cd0000        	call	_SPIWrite
3094                     ; 125 	SysTime = 0;
3096  013b 5f            	clrw	x
3097  013c bf00          	ldw	_SysTime,x
3098  013e               L7002:
3099                     ; 128 		temp=SPIRead(LR_RegPayloadLength);
3101  013e a622          	ld	a,#34
3102  0140 cd0000        	call	_SPIRead
3104  0143 6b01          	ld	(OFST+0,sp),a
3105                     ; 129 		if(temp==21)
3107  0145 7b01          	ld	a,(OFST+0,sp)
3108  0147 a115          	cp	a,#21
3109  0149 2603          	jrne	L3102
3110                     ; 131 			break; 
3111                     ; 136 }
3114  014b 5b01          	addw	sp,#1
3115  014d 81            	ret
3116  014e               L3102:
3117                     ; 133 		if(SysTime>=3)	
3119  014e be00          	ldw	x,_SysTime
3120  0150 a30003        	cpw	x,#3
3121  0153 25e9          	jrult	L7002
3122                     ; 134 			return 0;
3124  0155 4f            	clr	a
3127  0156 5b01          	addw	sp,#1
3128  0158 81            	ret
3168                     ; 139 u8 sx1278_LoRaTxPacket(void)
3168                     ; 140 //=====================================
3168                     ; 141 { 
3169                     	switch	.text
3170  0159               _sx1278_LoRaTxPacket:
3172  0159 88            	push	a
3173       00000001      OFST:	set	1
3176                     ; 142   u8 TxFlag=0;
3178  015a 0f01          	clr	(OFST+0,sp)
3179                     ; 145 	BurstWrite(0x00, (u8 *)sx1278Data, 21);
3181  015c 4b15          	push	#21
3182  015e ae0018        	ldw	x,#_sx1278Data
3183  0161 89            	pushw	x
3184  0162 4f            	clr	a
3185  0163 cd0000        	call	_BurstWrite
3187  0166 5b03          	addw	sp,#3
3188                     ; 146 	SPIWrite(LR_RegOpMode,0x8b);                    	//Tx Mode           
3190  0168 ae018b        	ldw	x,#395
3191  016b cd0000        	call	_SPIWrite
3193  016e               L5302:
3194                     ; 149 		if(Get_NIRQ())                      						//Packet send over
3196  016e c65010        	ld	a,_PD_IDR
3197  0171 a408          	and	a,#8
3198  0173 a108          	cp	a,#8
3199  0175 26f7          	jrne	L5302
3200                     ; 151 			SPIRead(LR_RegIrqFlags);
3202  0177 a612          	ld	a,#18
3203  0179 cd0000        	call	_SPIRead
3205                     ; 152 			SPIWrite(LR_RegIrqFlags,LoRa_ClearIRQ_Value);	//Clear irq				
3207  017c ae12ff        	ldw	x,#4863
3208  017f cd0000        	call	_SPIWrite
3210                     ; 153 			SPIWrite(LR_RegOpMode,LoRa_Standby_Value);    //Entry Standby mode   
3212  0182 ae0109        	ldw	x,#265
3213  0185 cd0000        	call	_SPIWrite
3215                     ; 154 			break;
3216                     ; 157 }
3219  0188 84            	pop	a
3220  0189 81            	ret
3255                     ; 160 u8 sx1278_ReadRSSI(void)
3255                     ; 161 //=====================================
3255                     ; 162 {
3256                     	switch	.text
3257  018a               _sx1278_ReadRSSI:
3259  018a 88            	push	a
3260       00000001      OFST:	set	1
3263                     ; 163   u8 temp=0xff;	
3265                     ; 164   temp=SPIRead(0x11);
3267  018b a611          	ld	a,#17
3268  018d cd0000        	call	_SPIRead
3270  0190 6b01          	ld	(OFST+0,sp),a
3271                     ; 165   temp>>=1;
3273  0192 0401          	srl	(OFST+0,sp)
3274                     ; 166   temp=127-temp;		                     					//127:Max RSSI
3276  0194 a67f          	ld	a,#127
3277  0196 1001          	sub	a,(OFST+0,sp)
3278  0198 6b01          	ld	(OFST+0,sp),a
3279                     ; 167   return temp;
3281  019a 7b01          	ld	a,(OFST+0,sp)
3284  019c 5b01          	addw	sp,#1
3285  019e 81            	ret
3341                     ; 171 void sx1278_Config(void)
3341                     ; 172 //=====================================
3341                     ; 173 {
3342                     	switch	.text
3343  019f               _sx1278_Config:
3345  019f 88            	push	a
3346       00000001      OFST:	set	1
3349                     ; 175   SPIWrite(LR_RegOpMode,LoRa_Sleep_Value);   			//Change modem mode Must in Sleep mode 
3351  01a0 ae0108        	ldw	x,#264
3352  01a3 cd0000        	call	_SPIWrite
3354                     ; 176   for(i=250;i!=0;i--)                             //Delay
3356  01a6 a6fa          	ld	a,#250
3357  01a8 6b01          	ld	(OFST+0,sp),a
3358  01aa               L3012:
3359                     ; 177     NOP();
3362  01aa 9d            nop
3364                     ; 176   for(i=250;i!=0;i--)                             //Delay
3366  01ab 0a01          	dec	(OFST+0,sp)
3369  01ad 0d01          	tnz	(OFST+0,sp)
3370  01af 26f9          	jrne	L3012
3371                     ; 178 	delay_ms(15);
3374  01b1 ae000f        	ldw	x,#15
3375  01b4 cd0000        	call	_delay_ms
3377                     ; 181 	SPIWrite(LR_RegOpMode,LoRa_Entry_Value);     
3379  01b7 ae0188        	ldw	x,#392
3380  01ba cd0000        	call	_SPIWrite
3382                     ; 182 	BurstWrite(LR_RegFrMsb,sx1278FreqTable[Freq_Sel],3);  //setting frequency parameter
3384  01bd 4b03          	push	#3
3385  01bf b600          	ld	a,_Freq_Sel
3386  01c1 97            	ld	xl,a
3387  01c2 a603          	ld	a,#3
3388  01c4 42            	mul	x,a
3389  01c5 1c0000        	addw	x,#_sx1278FreqTable
3390  01c8 89            	pushw	x
3391  01c9 a606          	ld	a,#6
3392  01cb cd0000        	call	_BurstWrite
3394  01ce 5b03          	addw	sp,#3
3395                     ; 185 	SPIWrite(LR_RegPaConfig,sx1278PowerTable[Power_Sel]); //Setting output power parameter  
3397  01d0 b600          	ld	a,_Power_Sel
3398  01d2 5f            	clrw	x
3399  01d3 97            	ld	xl,a
3400  01d4 d60003        	ld	a,(_sx1278PowerTable,x)
3401  01d7 97            	ld	xl,a
3402  01d8 a609          	ld	a,#9
3403  01da 95            	ld	xh,a
3404  01db cd0000        	call	_SPIWrite
3406                     ; 186 	SPIWrite(LR_RegOcp,0x0B);                              	//RegOcp,Close Ocp
3408  01de ae0b0b        	ldw	x,#2827
3409  01e1 cd0000        	call	_SPIWrite
3411                     ; 187 	SPIWrite(LR_RegLna,0x23);                              	//RegLNA,High & LNA Enable
3413  01e4 ae0c23        	ldw	x,#3107
3414  01e7 cd0000        	call	_SPIWrite
3416                     ; 188 	if(sx1278SpreadFactorTable[Lora_Rate_Sel]==6)         //SFactor=6
3418  01ea b600          	ld	a,_Lora_Rate_Sel
3419  01ec 5f            	clrw	x
3420  01ed 97            	ld	xl,a
3421  01ee d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3422  01f1 a106          	cp	a,#6
3423  01f3 264e          	jrne	L1112
3424                     ; 191 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x01));//Implicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3426  01f5 b600          	ld	a,_BandWide_Sel
3427  01f7 5f            	clrw	x
3428  01f8 97            	ld	xl,a
3429  01f9 d6000e        	ld	a,(_sx1278LoRaBwTable,x)
3430  01fc 97            	ld	xl,a
3431  01fd a610          	ld	a,#16
3432  01ff 42            	mul	x,a
3433  0200 9f            	ld	a,xl
3434  0201 ab03          	add	a,#3
3435  0203 97            	ld	xl,a
3436  0204 a61d          	ld	a,#29
3437  0206 95            	ld	xh,a
3438  0207 cd0000        	call	_SPIWrite
3440                     ; 192 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));
3442  020a b600          	ld	a,_Lora_Rate_Sel
3443  020c 5f            	clrw	x
3444  020d 97            	ld	xl,a
3445  020e d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3446  0211 97            	ld	xl,a
3447  0212 a610          	ld	a,#16
3448  0214 42            	mul	x,a
3449  0215 9f            	ld	a,xl
3450  0216 ab07          	add	a,#7
3451  0218 97            	ld	xl,a
3452  0219 a61e          	ld	a,#30
3453  021b 95            	ld	xh,a
3454  021c cd0000        	call	_SPIWrite
3456                     ; 193 		tmp = SPIRead(0x31);
3458  021f a631          	ld	a,#49
3459  0221 cd0000        	call	_SPIRead
3461  0224 6b01          	ld	(OFST+0,sp),a
3462                     ; 194 		tmp &= 0xF8;
3464  0226 7b01          	ld	a,(OFST+0,sp)
3465  0228 a4f8          	and	a,#248
3466  022a 6b01          	ld	(OFST+0,sp),a
3467                     ; 195 		tmp |= 0x05;
3469  022c 7b01          	ld	a,(OFST+0,sp)
3470  022e aa05          	or	a,#5
3471  0230 6b01          	ld	(OFST+0,sp),a
3472                     ; 196 		SPIWrite(0x31,tmp);
3474  0232 7b01          	ld	a,(OFST+0,sp)
3475  0234 97            	ld	xl,a
3476  0235 a631          	ld	a,#49
3477  0237 95            	ld	xh,a
3478  0238 cd0000        	call	_SPIWrite
3480                     ; 197 		SPIWrite(0x37,0x0C);
3482  023b ae370c        	ldw	x,#14092
3483  023e cd0000        	call	_SPIWrite
3486  0241 202a          	jra	L3112
3487  0243               L1112:
3488                     ; 201 		SPIWrite(LR_RegModemConfig1,((sx1278LoRaBwTable[BandWide_Sel]<<4)+(CR<<1)+0x00));//Explicit Enable CRC Enable(0x02) & Error Coding rate 4/5(0x01), 4/6(0x02), 4/7(0x03), 4/8(0x04)
3490  0243 b600          	ld	a,_BandWide_Sel
3491  0245 5f            	clrw	x
3492  0246 97            	ld	xl,a
3493  0247 d6000e        	ld	a,(_sx1278LoRaBwTable,x)
3494  024a 97            	ld	xl,a
3495  024b a610          	ld	a,#16
3496  024d 42            	mul	x,a
3497  024e 9f            	ld	a,xl
3498  024f ab02          	add	a,#2
3499  0251 97            	ld	xl,a
3500  0252 a61d          	ld	a,#29
3501  0254 95            	ld	xh,a
3502  0255 cd0000        	call	_SPIWrite
3504                     ; 202 		SPIWrite(LR_RegModemConfig2,((sx1278SpreadFactorTable[Lora_Rate_Sel]<<4)+(CRC<<2)+0x03));  //SFactor &  LNA gain set by the internal AGC loop 
3506  0258 b600          	ld	a,_Lora_Rate_Sel
3507  025a 5f            	clrw	x
3508  025b 97            	ld	xl,a
3509  025c d60007        	ld	a,(_sx1278SpreadFactorTable,x)
3510  025f 97            	ld	xl,a
3511  0260 a610          	ld	a,#16
3512  0262 42            	mul	x,a
3513  0263 9f            	ld	a,xl
3514  0264 ab07          	add	a,#7
3515  0266 97            	ld	xl,a
3516  0267 a61e          	ld	a,#30
3517  0269 95            	ld	xh,a
3518  026a cd0000        	call	_SPIWrite
3520  026d               L3112:
3521                     ; 204 	SPIWrite(LR_RegSymbTimeoutLsb,0xFF);                  //RegSymbTimeoutLsb Timeout = 0x3FF(Max)    
3523  026d ae1fff        	ldw	x,#8191
3524  0270 cd0000        	call	_SPIWrite
3526                     ; 205 	SPIWrite(LR_RegPreambleMsb,0x00);                     //RegPreambleMsb 
3528  0273 ae2000        	ldw	x,#8192
3529  0276 cd0000        	call	_SPIWrite
3531                     ; 206 	SPIWrite(LR_RegPreambleLsb,12);                      	//RegPreambleLsb 8+4=12byte Preamble    
3533  0279 ae210c        	ldw	x,#8460
3534  027c cd0000        	call	_SPIWrite
3536                     ; 207 	SPIWrite(REG_LR_DIOMAPPING2,0x01);                    //RegDioMapping2 DIO5=00, DIO4=01	
3538  027f ae4101        	ldw	x,#16641
3539  0282 cd0000        	call	_SPIWrite
3541                     ; 208   SPIWrite(LR_RegOpMode,LoRa_Standby_Value);            //Entry standby mode
3543  0285 ae0109        	ldw	x,#265
3544  0288 cd0000        	call	_SPIWrite
3546                     ; 209 }
3549  028b 84            	pop	a
3550  028c 81            	ret
3627                     	xdef	_sx1278_ReadRSSI
3628                     	xdef	_sx1278Data
3629                     	xdef	_sx1278LoRaBwTable
3630                     	xdef	_sx1278SpreadFactorTable
3631                     	xdef	_sx1278PowerTable
3632                     	xdef	_sx1278FreqTable
3633                     	xdef	_sx1278_LoRaTxPacket
3634                     	xdef	_sx1278_LoRaEntryTx
3635                     	xdef	_sx1278_LoRaRxPacket
3636                     	xdef	_sx1278_LoRaReadRSSI
3637                     	xdef	_sx1278_LoRaEntryRx
3638                     	xdef	_sx1278_Config
3639                     	switch	.ubsct
3640  0000               _RxData:
3641  0000 000000000000  	ds.b	64
3642                     	xdef	_RxData
3643                     	xref	_delay_ms
3644                     	xref.b	_SysTime
3645                     	xref.b	_BandWide_Sel
3646                     	xref.b	_Lora_Rate_Sel
3647                     	xref.b	_Power_Sel
3648                     	xref.b	_Freq_Sel
3649                     	xref	_BurstWrite
3650                     	xref	_SPIBurstRead
3651                     	xref	_SPIWrite
3652                     	xref	_SPIRead
3672                     	end
