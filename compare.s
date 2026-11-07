// Robert Cromer
// TCES 430
// This file contains code for the compare_LED assembly function

.syntax unified
.cpu cortex-m7
.thumb

// Memory Layout Declarations
.equ RCC_BASE, 0x40023800
.equ GPIOI_BASE, 0x40022000
.equ RCC_AHB1ENR, 0x30
.equ GPIO_MODER, 0x00
.equ GPIO_ODR, 0x14


// But Feild Definition for Pin PI1 (Actual green LED LD1)
.equ RCC_GPIOIEN, (1<<8)
.equ FPIOI_IPN1_OUT, (1<<2) // Sets Pin 1 to output (0b01 in bits 3:2)
.equ GPIOI_PIN1_ON, (1<<1) // Sets Pin 1 High

.section .text
.align 2


// Turns on the clock for GPIOI
LDR R0, =RCC_BASE
LDR R1, [R0, #RCC_AHB1ENR]
ORR R1, R1, #RCC_GPIOIEN
STR R1, [R0, #RCC_AHB1ENR]

// Enables GPIO pin PI0, or pin D3 on the arduino header
LDR R0, =GPIOI_BASE
LDR R1, [R0, #GPIO_MODER] // Puts the current value of GPIOI_MODER into Register R1
ORR R1, R1, #0b1 // Sets MODER to General Output mode
// Not storing the result to GPIOI_MODER yet since t
// the next pin that we modify is also in GPIOI

// Enables GPIO pin PI2, or pin D7 on the arduino header
// Not Loading GPIOI_BASE since it is already in memory
// Not Loading GPIOI_MODER because it's already in R1
AND R2, R2, #0 // Ensures that R2 is 0 to make the proper bit sequence to set GPIO_MODER
ORR R2, R2, #0b1
LSL R2, R2, #4 // Shifts 4 time becasue 2 bits * second pin entry in GPIOI
ORR R1, R1, R2 // Updates bit shift in R1 to write to GPIOI_MODER



// Setting up the following registers are used for the following activities:
// R0-> Current index (increment counter)
// R1-> address Offset
// R2-> Maximum value
// R3-> index of Maximum value
// R4-> current value being compared

// Set R0 to act like the increment variable in a loop
AND R0, R0, #0

// Sets R1 to 0 since our first offset will be 0
AND R1, R1, #0

// Set R2 to 0 since R2 holds the maximum absolute value, meaning that 0 is the
// least possible value.
AND R1, R1, #0

// R3 and R4 don't need any setting up for the next part of the code
COMPARISON_LOOP:
	// Read Value from memory
	LDR R4, =FLASH_DATA
	LDR R4, [R4, R1]

	// Finds absolute value of the data loaded in R3
	ASR R5, R4, #31
	ADD R5, R5, #31
	EOR R4, R5, R4

	// Compares the two values to each other
	CMP R2, R4
	BPL FINISH_LOOP // jumps to the loop conclusion program after
					// checking if R2 still holds the greater value
	MOVMI R2, R4 // Lets R2 hold the maximum absolut value to compare in later tuns
	MOVMI R3, R1 // Updates the offset



	FINISH_LOOP:



// TODO: calculate offset for next value
// TODO: load FLASH_DATA + offsetultr
// TODO: compare against minimal value
// TODO: go back up to the loop if we havent gone through all values (use increment)

CHECK_GREATEST_VALUE:



SET_RED_LED:


SET_YELLOW_LED:





ABSOLUTE_VALUE:



// Aligning data for
FLASH_DATA:
.align 2
	// Positive number test set
	.word -371502
	.word 931252
	.word 1239879
	.word 281512
	.word -213
	.word -542753
	.word -682123
	.word 123451
	.word 821365
	.word 102385126


	/**
	.word -371502
	.word -931252
	.word -1239879
	.word -281512
	.word -213
	.word -542753
	.word -682123
	.word -123451
	.word -821365
	.word -102385126
	*/

