.data
	msg1: .asciiz "\n\nDigite o valor de vendas do funcionario: "
	msg2: .asciiz "\n\nSalario base: R$"
	msg3: .asciiz "\nSalario Final: R$"
	msg4: .asciiz "\n\nDeseja continuar\n[0] - NAO\n[1] - SIM"
	msg5: .asciiz "\nResposta: "
.text
main:
	enquanto:

	li.s $f1, 1200.00

	li $v0, 4
	la $a0, msg1
	syscall

	li $v0, 6
	syscall
	mov.s $f2, $f0

	li.s $f3, 1500.00
	li.s $f4, 0.1
	li.s $f5, 0.2 

	c.le.s $f2, $f3
	bc1t se
	bc1f senao

	se:
	mul.s $f6, $f2, $f4
	add.s $f6, $f6, $f1
	
	j fimse

	senao:
	mul.s $f6, $f3, $f4
	add.s $f6, $f6, $f1
	sub.s $f7, $f2, $f3
	mul.s $f7, $f7, $f5
	add.s $f6, $f6, $f7

	j fimse
	fimse:

	li $v0, 4
	la $a0, msg2
	syscall

	li $v0, 2
	mov.s $f12, $f1
	syscall

	li $v0, 4
	la $a0, msg3
	syscall

	li $v0, 2
	mov.s $f12, $f6
	syscall

	li $v0, 4
	la $a0, msg4
	syscall
	
	li $v0, 4
	la $a0, msg5
	syscall

	li $v0, 5
	syscall
	add $t0, $v0, $zero

	bne $t0, 0, enquanto
	
	li $v0, 10
	syscall