   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2593                     ; 22 void SPICmd8bit(u8 WrPara)
2593                     ; 23 {
2595                     	switch	.text
2596  0000               _SPICmd8bit:
2598  0000 88            	push	a
2599  0001 88            	push	a
2600       00000001      OFST:	set	1
2603                     ; 25   for(bitcnt=8; bitcnt!=0; bitcnt--)
2605  0002 a608          	ld	a,#8
2606  0004 6b01          	ld	(OFST+0,sp),a
2607  0006               L3661:
2608                     ; 27     SCK_L();
2610  0006 7219500a      	bres	_PC_ODR,#4
2611                     ; 28     if(WrPara&0x80)
2613  000a 7b02          	ld	a,(OFST+1,sp)
2614  000c a580          	bcp	a,#128
2615  000e 2706          	jreq	L1761
2616                     ; 29       MOSI_H();
2618  0010 721c500a      	bset	_PC_ODR,#6
2620  0014 2004          	jra	L3761
2621  0016               L1761:
2622                     ; 31       MOSI_L();
2624  0016 721d500a      	bres	_PC_ODR,#6
2625  001a               L3761:
2626                     ; 32     SCK_H();
2628  001a 7218500a      	bset	_PC_ODR,#4
2629                     ; 33     WrPara <<= 1;
2631  001e 0802          	sll	(OFST+1,sp)
2632                     ; 25   for(bitcnt=8; bitcnt!=0; bitcnt--)
2634  0020 0a01          	dec	(OFST+0,sp)
2637  0022 0d01          	tnz	(OFST+0,sp)
2638  0024 26e0          	jrne	L3661
2639                     ; 35   SCK_L();
2641  0026 7219500a      	bres	_PC_ODR,#4
2642                     ; 36 }
2645  002a 85            	popw	x
2646  002b 81            	ret
2691                     ; 45 u8 SPIRead8bit(void)
2691                     ; 46 {
2692                     	switch	.text
2693  002c               _SPIRead8bit:
2695  002c 89            	pushw	x
2696       00000002      OFST:	set	2
2699                     ; 47  u8 RdPara = 0;
2701  002d 0f02          	clr	(OFST+0,sp)
2702                     ; 50   NSS_L();
2704  002f 721f500a      	bres	_PC_ODR,#7
2705                     ; 51   MOSI_H();                                                 //Read one byte data from FIFO, MOSI hold to High
2707  0033 721c500a      	bset	_PC_ODR,#6
2708                     ; 52 	for(bitcnt=8; bitcnt!=0; bitcnt--)
2710  0037 a608          	ld	a,#8
2711  0039 6b01          	ld	(OFST-1,sp),a
2712  003b               L7171:
2713                     ; 54     SCK_L();
2715  003b 7219500a      	bres	_PC_ODR,#4
2716                     ; 55     RdPara <<= 1;
2718  003f 0802          	sll	(OFST+0,sp)
2719                     ; 56     SCK_H();
2721  0041 7218500a      	bset	_PC_ODR,#4
2722                     ; 57     if(Get_MISO())
2724  0045 c6500b        	ld	a,_PC_IDR
2725  0048 a420          	and	a,#32
2726  004a a120          	cp	a,#32
2727  004c 2606          	jrne	L5271
2728                     ; 58       RdPara |= 0x01;
2730  004e 7b02          	ld	a,(OFST+0,sp)
2731  0050 aa01          	or	a,#1
2732  0052 6b02          	ld	(OFST+0,sp),a
2734  0054               L5271:
2735                     ; 60       RdPara |= 0x00;	
2737                     ; 52 	for(bitcnt=8; bitcnt!=0; bitcnt--)
2739  0054 0a01          	dec	(OFST-1,sp)
2742  0056 0d01          	tnz	(OFST-1,sp)
2743  0058 26e1          	jrne	L7171
2744                     ; 62   SCK_L();
2746  005a 7219500a      	bres	_PC_ODR,#4
2747                     ; 63   return(RdPara);
2749  005e 7b02          	ld	a,(OFST+0,sp)
2752  0060 85            	popw	x
2753  0061 81            	ret
2799                     ; 72 u8 SPIRead(u8 adr)
2799                     ; 73 {
2800                     	switch	.text
2801  0062               _SPIRead:
2803  0062 88            	push	a
2804       00000001      OFST:	set	1
2807                     ; 75 	SCK_L();	
2809  0063 7219500a      	bres	_PC_ODR,#4
2810                     ; 76 	NSS_L();	
2812  0067 721f500a      	bres	_PC_ODR,#7
2813                     ; 77   SPICmd8bit(adr&0x7f);                                         //Send address first
2815  006b a47f          	and	a,#127
2816  006d ad91          	call	_SPICmd8bit
2818                     ; 78   tmp = SPIRead8bit();  
2820  006f adbb          	call	_SPIRead8bit
2822  0071 6b01          	ld	(OFST+0,sp),a
2823                     ; 79 	SCK_L();
2825  0073 7219500a      	bres	_PC_ODR,#4
2826                     ; 80   NSS_H();
2828  0077 721e500a      	bset	_PC_ODR,#7
2829                     ; 81   return tmp;
2831  007b 7b01          	ld	a,(OFST+0,sp)
2834  007d 5b01          	addw	sp,#1
2835  007f 81            	ret
2880                     ; 90 void SPIWrite(u8 adr, u8 WrPara)  
2880                     ; 91 {
2881                     	switch	.text
2882  0080               _SPIWrite:
2884  0080 89            	pushw	x
2885       00000000      OFST:	set	0
2888                     ; 92 	SCK_L();	
2890  0081 7219500a      	bres	_PC_ODR,#4
2891                     ; 93 	NSS_L();						
2893  0085 721f500a      	bres	_PC_ODR,#7
2894                     ; 94 	SPICmd8bit(adr|0x80);		 
2896  0089 9e            	ld	a,xh
2897  008a aa80          	or	a,#128
2898  008c cd0000        	call	_SPICmd8bit
2900                     ; 95 	SPICmd8bit(WrPara);	
2902  008f 7b02          	ld	a,(OFST+2,sp)
2903  0091 cd0000        	call	_SPICmd8bit
2905                     ; 96 	SCK_L();
2907  0094 7219500a      	bres	_PC_ODR,#4
2908                     ; 97   NSS_H();
2910  0098 721e500a      	bset	_PC_ODR,#7
2911                     ; 98 }
2914  009c 85            	popw	x
2915  009d 81            	ret
2980                     ; 107 void SPIBurstRead(u8 adr, u8 *ptr, u8 length)
2980                     ; 108 {
2981                     	switch	.text
2982  009e               _SPIBurstRead:
2984  009e 88            	push	a
2985  009f 88            	push	a
2986       00000001      OFST:	set	1
2989                     ; 110   if(length<=1)                                            //length must more than one
2991  00a0 7b07          	ld	a,(OFST+6,sp)
2992  00a2 a102          	cp	a,#2
2993  00a4 2532          	jrult	L02
2994                     ; 111     return;
2996                     ; 114     SCK_L();	
2998  00a6 7219500a      	bres	_PC_ODR,#4
2999                     ; 115     NSS_L();
3001  00aa 721f500a      	bres	_PC_ODR,#7
3002                     ; 116     SPICmd8bit(adr); 
3004  00ae 7b02          	ld	a,(OFST+1,sp)
3005  00b0 cd0000        	call	_SPICmd8bit
3007                     ; 117     for(i=0;i<length;i++)
3009  00b3 0f01          	clr	(OFST+0,sp)
3011  00b5 2013          	jra	L7302
3012  00b7               L3302:
3013                     ; 118     ptr[i] = SPIRead8bit();
3015  00b7 7b05          	ld	a,(OFST+4,sp)
3016  00b9 97            	ld	xl,a
3017  00ba 7b06          	ld	a,(OFST+5,sp)
3018  00bc 1b01          	add	a,(OFST+0,sp)
3019  00be 2401          	jrnc	L61
3020  00c0 5c            	incw	x
3021  00c1               L61:
3022  00c1 02            	rlwa	x,a
3023  00c2 89            	pushw	x
3024  00c3 cd002c        	call	_SPIRead8bit
3026  00c6 85            	popw	x
3027  00c7 f7            	ld	(x),a
3028                     ; 117     for(i=0;i<length;i++)
3030  00c8 0c01          	inc	(OFST+0,sp)
3031  00ca               L7302:
3034  00ca 7b01          	ld	a,(OFST+0,sp)
3035  00cc 1107          	cp	a,(OFST+6,sp)
3036  00ce 25e7          	jrult	L3302
3037                     ; 119     SCK_L();			
3039  00d0 7219500a      	bres	_PC_ODR,#4
3040                     ; 120     NSS_H();  
3042  00d4 721e500a      	bset	_PC_ODR,#7
3043                     ; 122 }
3044  00d8               L02:
3047  00d8 85            	popw	x
3048  00d9 81            	ret
3112                     ; 132 void BurstWrite(u8 adr, u8 *ptr, u8 length)
3112                     ; 133 { 
3113                     	switch	.text
3114  00da               _BurstWrite:
3116  00da 88            	push	a
3117  00db 88            	push	a
3118       00000001      OFST:	set	1
3121                     ; 135   if(length<=1)                                            //length must more than one
3123  00dc 7b07          	ld	a,(OFST+6,sp)
3124  00de a102          	cp	a,#2
3125  00e0 2532          	jrult	L62
3126                     ; 136     return;
3128                     ; 139     SCK_L();
3130  00e2 7219500a      	bres	_PC_ODR,#4
3131                     ; 140     NSS_L();        
3133  00e6 721f500a      	bres	_PC_ODR,#7
3134                     ; 141     SPICmd8bit(adr|0x80);
3136  00ea 7b02          	ld	a,(OFST+1,sp)
3137  00ec aa80          	or	a,#128
3138  00ee cd0000        	call	_SPICmd8bit
3140                     ; 142     for(i=0;i<length;i++)
3142  00f1 0f01          	clr	(OFST+0,sp)
3144  00f3 2011          	jra	L5012
3145  00f5               L1012:
3146                     ; 143 			SPICmd8bit(ptr[i]);
3148  00f5 7b05          	ld	a,(OFST+4,sp)
3149  00f7 97            	ld	xl,a
3150  00f8 7b06          	ld	a,(OFST+5,sp)
3151  00fa 1b01          	add	a,(OFST+0,sp)
3152  00fc 2401          	jrnc	L42
3153  00fe 5c            	incw	x
3154  00ff               L42:
3155  00ff 02            	rlwa	x,a
3156  0100 f6            	ld	a,(x)
3157  0101 cd0000        	call	_SPICmd8bit
3159                     ; 142     for(i=0;i<length;i++)
3161  0104 0c01          	inc	(OFST+0,sp)
3162  0106               L5012:
3165  0106 7b01          	ld	a,(OFST+0,sp)
3166  0108 1107          	cp	a,(OFST+6,sp)
3167  010a 25e9          	jrult	L1012
3168                     ; 144     SCK_L();				
3170  010c 7219500a      	bres	_PC_ODR,#4
3171                     ; 145     NSS_H();  
3173  0110 721e500a      	bset	_PC_ODR,#7
3174                     ; 147 }
3175  0114               L62:
3178  0114 85            	popw	x
3179  0115 81            	ret
3192                     	xdef	_BurstWrite
3193                     	xdef	_SPIBurstRead
3194                     	xdef	_SPIWrite
3195                     	xdef	_SPIRead8bit
3196                     	xdef	_SPIRead
3197                     	xdef	_SPICmd8bit
3216                     	end
