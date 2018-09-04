			LIST		p=18f452
			INCLUDE		<P18F452.INC>

			ORG 		0x00
						
RegA		EQU			0x80  
RegB		EQU			0x81

			goto		main

			ORG  		0x04


main
			movlw		0x0A				;Move literal to the WREG
			movwf		RegA, 1				;Move WREG to RegA
			;call		mulByFourTC 		
			;call		mulByFourWC
			;call		clrZCFlag
			call		clrZCFlagAB
			sleep

mulByFourTC									; Routine to multiply RegA by four through the carry
			rlcf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA

			movf		RegA, 0, 1			; Move RegA to the WREG
			;movwf		RegB, 1				; Move WREG to RegB
			return

mulByFourWC									; Routine to multiply RegA by four through the carry
			rlncf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA
			rlncf		RegA, 1, 1			; Mutiply RegA (which is now RegA = 2*RegA) by two

			movf		RegA, 0, 1			; Move RegA to the WREG
			;movwf		RegB, 1				; Move WREG to RegB
			return	

clrZCFlag									;Clear the Carry and Zero Flags in the STATUS Register in bank 15
			movlw		0x0F				;Move 15 into the WREG
			movwf		BSR, 0				;Move 15 into BSR
			bsf 		STATUS, C, 1		;Clear Carry Flag
			bsf			STATUS, Z, 1		;Clear Zero Flag
			return

clrZCFlagAB									;Clear the Carry and Zero Flags in the STATUS Register in bank 15 USING ACCESS BANKING
			bsf 		STATUS, C, 0		;Clear Carry Flag
			bsf			STATUS, Z, 0		;Clear Zero Flag
			return	

			END