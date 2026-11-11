// Robert Cromer
// TCES 430
// This file contails the ARM assembly equivalent of teh following C code:

/*
i = 1;
j = 0;
k = -1;
while (i > j) {
	i = 1 + a - 2 * j;
	if (j >= k) {
		i = i + 2;
		k = k - b + 2 * j;
	}
	j++;
}
*/

.syntax unified
.cpu cortex-m7
.thumb

.equ a, 1
.equ b, 0

.section .data
.align 2
// I decided to both reserve the addresses and initialize the variables before continuing with the program
i:
	.word 1
j:
	.word 0
k:
	.word -1


.section .text
.global while_loop_program
.align 2
.thumb_func


// The actual code
while_loop_program:

	// LOOP LINE 1: i = i + a - 2 * j

	// Puts i in R0
	LDR R0, =i
	LDR R0, [R0]

	//  Adds a to i
	ADD R0, R0, #a

	// Loads j into R1
	LDR R1, =j
	LDR R1, [R1]

	// Makes 2j and subtracts from R0 to make new i value
	ADD R1, R1, R1
	SUB R0, R0, R1
	LDR R1, =i
	STR R0, [R1]

	// IF LINE: compares to see j >= k
	LDR R0, =j
	LDR R0, [R0]
	LDR R1, =k
	CMP R1, R0 // Using j - k, and then using the negative flag
	BMI POST_IF_STATEMENT

	// i = i + 2
	LDR R0, =i
	LDR R1, [R0]
	ADD R1, R1, #2
	STR R1, [R0]

	// k = k - b + 2 * j
	LDR R0, =k
	LDR R1, [R0]
	SUB R1, R1, #b

	// Loads j into memory for 2 * j
	LDR R2, =j
	LDR R2, [R2]
	ADD R2, R2, R2
	ADD R1, R1, R2

	// Stores our new k value
	STR R1, [R0]

	// Code after the if statement
	POST_IF_STATEMENT:

	// j++
	LDR R0, =j
	LDR R1, [R0]
	ADD R1, R1, #1
	STR R1, [R0]

	// Branching logic (go back up when i > j)
	LDR R0, =i
	LDR R0, [R0]
	LDR R1, =j
	LDR R1, [R1]
	CMP R0, R1
	BPL while_loop_program

	// Extra line added so that we can see the values of i, j, and k in the debugger
	NOP

