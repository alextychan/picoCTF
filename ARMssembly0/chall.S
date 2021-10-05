	.arch armv8-a
	.file	"chall.c"
	.text
	.align	2
	.global	func1
	.type	func1, %function
func1:
	sub	sp, sp, #16		# Subtract to add local variables
	str	w0, [sp, 12]	# Store w0 into stack @ position 12: sp-12 <= w0 = 266134863		
	str	w1, [sp, 8]		# Store w1 into stack @ position 8: sp-8  <= w1 =  1592237099
	ldr	w1, [sp, 12]	# Load w1 with value in stack @ position 12: w1 <= sp-12 = 266134863
	ldr	w0, [sp, 8] 	# Load w0 with value in stack @ position 8: w0 <= sp-8 =   1592237099
	cmp	w1, w0			# Compare w1 and w0
	bls	.L2				# GoTo L2 if w1 < w0
	ldr	w0, [sp, 12]	# Load w0 from stack @ position 12
	b	.L3				# GoTo L3
.L2:
	ldr	w0, [sp, 8]		# Load w0 from stack @ position 8; w0 = 1592237099
.L3:
	add	sp, sp, 16
	ret
	.size	func1, .-func1
	.section	.rodata
	.align	3
.LC0:
	.string	"Result: %ld\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	str	w0, [x29, 44]
	str	x1, [x29, 32]
	ldr	x0, [x29, 32]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	mov	w19, w0			# Atoi result stored in w0: 266134863
	ldr	x0, [x29, 32]
	add	x0, x0, 16
	ldr	x0, [x0]
	bl	atoi
	mov	w1, w0			# Atoi result stored in w0: 1592237099
	mov	w0, w19 		# 266134863
	bl	func1
	mov	w1, w0		# w1 = w0 = 1592237099
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
