section .data

section .text

global _start

_start:
	mov EAX, 0x1
	mov EBX, 0x0
	int 0x80