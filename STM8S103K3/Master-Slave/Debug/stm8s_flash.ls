   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
   4                     ; Optimizer V4.3.6 - 29 Nov 2011
2588                     ; 32 void FLASH_Unlock(uint8_t FLASH_MemType)
2588                     ; 33 {
2590                     	switch	.text
2591  0000               _FLASH_Unlock:
2593  0000 88            	push	a
2594       00000000      OFST:	set	0
2597                     ; 35 	if(IS_MEMORY_TYPE_OK(FLASH_MemType));
2600                     ; 39 		if (FLASH_MemType == FLASH_MEMTYPE_PROG)
2602  0001 7b01          	ld	a,(OFST+1,sp)
2603  0003 a1fd          	cp	a,#253
2604  0005 260a          	jrne	L3661
2605                     ; 41 				FLASH_PUKR = FLASH_RASS_KEY1;
2607  0007 35565062      	mov	_FLASH_PUKR,#86
2608                     ; 42 				FLASH_PUKR = FLASH_RASS_KEY2;
2610  000b 35ae5062      	mov	_FLASH_PUKR,#174
2612  000f 2008          	jra	L5661
2613  0011               L3661:
2614                     ; 47 				FLASH_DUKR = FLASH_RASS_KEY2; /* Warning: keys are reversed on data memory !!! */
2616  0011 35ae5064      	mov	_FLASH_DUKR,#174
2617                     ; 48 				FLASH_DUKR = FLASH_RASS_KEY1;
2619  0015 35565064      	mov	_FLASH_DUKR,#86
2620  0019               L5661:
2621                     ; 51 }
2624  0019 84            	pop	a
2625  001a 81            	ret	
2652                     ; 73 void FLASH_DeInit(void)
2652                     ; 74 {
2653                     	switch	.text
2654  001b               _FLASH_DeInit:
2658                     ; 75     FLASH_CR1 = FLASH_CR1_RESET_VALUE;
2660  001b 725f505a      	clr	_FLASH_CR1
2661                     ; 76     FLASH_CR2 = FLASH_CR2_RESET_VALUE;
2663  001f 725f505b      	clr	_FLASH_CR2
2664                     ; 77     FLASH_NCR2 = FLASH_NCR2_RESET_VALUE;
2666  0023 35ff505c      	mov	_FLASH_NCR2,#255
2667                     ; 78     FLASH_IAPSR &= (uint8_t)(~FLASH_IAPSR_DUL);
2669  0027 7217505f      	bres	_FLASH_IAPSR,#3
2670                     ; 79     FLASH_IAPSR &= (uint8_t)(~FLASH_IAPSR_PUL);
2672  002b 7213505f      	bres	_FLASH_IAPSR,#1
2673                     ; 80     (void) FLASH_IAPSR; /* Reading of this register causes the clearing of status flags */
2675  002f c6505f        	ld	a,_FLASH_IAPSR
2676                     ; 81 }
2679  0032 81            	ret	
2722                     .const:	section	.text
2723  0000               L21:
2724  0000 00008000      	dc.l	32768
2725  0004               L41:
2726  0004 0000a000      	dc.l	40960
2727  0008               L61:
2728  0008 00004000      	dc.l	16384
2729  000c               L02:
2730  000c 00004280      	dc.l	17024
2731                     ; 133 void FLASH_ProgramByte(uint32_t Address, uint8_t Data)
2731                     ; 134 {
2732                     	switch	.text
2733  0033               _FLASH_ProgramByte:
2735       00000000      OFST:	set	0
2738                     ; 136     if(IS_FLASH_ADDRESS_OK(Address))
2740  0033 96            	ldw	x,sp
2741  0034 1c0003        	addw	x,#OFST+3
2742  0037 cd0000        	call	c_ltor
2744  003a ae0000        	ldw	x,#L21
2745  003d cd0000        	call	c_lcmp
2747  0040 250f          	jrult	L5271
2749  0042 96            	ldw	x,sp
2750  0043 1c0003        	addw	x,#OFST+3
2751  0046 cd0000        	call	c_ltor
2753  0049 ae0004        	ldw	x,#L41
2754  004c cd0000        	call	c_lcmp
2756  004f 251e          	jrult	L3271
2757  0051               L5271:
2759  0051 96            	ldw	x,sp
2760  0052 1c0003        	addw	x,#OFST+3
2761  0055 cd0000        	call	c_ltor
2763  0058 ae0008        	ldw	x,#L61
2764  005b cd0000        	call	c_lcmp
2766  005e 2514          	jrult	L1271
2768  0060 96            	ldw	x,sp
2769  0061 1c0003        	addw	x,#OFST+3
2770  0064 cd0000        	call	c_ltor
2772  0067 ae000c        	ldw	x,#L02
2773  006a cd0000        	call	c_lcmp
2775  006d 2405          	jruge	L1271
2776  006f               L3271:
2777                     ; 138 			*(PointerAttr uint8_t*) (uint16_t)Address = Data;
2779  006f 1e05          	ldw	x,(OFST+5,sp)
2780  0071 7b07          	ld	a,(OFST+7,sp)
2781  0073 f7            	ld	(x),a
2782  0074               L1271:
2783                     ; 140 }
2786  0074 81            	ret	
2820                     ; 149 uint8_t FLASH_ReadByte(uint32_t Address)
2820                     ; 150 {
2821                     	switch	.text
2822  0075               _FLASH_ReadByte:
2824       00000000      OFST:	set	0
2827                     ; 152 	if(IS_FLASH_ADDRESS_OK(Address))
2829  0075 96            	ldw	x,sp
2830  0076 1c0003        	addw	x,#OFST+3
2831  0079 cd0000        	call	c_ltor
2833  007c ae0000        	ldw	x,#L21
2834  007f cd0000        	call	c_lcmp
2836  0082 250f          	jrult	L1571
2838  0084 96            	ldw	x,sp
2839  0085 1c0003        	addw	x,#OFST+3
2840  0088 cd0000        	call	c_ltor
2842  008b ae0004        	ldw	x,#L41
2843  008e cd0000        	call	c_lcmp
2845  0091 251e          	jrult	L7471
2846  0093               L1571:
2848  0093 96            	ldw	x,sp
2849  0094 1c0003        	addw	x,#OFST+3
2850  0097 cd0000        	call	c_ltor
2852  009a ae0008        	ldw	x,#L61
2853  009d cd0000        	call	c_lcmp
2855  00a0 2512          	jrult	L5471
2857  00a2 96            	ldw	x,sp
2858  00a3 1c0003        	addw	x,#OFST+3
2859  00a6 cd0000        	call	c_ltor
2861  00a9 ae000c        	ldw	x,#L02
2862  00ac cd0000        	call	c_lcmp
2864  00af 2403          	jruge	L5471
2865  00b1               L7471:
2866                     ; 155     return(*(PointerAttr uint8_t *) (uint16_t)Address);
2868  00b1 1e05          	ldw	x,(OFST+5,sp)
2869  00b3 f6            	ld	a,(x)
2872  00b4               L5471:
2873                     ; 158 }
2876  00b4 81            	ret	
2889                     	xdef	_FLASH_ReadByte
2890                     	xdef	_FLASH_ProgramByte
2891                     	xdef	_FLASH_DeInit
2892                     	xdef	_FLASH_Unlock
2911                     	xref	c_lcmp
2912                     	xref	c_ltor
2913                     	end
