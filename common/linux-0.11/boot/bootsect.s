.text
entry _start
_start:
	mov	ax, #0x07c0
	mov	ds, ax
	mov	es, ax

	mov	ah, #0x03
	xor	bh, bh
	int	0x10

	mov	cx, #0x18
	mov	bx, #0x0007
	mov	bp, #msg
	mov	ax, #0x1301
	int	0x10

read_setup:
	mov	ax, #0x0201
	mov	cx, #0x0002
	mov	bx, #0x0200
	mov	dx, #0x0000
	int	0x13
	jnc	roll
	mov	dx, #0x0000
	mov	ax, #0x0000
	int	0x13
	j	read_setup

roll:
	mov	ax, #0x7e00
	jmp	ax

msg:
	.byte 13,10
	.ascii "Loading Setup..."
	.byte 13,10,13,10

.org	510
boot_flag:
	.word	0xAA55

