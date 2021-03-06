; calculating the first 20 Fibonacci Numbers
; int tmpNumber;
; int previousNumber = 1;
; int currentNumber = 1;
; int counter = 17;
; print 0, 1, 1
; while (counter not equals 0) tmpNumber = currentNumber, currentNumber = currentNumber + previousNumber, previousNumber = tmpNumber, print currentNumber, counter--

	.data
A:	.word 1		; init for Numbers
B:	.word 17	; init for counter
C:  .word 2		; constant for output command

; to be used for writing to terminal
CONTROL:	.word 0x10000
DATA:		.word 0x10008

	.text
main:
	dadd r1, r1, r0	; tmpNumber = 0 
	ld r2, B(r0)	; counter = 17
	ld r3, A(r0)	; previousNumber = 1
	ld r4, A(r0)	; currentNumber = 1

	; print 0, 1, 1 -> set DATA = valueToBeWritten, set CONTROL = 2 (i.e. set DATA as signed Integer for output)
	ld r20, CONTROL(r0)	; load CONTROL and DATA addresses into registers so we can use them
	ld r21, DATA(r0)

	sd r1, 0(r21)		; store 0 in memory address DATA
	ld r1, C(r0)		; tmpNumber = 2 
	sd r1, 0(r20)		; store 2 in memory address CONTOL - now it prints the content of MEM[DATA] out to terminal

	sd r3, 0(r21)		; store 1 (previousNumber) in memory address DATA
	sd r1, 0(r20)		; store 2 in memory address CONTOL - now it prints the content of MEM[DATA] out to terminal

	sd r3, 0(r21)		; store 1 (previousNumber) in memory address DATA
	sd r1, 0(r20)		; store 2 in memory address CONTOL - now it prints the content of MEM[DATA] out to terminal

	; now terminal shows 0 1 1 -< the first three Fibonacci Numbers
	; prelims are done, lets get to the while loop

while:
	beqz r2, finish	; if counter == 0 go to finish (and be done)
	; else do the following
	dadd r1, r4, r0		; tmpNumber = currentNumber + 0 (i.e. r1 := r4)
	dadd r4, r4, r3		; currentNumber = currentNumber + previousNumber
	dadd r3, r1, r0		; previousNumber = tmpNumber + 0 (i.e. r3 := r1)

	; print current number
	sd r4, 0(r21)		; store currentNumber in Mem[DATA]
	ld r1, C(r0)		; tmpNumber = 2 
	sd r1, 0(r20)		; store 2 in memory address CONTOL - now it prints the content of MEM[DATA] out to terminal

	daddi r2, r2, -1	; counter = counter + -1 (counter--)

	j while

finish:
	halt	; the terminal should now show the first 20 Fibonacci numbers