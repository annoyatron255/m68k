	.org 0x0
e_vectors:
	.long 0x00001000
	.long start
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap, trap, trap
	.long trap, trap
	.org 0x400
trap:
	rte
start:
	movea.l #(message),a0
	move.b #14,d1
loop:
	move.b (a0)+,d0
	jsr cout
	sub #1,d1
	tst.b d1
	bne.s loop
	bra start

cout:
	btst.b #0,0x7C000
	bne.s cout
	move.b d0,0x7A000
	rts

cin:
	btst.b #0,0x7D000
	bne.s cin
	move.b 0x78000,d0
	rts

message:
	.ascii "Hello, World!\n"
