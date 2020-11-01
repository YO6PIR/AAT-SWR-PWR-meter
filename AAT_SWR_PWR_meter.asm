
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : No
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _RF_power=R4
	.DEF _RF_power_msb=R5
	.DEF _Pwr=R6
	.DEF _Pwr_msb=R7
	.DEF _Pwr_old=R8
	.DEF _Pwr_old_msb=R9
	.DEF _C=R10
	.DEF _C_msb=R11
	.DEF _L=R12
	.DEF _L_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_char0:
	.DB  0x9C,0x98,0x90,0x80,0x98,0x94,0x98,0x94
_char1:
	.DB  0x80,0x80,0x95,0x80,0x80,0x80,0x95,0x80
_char2:
	.DB  0x80,0x95,0x95,0x95,0x80,0x80,0x95,0x80
_char3:
	.DB  0x80,0x80,0x95,0x80,0x80,0x95,0x95,0x95
_char4:
	.DB  0x80,0x95,0x95,0x95,0x80,0x95,0x95,0x95
_L_table_coarsie:
	.DB  0x0,0x1,0x2,0x4,0x5,0x8,0xB,0xE
	.DB  0x12,0x17,0x1C,0x21,0x27,0x2E,0x35,0x3C
	.DB  0x44,0x4D,0x56,0x5F,0x69,0x74,0x7F,0x8A
	.DB  0x96,0xA3,0xB0,0xBD,0xCB,0xDA,0xE9,0xF8
_C_table_coarsie:
	.DB  0x0,0x1,0x2,0x4,0x5,0x8,0xB,0xE
	.DB  0x12,0x17,0x1C,0x21,0x27,0x2E,0x35,0x3C
	.DB  0x44,0x4D,0x56,0x5F,0x69,0x74,0x7F,0x8A
	.DB  0x96,0xA3,0xB0,0xBD,0xCB,0xDA,0xE9,0xF8

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x3E,0x3E,0x3E,0x3E,0x0,0x2C,0x0,0x20
	.DB  0x0,0x4C,0x0,0x30,0x0,0x43,0x0,0x2D
	.DB  0x0,0x42,0x3A,0x33,0x2C,0x35,0x38,0x0
	.DB  0x42,0x3A,0x33,0x2C,0x37,0x30,0x0,0x42
	.DB  0x3A,0x37,0x2C,0x30,0x34,0x0,0x42,0x3A
	.DB  0x37,0x2C,0x31,0x30,0x0,0x42,0x3A,0x31
	.DB  0x30,0x2C,0x31,0x0,0x42,0x3A,0x31,0x34
	.DB  0x2C,0x30,0x0,0x42,0x3A,0x31,0x34,0x2C
	.DB  0x32,0x0,0x42,0x3A,0x31,0x38,0x2C,0x31
	.DB  0x0,0x42,0x3A,0x32,0x31,0x2C,0x30,0x0
	.DB  0x42,0x3A,0x32,0x37,0x2C,0x32,0x0,0x42
	.DB  0x3A,0x32,0x38,0x2C,0x35,0x0,0x52,0x65
	.DB  0x6C,0x65,0x61,0x73,0x65,0x20,0x62,0x75
	.DB  0x74,0x74,0x6F,0x6E,0x21,0x20,0x0,0x20
	.DB  0x55,0x72,0x65,0x66,0x20,0x3D,0x20,0x0
	.DB  0x6D,0x56,0x20,0x20,0x0,0x4F,0x46,0x46
	.DB  0x20,0x3D,0x20,0x66,0x61,0x63,0x74,0x2E
	.DB  0x72,0x65,0x73,0x65,0x74,0x0,0x20,0x31
	.DB  0x57,0x20,0x6C,0x65,0x76,0x65,0x6C,0x3D
	.DB  0x0,0x50,0x72,0x65,0x73,0x73,0x20,0x42
	.DB  0x75,0x74,0x74,0x6F,0x6E,0x20,0x4F,0x4B
	.DB  0x20,0x0,0x20,0x31,0x30,0x57,0x20,0x6C
	.DB  0x65,0x76,0x65,0x6C,0x3D,0x0,0x20,0x20
	.DB  0x20,0x2E,0x2E,0x2E,0x53,0x61,0x76,0x65
	.DB  0x64,0x21,0x20,0x20,0x20,0x20,0x0,0x41
	.DB  0x41,0x54,0x2D,0x53,0x57,0x52,0x2D,0x50
	.DB  0x57,0x52,0x6D,0x65,0x74,0x65,0x72,0x0
	.DB  0x20,0x59,0x4F,0x36,0x50,0x49,0x52,0x2D
	.DB  0x32,0x30,0x32,0x30,0x28,0x43,0x29,0x20
	.DB  0x0,0x20,0x20,0x41,0x55,0x54,0x4F,0x0
	.DB  0x20,0x20,0x4D,0x41,0x4E,0x55,0x0,0x46
	.DB  0x77,0x64,0x0,0x20,0x20,0x52,0x65,0x77
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x53,0x57,0x52,0x3A,0x0,0x20
	.DB  0x20,0x50,0x3D,0x0,0x57,0x0,0x54,0x75
	.DB  0x6E,0x65,0x72,0x20,0x4F,0x46,0x46,0x20
	.DB  0x20,0x20,0x0,0x44,0x65,0x6C,0x61,0x79
	.DB  0x20,0x54,0x69,0x6D,0x65,0x20,0x52,0x65
	.DB  0x6C,0x61,0x79,0x0,0x20,0x6D,0x73,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V3.14 Advanced
;� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : AAT-SWR-PWR meter
;Version : 10.2020
;Date    : 14.10.2020
;Author  : Chiorean Ovidiu
;Company : YO6PIR
;Comments: Program refacut dupa criterii personale
;incorporeaza bargraf cu doua randuri compactate pe o linie de LCD, dupa varianta de la SWR11 Ver.2
;
;Chip type           : ATmega8A
;Clock frequency     : 8,000000 MHz INT_OSC
;*****************************************************/
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <math.h>                                       //rutina de calcule matematice exponentiale
;#include <Calcul_putere_AD8307.h>                       //rutina de calculare a tensiunii, Puterea in [dBm] si [W] si Ca ...

	.CSEG
_Tensiune:
; .FSTART _Tensiune
	RCALL SUBOPT_0x0
;	Uref -> Y+6
;	Div_rez -> Y+2
;	Uadc -> Y+0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	RCALL __DIVW21U
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	CLR  R24
	CLR  R25
	RCALL __CDF2
	RCALL __DIVF21
	POP  R26
	POP  R27
	CLR  R24
	CLR  R25
	RCALL __CDF2
	RCALL __MULF12
	STS  _Volt_masurat,R30
	STS  _Volt_masurat+1,R31
	STS  _Volt_masurat+2,R22
	STS  _Volt_masurat+3,R23
	ADIW R28,8
	RET
; .FEND
_Cal_power:
; .FSTART _Cal_power
	RCALL SUBOPT_0x3
;	ADC_1W -> Y+2
;	ADC_10W -> Y+0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x4
	STS  _U_1W,R30
	STS  _U_1W+1,R31
	STS  _U_1W+2,R22
	STS  _U_1W+3,R23
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	RCALL __PUTPARD1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x4
	STS  _U_10W,R30
	STS  _U_10W+1,R31
	STS  _U_10W+2,R22
	STS  _U_10W+3,R23
	RCALL SUBOPT_0x8
	STS  _S10W,R30
	STS  _S10W+1,R31
	STS  _S10W+2,R22
	STS  _S10W+3,R23
	LDI  R26,LOW(_S10W_cal)
	LDI  R27,HIGH(_S10W_cal)
	RCALL __EEPROMWRD
	RCALL SUBOPT_0x8
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_U_1W
	LDS  R27,_U_1W+1
	LDS  R24,_U_1W+2
	LDS  R25,_U_1W+3
	RCALL SUBOPT_0x9
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xA
	STS  _SW,R30
	STS  _SW+1,R31
	STS  _SW+2,R22
	STS  _SW+3,R23
	LDS  R26,_SW
	LDS  R27,_SW+1
	LDS  R24,_SW+2
	LDS  R25,_SW+3
	RCALL SUBOPT_0xB
	RCALL __DIVF21
	STS  _Step_size,R30
	STS  _Step_size+1,R31
	STS  _Step_size+2,R22
	STS  _Step_size+3,R23
	LDI  R26,LOW(_Step_size_cal)
	LDI  R27,HIGH(_Step_size_cal)
	RCALL __EEPROMWRD
	RJMP _0x20A0007
; .FEND
_Putere:
; .FSTART _Putere
	RCALL SUBOPT_0x3
;	ADC_pwr -> Y+0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _Tensiune
	LDS  R26,_Volt_masurat
	LDS  R27,_Volt_masurat+1
	LDS  R24,_Volt_masurat+2
	LDS  R25,_Volt_masurat+3
	RCALL SUBOPT_0x9
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_S10W_cal)
	LDI  R27,HIGH(_S10W_cal)
	RCALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xA
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_Step_size_cal)
	LDI  R27,HIGH(_Step_size_cal)
	RCALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	__GETD2N 0x42200000
	RCALL __ADDF12
	STS  _dBm_zec,R30
	STS  _dBm_zec+1,R31
	STS  _dBm_zec+2,R22
	STS  _dBm_zec+3,R23
	RCALL SUBOPT_0xB
	RCALL __PUTPARD1
	LDS  R26,_dBm_zec
	LDS  R27,_dBm_zec+1
	LDS  R24,_dBm_zec+2
	LDS  R25,_dBm_zec+3
	RCALL SUBOPT_0xB
	RCALL __DIVF21
	RCALL SUBOPT_0xC
	RCALL _pow
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x9
	RCALL __CFD1U
	MOVW R4,R30
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	CP   R30,R4
	CPC  R31,R5
	BRSH _0x3
	MOVW R4,R30
_0x3:
	RJMP _0x20A0003
; .FEND
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x12 ;PORTD
; 0000 0019 #endasm
;#include <lcd.h>
;#include <delay.h>
;
;#define K1_relay            PORTD.3
;#define PWR_input           PORTC.0
;#define ON                  1
;#define OFF                 0
;#define L_clk               PORTC.3
;#define L_data              PORTC.4
;#define C_clk               PORTC.5
;#define C_data              PORTC.4
;#define SHIFT_register      8
;#define C_steps_coarse      32
;#define L_steps_coarse      32
;#define DELAY_MANUAL_TUNING 200
;#define DELAY_AFTER_RELAY   13
;#define DELAY_BEFORE_RELAY  5
;#define DELAY_SET_RELAY     20
;//	---------- ADCSRA ----------
;#define ADC_INIT		0b10010111
;/*                        |||||\|/________ PRESCALER - Fclk / 128
;                          |||||___________ ADIE interupt enable - DISABLE
;                          |||\____________ ADIF complete convertion flag -CLEAR
;                          ||\_____________ ADFR free runing mode - DISABLE
;						  |\______________ ADSC start convertion - DISABLE
;                          \_______________ ADEN enable ADC - ENABLE */
;
;#define ADC_START_CONVERTION	0b11010101
;/*                                |||||\|/_PRESCALER - Fclk / 32
;                                  |||||____ADIE interupt enable - DISABLE
;                                  |||\_____ADIF complete convertion flag -CLEAR
;                                  ||\______ADFR free runing mode - DISABLE
;						          |\_______ADSC start convertion - ENABLE
;                                  \________ADEN enable ADC - ENABLE*/
;#define ADC_FLAG_READY		0b00010000
;//                               \_________ADIF complete convertion flag -CHECK
;//---------------- ADMUX   -------
;#define ADC_CHANELL_Vrew	0b01000010	   //PortC.2 -Reflectata
;#define ADC_CHANELL_Vfwd	0b01000001	   //PortC.1 -Directa
;#define ADC_CHANELL_Pwr     0b01000000     //PortC.0 -Putere
;//                            \|___________tensiunea de referinta Vcc cu cond ext.la Vref
;
;#define BUTON_C_UP          PINB.6
;#define BUTON_C_DOWN		PINB.1
;#define BUTON_TUNE_SWR		PINB.5
;#define BUTON_L_UP			PINB.0
;#define BUTON_L_DOWN		PINB.7
;#define BUTON_MODE			PINB.2
;#define BUTON_BAND_UP		PINB.3
;#define BUTON_BAND_DOWN		PINB.4
;
;unsigned long Vfwd;                        //tensiunea citita pe intrarea Dir
;unsigned long Vrew;                        //tensiunea citita pe intrarea Ref
;unsigned long swr;                         //valoarea SWR calculata
;unsigned int Pwr, Pwr_old=0;                          //tensiunea de la AD8507 citita pe intrarea PWR_input
;//caracterul F/R miniatura care precede bargraful
;char flash char0 [ 8 ] =
;        {
;        0b10011100,
;        0b10011000,
;        0b10010000,
;	    0b10000000,
;        0b10011000,
;        0b10010100,
;        0b10011000,
;        0b10010100
;        };
;//Spatiu gol fara semnal doua rand.pct
;char flash char1 [ 8 ] =
;        {
;        0b10000000,
;        0b10000000,
;        0b10010101,
;        0b10000000,
;	    0b10000000,
;        0b10000000,
;        0b10010101,
;        0b10000000
;        };
;//Sus plin, jos gol
;char flash char2 [ 8 ] =
;        {
;        0b10000000,
;	    0b10010101,
;        0b10010101,
;        0b10010101,
;        0b10000000,
;        0b10000000,
;        0b10010101,
;        0b10000000
;        };
;//Sus gol, Jos plin
;char flash char3 [ 8 ] =
;        {
;        0b10000000,
;	    0b10000000,
;        0b10010101,
;        0b10000000,
;        0b10000000,
;        0b10010101,
;        0b10010101,
;        0b10010101
;        };
;//Sus plin, Jos plin
;char flash char4 [ 8 ] =
;        {
;        0b10000000,
;	    0b10010101,
;        0b10010101,
;        0b10010101,
;        0b10000000,
;        0b10010101,
;        0b10010101,
;        0b10010101
;        };
;
;unsigned char eeprom DELAY_BEFORE_ADC = 20 ;
;unsigned eeprom  Band_selector;
;unsigned eeprom Ind_min[11]={1,1,1,1,1,1,1,1,1,1,1};        //Inductor minim initial pe fiecare banda (11 benzi de frecv ...
;unsigned eeprom Cap_min[11]={1,1,1,1,1,1,1,1,1,1,1};                                     //Capacitor minim initial pe fi ...
;unsigned eeprom k1_min[11]={1,1,1,1,1,1,1,1,1,1,1};
;unsigned long eeprom swr_min[11]={102,102,102,102,102,102,102,102,102,102,102};             // SWR minim initial pe fiec ...
;unsigned C = 0, L = 0, sweep_relay= 0;
;//unsigned int t=0;
;unsigned send=0;                            //variabila de sistem folosita la selectia transmisiei seriale 0=semd_C; 1=s ...
;char const L_table_coarsie[32] = {0, 1, 2, 4, 5, 8, 11, 14, 18, 23, 28, 33, 39, 46, 53, 60, 68, 77, 86, 95, 105, 116, 12 ...
;char const C_table_coarsie[32] = {0, 1, 2, 4, 5, 8, 11, 14, 18, 23, 28, 33, 39, 46, 53, 60, 68, 77, 86, 95, 105, 116, 12 ...
;
;//******************************** incarca caracterele speciale in Flash ********************************
;void define_char ( char flash *pc, char char_code )
; 0000 009C 	{
_define_char:
; .FSTART _define_char
; 0000 009D     char i, a;
; 0000 009E     a = ( char_code << 3 ) | 0x40;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 009F     for ( i = 0; i < 8; i ++ )
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,8
	BRSH _0x6
; 0000 00A0         lcd_write_byte ( a ++, *pc ++);
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x5
_0x6:
; 0000 00A1 }
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
;//******** rutina de transmisie date catre grupele de relee LC ***************
;void Send_LC (char tmp1, char tmp)
; 0000 00A4         {
_Send_LC:
; .FSTART _Send_LC
; 0000 00A5         char i;
; 0000 00A6         delay_ms ( DELAY_BEFORE_RELAY);
	ST   -Y,R26
	ST   -Y,R17
;	tmp1 -> Y+2
;	tmp -> Y+1
;	i -> R17
	LDI  R26,LOW(5)
	RCALL SUBOPT_0xD
; 0000 00A7         if (send==0) goto Send_C;                                       //selectie transmisie numai Capacitor [C]
	LDS  R30,_send
	LDS  R31,_send+1
	SBIW R30,0
	BREQ _0x8
; 0000 00A8         for ( i=0;i< SHIFT_register; i++)
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,8
	BRSH _0xB
; 0000 00A9             {
; 0000 00AA             if( tmp1 & 0x80 ) L_data = ON; else L_data = OFF;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	BREQ _0xC
	SBI  0x15,4
	RJMP _0xF
_0xC:
	CBI  0x15,4
; 0000 00AB             tmp1 = tmp1 << 1;
_0xF:
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0000 00AC  		    L_clk = OFF;
	CBI  0x15,3
; 0000 00AD             delay_us (DELAY_SET_RELAY);
	RCALL SUBOPT_0xE
; 0000 00AE 		    L_clk = ON;
	SBI  0x15,3
; 0000 00AF             delay_us (DELAY_SET_RELAY);
	RCALL SUBOPT_0xE
; 0000 00B0             }
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 00B1         Send_C:
_0x8:
; 0000 00B2         if (send==1) goto exit_do;                                      //selectie transmisie numai Inductor [L]
	LDS  R26,_send
	LDS  R27,_send+1
	SBIW R26,1
	BREQ _0x17
; 0000 00B3         for ( i=0;i< SHIFT_register; i++)
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,8
	BRSH _0x1A
; 0000 00B4             {
; 0000 00B5             if( tmp & 0x80 ) C_data = ON; else C_data = OFF;
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x1B
	SBI  0x15,4
	RJMP _0x1E
_0x1B:
	CBI  0x15,4
; 0000 00B6             tmp = tmp << 1;
_0x1E:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0000 00B7  		    C_clk = 0;
	CBI  0x15,5
; 0000 00B8             delay_us (DELAY_SET_RELAY);
	RCALL SUBOPT_0xE
; 0000 00B9 		    C_clk = 1;
	SBI  0x15,5
; 0000 00BA             delay_us (DELAY_SET_RELAY);
	RCALL SUBOPT_0xE
; 0000 00BB             }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00BC         delay_ms ( DELAY_AFTER_RELAY);
	LDI  R26,LOW(13)
	RCALL SUBOPT_0xD
; 0000 00BD         exit_do:
_0x17:
; 0000 00BE         }
	RJMP _0x20A0002
; .FEND
;//*************** Rutina de calculare SWR si citire semnale analogice ADC ************************
;void Samples (void)
; 0000 00C1         {
_Samples:
; .FSTART _Samples
; 0000 00C2         char i;
; 0000 00C3         Pwr = Vfwd = Vrew = 0;
	ST   -Y,R17
;	i -> R17
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	MOVW R6,R30
; 0000 00C4 		delay_ms ( DELAY_BEFORE_ADC );
	RCALL SUBOPT_0x12
	LDI  R31,0
	MOVW R26,R30
	RCALL _delay_ms
; 0000 00C5         for ( i = 0; i < 1; i ++ )
	LDI  R17,LOW(0)
_0x26:
	CPI  R17,1
	BRSH _0x27
; 0000 00C6                 {
; 0000 00C7 				ADMUX = ADC_CHANELL_Vfwd;          //GetADC(chanel 1)
	LDI  R30,LOW(65)
	RCALL SUBOPT_0x13
; 0000 00C8                 ADCSRA = ADC_START_CONVERTION;
; 0000 00C9                 while ((ADCSRA & 0x10) == 1 );     //wait until adc is ready
_0x28:
	RCALL SUBOPT_0x14
	BREQ _0x28
; 0000 00CA                 while ((ADCSRA & 0x10) == 0 );     //wait until adc is ready
_0x2B:
	SBIS 0x6,4
	RJMP _0x2B
; 0000 00CB                 Vfwd = ADCW;                       //salveaza valoarea [Vfwd]
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x11
; 0000 00CC 				ADMUX = ADC_CHANELL_Vrew;          //GetADC(chanel 2)
	LDI  R30,LOW(66)
	RCALL SUBOPT_0x13
; 0000 00CD                 ADCSRA = ADC_START_CONVERTION;
; 0000 00CE                 while ((ADCSRA & 0x10) == 1 );     //wait until adc is ready
_0x2E:
	RCALL SUBOPT_0x14
	BREQ _0x2E
; 0000 00CF                 while ((ADCSRA & 0x10) == 0 );     //wait until adc is ready
_0x31:
	SBIS 0x6,4
	RJMP _0x31
; 0000 00D0                 Vrew =  ADCW;                      //salveaza valoarea [Vrew]
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
; 0000 00D1                 ADMUX = ADC_CHANELL_Pwr;           //GetADC(chanel 0)
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x13
; 0000 00D2                 ADCSRA = ADC_START_CONVERTION;
; 0000 00D3                 while ((ADCSRA & 0x10) == 1 );     //wait until adc is ready
_0x34:
	RCALL SUBOPT_0x14
	BREQ _0x34
; 0000 00D4                 while ((ADCSRA & 0x10) == 0 );     //wait until adc is ready
_0x37:
	SBIS 0x6,4
	RJMP _0x37
; 0000 00D5                 Pwr =  ADCW;                       //salveaza valoarea [Pwr]
	__INWR 6,7,4
; 0000 00D6                 };
	SUBI R17,-1
	RJMP _0x26
_0x27:
; 0000 00D7 	   //calculeaza valoarea VSWR in functie de valorile citite
; 0000 00D8         swr=(((Vfwd+Vrew)*100)/(Vfwd-Vrew));
	LDS  R30,_Vrew
	LDS  R31,_Vrew+1
	LDS  R22,_Vrew+2
	LDS  R23,_Vrew+3
	RCALL SUBOPT_0x16
	RCALL __ADDD21
	RCALL SUBOPT_0x17
	RCALL __MULD12U
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_Vrew
	LDS  R27,_Vrew+1
	LDS  R24,_Vrew+2
	LDS  R25,_Vrew+3
	LDS  R30,_Vfwd
	LDS  R31,_Vfwd+1
	LDS  R22,_Vfwd+2
	LDS  R23,_Vfwd+3
	RCALL __SUBD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVD21U
	RCALL SUBOPT_0x18
; 0000 00D9         if ( ( swr > 999 ) || ( Vfwd == 0 )) swr = 999;
	RCALL SUBOPT_0x19
	__CPD2N 0x3E8
	BRSH _0x3B
	RCALL SUBOPT_0x16
	RCALL __CPD02
	BRNE _0x3A
_0x3B:
	RCALL SUBOPT_0x1A
; 0000 00DA         if (Pwr==0) Pwr_old=0;
_0x3A:
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x3D
	CLR  R8
	CLR  R9
; 0000 00DB         }
_0x3D:
	LD   R17,Y+
	RET
; .FEND
;//********************** Rutina de afisare bargraf dublu pe doua randuri ************************
;//                         Versiunea preluata de la SWR11 Ver.2.2019                            *
;//***********************************************************************************************
;void bargraf(char Pos, char Row , char Maxbar , unsigned int Adc1 , unsigned int Adc2 )
; 0000 00E0 {
_bargraf:
; .FSTART _bargraf
; 0000 00E1     char Aplin;                           //nr.bare pline pe randul de sus
; 0000 00E2     char Bplin;                           //nr.bare pline pe randul jos
; 0000 00E3     char Aplin2;                          //nr.bare pline+1  sus
; 0000 00E4     char Bplin2;                                                    //nr.bare pline+1 jos
; 0000 00E5     char Agol ;                                                     //spatii goale sus
; 0000 00E6     char Bgol;                                                      // spatii goale jos
; 0000 00E7     char X , Y;                                                     // variabila de afisare
; 0000 00E8     unsigned int Barval_sus;                                        //val. bargraf sus
; 0000 00E9     unsigned int Barval_jos;                                        //val.bargraf jos
; 0000 00EA     unsigned int Scala;                                             //val.scala
; 0000 00EB 
; 0000 00EC     Scala = 1023 / Maxbar;                                          // variabila de scalare pe bargraf
	RCALL SUBOPT_0x0
	SBIW R28,8
	RCALL __SAVELOCR6
;	Pos -> Y+20
;	Row -> Y+19
;	Maxbar -> Y+18
;	Adc1 -> Y+16
;	Adc2 -> Y+14
;	Aplin -> R17
;	Bplin -> R16
;	Aplin2 -> R19
;	Bplin2 -> R18
;	Agol -> R21
;	Bgol -> R20
;	X -> Y+13
;	Y -> Y+12
;	Barval_sus -> Y+10
;	Barval_jos -> Y+8
;	Scala -> Y+6
	LDD  R30,Y+18
	LDI  R31,0
	LDI  R26,LOW(1023)
	LDI  R27,HIGH(1023)
	RCALL __DIVW21
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00ED     Barval_sus = Adc1 / Scala;                                      //calculeaza nr.de casute pline sus
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RCALL __DIVW21U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 00EE     Aplin = Barval_sus;                                             //conversie
	LDD  R17,Y+10
; 0000 00EF     Agol = Maxbar - Aplin;                                          //calculeaza nr.de casute goale sus
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R21,R30
; 0000 00F0     Barval_jos = Adc2 / Scala;                                      //calculeaza nr.de casute pline jos
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL __DIVW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 00F1     Bplin = Barval_jos;                                             //conversie
	LDD  R16,Y+8
; 0000 00F2     Bgol = Maxbar - Bplin;                                          //calculeaza nr.de casute goale jos
	LDD  R30,Y+18
	SUB  R30,R16
	MOV  R20,R30
; 0000 00F3     Aplin2 = Aplin + 1;                                             //var.casute pline+1 sus
	MOV  R30,R17
	SUBI R30,-LOW(1)
	MOV  R19,R30
; 0000 00F4     Bplin2 = Bplin + 1;                                             //var.casute pline+1 jos
	MOV  R30,R16
	SUBI R30,-LOW(1)
	MOV  R18,R30
; 0000 00F5     lcd_gotoxy(Pos,Row);                                            //localizeaza pozitia bargrafului
	LDD  R30,Y+20
	ST   -Y,R30
	LDD  R26,Y+20
	RCALL _lcd_gotoxy
; 0000 00F6     lcd_putchar(0);                                                 //afiseaza caracterul special <F/R>
	LDI  R26,LOW(0)
	RCALL _lcd_putchar
; 0000 00F7     lcd_gotoxy(Pos+1,Row);                                          //localizeaza pozitia bargrafului pe ecran
	LDD  R30,Y+20
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDD  R26,Y+20
	RCALL _lcd_gotoxy
; 0000 00F8 
; 0000 00F9      if ((Aplin) || (Bplin))                                        //daca se detecteaza semnal pe oricare canal A sau B
	CPI  R17,0
	BRNE _0x3F
	CPI  R16,0
	BRNE _0x3F
	RJMP _0x3E
_0x3F:
; 0000 00FA      {
; 0000 00FB      // 'CONDITIA No.1: A > B
; 0000 00FC      if (Aplin > Bplin)
	CP   R16,R17
	BRSH _0x41
; 0000 00FD             { //caractere egale sus-jos pana la B (cel mai mic)
; 0000 00FE             for ( X=1; X <= Bplin; X ++ ) lcd_putchar ( 4 );
	RCALL SUBOPT_0x1B
_0x43:
	LDD  R26,Y+13
	CP   R16,R26
	BRLO _0x44
	LDI  R26,LOW(4)
	RCALL _lcd_putchar
	RCALL SUBOPT_0x1C
	RJMP _0x43
_0x44:
; 0000 0100 for ( X = Bplin2; X <= Aplin; X ++) lcd_putchar( 2 );
	__PUTBSR 18,13
_0x46:
	LDD  R26,Y+13
	CP   R17,R26
	BRLO _0x47
	LDI  R26,LOW(2)
	RCALL _lcd_putchar
	RCALL SUBOPT_0x1C
	RJMP _0x46
_0x47:
; 0000 0102 for (Y = 1; Y<= Agol; Y ++) lcd_putchar( 1 );
	LDI  R30,LOW(1)
	STD  Y+12,R30
_0x49:
	LDD  R26,Y+12
	CP   R21,R26
	BRLO _0x4A
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RJMP _0x49
_0x4A:
; 0000 0103 }
; 0000 0104      //'CONDITIA No.2: B > A
; 0000 0105      if (Bplin > Aplin)
_0x41:
	CP   R17,R16
	BRSH _0x4B
; 0000 0106             {//'caractere egale sus-jos pana la A (cel mai mic)
; 0000 0107             for (X = 1; X<= Aplin; X ++) lcd_putchar( 4 );
	RCALL SUBOPT_0x1B
_0x4D:
	LDD  R26,Y+13
	CP   R17,R26
	BRLO _0x4E
	LDI  R26,LOW(4)
	RCALL _lcd_putchar
	RCALL SUBOPT_0x1C
	RJMP _0x4D
_0x4E:
; 0000 0109 for (X = Aplin2; X <= Bplin; X ++)  lcd_putchar( 3 );
	__PUTBSR 19,13
_0x50:
	LDD  R26,Y+13
	CP   R16,R26
	BRLO _0x51
	LDI  R26,LOW(3)
	RCALL _lcd_putchar
	RCALL SUBOPT_0x1C
	RJMP _0x50
_0x51:
; 0000 010B for (Y = 1; Y <= Bgol; Y ++) lcd_putchar( 1 );
	LDI  R30,LOW(1)
	STD  Y+12,R30
_0x53:
	LDD  R26,Y+12
	CP   R20,R26
	BRLO _0x54
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RJMP _0x53
_0x54:
; 0000 010C }
; 0000 010D      //'CONDITIA No.3: A = B
; 0000 010E      if (Aplin == Bplin)
_0x4B:
	CP   R16,R17
	BRNE _0x55
; 0000 010F             {//afiseaza ambele caractere pline
; 0000 0110             for (X = 1; X <= Aplin; X ++)  lcd_putchar( 4 );
	RCALL SUBOPT_0x1B
_0x57:
	LDD  R26,Y+13
	CP   R17,R26
	BRLO _0x58
	LDI  R26,LOW(4)
	RCALL _lcd_putchar
	RCALL SUBOPT_0x1C
	RJMP _0x57
_0x58:
; 0000 0113 for (Y = 1; Y <= Agol; Y ++)  lcd_putchar( 1 );
	LDI  R30,LOW(1)
	STD  Y+12,R30
_0x5A:
	LDD  R26,Y+12
	CP   R21,R26
	BRLO _0x5B
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RJMP _0x5A
_0x5B:
; 0000 0114 }
; 0000 0115      }
_0x55:
; 0000 0116      else
	RJMP _0x5C
_0x3E:
; 0000 0117      {
; 0000 0118      //'Daca nu este semnal pe niciun canal afiseaza bargraf gol pe ambele canale pana la maxim bargraf
; 0000 0119      for (X = 1; X <= Maxbar; X ++) lcd_putchar( 1 );
	RCALL SUBOPT_0x1B
_0x5E:
	LDD  R30,Y+18
	LDD  R26,Y+13
	CP   R30,R26
	BRLO _0x5F
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1C
	RJMP _0x5E
_0x5F:
; 0000 011A }
_0x5C:
; 0000 011B }
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
;//******************** Rutina de afisare SWR in valoare numerica pe ecran *********************
;void swr_out(void)
; 0000 011E         {
_swr_out:
; .FSTART _swr_out
; 0000 011F         if ( swr > 900 | swr < 1 )                                              //daca SWR este mai mare de 9 sau ne-sem ...
	RCALL SUBOPT_0x19
	__GETD1N 0x384
	RCALL __GTD12U
	MOV  R0,R30
	RCALL SUBOPT_0x19
	__GETD1N 0x1
	RCALL __LTD12U
	OR   R30,R0
	BREQ _0x60
; 0000 0120             {
; 0000 0121 		    lcd_putsf(">>>>");                                                  //afiseaza "HIGH" in loc de valoarea numerica
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 0122            	swr=999;
	RCALL SUBOPT_0x1A
; 0000 0123             }
; 0000 0124         else
	RJMP _0x61
_0x60:
; 0000 0125             {
; 0000 0126 		    if (swr/100)
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x17
	RCALL __DIVD21U
	RCALL __CPD10
	BREQ _0x62
; 0000 0127 		        lcd_putchar ((swr/100%10)+0x30);                                // afiseaza numar intreg
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1F
; 0000 0128 		        lcd_putsf (",");                                                // virgula
_0x62:
	__POINTW2FN _0x0,5
	RCALL _lcd_putsf
; 0000 0129 		        lcd_putchar (((swr/10)%10)+0x30);                               // prima zecimala
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1F
; 0000 012A 		        lcd_putchar ((swr%10)+0x30);                                    // a doua zecimala
	RCALL SUBOPT_0x20
	RCALL __MODD21U
	RCALL SUBOPT_0x21
; 0000 012B             }
_0x61:
; 0000 012C          }
	RET
; .FEND
;//********* Rutina de Formatare pentru afisare analogica cu 4 cifre [0000] **************************
;      bit sar;
;void Formateaza( int tmp )
; 0000 0130       {
_Formateaza:
; .FSTART _Formateaza
; 0000 0131       if (sar) goto trei_cifre;
	RCALL SUBOPT_0x0
;	tmp -> Y+0
	SBRC R2,0
	RJMP _0x64
; 0000 0132       if (tmp/1000) lcd_putchar(tmp / 1000+0x30); else lcd_putsf(" ");          //mii sau simbolul ":" daca valoarea=0
	RCALL SUBOPT_0x22
	SBIW R30,0
	BREQ _0x65
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x21
	RJMP _0x66
_0x65:
	RCALL SUBOPT_0x23
; 0000 0133       trei_cifre:
_0x66:
_0x64:
; 0000 0134       if ((tmp/100)) lcd_putchar((tmp/100)%10+0x30); else lcd_putsf(" ");       //sute
	RCALL SUBOPT_0x24
	SBIW R30,0
	BREQ _0x67
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RJMP _0x68
_0x67:
	RCALL SUBOPT_0x23
; 0000 0135       if ((tmp/10)) lcd_putchar ((tmp/10)%10+0x30); else lcd_putsf(" ");        //zeci
_0x68:
	RCALL SUBOPT_0x26
	SBIW R30,0
	BREQ _0x69
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x25
	RJMP _0x6A
_0x69:
	RCALL SUBOPT_0x23
; 0000 0136       lcd_putchar (tmp%10+0x30);                                                //unitati
_0x6A:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RCALL SUBOPT_0x21
; 0000 0137       sar=OFF;
	CLT
	BLD  R2,0
; 0000 0138       }
	RJMP _0x20A0003
; .FEND
;//******************** Rutina de formatare si afisare valoare L (inductor) *************************
;void l_out(char inductor)
; 0000 013B         {
_l_out:
; .FSTART _l_out
; 0000 013C         if (sweep_relay) lcd_gotoxy(5,0); else lcd_gotoxy (0,0);
	RCALL SUBOPT_0x27
;	inductor -> Y+0
	BREQ _0x6B
	LDI  R30,LOW(5)
	RJMP _0x123
_0x6B:
	LDI  R30,LOW(0)
_0x123:
	ST   -Y,R30
	RCALL SUBOPT_0x28
; 0000 013D         lcd_putsf ("L");
	__POINTW2FN _0x0,9
	RCALL SUBOPT_0x29
; 0000 013E         if (inductor/100) lcd_putchar ((inductor/100)%10+0x30); else lcd_putsf("0");
	BREQ _0x6D
	RCALL SUBOPT_0x2A
	RJMP _0x6E
_0x6D:
	RCALL SUBOPT_0x2B
; 0000 013F         if (inductor/10) lcd_putchar ((inductor/10)%10+0x30); else lcd_putsf("0");
_0x6E:
	RCALL SUBOPT_0x2C
	CPI  R30,0
	BREQ _0x6F
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RJMP _0x70
_0x6F:
	RCALL SUBOPT_0x2B
; 0000 0140         lcd_putchar (inductor%10+0x30);
_0x70:
	RCALL SUBOPT_0x2E
; 0000 0141         }
	RJMP _0x20A0001
; .FEND
;//******************* Rutina de formatare si afisare C (capacitor) **************************
;void c_out(char capacity)
; 0000 0144         {
_c_out:
; .FSTART _c_out
; 0000 0145         if ( sweep_relay ) lcd_gotoxy(0,0); else lcd_gotoxy ( 5, 0 );
	RCALL SUBOPT_0x27
;	capacity -> Y+0
	BREQ _0x71
	LDI  R30,LOW(0)
	RJMP _0x124
_0x71:
	LDI  R30,LOW(5)
_0x124:
	ST   -Y,R30
	RCALL SUBOPT_0x28
; 0000 0146         lcd_putsf ("C");
	__POINTW2FN _0x0,13
	RCALL SUBOPT_0x29
; 0000 0147         if (capacity/100) lcd_putchar ((capacity/100)%10+0x30); else lcd_putsf("0");
	BREQ _0x73
	RCALL SUBOPT_0x2A
	RJMP _0x74
_0x73:
	RCALL SUBOPT_0x2B
; 0000 0148         if (capacity/10) lcd_putchar ((capacity/10)%10+0x30); else lcd_putsf("0");
_0x74:
	RCALL SUBOPT_0x2C
	CPI  R30,0
	BREQ _0x75
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RJMP _0x76
_0x75:
	RCALL SUBOPT_0x2B
; 0000 0149         lcd_putchar (capacity%10+0x30);
_0x76:
	RCALL SUBOPT_0x2E
; 0000 014A         }
	RJMP _0x20A0001
; .FEND
;void tunner(void)
; 0000 014C         {
_tunner:
; .FSTART _tunner
; 0000 014D         swr = swr_min [ Band_selector ];                            //citeste SWR minim memorat pt.banda selectata
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	RCALL __EEPROMRDD
	RCALL SUBOPT_0x18
; 0000 014E         C = Cap_min [ Band_selector ];                              //citeste Capacitor minim memorat pt.banda selectata
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x31
	RCALL __EEPROMRDW
	MOVW R10,R30
; 0000 014F         L = Ind_min [ Band_selector ];                              //citeste Capacitor minim memorat pt.banda selectata
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x31
	RCALL __EEPROMRDW
	MOVW R12,R30
; 0000 0150         sweep_relay = k1_min [ Band_selector ];                     //citeste pozitia releului pt.banda selectata
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x31
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x35
; 0000 0151         K1_relay = sweep_relay;                                     //seteaza releul
	LDS  R30,_sweep_relay
	CPI  R30,0
	BRNE _0x77
	CBI  0x12,3
	RJMP _0x78
_0x77:
	SBI  0x12,3
_0x78:
; 0000 0152         send=2;
	RCALL SUBOPT_0x36
; 0000 0153         Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C in functie de valorile L si C c ...
; 0000 0154         c_out (C_table_coarsie [ C ] );                             //afiseaza valoarea condensatorului citit
	RCALL SUBOPT_0x37
; 0000 0155         l_out (L_table_coarsie [ L ] );                             //afiseaza valoarea inductorului citit
; 0000 0156         lcd_gotoxy(4,0);
	RCALL SUBOPT_0x38
; 0000 0157         lcd_putsf("-");}
	__POINTW2FN _0x0,15
	RCALL _lcd_putsf
	RET
; .FEND
;//**************** Rutina de comutare a benzii de lucru ***********************
;void band_out(void)
; 0000 015A         {
_band_out:
; .FSTART _band_out
; 0000 015B         lcd_gotoxy(10,0);
	RCALL SUBOPT_0x39
; 0000 015C 
; 0000 015D 		if ( Band_selector == 0 )
	RCALL SUBOPT_0x2F
	SBIW R30,0
	BRNE _0x79
; 0000 015E  			 lcd_putsf("B:3,58");
	__POINTW2FN _0x0,17
	RJMP _0x125
; 0000 015F 		else if ( Band_selector == 1 )
_0x79:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7B
; 0000 0160  			 lcd_putsf("B:3,70");
	RJMP _0x126
; 0000 0161 		else if ( Band_selector == 2 )
_0x7B:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7D
; 0000 0162  			 lcd_putsf("B:7,04");
	__POINTW2FN _0x0,31
	RJMP _0x125
; 0000 0163 		else if ( Band_selector == 3 )
_0x7D:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7F
; 0000 0164  			 lcd_putsf("B:7,10");
	__POINTW2FN _0x0,38
	RJMP _0x125
; 0000 0165 		else if ( Band_selector == 4 )
_0x7F:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x81
; 0000 0166  			 lcd_putsf("B:10,1");
	__POINTW2FN _0x0,45
	RJMP _0x125
; 0000 0167 		else if ( Band_selector == 5 )
_0x81:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x83
; 0000 0168  			 lcd_putsf("B:14,0");
	__POINTW2FN _0x0,52
	RJMP _0x125
; 0000 0169 		else if ( Band_selector == 6 )
_0x83:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x85
; 0000 016A  			 lcd_putsf("B:14,2");
	__POINTW2FN _0x0,59
	RJMP _0x125
; 0000 016B 		else if ( Band_selector == 7 )
_0x85:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x87
; 0000 016C  			 lcd_putsf("B:18,1");
	__POINTW2FN _0x0,66
	RJMP _0x125
; 0000 016D 		else if ( Band_selector == 8 )
_0x87:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x89
; 0000 016E  			 lcd_putsf("B:21,0");
	__POINTW2FN _0x0,73
	RJMP _0x125
; 0000 016F 		else if ( Band_selector == 9 )
_0x89:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x8B
; 0000 0170  			 lcd_putsf("B:27,2");
	__POINTW2FN _0x0,80
	RJMP _0x125
; 0000 0171 		else if ( Band_selector == 10 )
_0x8B:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x8D
; 0000 0172  			 lcd_putsf("B:28,5");
	__POINTW2FN _0x0,87
	RJMP _0x125
; 0000 0173         else
_0x8D:
; 0000 0174             {
; 0000 0175  			Band_selector = 1;
	LDI  R26,LOW(_Band_selector)
	LDI  R27,HIGH(_Band_selector)
	RCALL SUBOPT_0x3A
	RCALL __EEPROMWRW
; 0000 0176  			lcd_putsf("B:3,70");
_0x126:
	__POINTW2FN _0x0,24
_0x125:
	RCALL _lcd_putsf
; 0000 0177             }
; 0000 0178         tunner();                                                           //executa noile ajustari in functie de banda ...
	RCALL _tunner
; 0000 0179         }
	RET
; .FEND
;//rutina de setare a nivelului de putere pentru [Vref, ADC_1W, ADC_10W]
;#include <setari.h>
_setari:
; .FSTART _setari
	RCALL _lcd_clear
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x1389)
	LDI  R26,HIGH(0x1389)
	CPC  R31,R26
	BRLO _0x8F
	LDI  R26,LOW(_Uref)
	LDI  R27,HIGH(_Uref)
	LDI  R30,LOW(4960)
	LDI  R31,HIGH(4960)
	RCALL __EEPROMWRW
_0x8F:
	RCALL SUBOPT_0x3B
	LDI  R30,LOW(416)
	LDI  R31,HIGH(416)
	RCALL __EEPROMWRW
	RCALL SUBOPT_0x3C
	LDI  R30,LOW(465)
	LDI  R31,HIGH(465)
	RCALL __EEPROMWRW
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
	__POINTW2FN _0x0,94
	RCALL _lcd_putsf
_0x90:
	SBIS 0x16,5
	RJMP _0x90
_0x93:
	RCALL _lcd_clear
	__POINTW2FN _0x0,111
	RCALL _lcd_putsf
	RCALL SUBOPT_0x5
	MOVW R26,R30
	RCALL _Formateaza
	__POINTW2FN _0x0,120
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	__POINTW2FN _0x0,125
	RCALL _lcd_putsf
	SBIC 0x16,3
	RJMP _0x94
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x157C)
	LDI  R26,HIGH(0x157C)
	CPC  R31,R26
	BRSH _0x95
	RCALL SUBOPT_0x5
	ADIW R30,1
	RCALL __EEPROMWRW
_0x95:
_0x94:
	SBIC 0x16,4
	RJMP _0x96
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x1195)
	LDI  R26,HIGH(0x1195)
	CPC  R31,R26
	BRLO _0x97
	RCALL SUBOPT_0x5
	SBIW R30,1
	RCALL __EEPROMWRW
_0x97:
_0x96:
	RCALL SUBOPT_0x41
	SBIS 0x16,5
	RJMP _0x99
	RJMP _0x93
_0x99:
_0x9A:
	SBIS 0x16,5
	RJMP _0x9A
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x28
	__POINTW2FN _0x0,142
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x40
	__POINTW2FN _0x0,153
	RCALL _lcd_putsf
	SBIS 0x16,5
	RJMP _0x9E
	RJMP _0x99
_0x9E:
	MOVW R30,R6
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x44
_0x9F:
_0xA0:
	SBIS 0x16,5
	RJMP _0xA0
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x28
	__POINTW2FN _0x0,170
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x40
	__POINTW2FN _0x0,153
	RCALL _lcd_putsf
	SBIS 0x16,5
	RJMP _0xA4
	RJMP _0x9F
_0xA4:
	MOVW R30,R6
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
	__POINTW2FN _0x0,182
	RCALL _lcd_putsf
	RCALL SUBOPT_0x3D
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
	RCALL _lcd_clear
	RET
; .FEND
;
;//*****************************************************************************************
;//**************************** RUTINA PRINCIPALA DE PROGRAM  ******************************
;//*****************************************************************************************
;void main(void)
; 0000 0181         {
_main:
; .FSTART _main
; 0000 0182         DDRB =  0b00000000;  //configure PortB intrari
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0183         PORTB = 0b11111111;  //pull-up PortB pt butoane
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0184         DDRC =  0b11111000;  //configure PortC(0,1,2) intrari, restul (3,4,5,6,7)iesiri
	LDI  R30,LOW(248)
	OUT  0x14,R30
; 0000 0185         DDRD =  0b11111111;  //configure portD iesiri
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0186 
; 0000 0187         lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0188         lcd_clear();
	RCALL _lcd_clear
; 0000 0189         lcd_putsf("AAT-SWR-PWRmeter");
	__POINTW2FN _0x0,199
	RCALL _lcd_putsf
; 0000 018A         lcd_putsf(" YO6PIR-2020(C) ");
	__POINTW2FN _0x0,216
	RCALL _lcd_putsf
; 0000 018B         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 018C         if (! BUTON_TUNE_SWR) setari();                                  //daca se apasa butonul TUNE se intra in setari
	SBIS 0x16,5
	RCALL _setari
; 0000 018D         lcd_clear();
	RCALL _lcd_clear
; 0000 018E         define_char ( char0, 0 );
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(0)
	RCALL _define_char
; 0000 018F         define_char ( char1, 1 );
	LDI  R30,LOW(_char1*2)
	LDI  R31,HIGH(_char1*2)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(1)
	RCALL _define_char
; 0000 0190         define_char ( char2, 2 );
	LDI  R30,LOW(_char2*2)
	LDI  R31,HIGH(_char2*2)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(2)
	RCALL _define_char
; 0000 0191         define_char ( char3, 3 );
	LDI  R30,LOW(_char3*2)
	LDI  R31,HIGH(_char3*2)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(3)
	RCALL _define_char
; 0000 0192         define_char ( char4, 4 );
	LDI  R30,LOW(_char4*2)
	LDI  R31,HIGH(_char4*2)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(4)
	RCALL _define_char
; 0000 0193         goto StandBy_Menu;
	RJMP _0xA6
; 0000 0194         // Verifica apasarea butonului TUNE
; 0000 0195         tune_swr_key:
_0xA7:
; 0000 0196                          delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 0197                          if ( BUTON_TUNE_SWR )
	SBIS 0x16,5
	RJMP _0xA8
; 0000 0198                                 {
; 0000 0199                                 lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL SUBOPT_0x40
; 0000 019A                                 lcd_putsf("    ");
	__POINTW2FN _0x0,194
	RCALL SUBOPT_0x45
; 0000 019B                                 band_out();
; 0000 019C                                 goto StandBy_Menu;
	RJMP _0xA6
; 0000 019D                                 }
; 0000 019E                          else goto tune;
_0xA8:
; 0000 019F 
; 0000 01A0         //-----------------------------------------------------------
; 0000 01A1         // MODUL DE ACORDARE AUTOMATA - <Automatik Antenna Tunning>  |
; 0000 01A2         //-----------------------------------------------------------
; 0000 01A3         tune:
; 0000 01A4                 send=2;                                                                 //seteaza ambele seturi de relee
	RCALL SUBOPT_0x36
; 0000 01A5                 Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );                //comuta releele L/C
; 0000 01A6                 swr_min [ Band_selector ] = swr;
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x46
; 0000 01A7                 while ( ! BUTON_TUNE_SWR );
_0xAB:
	SBIS 0x16,5
	RJMP _0xAB
; 0000 01A8                         lcd_gotoxy(10,0);
	RCALL SUBOPT_0x39
; 0000 01A9                         lcd_putsf("  AUTO");
	__POINTW2FN _0x0,233
	RCALL _lcd_putsf
; 0000 01AA                  for (C=0; C<32; C ++)
	CLR  R10
	CLR  R11
_0xAF:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CP   R10,R30
	CPC  R11,R31
	BRLO PC+2
	RJMP _0xB0
; 0000 01AB                         {
; 0000 01AC                         if (C==31)
	RCALL SUBOPT_0x47
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xB1
; 0000 01AD                             {
; 0000 01AE                             if (sweep_relay) sweep_relay=0; else sweep_relay=1;
	RCALL SUBOPT_0x48
	SBIW R30,0
	BREQ _0xB2
	RCALL SUBOPT_0x49
	RJMP _0xB3
_0xB2:
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x35
; 0000 01AF                             C=0;
_0xB3:
	CLR  R10
	CLR  R11
; 0000 01B0                             }
; 0000 01B1 
; 0000 01B2                         for  (L=0;L<32; L ++ )
_0xB1:
	CLR  R12
	CLR  R13
_0xB5:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CP   R12,R30
	CPC  R13,R31
	BRSH _0xB6
; 0000 01B3                             {
; 0000 01B4                             send=2;
	RCALL SUBOPT_0x36
; 0000 01B5                             Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C
; 0000 01B6                             c_out ( C_table_coarsie [ C ] );                            //afiseaza valoarea C
	RCALL SUBOPT_0x37
; 0000 01B7                             l_out (L_table_coarsie [ L ] );                             //afiseaza valoarea L
; 0000 01B8                             Samples ( );                                                //verifica semnalele ADC
	RCALL SUBOPT_0x42
; 0000 01B9                             bargraf (0,1,11,Vfwd,Vrew );                                //afiseaza bargraf
	RCALL SUBOPT_0x4A
; 0000 01BA 
; 0000 01BB                             if ( (swr_min [ Band_selector ] >= swr) && ( swr >= 100) )
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	RCALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_swr
	LDS  R31,_swr+1
	LDS  R22,_swr+2
	LDS  R23,_swr+3
	RCALL __CPD21
	BRLO _0xB8
	RCALL SUBOPT_0x19
	__CPD2N 0x64
	BRSH _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
; 0000 01BC                                 {
; 0000 01BD                                 swr_min [ Band_selector ] = swr;                        //salveaza noua valoare swr
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x46
; 0000 01BE                                 swr_out();                                              //afiseaza valoarea Min. SWR
	RCALL _swr_out
; 0000 01BF                                 Cap_min [ Band_selector ] = C;                          //salveaza noua valoare C
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x4B
	RCALL __EEPROMWRW
; 0000 01C0                                 Ind_min [ Band_selector ] = L;                          //salveaza noua valoare L
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x4C
	RCALL __EEPROMWRW
; 0000 01C1                                 k1_min [ Band_selector ] = sweep_relay;                 //salveaza noua valoare releu KL
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x4D
; 0000 01C2                                 }
; 0000 01C3                             //daca se apasa scurt butonul TUNE sau SWR este mai mic de 1,09....
; 0000 01C4                             if (! BUTON_TUNE_SWR || swr == 102 ) goto StandBy_Menu;
_0xB7:
	SBIS 0x16,5
	RJMP _0xBB
	RCALL SUBOPT_0x19
	__CPD2N 0x66
	BRNE _0xBA
_0xBB:
	RJMP _0xA6
; 0000 01C5                             }
_0xBA:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0xB5
_0xB6:
; 0000 01C6                         }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0xAF
_0xB0:
; 0000 01C7         //------------------------------------------------------
; 0000 01C8         // MODUL DE ACORDARE MANUALA - <Manual Antenna Tunning> |
; 0000 01C9         //------------------------------------------------------
; 0000 01CA         manual:
_0xBD:
; 0000 01CB                  while (1)
_0xBE:
; 0000 01CC                         {
; 0000 01CD                         lcd_gotoxy(4,0);
	RCALL SUBOPT_0x38
; 0000 01CE                         lcd_putchar(0xEE);                          //afiseaza caracter special
	LDI  R26,LOW(238)
	RCALL _lcd_putchar
; 0000 01CF                         lcd_gotoxy(10,0);
	RCALL SUBOPT_0x39
; 0000 01D0                         lcd_putsf("  MANU");
	__POINTW2FN _0x0,240
	RCALL _lcd_putsf
; 0000 01D1                         Samples ();                                 //citeste semnale analogice si calculeaza SWR
	RCALL SUBOPT_0x42
; 0000 01D2                         bargraf (0,1,11,Vfwd,Vrew );                //afiseaza bargraf pe linia 2
	RCALL SUBOPT_0x4A
; 0000 01D3                         swr_out();                                  //afiseaza SWR
	RCALL _swr_out
; 0000 01D4                         c_out( C_table_coarsie[C] );                //afiseaza valoarea C
	RCALL SUBOPT_0x37
; 0000 01D5                 		l_out(L_table_coarsie[L] );                 //afiseaza valoarea L
; 0000 01D6 
; 0000 01D7                         if ( ! BUTON_C_UP )
	SBIC 0x16,6
	RJMP _0xC1
; 0000 01D8                                {
; 0000 01D9                                if (C < 31) C ++; else C = 0;
	RCALL SUBOPT_0x47
	CP   R10,R30
	CPC  R11,R31
	BRSH _0xC2
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0xC3
_0xC2:
	CLR  R10
	CLR  R11
; 0000 01DA                                send = 0;                                                //selecteaza releele de Condensa ...
_0xC3:
	RCALL SUBOPT_0x4E
; 0000 01DB                                Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] ); //comuta releele L/C
; 0000 01DC                                Cap_min[ Band_selector ] = C;                            //salveaza valoarea setata in EE ...
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x44
; 0000 01DD 		                       delay_ms(DELAY_MANUAL_TUNING);
; 0000 01DE                                };
_0xC1:
; 0000 01DF 
; 0000 01E0                         if ( ! BUTON_C_DOWN )
	SBIC 0x16,1
	RJMP _0xC4
; 0000 01E1                             {
; 0000 01E2                             if (C > 0) C --; else C = 31;
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRSH _0xC5
	MOVW R30,R10
	SBIW R30,1
	RJMP _0x127
_0xC5:
	RCALL SUBOPT_0x47
_0x127:
	MOVW R10,R30
; 0000 01E3                             send=0;                                                     //selecteaza releele de Condensa ...
	RCALL SUBOPT_0x4E
; 0000 01E4                             Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C
; 0000 01E5                             Cap_min[ Band_selector ]=C;                                 //salveaza valoarea setata in EE ...
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x44
; 0000 01E6 		                    delay_ms(DELAY_MANUAL_TUNING);
; 0000 01E7                             };
_0xC4:
; 0000 01E8 
; 0000 01E9                         if ( ! BUTON_L_UP )
	SBIC 0x16,0
	RJMP _0xC7
; 0000 01EA                            {
; 0000 01EB                            if (L < 31) L ++; else L = 0;
	RCALL SUBOPT_0x47
	CP   R12,R30
	CPC  R13,R31
	BRSH _0xC8
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0xC9
_0xC8:
	CLR  R12
	CLR  R13
; 0000 01EC                            send=1;                                                      //selecteaza releele de Inductor ...
_0xC9:
	RCALL SUBOPT_0x4F
; 0000 01ED                            Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );     //comuta releele L/C
; 0000 01EE                            Ind_min[ Band_selector ]= L;                                 //salveaza valoarea setata in EE ...
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x44
; 0000 01EF 		                   delay_ms(DELAY_MANUAL_TUNING);
; 0000 01F0                            };
_0xC7:
; 0000 01F1 
; 0000 01F2                         if (! BUTON_L_DOWN )
	SBIC 0x16,7
	RJMP _0xCA
; 0000 01F3                             {
; 0000 01F4                             if (L > 0) --L; else L = 31;
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRSH _0xCB
	MOVW R30,R12
	SBIW R30,1
	RJMP _0x128
_0xCB:
	RCALL SUBOPT_0x47
_0x128:
	MOVW R12,R30
; 0000 01F5                             send=1;                                                     //selecteaza releele de Inductor ...
	RCALL SUBOPT_0x4F
; 0000 01F6                             Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C
; 0000 01F7                             Ind_min[ Band_selector ] = L;                               //salveaza valoarea setata in EE ...
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x44
; 0000 01F8 		                    delay_ms(DELAY_MANUAL_TUNING);
; 0000 01F9                             };
_0xCA:
; 0000 01FA 
; 0000 01FB                         if ( ! BUTON_BAND_UP )
	SBIC 0x16,3
	RJMP _0xCD
; 0000 01FC                             {
; 0000 01FD                                 do
_0xCF:
; 0000 01FE                                 {
; 0000 01FF                                 if ( sweep_relay ) sweep_relay = 0; else sweep_relay = 1;
	RCALL SUBOPT_0x48
	SBIW R30,0
	BREQ _0xD1
	RCALL SUBOPT_0x49
	RJMP _0xD2
_0xD1:
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x35
; 0000 0200                                 }
_0xD2:
; 0000 0201                             while ( BUTON_BAND_UP );
	SBIC 0x16,3
	RJMP _0xCF
; 0000 0202                             while ( ! BUTON_BAND_UP );
_0xD3:
	SBIS 0x16,3
	RJMP _0xD3
; 0000 0203                             k1_min [ Band_selector ] = sweep_relay;                     //salveaza valoarea setata in EE ...
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x4D
; 0000 0204 		                    K1_relay = sweep_relay;                                     //comuta releul L/C la noua valoare
	LDS  R30,_sweep_relay
	CPI  R30,0
	BRNE _0xD6
	CBI  0x12,3
	RJMP _0xD7
_0xD6:
	SBI  0x12,3
_0xD7:
; 0000 0205                             };
_0xCD:
; 0000 0206 
; 0000 0207                         if ( ! BUTON_MODE )
	SBIC 0x16,2
	RJMP _0xD8
; 0000 0208                             {
; 0000 0209                             lcd_gotoxy(4,0);
	RCALL SUBOPT_0x38
; 0000 020A                             lcd_putsf(" ");
	RCALL SUBOPT_0x23
; 0000 020B                             while (! BUTON_MODE);
_0xD9:
	SBIS 0x16,2
	RJMP _0xD9
; 0000 020C                             goto StandBy_Menu;
	RJMP _0xA6
; 0000 020D                             }
; 0000 020E                         if ( ! BUTON_TUNE_SWR ) goto tune_swr_key;
_0xD8:
	SBIS 0x16,5
	RJMP _0xA7
; 0000 020F                         }
	RJMP _0xBE
; 0000 0210 
; 0000 0211 StandBy_Menu:
_0xA6:
; 0000 0212         band_out();                                                 //afiseaza banda
	RCALL _band_out
; 0000 0213         tunner();                                                   //acordeaza tunerul
	RCALL _tunner
; 0000 0214             while (1)                                               //executa o bucla inchisa de program
; 0000 0215                  {
; 0000 0216         again:
_0xE0:
; 0000 0217                  Samples();                                         //verifica semnalele analogice
	RCALL SUBOPT_0x42
; 0000 0218                  bargraf (0,1,11,Vfwd,Vrew );                       //afiseaza bargraf pe linia de jos HOME L
	RCALL SUBOPT_0x4A
; 0000 0219                  swr_out();                                         //afiseaza valoarea SWR
	RCALL _swr_out
; 0000 021A                  if ( ! BUTON_TUNE_SWR ){delay_ms(50); goto tune_swr_key;};
	SBIC 0x16,5
	RJMP _0xE1
	RCALL SUBOPT_0x50
	RJMP _0xA7
_0xE1:
; 0000 021B 
; 0000 021C                  if ( ! BUTON_BAND_UP )                              //butonul BAND-UP apasat
	SBIC 0x16,3
	RJMP _0xE2
; 0000 021D                     {
; 0000 021E                     if ( Band_selector < 10) Band_selector ++; else Band_selector = 0;
	RCALL SUBOPT_0x2F
	SBIW R30,10
	BRSH _0xE3
	RCALL SUBOPT_0x2F
	ADIW R30,1
	RJMP _0x129
_0xE3:
	LDI  R26,LOW(_Band_selector)
	LDI  R27,HIGH(_Band_selector)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x129:
	RCALL __EEPROMWRW
; 0000 021F                     band_out();
	RCALL _band_out
; 0000 0220                     while (! BUTON_BAND_UP);
_0xE5:
	SBIS 0x16,3
	RJMP _0xE5
; 0000 0221                     };
_0xE2:
; 0000 0222 
; 0000 0223                  if ( ! BUTON_BAND_DOWN )                   //butonul BAND-DOWN apasat
	SBIC 0x16,4
	RJMP _0xE8
; 0000 0224                     {
; 0000 0225                     if (Band_selector > 0) Band_selector --; else Band_selector = 10;
	RCALL SUBOPT_0x2F
	RCALL __CPW01
	BRSH _0xE9
	RCALL SUBOPT_0x2F
	SBIW R30,1
	RJMP _0x12A
_0xE9:
	LDI  R26,LOW(_Band_selector)
	LDI  R27,HIGH(_Band_selector)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x12A:
	RCALL __EEPROMWRW
; 0000 0226                     band_out();
	RCALL _band_out
; 0000 0227                     while (! BUTON_BAND_DOWN);
_0xEB:
	SBIS 0x16,4
	RJMP _0xEB
; 0000 0228                     };
_0xE8:
; 0000 0229 
; 0000 022A                  if (! BUTON_C_UP ){delay_ms(50); goto DirRef;}
	SBIC 0x16,6
	RJMP _0xEE
	RCALL SUBOPT_0x50
	RJMP _0xEF
; 0000 022B 
; 0000 022C                  if ( ! BUTON_C_DOWN ) {delay_ms(50); goto SWR11;}
_0xEE:
	SBIC 0x16,1
	RJMP _0xF0
	RCALL SUBOPT_0x50
	RJMP _0xF1
; 0000 022D 
; 0000 022E                  if (! BUTON_L_UP ) {delay_ms(50); goto TunnerOff;}
_0xF0:
	SBIC 0x16,0
	RJMP _0xF2
	RCALL SUBOPT_0x50
	RJMP _0xF3
; 0000 022F 
; 0000 0230                  if (! BUTON_L_DOWN ){delay_ms(50); goto DelayRelay;}
_0xF2:
	SBIC 0x16,7
	RJMP _0xF4
	RCALL SUBOPT_0x50
	RJMP _0xF5
; 0000 0231 
; 0000 0232                  if ( ! BUTON_MODE ){while (! BUTON_MODE); goto manual;}
_0xF4:
	SBIC 0x16,2
	RJMP _0xF6
_0xF7:
	SBIS 0x16,2
	RJMP _0xF7
	RJMP _0xBD
; 0000 0233                  goto again;
_0xF6:
	RJMP _0xE0
; 0000 0234         DirRef:
_0xEF:
; 0000 0235                     {
; 0000 0236                     while (! BUTON_C_UP);
_0xFA:
	SBIS 0x16,6
	RJMP _0xFA
; 0000 0237                         do
_0xFE:
; 0000 0238                         {
; 0000 0239                         Samples ();                         //verifica semnale analogice si calc.SWR
	RCALL SUBOPT_0x42
; 0000 023A                         lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x28
; 0000 023B                         lcd_putsf ("Fwd");
	__POINTW2FN _0x0,247
	RCALL _lcd_putsf
; 0000 023C                         Formateaza ( Vfwd);                 //afiseaza valoarea numerica Vfwd
	LDS  R26,_Vfwd
	LDS  R27,_Vfwd+1
	RCALL _Formateaza
; 0000 023D                         lcd_putsf ("  Rew");
	__POINTW2FN _0x0,251
	RCALL _lcd_putsf
; 0000 023E                         Formateaza ( Vrew);                 //afiseaza valoarea numerica Vref
	RCALL SUBOPT_0x51
	RCALL _Formateaza
; 0000 023F                         bargraf (0,1,15,Vfwd,Vrew);         //bargraf pe un rand intreg
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x52
; 0000 0240                         delay_ms(10);
; 0000 0241                         }
; 0000 0242                     while (  BUTON_TUNE_SWR );              //asteapta apasarea butonului <TUNE>
	SBIC 0x16,5
	RJMP _0xFE
; 0000 0243                     while ( ! BUTON_TUNE_SWR );              //daca butonul <TUNE> a fost apasat...
_0x100:
	SBIS 0x16,5
	RJMP _0x100
; 0000 0244                     lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 0245                     lcd_putsf("                ");          //sterge caracterele afisate pe linia de sus
	RCALL SUBOPT_0x53
; 0000 0246                     band_out();                             //afiseaza banda
; 0000 0247                     c_out (C_table_coarsie [ C ] );         //afiseaza condensator
	RCALL SUBOPT_0x37
; 0000 0248                     l_out (L_table_coarsie [ L ] );         //afiseaza inductor
; 0000 0249                     goto again;
	RJMP _0xE0
; 0000 024A                     };
; 0000 024B         SWR11:
_0xF1:
; 0000 024C                   {
; 0000 024D                     while ( ! BUTON_C_DOWN );               //asteapta cat este apasat butonul
_0x103:
	SBIS 0x16,1
	RJMP _0x103
; 0000 024E                     lcd_gotoxy (0,0);
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 024F                     lcd_putsf("SWR:");
	__POINTW2FN _0x0,274
	RCALL _lcd_putsf
; 0000 0250                     lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL SUBOPT_0x28
; 0000 0251                     lcd_putsf("  P=");
	__POINTW2FN _0x0,279
	RCALL _lcd_putsf
; 0000 0252                         do
_0x107:
; 0000 0253                         {
; 0000 0254                         Samples ();                       //verifica semnale analogice si calculeaza SWR
	RCALL _Samples
; 0000 0255                         Putere(Pwr);                     //calculeaza puterea in functie de semnalul ADC.0
	MOVW R26,R6
	RCALL _Putere
; 0000 0256                         lcd_gotoxy(4,0);
	RCALL SUBOPT_0x38
; 0000 0257                         swr_out();
	RCALL _swr_out
; 0000 0258                         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL SUBOPT_0x28
; 0000 0259                         sar=ON;                          //activeaza Bitul de afisare cu 3 cifre
	SET
	BLD  R2,0
; 0000 025A                         Formateaza(RF_power);            //afiseaza PUTEREA cu 3 cifre
	MOVW R26,R4
	RCALL _Formateaza
; 0000 025B                         lcd_putsf("W");
	__POINTW2FN _0x0,284
	RCALL SUBOPT_0x3F
; 0000 025C                         bargraf (0,1,15,Vfwd,Vrew);      //afiseaza bargraf
	RCALL SUBOPT_0x52
; 0000 025D                         delay_ms(10);
; 0000 025E                         }
; 0000 025F                     while( BUTON_TUNE_SWR );              //asteapta apasarea butonului <TUNE>
	SBIC 0x16,5
	RJMP _0x107
; 0000 0260                     while(! BUTON_TUNE_SWR);               //daca butonul <TUNE> a fost apasat...
_0x109:
	SBIS 0x16,5
	RJMP _0x109
; 0000 0261                     lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 0262                     lcd_putsf("                ");        //sterge linia de sus HOME U
	RCALL SUBOPT_0x53
; 0000 0263                     band_out();                           //afiseaza Banda
; 0000 0264                     c_out (C_table_coarsie [ C ] );       //afiseaza Capacitor
	RCALL SUBOPT_0x37
; 0000 0265                     l_out (L_table_coarsie [ L ] );       //afiseaza Inductor
; 0000 0266                     goto again;
	RJMP _0xE0
; 0000 0267                     }
; 0000 0268         TunnerOff:
_0xF3:
; 0000 0269                     {
; 0000 026A                     lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 026B                     lcd_putsf("Tuner OFF   ");
	__POINTW2FN _0x0,286
	RCALL _lcd_putsf
; 0000 026C                     send=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _send,R30
	STS  _send+1,R31
; 0000 026D                     Send_LC(0,0);                        //relaxeaza toate  releele L/C
	RCALL SUBOPT_0x3E
	LDI  R26,LOW(0)
	RCALL _Send_LC
; 0000 026E                     while ( ! BUTON_L_UP );
_0x10C:
	SBIS 0x16,0
	RJMP _0x10C
; 0000 026F                         do
_0x110:
; 0000 0270                         {
; 0000 0271                         Samples();                       //masoara semnale analogice si calcul SWR
	RCALL SUBOPT_0x42
; 0000 0272                         bargraf (0,1,15,Vfwd,Vrew);      //afiseaza bargraf
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDS  R30,_Vfwd
	LDS  R31,_Vfwd+1
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x51
	RCALL _bargraf
; 0000 0273                         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL SUBOPT_0x28
; 0000 0274                         swr_out();                       //afiseaza valoarea numerica SWR
	RCALL _swr_out
; 0000 0275                         delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0xD
; 0000 0276                         }
; 0000 0277                     while (  BUTON_TUNE_SWR );           //asteapta apasarea butonului <TUNE>
	SBIC 0x16,5
	RJMP _0x110
; 0000 0278                     while ( ! BUTON_TUNE_SWR );          //daca butonul <TUNE> a fost apasat...
_0x112:
	SBIS 0x16,5
	RJMP _0x112
; 0000 0279                     lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 027A                     lcd_putsf("                ");        //sterge linia de sus pe afisaj
	RCALL SUBOPT_0x53
; 0000 027B                     band_out();                           //afiseaza Banda
; 0000 027C                     tunner();
	RCALL _tunner
; 0000 027D                     goto again;
	RJMP _0xE0
; 0000 027E                     };
; 0000 027F         DelayRelay:
_0xF5:
; 0000 0280                     {
; 0000 0281                     lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 0282                     lcd_putsf("Delay Time Relay");
	__POINTW2FN _0x0,299
	RCALL _lcd_putsf
; 0000 0283                     lcd_putsf("                ");
	__POINTW2FN _0x0,257
	RCALL _lcd_putsf
; 0000 0284                     while ( ! BUTON_L_DOWN );
_0x115:
	SBIS 0x16,7
	RJMP _0x115
; 0000 0285                         do
_0x119:
; 0000 0286                         {
; 0000 0287                         if ( ! BUTON_BAND_DOWN )   //
	SBIC 0x16,4
	RJMP _0x11B
; 0000 0288                             {
; 0000 0289                             DELAY_BEFORE_ADC = DELAY_BEFORE_ADC - 5;
	RCALL SUBOPT_0x12
	SUBI R30,LOW(5)
	RCALL SUBOPT_0x54
	RCALL __EEPROMWRB
; 0000 028A                             if (  DELAY_BEFORE_ADC < 5 )
	RCALL SUBOPT_0x12
	CPI  R30,LOW(0x5)
	BRSH _0x11C
; 0000 028B                                 {
; 0000 028C                                 DELAY_BEFORE_ADC =  5;
	RCALL SUBOPT_0x54
	LDI  R30,LOW(5)
	RCALL __EEPROMWRB
; 0000 028D                                 }
; 0000 028E                             }
_0x11C:
; 0000 028F                         delay_ms(150);
_0x11B:
	LDI  R26,LOW(150)
	RCALL SUBOPT_0xD
; 0000 0290                             if ( ! BUTON_BAND_UP )
	SBIC 0x16,3
	RJMP _0x11D
; 0000 0291                                 {
; 0000 0292                                 DELAY_BEFORE_ADC = DELAY_BEFORE_ADC + 5;
	RCALL SUBOPT_0x12
	SUBI R30,-LOW(5)
	RCALL SUBOPT_0x54
	RCALL __EEPROMWRB
; 0000 0293                                 if (  DELAY_BEFORE_ADC > 50 )
	RCALL SUBOPT_0x12
	CPI  R30,LOW(0x33)
	BRLO _0x11E
; 0000 0294                                     DELAY_BEFORE_ADC =  50;
	RCALL SUBOPT_0x54
	LDI  R30,LOW(50)
	RCALL __EEPROMWRB
; 0000 0295                                 }
_0x11E:
; 0000 0296                         lcd_gotoxy ( 4, 1 );
_0x11D:
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL SUBOPT_0x40
; 0000 0297                         Formateaza ( DELAY_BEFORE_ADC );
	RCALL SUBOPT_0x12
	LDI  R31,0
	MOVW R26,R30
	RCALL _Formateaza
; 0000 0298                         lcd_putsf(" ms");
	__POINTW2FN _0x0,316
	RCALL _lcd_putsf
; 0000 0299                         }
; 0000 029A                     while (  BUTON_TUNE_SWR );                              //asteapta apasarea butonului <TUNE>
	SBIC 0x16,5
	RJMP _0x119
; 0000 029B                     while ( ! BUTON_TUNE_SWR );                             //daca butonul <TUNE> a fost apasat...
_0x11F:
	SBIS 0x16,5
	RJMP _0x11F
; 0000 029C                     lcd_gotoxy ( 0, 0 );
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
; 0000 029D                     lcd_putsf("                ");
	RCALL SUBOPT_0x53
; 0000 029E                     band_out();
; 0000 029F                     goto again;
	RJMP _0xE0
; 0000 02A0                     };
; 0000 02A1                  }
; 0000 02A2          }
_0x122:
	RJMP _0x122
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x55
	RJMP _0x20A0007
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x56
_0x20A0007:
	ADIW R28,4
	RET
; .FEND
_log:
; .FSTART _log
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x57
	RCALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0006
_0x200000C:
	RCALL SUBOPT_0x58
	RCALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	RCALL _frexp
	POP  R16
	POP  R17
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x57
	__GETD1N 0x3F3504F3
	RCALL __CMPF12
	BRSH _0x200000D
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x57
	RCALL __ADDF12
	RCALL SUBOPT_0x59
	__SUBWRN 16,17,1
_0x200000D:
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x56
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x58
	__GETD2N 0x3F800000
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL SUBOPT_0x5A
	__GETD2N 0x3F654226
	RCALL __MULF12
	RCALL SUBOPT_0xC
	__GETD1N 0x4054114E
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x57
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	__GETD2N 0x3FD4114D
	RCALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3F317218
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
_0x20A0006:
	RCALL __LOADLOCR2
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	RCALL __PUTPARD2
	SBIW R28,8
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x5B
	__GETD1N 0xC2AEAC50
	RCALL __CMPF12
	BRSH _0x200000F
	RCALL SUBOPT_0xF
	RJMP _0x20A0005
_0x200000F:
	__GETD1S 10
	RCALL __CPD10
	BRNE _0x2000010
	RCALL SUBOPT_0x7
	RJMP _0x20A0005
_0x2000010:
	RCALL SUBOPT_0x5B
	__GETD1N 0x42B17218
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0005
_0x2000011:
	RCALL SUBOPT_0x5B
	__GETD1N 0x3FB8AA3B
	RCALL __MULF12
	__PUTD1S 10
	RCALL SUBOPT_0x5B
	RCALL _floor
	RCALL __CFD1
	MOVW R16,R30
	RCALL SUBOPT_0x5B
	RCALL __CWD1
	RCALL __CDF1
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xC
	__GETD1N 0x3F000000
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x5A
	__GETD2N 0x3D6C4C6D
	RCALL __MULF12
	__GETD2N 0x40E6E3A6
	RCALL __ADDF12
	RCALL SUBOPT_0x57
	RCALL __MULF12
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x1
	__GETD2N 0x41A68D28
	RCALL __ADDF12
	__PUTD1S 2
	RCALL SUBOPT_0x58
	__GETD2S 2
	RCALL __ADDF12
	__GETD2N 0x3FB504F3
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x1
	RCALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL __PUTPARD1
	MOVW R26,R16
	RCALL _ldexp
_0x20A0005:
	RCALL __LOADLOCR2
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL SUBOPT_0x5C
	RCALL __CPD10
	BRNE _0x2000012
	RCALL SUBOPT_0xF
	RJMP _0x20A0004
_0x2000012:
	RCALL SUBOPT_0x5D
	RCALL __CPD02
	BRGE _0x2000013
	RCALL SUBOPT_0x5E
	RCALL __CPD10
	BRNE _0x2000014
	RCALL SUBOPT_0x7
	RJMP _0x20A0004
_0x2000014:
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5F
	RJMP _0x20A0004
_0x2000013:
	RCALL SUBOPT_0x5E
	MOVW R26,R28
	RCALL __CFD1
	RCALL __PUTDP1
	RCALL SUBOPT_0x55
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x5E
	RCALL __CPD12
	BREQ _0x2000015
	RCALL SUBOPT_0xF
	RJMP _0x20A0004
_0x2000015:
	RCALL SUBOPT_0x5C
	RCALL __ANEGF1
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x5F
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	RCALL SUBOPT_0x5C
	RJMP _0x20A0004
_0x2000016:
	RCALL SUBOPT_0x5C
	RCALL __ANEGF1
_0x20A0004:
	ADIW R28,12
	RET
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
; .FSTART __lcd_delay_G101
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20A0001
; .FEND
_lcd_write_byte:
; .FSTART _lcd_write_byte
	ST   -Y,R26
	RCALL __lcd_ready
	LDD  R26,Y+1
	RCALL __lcd_write_data
	RCALL __lcd_ready
    sbi   __lcd_port,__lcd_rs     ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
	RJMP _0x20A0003
; .FEND
__lcd_read_nibble_G101:
; .FSTART __lcd_read_nibble_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G101:
; .FSTART _lcd_read_byte0_G101
	RCALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20A0003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	RCALL SUBOPT_0x3E
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	RJMP _0x20A0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x0
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x20A0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G101:
; .FSTART __long_delay_G101
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G101:
; .FSTART __lcd_init_write_G101
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20A0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x60
	RCALL __long_delay_G101
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20A0001
_0x202000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_Volt_masurat:
	.BYTE 0x4
_Step_size:
	.BYTE 0x4
_SW:
	.BYTE 0x4
_U_1W:
	.BYTE 0x4
_U_10W:
	.BYTE 0x4
_dBm_zec:
	.BYTE 0x4
_S10W:
	.BYTE 0x4

	.ESEG
_ADC_1W:
	.BYTE 0x2
_ADC_10W:
	.BYTE 0x2
_Uref:
	.BYTE 0x2
_S10W_cal:
	.BYTE 0x4
_Step_size_cal:
	.BYTE 0x4

	.DSEG
_Vfwd:
	.BYTE 0x4
_Vrew:
	.BYTE 0x4
_swr:
	.BYTE 0x4

	.ESEG
_DELAY_BEFORE_ADC:
	.DB  0x14
_Band_selector:
	.BYTE 0x2
_Ind_min:
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0
_Cap_min:
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0
_k1_min:
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0
	.DB  0x1,0x0
_swr_min:
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0
	.DB  0x66,0x0,0x0,0x0

	.DSEG
_sweep_relay:
	.BYTE 0x2
_send:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x0
	LDI  R26,LOW(_Uref)
	LDI  R27,HIGH(_Uref)
	RCALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x3F800000
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	RCALL _Tensiune
	LDS  R30,_Volt_masurat
	LDS  R31,_Volt_masurat+1
	LDS  R22,_Volt_masurat+2
	LDS  R23,_Volt_masurat+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_Uref)
	LDI  R27,HIGH(_Uref)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	LDS  R26,_U_10W
	LDS  R27,_U_10W+1
	LDS  R24,_U_10W+2
	LDS  R25,_U_10W+3
	__GETD1N 0x447A0000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	__GETD1N 0x447A0000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	__DELAY_USB 53
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	STS  _Vrew,R30
	STS  _Vrew+1,R31
	STS  _Vrew+2,R22
	STS  _Vrew+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	STS  _Vfwd,R30
	STS  _Vfwd+1,R31
	STS  _Vfwd+2,R22
	STS  _Vfwd+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_DELAY_BEFORE_ADC)
	LDI  R27,HIGH(_DELAY_BEFORE_ADC)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	OUT  0x7,R30
	LDI  R30,LOW(213)
	OUT  0x6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	IN   R30,0x6
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	IN   R30,0x4
	IN   R31,0x4+1
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDS  R26,_Vfwd
	LDS  R27,_Vfwd+1
	LDS  R24,_Vfwd+2
	LDS  R25,_Vfwd+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	__GETD1N 0x64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	STS  _swr,R30
	STS  _swr+1,R31
	STS  _swr+2,R22
	STS  _swr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x19:
	LDS  R26,_swr
	LDS  R27,_swr+1
	LDS  R24,_swr+2
	LDS  R25,_swr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__GETD1N 0x3E7
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(1)
	STD  Y+13,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+13
	SUBI R30,-LOW(1)
	STD  Y+13,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(1)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+12
	SUBI R30,-LOW(1)
	STD  Y+12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	RCALL __DIVD21U
	RCALL SUBOPT_0xC
	__GETD1N 0xA
	RCALL __MODD21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x19
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x21:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x23:
	__POINTW2FN _0x0,7
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R26
	LDS  R30,_sweep_relay
	LDS  R31,_sweep_relay+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	RCALL _lcd_putsf
	LD   R26,Y
	LDI  R30,LOW(100)
	RCALL __DIVB21U
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	LD   R26,Y
	LDI  R30,LOW(100)
	RCALL __DIVB21U
	MOV  R26,R30
	LDI  R30,LOW(10)
	RCALL __MODB21U
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	__POINTW2FN _0x0,11
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	LD   R26,Y
	LDI  R30,LOW(10)
	RCALL __DIVB21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	MOV  R26,R30
	LDI  R30,LOW(10)
	RCALL __MODB21U
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LD   R26,Y
	LDI  R30,LOW(10)
	RCALL __MODB21U
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:56 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(_Band_selector)
	LDI  R27,HIGH(_Band_selector)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(_swr_min)
	LDI  R27,HIGH(_swr_min)
	RCALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(_Cap_min)
	LDI  R27,HIGH(_Cap_min)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(_Ind_min)
	LDI  R27,HIGH(_Ind_min)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_k1_min)
	LDI  R27,HIGH(_k1_min)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	STS  _sweep_relay,R30
	STS  _sweep_relay+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _send,R30
	STS  _send+1,R31
	MOVW R30,R12
	SUBI R30,LOW(-_L_table_coarsie*2)
	SBCI R31,HIGH(-_L_table_coarsie*2)
	LPM  R30,Z
	ST   -Y,R30
	MOVW R30,R10
	SUBI R30,LOW(-_C_table_coarsie*2)
	SBCI R31,HIGH(-_C_table_coarsie*2)
	LPM  R26,Z
	RJMP _Send_LC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x37:
	MOVW R30,R10
	SUBI R30,LOW(-_C_table_coarsie*2)
	SBCI R31,HIGH(-_C_table_coarsie*2)
	LPM  R26,Z
	RCALL _c_out
	MOVW R30,R12
	SUBI R30,LOW(-_L_table_coarsie*2)
	SBCI R31,HIGH(-_L_table_coarsie*2)
	LPM  R26,Z
	RJMP _l_out

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(4)
	ST   -Y,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(_ADC_1W)
	LDI  R27,HIGH(_ADC_1W)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(_ADC_10W)
	LDI  R27,HIGH(_ADC_10W)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0x3B
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3C
	RCALL __EEPROMRDW
	MOVW R26,R30
	RJMP _Cal_power

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	RCALL _lcd_putsf
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(200)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	RCALL _Samples
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	RCALL _lcd_putsf
	MOVW R26,R6
	RCALL _Formateaza
	__POINTW2FN _0x0,122
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	RCALL __EEPROMWRW
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	RCALL _lcd_putsf
	RJMP _band_out

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x46:
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_swr
	LDS  R31,_swr+1
	LDS  R22,_swr+2
	LDS  R23,_swr+3
	RCALL __EEPROMWRD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x48:
	LDS  R30,_sweep_relay
	LDS  R31,_sweep_relay+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(0)
	STS  _sweep_relay,R30
	STS  _sweep_relay+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDS  R30,_Vfwd
	LDS  R31,_Vfwd+1
	RCALL SUBOPT_0x6
	LDS  R26,_Vrew
	LDS  R27,_Vrew+1
	RJMP _bargraf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x48
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(0)
	STS  _send,R30
	STS  _send+1,R30
	MOVW R30,R12
	SUBI R30,LOW(-_L_table_coarsie*2)
	SBCI R31,HIGH(-_L_table_coarsie*2)
	LPM  R30,Z
	ST   -Y,R30
	MOVW R30,R10
	SUBI R30,LOW(-_C_table_coarsie*2)
	SBCI R31,HIGH(-_C_table_coarsie*2)
	LPM  R26,Z
	RCALL _Send_LC
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x3A
	STS  _send,R30
	STS  _send+1,R31
	MOVW R30,R12
	SUBI R30,LOW(-_L_table_coarsie*2)
	SBCI R31,HIGH(-_L_table_coarsie*2)
	LPM  R30,Z
	ST   -Y,R30
	MOVW R30,R10
	SUBI R30,LOW(-_C_table_coarsie*2)
	SBCI R31,HIGH(-_C_table_coarsie*2)
	LPM  R26,Z
	RCALL _Send_LC
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(50)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x51:
	LDS  R26,_Vrew
	LDS  R27,_Vrew+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x52:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDS  R30,_Vfwd
	LDS  R31,_Vfwd+1
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x51
	RCALL _bargraf
	LDI  R26,LOW(10)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x53:
	__POINTW2FN _0x0,257
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	LDI  R26,LOW(_DELAY_BEFORE_ADC)
	LDI  R27,HIGH(_DELAY_BEFORE_ADC)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x55:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	__GETD2N 0x3F800000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x57:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x58:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x59:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5A:
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x57
	RCALL __MULF12
	__PUTD1S 2
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5B:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5C:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5E:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	RCALL _log
	__GETD2S 4
	RCALL __MULF12
	RCALL SUBOPT_0xC
	RJMP _exp

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x60:
	RCALL __long_delay_G101
	LDI  R26,LOW(48)
	RJMP __lcd_init_write_G101


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__LTD12U:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	LDI  R30,1
	BRLO __LTD12UT
	CLR  R30
__LTD12UT:
	RET

__GTD12U:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRLO __GTD12UT
	CLR  R30
__GTD12UT:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
