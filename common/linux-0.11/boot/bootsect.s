.text
entry _start
_start:
	mov	ax, #0x07c0
	mov	ds, ax
	mov	es, ax
	mov	ss, ax

	mov	ah, #0x03
	xor	bh, bh
	int	0x10

	mov	cx, #0x10
	mov	bx, #0x0007
	mov	bp, #msg
	mov	ax, #0x1301
	int	0x10
roll:
	j	roll

msg:
	.byte 13,10
	.ascii "hahahahaha"
	.byte 13,10,13,10

.org	510
boot_flag:
	.word	0xAA55

.text
