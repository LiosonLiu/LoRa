   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2583                     ; 14 void ReadDHT11(void)
2583                     ; 15 //=====================================
2583                     ; 16 {
2585                     	switch	.text
2586  0000               _ReadDHT11:
2588  0000 89            	pushw	x
2589       00000002      OFST:	set	2
2592                     ; 18 SET_DATA_PIN_OUTPUT();
2594  0001 72165002      	bset	_PA_DDR,#3
2595                     ; 19 SET_DEBUG_PIN_OUTPUT();
2597  0005 721e5007      	bset	_PB_DDR,#7
2598                     ; 20 SET_DATA_PIN_L();	
2600  0009 72175000      	bres	_PA_ODR,#3
2601                     ; 21 SET_DEBUG_PIN_L();
2603  000d 721f5005      	bres	_PB_ODR,#7
2604                     ; 22 delay_ms(20);
2606  0011 ae0014        	ldw	x,#20
2607  0014 cd0000        	call	_delay_ms
2609                     ; 23 SET_DATA_PIN_H();
2611  0017 72165000      	bset	_PA_ODR,#3
2612                     ; 24 SET_DEBUG_PIN_H();
2614  001b 721e5005      	bset	_PB_ODR,#7
2615                     ; 25 SET_DATA_PIN_INPUT();
2617  001f 72175002      	bres	_PA_DDR,#3
2618                     ; 27 if(PulseHighRead()==MaxTimeValue)
2620  0023 cd00d9        	call	_PulseHighRead
2622  0026 a303e8        	cpw	x,#1000
2623  0029 2708          	jreq	L02
2624                     ; 28 	return;
2626                     ; 29 if(PulseLowRead()==MaxTimeValue)
2628  002b cd0100        	call	_PulseLowRead
2630  002e a303e8        	cpw	x,#1000
2631  0031 2602          	jrne	L3561
2632                     ; 30 	return;	
2633  0033               L02:
2636  0033 85            	popw	x
2637  0034 81            	ret
2638  0035               L3561:
2639                     ; 32 DHT11Data[0]=ReadData();
2641  0035 ad53          	call	_ReadData
2643  0037 b700          	ld	_DHT11Data,a
2644                     ; 33 DHT11Data[1]=ReadData();
2646  0039 ad4f          	call	_ReadData
2648  003b b701          	ld	_DHT11Data+1,a
2649                     ; 34 DHT11Data[2]=ReadData();
2651  003d ad4b          	call	_ReadData
2653  003f b702          	ld	_DHT11Data+2,a
2654                     ; 35 DHT11Data[3]=ReadData();
2656  0041 ad47          	call	_ReadData
2658  0043 b703          	ld	_DHT11Data+3,a
2659                     ; 36 DHT11Data[4]=ReadData();
2661  0045 ad43          	call	_ReadData
2663  0047 b704          	ld	_DHT11Data+4,a
2664                     ; 37 if(DHT11Data[4]==(DHT11Data[0]+DHT11Data[1]+DHT11Data[2]+DHT11Data[3]))
2666  0049 b604          	ld	a,_DHT11Data+4
2667  004b 5f            	clrw	x
2668  004c 97            	ld	xl,a
2669  004d 1f01          	ldw	(OFST-1,sp),x
2670  004f b600          	ld	a,_DHT11Data
2671  0051 5f            	clrw	x
2672  0052 bb01          	add	a,_DHT11Data+1
2673  0054 2401          	jrnc	L6
2674  0056 5c            	incw	x
2675  0057               L6:
2676  0057 bb02          	add	a,_DHT11Data+2
2677  0059 2401          	jrnc	L01
2678  005b 5c            	incw	x
2679  005c               L01:
2680  005c bb03          	add	a,_DHT11Data+3
2681  005e 2401          	jrnc	L21
2682  0060 5c            	incw	x
2683  0061               L21:
2684  0061 02            	rlwa	x,a
2685  0062 1301          	cpw	x,(OFST-1,sp)
2686  0064 2622          	jrne	L5561
2687                     ; 39 	DHT11Humi=(DHT11Data[1]<<8)+DHT11Data[0];
2689  0066 b601          	ld	a,_DHT11Data+1
2690  0068 5f            	clrw	x
2691  0069 97            	ld	xl,a
2692  006a 4f            	clr	a
2693  006b 02            	rlwa	x,a
2694  006c 01            	rrwa	x,a
2695  006d bb00          	add	a,_DHT11Data
2696  006f 2401          	jrnc	L41
2697  0071 5c            	incw	x
2698  0072               L41:
2699  0072 b708          	ld	_DHT11Humi+1,a
2700  0074 9f            	ld	a,xl
2701  0075 b707          	ld	_DHT11Humi,a
2702                     ; 40 	DHT11Temp=(DHT11Data[3]<<8)+DHT11Data[2];
2704  0077 b603          	ld	a,_DHT11Data+3
2705  0079 5f            	clrw	x
2706  007a 97            	ld	xl,a
2707  007b 4f            	clr	a
2708  007c 02            	rlwa	x,a
2709  007d 01            	rrwa	x,a
2710  007e bb02          	add	a,_DHT11Data+2
2711  0080 2401          	jrnc	L61
2712  0082 5c            	incw	x
2713  0083               L61:
2714  0083 b706          	ld	_DHT11Temp+1,a
2715  0085 9f            	ld	a,xl
2716  0086 b705          	ld	_DHT11Temp,a
2717  0088               L5561:
2718                     ; 42 }
2720  0088 20a9          	jra	L02
2774                     ; 45 u8 ReadData(void)
2774                     ; 46 //=====================================
2774                     ; 47 {
2775                     	switch	.text
2776  008a               _ReadData:
2778  008a 5203          	subw	sp,#3
2779       00000003      OFST:	set	3
2782                     ; 49 data=0;
2784  008c 0f02          	clr	(OFST-1,sp)
2785                     ; 50 for(i=0;i<8;i++)
2787  008e 0f01          	clr	(OFST-2,sp)
2788  0090               L5071:
2789                     ; 52 	counter=PulseHighRead();
2791  0090 ad47          	call	_PulseHighRead
2793  0092 01            	rrwa	x,a
2794  0093 6b03          	ld	(OFST+0,sp),a
2795  0095 02            	rlwa	x,a
2796                     ; 53 	if(counter<High40Value)	
2798  0096 7b03          	ld	a,(OFST+0,sp)
2799  0098 a120          	cp	a,#32
2800  009a 240d          	jruge	L3171
2801                     ; 55 			if(counter>High10Value)
2803  009c 7b03          	ld	a,(OFST+0,sp)
2804  009e a109          	cp	a,#9
2805  00a0 2504          	jrult	L5171
2806                     ; 56 				data<<=1;
2808  00a2 0802          	sll	(OFST-1,sp)
2810  00a4 201d          	jra	L1271
2811  00a6               L5171:
2812                     ; 58 				return 0;
2814  00a6 4f            	clr	a
2816  00a7 2017          	jra	L42
2817  00a9               L3171:
2818                     ; 60 	else if(counter<High90Value)
2820  00a9 7b03          	ld	a,(OFST+0,sp)
2821  00ab a148          	cp	a,#72
2822  00ad 2414          	jruge	L1271
2823                     ; 62 			if(counter>High60Value)
2825  00af 7b03          	ld	a,(OFST+0,sp)
2826  00b1 a131          	cp	a,#49
2827  00b3 250a          	jrult	L5271
2828                     ; 64 					data|=0x01;
2830  00b5 7b02          	ld	a,(OFST-1,sp)
2831  00b7 aa01          	or	a,#1
2832  00b9 6b02          	ld	(OFST-1,sp),a
2833                     ; 65 					data<<=1;
2835  00bb 0802          	sll	(OFST-1,sp)
2837  00bd 2004          	jra	L1271
2838  00bf               L5271:
2839                     ; 68 				return 0;		
2841  00bf 4f            	clr	a
2843  00c0               L42:
2845  00c0 5b03          	addw	sp,#3
2846  00c2 81            	ret
2847  00c3               L1271:
2848                     ; 70 	if(PulseLowRead()==MaxTimeValue)
2850  00c3 ad3b          	call	_PulseLowRead
2852  00c5 a303e8        	cpw	x,#1000
2853  00c8 2603          	jrne	L1371
2854                     ; 71 		return 0;		
2856  00ca 4f            	clr	a
2858  00cb 20f3          	jra	L42
2859  00cd               L1371:
2860                     ; 50 for(i=0;i<8;i++)
2862  00cd 0c01          	inc	(OFST-2,sp)
2865  00cf 7b01          	ld	a,(OFST-2,sp)
2866  00d1 a108          	cp	a,#8
2867  00d3 25bb          	jrult	L5071
2868                     ; 73 return data;			
2870  00d5 7b02          	ld	a,(OFST-1,sp)
2872  00d7 20e7          	jra	L42
2908                     ; 77 u16 PulseHighRead(void)
2908                     ; 78 //=====================================
2908                     ; 79 {
2909                     	switch	.text
2910  00d9               _PulseHighRead:
2912  00d9 89            	pushw	x
2913       00000002      OFST:	set	2
2916                     ; 81 for(high=0;high<MaxTimeValue;high++)
2918  00da 5f            	clrw	x
2919  00db 1f01          	ldw	(OFST-1,sp),x
2920  00dd               L1571:
2921                     ; 83 	if(GET_DATA_PIN()==0)	
2923  00dd c65001        	ld	a,_PA_IDR
2924  00e0 a408          	and	a,#8
2925  00e2 c75001        	ld	_PA_IDR,a
2926  00e5 2604          	jrne	L7571
2927                     ; 84 		return high;
2929  00e7 1e01          	ldw	x,(OFST-1,sp)
2931  00e9 2012          	jra	L03
2932  00eb               L7571:
2933                     ; 81 for(high=0;high<MaxTimeValue;high++)
2935  00eb 1e01          	ldw	x,(OFST-1,sp)
2936  00ed 1c0001        	addw	x,#1
2937  00f0 1f01          	ldw	(OFST-1,sp),x
2940  00f2 1e01          	ldw	x,(OFST-1,sp)
2941  00f4 a303e8        	cpw	x,#1000
2942  00f7 25e4          	jrult	L1571
2943                     ; 86 SET_DEBUG_PIN_L();
2945  00f9 721f5005      	bres	_PB_ODR,#7
2946                     ; 87 }
2947  00fd               L03:
2950  00fd 5b02          	addw	sp,#2
2951  00ff 81            	ret
2987                     ; 89 u16 PulseLowRead(void)
2987                     ; 90 //=====================================	
2987                     ; 91 {
2988                     	switch	.text
2989  0100               _PulseLowRead:
2991  0100 89            	pushw	x
2992       00000002      OFST:	set	2
2995                     ; 93 for(low=0;low<MaxTimeValue;low++)
2997  0101 5f            	clrw	x
2998  0102 1f01          	ldw	(OFST-1,sp),x
2999  0104               L7771:
3000                     ; 95 	if(GET_DATA_PIN()!=0)	
3002  0104 c65001        	ld	a,_PA_IDR
3003  0107 a408          	and	a,#8
3004  0109 c75001        	ld	_PA_IDR,a
3005  010c 2704          	jreq	L5002
3006                     ; 96 		return low;
3008  010e 1e01          	ldw	x,(OFST-1,sp)
3010  0110 2012          	jra	L43
3011  0112               L5002:
3012                     ; 93 for(low=0;low<MaxTimeValue;low++)
3014  0112 1e01          	ldw	x,(OFST-1,sp)
3015  0114 1c0001        	addw	x,#1
3016  0117 1f01          	ldw	(OFST-1,sp),x
3019  0119 1e01          	ldw	x,(OFST-1,sp)
3020  011b a303e8        	cpw	x,#1000
3021  011e 25e4          	jrult	L7771
3022                     ; 98 SET_DEBUG_PIN_L();	
3024  0120 721f5005      	bres	_PB_ODR,#7
3025                     ; 99 }
3026  0124               L43:
3029  0124 5b02          	addw	sp,#2
3030  0126 81            	ret
3073                     	xdef	_ReadData
3074                     	xdef	_PulseLowRead
3075                     	xdef	_PulseHighRead
3076                     	switch	.ubsct
3077  0000               _DHT11Data:
3078  0000 0000000000    	ds.b	5
3079                     	xdef	_DHT11Data
3080                     	xdef	_ReadDHT11
3081  0005               _DHT11Temp:
3082  0005 0000          	ds.b	2
3083                     	xdef	_DHT11Temp
3084  0007               _DHT11Humi:
3085  0007 0000          	ds.b	2
3086                     	xdef	_DHT11Humi
3087                     	xref	_delay_ms
3107                     	end
