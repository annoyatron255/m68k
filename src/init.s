	.org 0x0
e_vectors:
	.long 0x00001000
	.long start
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
	.long trap
trap:
	rte
start:
	bra start
