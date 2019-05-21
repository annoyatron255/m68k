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
	bra start
