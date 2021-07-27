.text
entry start
start:
	call	out_nxt_line

	mov	ah, #0x03
	xor	bh, bh
	int	0x10

	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x14
	mov	bp, #setup_msg
	add	bp, #0x200
	int	0x10
	
	call	out_nxt_line

	mov	ax, #0x07c0
	mov	ds, ax

read_cursor:
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	[0], dx
	mov	ax, dx
	call	out_nxt_line
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x0b
	mov	bp, #cursor_msg
	add	bp, #0x200
	int	0x10
	call	out_num
	call	out_nxt_line

get_mem_sz:
	mov	ah, #0x88
	int	0x15
	mov	[2], ax
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x0c
	mov	bp, #mem_msg
	add	bp, #0x200
	int	0x10
	call	out_num
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x02
	mov	bp, #kb_msg
	add	bp, #0x200
	int	0x10

	call	out_nxt_line

get_hd0_data:
	push	ds
	mov	ax, #0x0
	mov	ds, ax
	lds	si, [4*0x41]
	mov	ax, #0x07c0
	mov	es, ax
	mov	di, #0x0004
	mov	cx, #0x0010
	rep
	movsb
	pop	ds
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x05
	mov	bp, #cyls_msg
	add	bp, #0x200
	int	0x10
	mov	ax, [0x04]
	call	out_num
	call	out_nxt_line
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x08
	mov	bp, #sector_msg
	add	bp, #0x200
	int	0x10
	mov	al, [0x06]
	and	ax, #0x00ff
	call	out_num
	call	out_nxt_line
	mov	ah, #0x03
	xor	bh, bh
	int	0x10
	mov	ax, #0x1301
	mov	bx, #0x0007
	mov	cx, #0x0c
	mov	bp, #mem_msg
	add	bp, #0x200
	int	0x10
	mov	al, [0x12]
	and	ax, #0x00ff
	call	out_num
	call	out_nxt_line

completed:
	j	completed

out_nxt_line:
	push	ax
	push	bx
	push	cx
	push	dx
	push	bp
	push	es

	mov	ax, #0x07e0
	mov	es, ax

	mov	ah, #0x03
	xor	bh, bh
	int	0x10

	mov	cx, #0x2
	mov	bx, #0x0007
	mov	bp, #nxt_line
	mov	ax, #0x1301
	int	0x10

	pop	es
	pop	bp
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret

out_num:
	push	cx
	push	bx

	mov	cx, #0x04
bgn:
	sub	cx, #0x01
	push	ax
	and	ax, #0xf000
	shr	ax, #0x0c
	cmp	ax, #0x0a
	jae	upper
	add	ax, #0x30
	j	print
upper:
	add	ax, #0x37
print:
	mov	ah, #0x0e
	mov	bx, #0x0
	int	0x10
	pop	ax
	shl	ax, #0x04
	sub	cx, #0x0
	jnz	bgn
	pop	bx
	pop	cx
	ret

nxt_line:
	.byte 0x0a,0x0d

setup_msg:
	.ascii "NOW we are in SETUP!"

cursor_msg:
	.ascii "Cursor POS:"

mem_msg:
	.ascii "Memory Size:"

cyls_msg:
	.ascii "Cyls:"

head_msg:
	.ascii "Heads:"

sector_msg:
	.ascii "Sectors:"

kb_msg:
	.ascii "KB"
