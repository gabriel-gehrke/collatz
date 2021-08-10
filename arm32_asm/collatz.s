.text
.global _start

_start:
	/* load start number into r6 */
	mov r6, #27

_collatz:
	/* print hex value of current number */
	b _format_hex
_collatz_continue:
	/* print new line */
	ldr r1, =new_line
	bl _printchar

	/* exit if value is 1 */
	cmp r6, #1
	beq _exit

	/* test if val is odd. if so, zero flag gets set */
	tst r6, #1

	/* value is even: multiply by 3, add 1 */
	addne r6, r6, r6, lsl #1
	addne r6, #1

	/* value is odd: divide by 2 */
	moveq r6, r6, lsr #1

	b _collatz

_format_hex:
	/* set up nibble mask in r3, shift amount + loop counter in r10 */
	mov r3, #0xF0000000
	mov r9, #28
_format_hex_loop:
	/* extract nibble from r6, shift result to right */
	and r4, r3, r6
	mov r4, r4, lsr r9

	/* load address to character set, add value of nibble to get character, print it */
	ldr r1, =chars
	add r1, r1, r4
	bl _printchar

	/* decrement shift amount (r9), jump back to collatz if result was negative */
	subs r9, r9, #4
	bmi _collatz_continue

	/* right-shift nibble mask */
	mov r3, r3, lsr #4

	b _format_hex_loop

_printchar:
	mov r7, #4
	mov r0, #1
	mov r2, #1 /* print one character */
	swi 0

	bx lr

_exit:
	mov r0, r6
	mov r7, #1
	swi 0

.data
chars:
	.ascii "0123456789ABCDEF"
new_line:
	.ascii "\n"
