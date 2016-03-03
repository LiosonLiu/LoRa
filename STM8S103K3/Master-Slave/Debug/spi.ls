   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
   4                     ; Optimizer V4.3.6 - 29 Nov 2011
2596                     ; 22 void SPICmd8bit(u8 WrPara)
2596                     ; 23 {
2598                     	switch	.text
2599  0000               _SPICmd8bit:
2601  0000 88            	push	a
2602  0001 88            	push	a
2603       00000001      OFST:	set	1
2606                     ; 25   for(bitcnt=8; bitcnt!=0; bitcnt--)
2608  0002 a608          	ld	a,#8
2609  0004 6b01          	ld	(OFST+0,sp),a
2610  0006               L3661:
2611                     ; 27     SCK_L();
2613  0006 7219500a      	bres	_PC_ODR,#4
2614                     ; 28     if(WrPara&0x80)
2616  000a 7b02          	ld	a,(OFST+1,sp)
2617  000c 2a06          	jrpl	L1761
2618                     ; 29       MOSI_H();
2620  000e 721c500a      	bset	_PC_ODR,#6
2622  0012 2004          	jra	L3761
2623  0014               L1761:
2624                     ; 31       MOSI_L();
2626  0014 721d500a      	bres	_PC_ODR,#6
2627  0018               L3761:
2628                     ; 32     SCK_H();
2630  0018 7218500a      	bset	_PC_ODR,#4
2631                     ; 33     WrPara <<= 1;
2633  001c 0802          	sll	(OFST+1,sp)
2634                     ; 25   for(bitcnt=8; bitcnt!=0; bitcnt--)
2636  001e 0a01          	dec	(OFST+0,sp)
2639  0020 26e4          	jrne	L3661
2640                     ; 35   SCK_L();
2642  0022 7219500a      	bres	_PC_ODR,#4
2643                     ; 36 }
2646  0026 85            	popw	x
2647  0027 81            	ret	
2692                     ; 45 u8 SPIRead8bit(void)
2692                     ; 46 {
2693                     	switch	.text
2694  0028               _SPIRead8bit:
2696  0028 89            	pushw	x
2697       00000002      OFST:	set	2
2700                     ; 47  u8 RdPara = 0;
2702  0029 0f02          	clr	(OFST+0,sp)
2703                     ; 50   NSS_L();
2705  002b 721f500a      	bres	_PC_ODR,#7
2706                     ; 51   MOSI_H();                                                 //Read one byte data from FIFO, MOSI hold to High
2708                     ; 52 	for(bitcnt=8; bitcnt!=0; bitcnt--)
2710  002f a608          	ld	a,#8
2711  0031 721c500a      	bset	_PC_ODR,#6
2712  0035 6b01          	ld	(OFST-1,sp),a
2713  0037               L7171:
2714                     ; 54     SCK_L();
2716  0037 7219500a      	bres	_PC_ODR,#4
2717                     ; 55     RdPara <<= 1;
2719  003b 0802          	sll	(OFST+0,sp)
2720                     ; 56     SCK_H();
2722  003d 7218500a      	bset	_PC_ODR,#4
2723                     ; 57     if(Get_MISO())
2725  0041 720b500b06    	btjf	_PC_IDR,#5,L5271
2726                     ; 58       RdPara |= 0x01;
2728  0046 7b02          	ld	a,(OFST+0,sp)
2729  0048 aa01          	or	a,#1
2730  004a 6b02          	ld	(OFST+0,sp),a
2732  004c               L5271:
2733                     ; 60       RdPara |= 0x00;	
2735                     ; 52 	for(bitcnt=8; bitcnt!=0; bitcnt--)
2737  004c 0a01          	dec	(OFST-1,sp)
2740  004e 26e7          	jrne	L7171
2741                     ; 62   SCK_L();
2743  0050 7219500a      	bres	_PC_ODR,#4
2744                     ; 63   return(RdPara);
2746  0054 7b02          	ld	a,(OFST+0,sp)
2749  0056 85            	popw	x
2750  0057 81            	ret	
2796                     ; 72 u8 SPIRead(u8 adr)
2796                     ; 73 {
2797                     	switch	.text
2798  0058               _SPIRead:
2800       00000001      OFST:	set	1
2803                     ; 75 	SCK_L();	
2805  0058 7219500a      	bres	_PC_ODR,#4
2806  005c 88            	push	a
2807                     ; 76 	NSS_L();	
2809  005d 721f500a      	bres	_PC_ODR,#7
2810                     ; 77   SPICmd8bit(adr&0x7f);                                         //Send address first
2812  0061 a47f          	and	a,#127
2813  0063 ad9b          	call	_SPICmd8bit
2815                     ; 78   tmp = SPIRead8bit();  
2817  0065 adc1          	call	_SPIRead8bit
2819  0067 6b01          	ld	(OFST+0,sp),a
2820                     ; 79 	SCK_L();
2822  0069 7219500a      	bres	_PC_ODR,#4
2823                     ; 80   NSS_H();
2825                     ; 81   return tmp;
2829  006d 5b01          	addw	sp,#1
2830  006f 721e500a      	bset	_PC_ODR,#7
2831  0073 81            	ret	
2876                     ; 90 void SPIWrite(u8 adr, u8 WrPara)  
2876                     ; 91 {
2877                     	switch	.text
2878  0074               _SPIWrite:
2880       00000000      OFST:	set	0
2883                     ; 92 	SCK_L();	
2885  0074 7219500a      	bres	_PC_ODR,#4
2886  0078 89            	pushw	x
2887                     ; 93 	NSS_L();						
2889  0079 721f500a      	bres	_PC_ODR,#7
2890                     ; 94 	SPICmd8bit(adr|0x80);		 
2892  007d 9e            	ld	a,xh
2893  007e aa80          	or	a,#128
2894  0080 cd0000        	call	_SPICmd8bit
2896                     ; 95 	SPICmd8bit(WrPara);	
2898  0083 7b02          	ld	a,(OFST+2,sp)
2899  0085 cd0000        	call	_SPICmd8bit
2901                     ; 96 	SCK_L();
2903  0088 7219500a      	bres	_PC_ODR,#4
2904                     ; 97   NSS_H();
2906                     ; 98 }
2909  008c 85            	popw	x
2910  008d 721e500a      	bset	_PC_ODR,#7
2911  0091 81            	ret	
2976                     ; 107 void SPIBurstRead(u8 adr, u8 *ptr, u8 length)
2976                     ; 108 {
2977                     	switch	.text
2978  0092               _SPIBurstRead:
2980  0092 88            	push	a
2981  0093 88            	push	a
2982       00000001      OFST:	set	1
2985                     ; 110   if(length<=1)                                            //length must more than one
2987  0094 7b07          	ld	a,(OFST+6,sp)
2988  0096 a102          	cp	a,#2
2989  0098 2532          	jrult	L43
2990                     ; 111     return;
2992                     ; 114     SCK_L();	
2994  009a 7219500a      	bres	_PC_ODR,#4
2995                     ; 115     NSS_L();
2997  009e 721f500a      	bres	_PC_ODR,#7
2998                     ; 116     SPICmd8bit(adr); 
3000  00a2 7b02          	ld	a,(OFST+1,sp)
3001  00a4 cd0000        	call	_SPICmd8bit
3003                     ; 117     for(i=0;i<length;i++)
3005  00a7 0f01          	clr	(OFST+0,sp)
3007  00a9 2013          	jra	L7302
3008  00ab               L3302:
3009                     ; 118     ptr[i] = SPIRead8bit();
3011  00ab 7b05          	ld	a,(OFST+4,sp)
3012  00ad 97            	ld	xl,a
3013  00ae 7b06          	ld	a,(OFST+5,sp)
3014  00b0 1b01          	add	a,(OFST+0,sp)
3015  00b2 2401          	jrnc	L03
3016  00b4 5c            	incw	x
3017  00b5               L03:
3018  00b5 02            	rlwa	x,a
3019  00b6 89            	pushw	x
3020  00b7 cd0028        	call	_SPIRead8bit
3022  00ba 85            	popw	x
3023  00bb f7            	ld	(x),a
3024                     ; 117     for(i=0;i<length;i++)
3026  00bc 0c01          	inc	(OFST+0,sp)
3027  00be               L7302:
3030  00be 7b01          	ld	a,(OFST+0,sp)
3031  00c0 1107          	cp	a,(OFST+6,sp)
3032  00c2 25e7          	jrult	L3302
3033                     ; 119     SCK_L();			
3035  00c4 7219500a      	bres	_PC_ODR,#4
3036                     ; 120     NSS_H();  
3038  00c8 721e500a      	bset	_PC_ODR,#7
3039                     ; 122 }
3040  00cc               L43:
3043  00cc 85            	popw	x
3044  00cd 81            	ret	
3108                     ; 132 void BurstWrite(u8 adr, u8 *ptr, u8 length)
3108                     ; 133 { 
3109                     	switch	.text
3110  00ce               _BurstWrite:
3112  00ce 88            	push	a
3113  00cf 88            	push	a
3114       00000001      OFST:	set	1
3117                     ; 135   if(length<=1)                                            //length must more than one
3119  00d0 7b07          	ld	a,(OFST+6,sp)
3120  00d2 a102          	cp	a,#2
3121  00d4 2532          	jrult	L64
3122                     ; 136     return;
3124                     ; 139     SCK_L();
3126  00d6 7219500a      	bres	_PC_ODR,#4
3127                     ; 140     NSS_L();        
3129  00da 721f500a      	bres	_PC_ODR,#7
3130                     ; 141     SPICmd8bit(adr|0x80);
3132  00de 7b02          	ld	a,(OFST+1,sp)
3133  00e0 aa80          	or	a,#128
3134  00e2 cd0000        	call	_SPICmd8bit
3136                     ; 142     for(i=0;i<length;i++)
3138  00e5 0f01          	clr	(OFST+0,sp)
3140  00e7 2011          	jra	L5012
3141  00e9               L1012:
3142                     ; 143 			SPICmd8bit(ptr[i]);
3144  00e9 7b05          	ld	a,(OFST+4,sp)
3145  00eb 97            	ld	xl,a
3146  00ec 7b06          	ld	a,(OFST+5,sp)
3147  00ee 1b01          	add	a,(OFST+0,sp)
3148  00f0 2401          	jrnc	L44
3149  00f2 5c            	incw	x
3150  00f3               L44:
3151  00f3 02            	rlwa	x,a
3152  00f4 f6            	ld	a,(x)
3153  00f5 cd0000        	call	_SPICmd8bit
3155                     ; 142     for(i=0;i<length;i++)
3157  00f8 0c01          	inc	(OFST+0,sp)
3158  00fa               L5012:
3161  00fa 7b01          	ld	a,(OFST+0,sp)
3162  00fc 1107          	cp	a,(OFST+6,sp)
3163  00fe 25e9          	jrult	L1012
3164                     ; 144     SCK_L();				
3166  0100 7219500a      	bres	_PC_ODR,#4
3167                     ; 145     NSS_H();  
3169  0104 721e500a      	bset	_PC_ODR,#7
3170                     ; 147 }
3171  0108               L64:
3174  0108 85            	popw	x
3175  0109 81            	ret	
3188                     	xdef	_BurstWrite
3189                     	xdef	_SPIBurstRead
3190                     	xdef	_SPIWrite
3191                     	xdef	_SPIRead8bit
3192                     	xdef	_SPIRead
3193                     	xdef	_SPICmd8bit
3212                     	end
