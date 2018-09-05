			LIST		p=18f452
			INCLUDE		<P18F452.INC>

			ORG 		0x00
						
RegA		EQU			0x80  
RegB		EQU			0x81
num1Hi		EQU			0x83
num1Lo		EQU			0x84
num2Hi		EQU			0x85
num2Lo		EQU			0x86
resHi		EQU			0x87
resLo		EQU			0x88

			goto		main

			ORG  		0x04


main
			movlw		0x0A				;Move literal to the WREG
			movwf		RegA, 1				;Move WREG to RegA
			;call		mulByFourTC 		
			;call		mulByFourWC
			;call		clrZCFlag
			;call		clrZCFlagAB
			;call		add16BNum
			call 		add16BNumWC
			sleep

mulByFourTC									; Routine to multiply RegA by four through the carry
			rlcf		RegA, W, !A			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, W, !A			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, W, !A			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, W, !A			; Mutiply RegA by two, save the result in RegA
			rlcf		RegA, W, !A			; Mutiply RegA by two, save the result in RegA

			movf		RegA, F, !A			; Move RegA to the WREG
			;movwf		RegB, !A				; Move WREG to RegB
			return

mulByFourWC									; Routine to multiply RegA by four through the carry
			rlncf		RegA, 1, 1			; Mutiply RegA by two, save the result in RegA
			rlncf		RegA, 1, 1			; Mutiply RegA (which is now RegA = 2*RegA) by two

			movf		RegA, 0, 1			; Move RegA to the WREG
			;movwf		RegB, 1				; Move WREG to RegB
			return	

clrZCFlag									;Clear the Carry and Zero Flags in the STATUS Register in bank 15
			movlw		0x0F				;Move 15 into the WREG
			movwf		BSR, A				;Move 15 into BSR
			bsf 		STATUS, C, !A		;Clear Carry Flag
			bsf			STATUS, Z, !A		;Clear Zero Flag
			return

clrZCFlagAB									;Clear the Carry and Zero Flags in the STATUS Register in bank 15 USING ACCESS BANKING
			bsf 		STATUS, C, A		;Clear Carry Flag
			bsf			STATUS, Z, A		;Clear Zero Flag
			return	

add16BNum									;Addition of two 16-bit numbers num1 and num2
			movf		num1Lo, W, !A		;Move num1Lo into the WREG
			addwf		num2Lo, W, !A		;Add num2Lo to WREG store and store in WREG
			movwf 		resLo, !A			;Move WREG to the ResLo Register
			btfsc		STATUS, C, A		;Check if the Carry is SET
			incf		num1Hi, F, !A		; TRUE: Increment the High Byte of Number
											; FALSE: Add the Hi bytes of the two Numbers
			movf		num1Hi, W, !A       ;Move num1Hi into WREG
			addwf       num2Hi, F, !A		;Add num2Hi with WREG and store in WREG
			movwf		resHi,  !A			;Move WREG to resHi
			bcf 		STATUS, C, A		;Clear Carry Flag
			return

add16BNumWC									;Addition of two 16-bit numbers num1 and num2 without the Carry Flag
			bcf			STATUS, C, A 		;Clear Carry Flag
			movf		num1Lo, W, !A 		;Move num1Lo into WREG
			addwfc		num2Lo, W, !A 		;Add num2Lo to WREG and store in WREG
			movwf		resLo, !A 			;Move WREG into resLo
			movf  		num1Hi, W, !A 		;Move num1Hi into WREG
			addwfc 		num2Hi, W, !A 		;Add num2Hi to WREG and store the result in WREG
			movwf		resHi, !A 			;Move WREG into resHi
			return

sub16BNum									;Subtraction of two 16-bit numbers num1 and num2

			return

			END