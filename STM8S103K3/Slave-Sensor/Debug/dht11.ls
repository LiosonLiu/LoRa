   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2581                     ; 14 void ReadDHT11(void)
2581                     ; 15 //=====================================
2581                     ; 16 {
2583                     	switch	.text
2584  0000               _ReadDHT11:
2586  0000 89            	pushw	x
2587       00000002      OFST:	set	2
2590                     ; 18 SET_DATA_PIN_OUTPUT();
2592  0001 72165002      	bset	_PA_DDR,#3
2593                     ; 19 SET_DATA_PIN_L();	
2595  0005 72175000      	bres	_PA_ODR,#3
2596                     ; 20 delay_ms(20);
2598  0009 ae0014        	ldw	x,#20
2599  000c cd0000        	call	_delay_ms
2601                     ; 21 SET_DATA_PIN_H();
2603  000f 72165000      	bset	_PA_ODR,#3
2604                     ; 22 SET_DATA_PIN_INPUT();
2606  0013 72175002      	bres	_PA_DDR,#3
2607                     ; 24 if(PulseHighRead()==MaxTimeValue)
2609  0017 cd00cd        	call	_PulseHighRead
2611  001a a303e8        	cpw	x,#1000
2612  001d 2708          	jreq	L02
2613                     ; 25 	return;
2615                     ; 26 if(PulseLowRead()==MaxTimeValue)
2617  001f cd00f0        	call	_PulseLowRead
2619  0022 a303e8        	cpw	x,#1000
2620  0025 2602          	jrne	L3561
2621                     ; 27 	return;	
2622  0027               L02:
2625  0027 85            	popw	x
2626  0028 81            	ret
2627  0029               L3561:
2628                     ; 29 DHT11Data[0]=ReadData();
2630  0029 ad53          	call	_ReadData
2632  002b b700          	ld	_DHT11Data,a
2633                     ; 30 DHT11Data[1]=ReadData();
2635  002d ad4f          	call	_ReadData
2637  002f b701          	ld	_DHT11Data+1,a
2638                     ; 31 DHT11Data[2]=ReadData();
2640  0031 ad4b          	call	_ReadData
2642  0033 b702          	ld	_DHT11Data+2,a
2643                     ; 32 DHT11Data[3]=ReadData();
2645  0035 ad47          	call	_ReadData
2647  0037 b703          	ld	_DHT11Data+3,a
2648                     ; 33 DHT11Data[4]=ReadData();
2650  0039 ad43          	call	_ReadData
2652  003b b704          	ld	_DHT11Data+4,a
2653                     ; 34 if(DHT11Data[4]==(DHT11Data[0]+DHT11Data[1]+DHT11Data[2]+DHT11Data[3]))
2655  003d b604          	ld	a,_DHT11Data+4
2656  003f 5f            	clrw	x
2657  0040 97            	ld	xl,a
2658  0041 1f01          	ldw	(OFST-1,sp),x
2659  0043 b600          	ld	a,_DHT11Data
2660  0045 5f            	clrw	x
2661  0046 bb01          	add	a,_DHT11Data+1
2662  0048 2401          	jrnc	L6
2663  004a 5c            	incw	x
2664  004b               L6:
2665  004b bb02          	add	a,_DHT11Data+2
2666  004d 2401          	jrnc	L01
2667  004f 5c            	incw	x
2668  0050               L01:
2669  0050 bb03          	add	a,_DHT11Data+3
2670  0052 2401          	jrnc	L21
2671  0054 5c            	incw	x
2672  0055               L21:
2673  0055 02            	rlwa	x,a
2674  0056 1301          	cpw	x,(OFST-1,sp)
2675  0058 2622          	jrne	L5561
2676                     ; 36 	DHT11Humi=(DHT11Data[1]<<8)+DHT11Data[0];
2678  005a b601          	ld	a,_DHT11Data+1
2679  005c 5f            	clrw	x
2680  005d 97            	ld	xl,a
2681  005e 4f            	clr	a
2682  005f 02            	rlwa	x,a
2683  0060 01            	rrwa	x,a
2684  0061 bb00          	add	a,_DHT11Data
2685  0063 2401          	jrnc	L41
2686  0065 5c            	incw	x
2687  0066               L41:
2688  0066 b708          	ld	_DHT11Humi+1,a
2689  0068 9f            	ld	a,xl
2690  0069 b707          	ld	_DHT11Humi,a
2691                     ; 37 	DHT11Temp=(DHT11Data[3]<<8)+DHT11Data[2];
2693  006b b603          	ld	a,_DHT11Data+3
2694  006d 5f            	clrw	x
2695  006e 97            	ld	xl,a
2696  006f 4f            	clr	a
2697  0070 02            	rlwa	x,a
2698  0071 01            	rrwa	x,a
2699  0072 bb02          	add	a,_DHT11Data+2
2700  0074 2401          	jrnc	L61
2701  0076 5c            	incw	x
2702  0077               L61:
2703  0077 b706          	ld	_DHT11Temp+1,a
2704  0079 9f            	ld	a,xl
2705  007a b705          	ld	_DHT11Temp,a
2706  007c               L5561:
2707                     ; 39 }
2709  007c 20a9          	jra	L02
2763                     ; 42 u8 ReadData(void)
2763                     ; 43 //=====================================
2763                     ; 44 {
2764                     	switch	.text
2765  007e               _ReadData:
2767  007e 5203          	subw	sp,#3
2768       00000003      OFST:	set	3
2771                     ; 46 data=0;
2773  0080 0f02          	clr	(OFST-1,sp)
2774                     ; 47 for(i=0;i<8;i++)
2776  0082 0f01          	clr	(OFST-2,sp)
2777  0084               L5071:
2778                     ; 49 	counter=PulseHighRead();
2780  0084 ad47          	call	_PulseHighRead
2782  0086 01            	rrwa	x,a
2783  0087 6b03          	ld	(OFST+0,sp),a
2784  0089 02            	rlwa	x,a
2785                     ; 50 	if(counter<High40Value)	
2787  008a 7b03          	ld	a,(OFST+0,sp)
2788  008c a120          	cp	a,#32
2789  008e 240d          	jruge	L3171
2790                     ; 52 			if(counter>High10Value)
2792  0090 7b03          	ld	a,(OFST+0,sp)
2793  0092 a109          	cp	a,#9
2794  0094 2504          	jrult	L5171
2795                     ; 53 				data<<=1;
2797  0096 0802          	sll	(OFST-1,sp)
2799  0098 201d          	jra	L1271
2800  009a               L5171:
2801                     ; 55 				return 0;
2803  009a 4f            	clr	a
2805  009b 2017          	jra	L42
2806  009d               L3171:
2807                     ; 57 	else if(counter<High90Value)
2809  009d 7b03          	ld	a,(OFST+0,sp)
2810  009f a148          	cp	a,#72
2811  00a1 2414          	jruge	L1271
2812                     ; 59 			if(counter>High60Value)
2814  00a3 7b03          	ld	a,(OFST+0,sp)
2815  00a5 a131          	cp	a,#49
2816  00a7 250a          	jrult	L5271
2817                     ; 61 					data|=0x01;
2819  00a9 7b02          	ld	a,(OFST-1,sp)
2820  00ab aa01          	or	a,#1
2821  00ad 6b02          	ld	(OFST-1,sp),a
2822                     ; 62 					data<<=1;
2824  00af 0802          	sll	(OFST-1,sp)
2826  00b1 2004          	jra	L1271
2827  00b3               L5271:
2828                     ; 65 				return 0;		
2830  00b3 4f            	clr	a
2832  00b4               L42:
2834  00b4 5b03          	addw	sp,#3
2835  00b6 81            	ret
2836  00b7               L1271:
2837                     ; 67 	if(PulseLowRead()==MaxTimeValue)
2839  00b7 ad37          	call	_PulseLowRead
2841  00b9 a303e8        	cpw	x,#1000
2842  00bc 2603          	jrne	L1371
2843                     ; 68 		return 0;		
2845  00be 4f            	clr	a
2847  00bf 20f3          	jra	L42
2848  00c1               L1371:
2849                     ; 47 for(i=0;i<8;i++)
2851  00c1 0c01          	inc	(OFST-2,sp)
2854  00c3 7b01          	ld	a,(OFST-2,sp)
2855  00c5 a108          	cp	a,#8
2856  00c7 25bb          	jrult	L5071
2857                     ; 70 return data;			
2859  00c9 7b02          	ld	a,(OFST-1,sp)
2861  00cb 20e7          	jra	L42
2896                     ; 74 u16 PulseHighRead(void)
2896                     ; 75 //=====================================
2896                     ; 76 {
2897                     	switch	.text
2898  00cd               _PulseHighRead:
2900  00cd 89            	pushw	x
2901       00000002      OFST:	set	2
2904                     ; 78 for(high=0;high<MaxTimeValue;high++)
2906  00ce 5f            	clrw	x
2907  00cf 1f01          	ldw	(OFST-1,sp),x
2908  00d1               L1571:
2909                     ; 80 	if(GET_DATA_PIN()==0)	
2911  00d1 c65001        	ld	a,_PA_IDR
2912  00d4 a408          	and	a,#8
2913  00d6 c75001        	ld	_PA_IDR,a
2914  00d9 2604          	jrne	L7571
2915                     ; 81 		return high;
2917  00db 1e01          	ldw	x,(OFST-1,sp)
2919  00dd 200e          	jra	L03
2920  00df               L7571:
2921                     ; 78 for(high=0;high<MaxTimeValue;high++)
2923  00df 1e01          	ldw	x,(OFST-1,sp)
2924  00e1 1c0001        	addw	x,#1
2925  00e4 1f01          	ldw	(OFST-1,sp),x
2928  00e6 1e01          	ldw	x,(OFST-1,sp)
2929  00e8 a303e8        	cpw	x,#1000
2930  00eb 25e4          	jrult	L1571
2931                     ; 83 }
2932  00ed               L03:
2935  00ed 5b02          	addw	sp,#2
2936  00ef 81            	ret
2971                     ; 85 u16 PulseLowRead(void)
2971                     ; 86 //=====================================	
2971                     ; 87 {
2972                     	switch	.text
2973  00f0               _PulseLowRead:
2975  00f0 89            	pushw	x
2976       00000002      OFST:	set	2
2979                     ; 89 for(low=0;low<MaxTimeValue;low++)
2981  00f1 5f            	clrw	x
2982  00f2 1f01          	ldw	(OFST-1,sp),x
2983  00f4               L7771:
2984                     ; 91 	if(GET_DATA_PIN()!=0)	
2986  00f4 c65001        	ld	a,_PA_IDR
2987  00f7 a408          	and	a,#8
2988  00f9 c75001        	ld	_PA_IDR,a
2989  00fc 2704          	jreq	L5002
2990                     ; 92 		return low;
2992  00fe 1e01          	ldw	x,(OFST-1,sp)
2994  0100 200e          	jra	L43
2995  0102               L5002:
2996                     ; 89 for(low=0;low<MaxTimeValue;low++)
2998  0102 1e01          	ldw	x,(OFST-1,sp)
2999  0104 1c0001        	addw	x,#1
3000  0107 1f01          	ldw	(OFST-1,sp),x
3003  0109 1e01          	ldw	x,(OFST-1,sp)
3004  010b a303e8        	cpw	x,#1000
3005  010e 25e4          	jrult	L7771
3006                     ; 94 }
3007  0110               L43:
3010  0110 5b02          	addw	sp,#2
3011  0112 81            	ret
3054                     	xdef	_ReadData
3055                     	xdef	_PulseLowRead
3056                     	xdef	_PulseHighRead
3057                     	switch	.ubsct
3058  0000               _DHT11Data:
3059  0000 0000000000    	ds.b	5
3060                     	xdef	_DHT11Data
3061                     	xdef	_ReadDHT11
3062  0005               _DHT11Temp:
3063  0005 0000          	ds.b	2
3064                     	xdef	_DHT11Temp
3065  0007               _DHT11Humi:
3066  0007 0000          	ds.b	2
3067                     	xdef	_DHT11Humi
3068                     	xref	_delay_ms
3088                     	end
