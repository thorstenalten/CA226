      .data

CONTROL: .word 0x10000	; convention: use r20 for this
DATA:    .word 0x10008	; convention: use r21 for this

A:    .word 0
B:    .word 100
C:	  .word 1

      .text
main:
      ld r4,A(r0)		; r4 = 0
;      ld r5,B(r0)		; r5 = 100
	  ld r1,C(r0)		; r1 = 1

	  ld r20,CONTROL(r0)
	  ld r21,DATA(r0)
	  
	  daddi r8, r0, 8	; r8 = 8
	  sd r8, 0(r20)		; store 8 to CONTROL in order to read the terminal value into DATA
	  ld r5, 0(r21)		; load the value inside DATA into r5
loop:
	  beqz r5, finish	; branch if r5 is equal to zero
      dadd r4,r4,r5		; r4 += r5
      dsub r5, r5, r1   ; r5 -= 1
	  j loop 
finish:
      halt          

