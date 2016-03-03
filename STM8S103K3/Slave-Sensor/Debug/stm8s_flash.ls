   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2585                     ; 32 void FLASH_Unlock(uint8_t FLASH_MemType)
2585                     ; 33 {
2587                     	switch	.text
2588  0000               _FLASH_Unlock:
2590  0000 88            	push	a
2591       00000000      OFST:	set	0
2594                     ; 35 	if(IS_MEMORY_TYPE_OK(FLASH_MemType));
2596  0001 a1fd          	cp	a,#253
2597  0003 2702          	jreq	L7561
2599  0005 a1f7          	cp	a,#247
2600  0007               L7561:
2601                     ; 39 		if (FLASH_MemType == FLASH_MEMTYPE_PROG)
2603  0007 7b01          	ld	a,(OFST+1,sp)
2604  0009 a1fd          	cp	a,#253
2605  000b 260a          	jrne	L3661
2606                     ; 41 				FLASH_PUKR = FLASH_RASS_KEY1;
2608  000d 35565062      	mov	_FLASH_PUKR,#86
2609                     ; 42 				FLASH_PUKR = FLASH_RASS_KEY2;
2611  0011 35ae5062      	mov	_FLASH_PUKR,#174
2613  0015 2008          	jra	L5661
2614  0017               L3661:
2615                     ; 47 				FLASH_DUKR = FLASH_RASS_KEY2; /* Warning: keys are reversed on data memory !!! */
2617  0017 35ae5064      	mov	_FLASH_DUKR,#174
2618                     ; 48 				FLASH_DUKR = FLASH_RASS_KEY1;
2620  001b 35565064      	mov	_FLASH_DUKR,#86
2621  001f               L5661:
2622                     ; 51 }
2625  001f 84            	pop	a
2626  0020 81            	ret
2653                     ; 73 void FLASH_DeInit(void)
2653                     ; 74 {
2654                     	switch	.text
2655  0021               _FLASH_DeInit:
2659                     ; 75     FLASH_CR1 = FLASH_CR1_RESET_VALUE;
2661  0021 725f505a      	clr	_FLASH_CR1
2662                     ; 76     FLASH_CR2 = FLASH_CR2_RESET_VALUE;
2664  0025 725f505b      	clr	_FLASH_CR2
2665                     ; 77     FLASH_NCR2 = FLASH_NCR2_RESET_VALUE;
2667  0029 35ff505c      	mov	_FLASH_NCR2,#255
2668                     ; 78     FLASH_IAPSR &= (uint8_t)(~FLASH_IAPSR_DUL);
2670  002d 7217505f      	bres	_FLASH_IAPSR,#3
2671                     ; 79     FLASH_IAPSR &= (uint8_t)(~FLASH_IAPSR_PUL);
2673  0031 7213505f      	bres	_FLASH_IAPSR,#1
2674                     ; 80     (void) FLASH_IAPSR; /* Reading of this register causes the clearing of status flags */
2676  0035 c6505f        	ld	a,_FLASH_IAPSR
2677                     ; 81 }
2680  0038 81            	ret
2723                     .const:	section	.text
2724  0000               L21:
2725  0000 00008000      	dc.l	32768
2726  0004               L41:
2727  0004 0000a000      	dc.l	40960
2728  0008               L61:
2729  0008 00004000      	dc.l	16384
2730  000c               L02:
2731  000c 00004280      	dc.l	17024
2732                     ; 133 void FLASH_ProgramByte(uint32_t Address, uint8_t Data)
2732                     ; 134 {
2733                     	switch	.text
2734  0039               _FLASH_ProgramByte:
2736       00000000      OFST:	set	0
2739                     ; 136     if(IS_FLASH_ADDRESS_OK(Address))
2741  0039 96            	ldw	x,sp
2742  003a 1c0003        	addw	x,#OFST+3
2743  003d cd0000        	call	c_ltor
2745  0040 ae0000        	ldw	x,#L21
2746  0043 cd0000        	call	c_lcmp
2748  0046 250f          	jrult	L5271
2750  0048 96            	ldw	x,sp
2751  0049 1c0003        	addw	x,#OFST+3
2752  004c cd0000        	call	c_ltor
2754  004f ae0004        	ldw	x,#L41
2755  0052 cd0000        	call	c_lcmp
2757  0055 251e          	jrult	L3271
2758  0057               L5271:
2760  0057 96            	ldw	x,sp
2761  0058 1c0003        	addw	x,#OFST+3
2762  005b cd0000        	call	c_ltor
2764  005e ae0008        	ldw	x,#L61
2765  0061 cd0000        	call	c_lcmp
2767  0064 2514          	jrult	L1271
2769  0066 96            	ldw	x,sp
2770  0067 1c0003        	addw	x,#OFST+3
2771  006a cd0000        	call	c_ltor
2773  006d ae000c        	ldw	x,#L02
2774  0070 cd0000        	call	c_lcmp
2776  0073 2405          	jruge	L1271
2777  0075               L3271:
2778                     ; 138 			*(PointerAttr uint8_t*) (uint16_t)Address = Data;
2780  0075 7b07          	ld	a,(OFST+7,sp)
2781  0077 1e05          	ldw	x,(OFST+5,sp)
2782  0079 f7            	ld	(x),a
2783  007a               L1271:
2784                     ; 140 }
2787  007a 81            	ret
2821                     ; 149 uint8_t FLASH_ReadByte(uint32_t Address)
2821                     ; 150 {
2822                     	switch	.text
2823  007b               _FLASH_ReadByte:
2825       00000000      OFST:	set	0
2828                     ; 152 	if(IS_FLASH_ADDRESS_OK(Address))
2830  007b 96            	ldw	x,sp
2831  007c 1c0003        	addw	x,#OFST+3
2832  007f cd0000        	call	c_ltor
2834  0082 ae0000        	ldw	x,#L21
2835  0085 cd0000        	call	c_lcmp
2837  0088 250f          	jrult	L1571
2839  008a 96            	ldw	x,sp
2840  008b 1c0003        	addw	x,#OFST+3
2841  008e cd0000        	call	c_ltor
2843  0091 ae0004        	ldw	x,#L41
2844  0094 cd0000        	call	c_lcmp
2846  0097 251e          	jrult	L7471
2847  0099               L1571:
2849  0099 96            	ldw	x,sp
2850  009a 1c0003        	addw	x,#OFST+3
2851  009d cd0000        	call	c_ltor
2853  00a0 ae0008        	ldw	x,#L61
2854  00a3 cd0000        	call	c_lcmp
2856  00a6 2513          	jrult	L5471
2858  00a8 96            	ldw	x,sp
2859  00a9 1c0003        	addw	x,#OFST+3
2860  00ac cd0000        	call	c_ltor
2862  00af ae000c        	ldw	x,#L02
2863  00b2 cd0000        	call	c_lcmp
2865  00b5 2404          	jruge	L5471
2866  00b7               L7471:
2867                     ; 155     return(*(PointerAttr uint8_t *) (uint16_t)Address);
2869  00b7 1e05          	ldw	x,(OFST+5,sp)
2870  00b9 f6            	ld	a,(x)
2873  00ba 81            	ret
2874  00bb               L5471:
2875                     ; 158 }
2878  00bb 81            	ret
2891                     	xdef	_FLASH_ReadByte
2892                     	xdef	_FLASH_ProgramByte
2893                     	xdef	_FLASH_DeInit
2894                     	xdef	_FLASH_Unlock
2913                     	xref	c_lcmp
2914                     	xref	c_ltor
2915                     	end
