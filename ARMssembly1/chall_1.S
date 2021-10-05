	.arch armv8-a
	.file	"chall_1.c"
	.text
	.align	2
	.global	func
	.type	func, %function
func:
	sub	sp, sp, #32
	str	w0, [sp, 12]	sp-12 = w0 = 3
	mov	w0, 87			w0 = 87
	str	w0, [sp, 16]	sp-16 = 87
	mov	w0, 3			
	str	w0, [sp, 20]	sp-20 = 3
	mov	w0, 3
	str	w0, [sp, 24]	sp-24 = 3
	ldr	w0, [sp, 20]	w0 = 3
	ldr	w1, [sp, 16]	w1 = 87
	lsl	w0, w1, w0		w0 = 87 << 3 = 696
	str	w0, [sp, 28]	sp-28 = 696
	ldr	w1, [sp, 28]	w1 = 696
	ldr	w0, [sp, 24]	w0 = 3
	sdiv	w0, w1, w0	w0 = 696 / 3 = 232
	str	w0, [sp, 28]	sp-28 = 232
	ldr	w1, [sp, 28]	w1 = 232
	ldr	w0, [sp, 12]	w0 = 3
	sub	w0, w1, w0		w0 = w1 - w0 = 232 - 3 = 229
	str	w0, [sp, 28]	sp-28 = 229
	ldr	w0, [sp, 28]	w0 = 229
	add	sp, sp, 32		
	ret
	.size	func, .-func
	.section	.rodata
	.align	3
.LC0:
	.string	"You win!"
	.align	3
.LC1:
	.string	"You Lose :("
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	str	w0, [x29, 28]	# What do these parts mean?
	str	x1, [x29, 16]	# 
	ldr	x0, [x29, 16]	# 
	add	x0, x0, 8		#
	ldr	x0, [x0]		#
	bl	atoi			# Till here
	str	w0, [x29, 44]	# w0 (x29 + 44): 3
	ldr	w0, [x29, 44]
	bl	func
	cmp	w0, 0			# 5
	bne	.L4
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts
	b	.L6
.L4:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
.L6:
	nop
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
