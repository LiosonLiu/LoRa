   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2574                     ; 45 @far @interrupt void PBX_IO_Switch_HandledInterrupt (void)
2574                     ; 46 //===============================================
2574                     ; 47 {
2575                     	switch	.text
2576  0000               f_PBX_IO_Switch_HandledInterrupt:
2580                     ; 48 	return;	
2583  0000 80            	iret
2606                     ; 51 @far @interrupt void PDX_IO_Switch_HandledInterrupt (void)
2606                     ; 52 //===============================================
2606                     ; 53 {
2607                     	switch	.text
2608  0001               f_PDX_IO_Switch_HandledInterrupt:
2612                     ; 54 		return;
2615  0001 80            	iret
2641                     ; 57 @far @interrupt void Timer1_Overflow_HandledInterrupt (void)
2641                     ; 58 //===============================================
2641                     ; 59 {
2642                     	switch	.text
2643  0002               f_Timer1_Overflow_HandledInterrupt:
2647                     ; 60 	if(TIM1_SR1 & 0x01)
2649  0002 c65255        	ld	a,_TIM1_SR1
2650  0005 a501          	bcp	a,#1
2651  0007 2719          	jreq	L1761
2652                     ; 62 		TIM1_SR1 &= 0xfe; //clear time1 overflow flag
2654  0009 72115255      	bres	_TIM1_SR1,#0
2655                     ; 63 		SysTime++;
2657  000d be00          	ldw	x,_SysTime
2658  000f 1c0001        	addw	x,#1
2659  0012 bf00          	ldw	_SysTime,x
2660                     ; 64 		if(SysTime > 1500)
2662  0014 be00          	ldw	x,_SysTime
2663  0016 a305dd        	cpw	x,#1501
2664  0019 2507          	jrult	L1761
2665                     ; 66 			SysTime = 0;
2667  001b 5f            	clrw	x
2668  001c bf00          	ldw	_SysTime,x
2669                     ; 67 			time_flag |= 0x01;
2671  001e 72100000      	bset	_time_flag,#0
2672  0022               L1761:
2673                     ; 70 	return;
2676  0022 80            	iret
2699                     ; 73 @far @interrupt void Timer2_Overflow_HandledInterrupt (void)
2699                     ; 74 //===============================================
2699                     ; 75 {
2700                     	switch	.text
2701  0023               f_Timer2_Overflow_HandledInterrupt:
2705                     ; 76 }
2708  0023 80            	iret
2731                     ; 78 @far @interrupt void Uart1_TX_Data_HandledInterrupt (void)
2731                     ; 79 //===============================================
2731                     ; 80 {
2732                     	switch	.text
2733  0024               f_Uart1_TX_Data_HandledInterrupt:
2737                     ; 81 	return;
2740  0024 80            	iret
2763                     ; 84 @far @interrupt void Uart1_RX_Data_HandledInterrupt (void)
2763                     ; 85 //===============================================
2763                     ; 86 {
2764                     	switch	.text
2765  0025               f_Uart1_RX_Data_HandledInterrupt:
2769                     ; 87 	return;
2772  0025 80            	iret
2795                     ; 90 @far @interrupt void NonHandledInterrupt (void)
2795                     ; 91 //===============================================
2795                     ; 92 {
2796                     	switch	.text
2797  0026               f_NonHandledInterrupt:
2801                     ; 93 	return;
2804  0026 80            	iret
2806                     .const:	section	.text
2807  0000               __vectab:
2808  0000 82            	dc.b	130
2810  0001 00            	dc.b	page(__stext)
2811  0002 0000          	dc.w	__stext
2812  0004 82            	dc.b	130
2814  0005 26            	dc.b	page(f_NonHandledInterrupt)
2815  0006 0026          	dc.w	f_NonHandledInterrupt
2816  0008 82            	dc.b	130
2818  0009 26            	dc.b	page(f_NonHandledInterrupt)
2819  000a 0026          	dc.w	f_NonHandledInterrupt
2820  000c 82            	dc.b	130
2822  000d 26            	dc.b	page(f_NonHandledInterrupt)
2823  000e 0026          	dc.w	f_NonHandledInterrupt
2824  0010 82            	dc.b	130
2826  0011 26            	dc.b	page(f_NonHandledInterrupt)
2827  0012 0026          	dc.w	f_NonHandledInterrupt
2828  0014 82            	dc.b	130
2830  0015 26            	dc.b	page(f_NonHandledInterrupt)
2831  0016 0026          	dc.w	f_NonHandledInterrupt
2832  0018 82            	dc.b	130
2834  0019 00            	dc.b	page(f_PBX_IO_Switch_HandledInterrupt)
2835  001a 0000          	dc.w	f_PBX_IO_Switch_HandledInterrupt
2836  001c 82            	dc.b	130
2838  001d 26            	dc.b	page(f_NonHandledInterrupt)
2839  001e 0026          	dc.w	f_NonHandledInterrupt
2840  0020 82            	dc.b	130
2842  0021 01            	dc.b	page(f_PDX_IO_Switch_HandledInterrupt)
2843  0022 0001          	dc.w	f_PDX_IO_Switch_HandledInterrupt
2844  0024 82            	dc.b	130
2846  0025 26            	dc.b	page(f_NonHandledInterrupt)
2847  0026 0026          	dc.w	f_NonHandledInterrupt
2848  0028 82            	dc.b	130
2850  0029 26            	dc.b	page(f_NonHandledInterrupt)
2851  002a 0026          	dc.w	f_NonHandledInterrupt
2852  002c 82            	dc.b	130
2854  002d 26            	dc.b	page(f_NonHandledInterrupt)
2855  002e 0026          	dc.w	f_NonHandledInterrupt
2856  0030 82            	dc.b	130
2858  0031 26            	dc.b	page(f_NonHandledInterrupt)
2859  0032 0026          	dc.w	f_NonHandledInterrupt
2860  0034 82            	dc.b	130
2862  0035 02            	dc.b	page(f_Timer1_Overflow_HandledInterrupt)
2863  0036 0002          	dc.w	f_Timer1_Overflow_HandledInterrupt
2864  0038 82            	dc.b	130
2866  0039 26            	dc.b	page(f_NonHandledInterrupt)
2867  003a 0026          	dc.w	f_NonHandledInterrupt
2868  003c 82            	dc.b	130
2870  003d 23            	dc.b	page(f_Timer2_Overflow_HandledInterrupt)
2871  003e 0023          	dc.w	f_Timer2_Overflow_HandledInterrupt
2872  0040 82            	dc.b	130
2874  0041 26            	dc.b	page(f_NonHandledInterrupt)
2875  0042 0026          	dc.w	f_NonHandledInterrupt
2876  0044 82            	dc.b	130
2878  0045 26            	dc.b	page(f_NonHandledInterrupt)
2879  0046 0026          	dc.w	f_NonHandledInterrupt
2880  0048 82            	dc.b	130
2882  0049 26            	dc.b	page(f_NonHandledInterrupt)
2883  004a 0026          	dc.w	f_NonHandledInterrupt
2884  004c 82            	dc.b	130
2886  004d 24            	dc.b	page(f_Uart1_TX_Data_HandledInterrupt)
2887  004e 0024          	dc.w	f_Uart1_TX_Data_HandledInterrupt
2888  0050 82            	dc.b	130
2890  0051 25            	dc.b	page(f_Uart1_RX_Data_HandledInterrupt)
2891  0052 0025          	dc.w	f_Uart1_RX_Data_HandledInterrupt
2892  0054 82            	dc.b	130
2894  0055 26            	dc.b	page(f_NonHandledInterrupt)
2895  0056 0026          	dc.w	f_NonHandledInterrupt
2896  0058 82            	dc.b	130
2898  0059 26            	dc.b	page(f_NonHandledInterrupt)
2899  005a 0026          	dc.w	f_NonHandledInterrupt
2900  005c 82            	dc.b	130
2902  005d 26            	dc.b	page(f_NonHandledInterrupt)
2903  005e 0026          	dc.w	f_NonHandledInterrupt
2904  0060 82            	dc.b	130
2906  0061 26            	dc.b	page(f_NonHandledInterrupt)
2907  0062 0026          	dc.w	f_NonHandledInterrupt
2908  0064 82            	dc.b	130
2910  0065 26            	dc.b	page(f_NonHandledInterrupt)
2911  0066 0026          	dc.w	f_NonHandledInterrupt
2912  0068 82            	dc.b	130
2914  0069 26            	dc.b	page(f_NonHandledInterrupt)
2915  006a 0026          	dc.w	f_NonHandledInterrupt
2916  006c 82            	dc.b	130
2918  006d 26            	dc.b	page(f_NonHandledInterrupt)
2919  006e 0026          	dc.w	f_NonHandledInterrupt
2920  0070 82            	dc.b	130
2922  0071 26            	dc.b	page(f_NonHandledInterrupt)
2923  0072 0026          	dc.w	f_NonHandledInterrupt
2924  0074 82            	dc.b	130
2926  0075 26            	dc.b	page(f_NonHandledInterrupt)
2927  0076 0026          	dc.w	f_NonHandledInterrupt
2928  0078 82            	dc.b	130
2930  0079 26            	dc.b	page(f_NonHandledInterrupt)
2931  007a 0026          	dc.w	f_NonHandledInterrupt
2932  007c 82            	dc.b	130
2934  007d 26            	dc.b	page(f_NonHandledInterrupt)
2935  007e 0026          	dc.w	f_NonHandledInterrupt
2986                     	xdef	__vectab
2987                     	xref	__stext
2988                     	xdef	f_NonHandledInterrupt
2989                     	xdef	f_Uart1_RX_Data_HandledInterrupt
2990                     	xdef	f_Uart1_TX_Data_HandledInterrupt
2991                     	xdef	f_Timer2_Overflow_HandledInterrupt
2992                     	xdef	f_Timer1_Overflow_HandledInterrupt
2993                     	xdef	f_PDX_IO_Switch_HandledInterrupt
2994                     	xdef	f_PBX_IO_Switch_HandledInterrupt
2995                     	xref.b	_time_flag
2996                     	xref.b	_SysTime
3015                     	end
