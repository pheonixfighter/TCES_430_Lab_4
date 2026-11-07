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

.section .text
.global compare_LED
.align 2
.thumb_func

compare_LED:

	// Turns on the clock for GPIOI
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB1ENR]
	ORR R1, R1, #RCC_GPIOIEN
	STR R1, [R0, #RCC_AHB1ENR]

	// Enables GPIO pin PI0, or pin D5 on the arduino header for Red LED
	LDR R0, =GPIOI_BASE
	LDR R1, [R0, #GPIO_MODER] // Puts the current value of GPIOI_MODER into Register R1
	ORR R1, R1, #0b1 // Sets MODER to General Output mode
	// Not storing the result to GPIOI_MODER yet since t
	// the next pin that we modify is also in GPIOI

	// Enables GPIO pin PI2, or pin D7 on the arduino header for Yellow LED
	// Not Loading GPIOI_BASE since it is already in memory
	// Not Loading GPIOI_MODER because it's already in R1
	AND R2, R2, #0 // Ensures that R2 is 0 to make the proper bit sequence to set GPIO_MODER
	ORR R2, R2, #0b1
	LSL R2, R2, #4 // Shifts 4 time becasue 2 bits * second pin entry in GPIOI
	ORR R1, R1, R2 // Updates bit shift in R1 to write to GPIOI_MODER
	STR R1, [R0, #GPIO_MODER]



	// Setting up the following registers are used for the following activities:
	// R0-> Current index (increment counter)
	// R1-> address Offset
	// R2-> Maximum value
	// R3-> offset of Maximum value
	// R4-> current value being compared

	// Set R0 to act like the increment variable in a loop
	AND R0, R0, #0

	// Sets R1 to 0 since our first offset will be 0
	AND R1, R1, #0

	// Set R2 to 0 since R2 holds the maximum absolute value, meaning that 0 is the
	// least possible value.
	AND R2, R1, #0

	// R3 and R4 don't need any setting up for the next part of the code
	COMPARISON_LOOP:
		// Read Value from memory
		LDR R4, =FLASH_DATA
		LDR R4, [R4, R1]

		// Finds absolute value of the data loaded in R3
		ASR R5, R4, #31
		ADD R4, R5, R4
		EOR R4, R5, R4

		// Compares the two values to each other
		CMP R2, R4
		BPL FINISH_LOOP // jumps to the loop conclusion program after
						// checking if R2 still holds the greater value
		ITT MI
			MOVMI R2, R4 // Lets R2 hold the maximum absolut value to compare in later tuns
			MOVMI R3, R1 // Updates the offset

		FINISH_LOOP:
		ADD R0, R0, #1 // Increments loop variable
		ADD R1, R1, #4 // Points to next word address

		CMP R0, #10 // Checks if R0 = 10 yet
		BEQ CHECK_GREATEST_VALUE // Moving on if we have reached R0 = 10
		B COMPARISON_LOOP


	// The next step is to figure out if the entry of greatest abslute value is positive or negative
	CHECK_GREATEST_VALUE:
		LDR R0, =FLASH_DATA
		LDR R0, [R0, R3]
		CMP R0, #0
		BMI SET_YELLOW_LED


	SET_RED_LED:
		LDR R0, =GPIOI_BASE
		LDR R1, [R0, #GPIO_ODR]
		ORR R1, R1, #0b1 //
		STR R1, [R0, #GPIO_ODR]
		BX LR

	SET_YELLOW_LED:
		LDR R0, =GPIOI_BASE
		LDR R1, [R0, #GPIO_ODR]
		LDR R2, =0x1
		LSL	R2, R2, #2
		STR R2, [R0, #GPIO_ODR]
		BX LR

	// Aligning data for the function to compare
	.align 2
	FLASH_DATA:
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

/*
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
