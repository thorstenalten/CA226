; calculating the first 20 Fibonacci Numbers
; int tmpNumber;
; int previousNumber = 1;
; int currentNumber = 1;
; int counter = 27;
; print 0, 1, 1
; while (counter not equals 0) tmpNumber = currentNumber, currentNumber = currentNumber + previousNumber, previousNumber = tmpNumber, print currentNumber, counter--

	.data
A:	.word 1		; init for Numbers
B:	.word 37	; init for counter
C:  .word 2		; constant for output command
D:	.word 1		; initial diff (1/1 = 1) for use later when we compare it with the new ratio, will be overwritten on each pass

E:  .double 0.00000001 ; Epsilon

; to be used for writing to terminal
CONTROL:	.word 0x10000
DATA:		.word 0x10008

	.text
main:
	dadd r1, r1, r0	; tmpNumber = 0 
	ld r2, B(r0)	; counter = 27
	ld r3, A(r0)	; previousNumber = 1
	ld r4, A(r0)	; currentNumber = 1
	l.d f1, E(r0)	; Epsilon = 0.00000..01
	
	

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
	beqz r2, finish		; if counter == 0 go to finish (and be done)
	; else do the following
	dadd r1, r4, r0		; tmpNumber = currentNumber + 0 (i.e. r1 := r4)
	dadd r4, r4, r3		; currentNumber = currentNumber + previousNumber
	dadd r3, r1, r0		; previousNumber = tmpNumber + 0 (i.e. r3 := r1)

	; print current number
	sd r4, 0(r21)		; store currentNumber in Mem[DATA]
	ld r1, C(r0)		; tmpNumber = 2 
	sd r1, 0(r20)		; store 2 in memory address CONTOL - now it prints the content of MEM[DATA] out to terminal

	; now calculate the golden ratio approximation (i.e. currentNumber / previousNumber) <- floating point division
	; first load the two numbers into floating point registers
	mtc1 r3, f3			; previousNumber into f3
	mtc1 r4, f4			; currentNumber into f4

	div.d f4, f4, f3	; curent div.d = currentNumberFloat / previousNumberFloat
	l.d f3, D(r0)		; load the previous ratio
	sub.d f3, f4, f3	; difference = current div.d - previous div.d 
	; we have the difference but it might be positive or negative (because Fibonacci ratio align to golden ratio from above/below on each next step)
	; so we need to get the total difference
	;; branch to label "positive" if !(difference < 0), so if f10 is positive
    c.lt.d f3,f0
    bc1f positive

    ;; otherwise difference is negative, make it positive
    sub.d f3,f0,f3

positive:				; out difference is now total
	s.d f4, D(r0)		; store current div.d in memory
	; now set the Floating Flag on whether difference < Epsilon 
	c.lt.d f3, f1		; if difference < Epsilon
	bc1f skipPrint		; if it wasnt skip printing out the ratio
	; else print out the ratio
	s.d f4, 0(r21)		; store currentNumberFloat in Mem[DATA]
	ld r1, C(r0)		; tmpNumber = 2 (we need 3 for printing Float)
	daddi r1, r1, 1		; tmpNumber = tmpNumber + 1 (= 3)
	sd r1, 0(r20)		; store 3 in memory address CONTOL - now it prints the Float content of MEM[DATA] out to terminal
	; jump to finish (so the last number in terminal is this ratio so I can see whether it works)
	j finish

skipPrint:
	daddi r2, r2, -1	; counter = counter + -1 (counter--)

	j while

finish:
	halt	; the terminal should now show the first 20 Fibonacci numbers