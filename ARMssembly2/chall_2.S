	.arch armv8-a
	.file	"chall_2.c"
	.text
	.align	2
	.global	func1
	.type	func1, %function
func1:
	sub	sp, sp, #32
	str	w0, [sp, 12]	sp-12 = 3736234946
	str	wzr, [sp, 24] 	sp-24 = 0
	str	wzr, [sp, 28]	sp-28 = 0
	b	.L2
.L3:
	ldr	w0, [sp, 24]	w0 = 0
	add	w0, w0, 3		w0 = 3
	str	w0, [sp, 24]	sp-24 = 3
	ldr	w0, [sp, 28]	w0 = 0
	add	w0, w0, 1		w0 = 1
	str	w0, [sp, 28]	sp-28 = 1						; sp-28: counter, sp-24: adder
.L2:
	ldr	w1, [sp, 28]	w1 = 0							; w1 = 1, continue looping until w1 >= 3736234946
	ldr	w0, [sp, 12]	w0 = 3736234946
	cmp	w1, w0			w1 < w0. Set carry flag to 1.
	bcc	.L3				
	ldr	w0, [sp, 24]	x0 = 11208704838, w0 = 2618770246
	add	sp, sp, 32
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
	str	w0, [x29, 28]
	str	x1, [x29, 16]
	ldr	x0, [x29, 16]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	bl	func1
	str	w0, [x29, 44]	x0 = 11208704838, w0 = 2618770246 
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	ldr	w1, [x29, 44]	w1 = 2618770246
	bl	printf
	nop
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
