      .data

CONTROL: .word 0x10000	; convention: use r20 for this
DATA:    .word 0x10008	; convention: use r21 for this

C:	  .word 1
D:	  .word 2

      .text
main:
	  ld r1,C(r0)		; r1 = 1
	  ld r2,D(r0)		; r2 = 2

	  ld r20,CONTROL(r0)
	  ld r21,DATA(r0)
	  
	  daddi r8, r0, 8	; r8 = 8
	  sd r8, 0(r20)		; store 8 to CONTROL in order to read the terminal value into DATA
	  ld r5, 0(r21)		; load the value inside DATA into r5 (i.e r5 = n)

      dadd r1, r5, r1	; r1 = n + 1
      dmul r5, r5, r1   ; r5 = n * (n+1)
	  ddiv r5, r5, r2	; r4 = r5 / 2

	  sd r5, 0(r21)		; store result to DATA in order to prepare for writing it out to the terminal
	  sd r2, 0(r20)		; store 2 inside CONTROL to output for outputting a signed integer
	 
