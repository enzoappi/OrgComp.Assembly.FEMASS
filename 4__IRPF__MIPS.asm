.data
	meuVetor: .space 16 #criacao de um vetor em memoria

	msg1: .asciiz "\nSalario Bruto: "
	msg2: .asciiz "Deducao total do INSS: "
	msg3: .asciiz "\n\nDependentes: "
	msg4: .asciiz "Deducao total do(s) dependente(s): "
	msg5: .asciiz "\n\nSalario Liquido: "
	msg6: .asciiz "RECEITA FEDERAL - IRPF 2019\n"
	msg7: .asciiz "["
	msg8: .asciiz "a Faixa]: "
	msg9: .asciiz "  - [Aliquota]: "
	msg10: .asciiz "  - [Valor do Imposto]: "
	msg11: .asciiz "\nTotal de imposto: "
   	msg12: .asciiz "\nAliquota efetiva (PORCENTAGEM) : "
	msg13: .asciiz "\n"
.text
main:
	
	#**************************************************#	
	#                     Cabecalho                    #
	#**************************************************#
	li $v0, 4
	la $a0, msg6
	syscall
	#**************************************************#
	#INSERCAO DO SALARIO BRUTO
	li $v0, 4
	la $a0, msg1
	syscall
	#--------------------------------------------------#	
	li $v0, 6
	syscall
	mov.s $f1, $f0		#REGISTRADOR do SALARIO BRUTO
	
	#**************************************************#
	#Faixas de deducao do INSS pra inserir no DC I
	li.s $f2, 1751.81
	li.s $f3, 2919.72
	li.s $f4, 5839.45
	li.s $f5, 0.08
	li.s $f6, 0.09
	li.s $f7, 0.11
	li.s $f8, 621.04
	#**************************************************#
	
	#**************************************************#	
	#**************************************************#	
	#               DESVIO CONDICIONAL I               #
	#**************************************************#
	#**************************************************#
	c.lt.s $f1, $f2
	bc1t se_a
	bc1f senao_a
	#--------------------------------------------------#	
	se_a:
	mul.s $f9, $f1, $f5 
	j fimse_a
	#--------------------------------------------------#	
	senao_a:
	c.lt.s $f1, $f3
	bc1t se_b
	bc1f senao_b
	#--------------------------------------------------#	
	se_b:
	mul.s $f9, $f1, $f6
	j fimse_a
	#--------------------------------------------------#	
	senao_b:
	c.lt.s $f1, $f4
	bc1t se_c
	bc1f senao_c
	#--------------------------------------------------#	
	se_c:
	mul.s $f9, $f1, $f7		#registrador da deducao total do INSS
	j fimse_a
	#--------------------------------------------------#	
	senao_c:
	mov.s $f9, $f8			#registrador da deducao total do INSS
	j fimse_a
	#**************************************************#
	#**************************************************#
	fimse_a:		#FIM DO DESVIO CONDICIONAL I       #
	#**************************************************#
	#**************************************************#

	#**************************************************#
	#Apresentacao da deducao do INSS	
	li $v0, 4
	la $a0, msg2
	syscall
	#--------------------------------------------------#	
	li $v0, 2
	mov.s $f12, $f9
	syscall
	#**************************************************#
	#Insercao do numero de dependentes	
	li $v0, 4
	la $a0, msg3
	syscall
	#--------------------------------------------------#	
	li $v0, 6
	syscall
	mov.s $f10, $f0		#registrador do NUM DE DEPENDENTES

	#**************************************************#
	#Condicoes de deducao DEPENDENTES pra inserir no DC II
	li.s $f11, 12.0
	li.s $f13, 189.59
	#**************************************************#
	
	#**************************************************#	
	#**************************************************#	
	#               DESVIO CONDICIONAL II              #
	#**************************************************#
	#**************************************************#
	c.lt.s $f10, $f11
	bc1t se_d
	bc1f senao_d
	#--------------------------------------------------#	
	se_d:
	mul.s $f14, $f10, $f13		#registrador do desconto NUM DE DEPENDENTES
	j fimse_b
	#--------------------------------------------------#	
	senao_d:
	mul.s $f14, $f11, $f13		#registrador do desconto NUM DE DEPENDENTES
	j fimse_b
	#**************************************************#
	#**************************************************#
	fimse_b:		#FIM DO DESVIO CONDICIONAL II      #
	#**************************************************#
	#**************************************************#
	
	#**************************************************#
	#Apresentacao de DEDUCOES DE DEPENDENTES	
	li $v0, 4
	la $a0, msg4
	syscall
	#--------------------------------------------------#	
	li $v0, 2
	mov.s $f12, $f14
	syscall
	#**************************************************#
	#Apresentacao do SALARIO LIQUIDO	
	li $v0, 4
	la $a0, msg5
	syscall

	#**************************************************#
	#Desconto de INSS e Dependentes do salario Bruto
	add.s $f15, $f9, $f14
	sub.s $f16, $f1, $f15		#registrador do SALARIO LIQUIDO
	#**************************************************#
	
	li $v0, 2
	mov.s $f12, $f16
	syscall	 
	#--------------------------------------------------#	
	#--------------------------------------------------#	
	#pula linha
	li $v0, 4
	la $a0, msg13
	syscall
	#--------------------------------------------------#	
	#pula linha
	li $v0, 4
	la $a0, msg13
	syscall
	#--------------------------------------------------#	
	#pula uma linha
	li $v0, 4
	la $a0, msg13
	syscall
	#**************************************************#	
	#                     Cabecalho                    #
	#**************************************************#	
	li $v0, 4
	la $a0, msg6
	syscall

	#**************************************************#		
	#**************************************************#	
	#    valores que serao armazenados no meuVetor     #
	#**************************************************#
	#**************************************************#		
	li.s $f21, 1903.98	#inserindo o valor da base de calculo da faixa no reg. f21
	li.s $f22, 2826.65	#inserindo o valor da base de calculo da faixa no reg. f22
	li.s $f23, 3751.05	#inserindo o valor da base de calculo da faixa no reg. f23
	li.s $f24, 4664.68	#inserindo o valor da base de calculo da faixa no reg. f24

	#**************************************************#	
	#**************************************************#	
	#         alocando os valores no meuVetor          #
	#**************************************************#
	#**************************************************#		
	addi $t0, $zero, 0	#incremento do indexador do endereco de memoria de acesso aos elementos do vetor. Valor final do endereco = 0
	swc1 $f21, meuVetor($t0)	#acessando o valor do vetor na posicao do incremento $t0
	addi $t0, $t0, 4	#incremento do indexador do endereco de memoria de acesso aos elementos do vetor. Valor final do endereco = 4
	swc1 $f22, meuVetor($t0)	#acessando o valor do vetor na posicao do incremento $t0
	addi $t0, $t0, 4	#incremento do indexador do endereco de memoria de acesso aos elementos do vetor. Valor final do endereco = 8
	swc1 $f23, meuVetor($t0)	#acessando o valor do vetor na posicao do incremento $t0
	addi $t0, $t0, 4	#incremento do indexador do endereco de memoria de acesso aos elementos do vetor. Valor final do endereco = 12
	swc1 $f24, meuVetor($t0)


	#**************************************************#	
	#alocacoes necessarias pra execucao do laco	
	li.s $f10, 0.0		#acumulador do imposto total
	li.s $f28, 0.0		#declaracao do registrador de incremento da aliquota
	li.s $f27, 1.0		#incrementador da aliquota
	#**************************************************#
	
	
	#**************************************************#
	#**************************************************#		
	#**************************************************#	
	#                 INICIO DO LOOP                   #
	#**************************************************#
	#**************************************************#
	#**************************************************#	
	
	li $v0, 0
	li $t0, 0

	
	loop:
	bgt $t0, 4, exit
	mul $t9, $t0, 4
	
	li.s $f1, 0.075		#aliquota
	lwc1 $f0, meuVetor($t9)
	mov.s $f2, $f0
	mul.s $f1, $f1, $f28  #tava efffedois antes de efffevinteoito	
	
	
	#**************************************************#	
	#**************************************************#	
	#               DESVIO CONDICIONAL III             #
	#**************************************************#
	#**************************************************#

	#**************************************************#		
	#teste logico pra saber qual o valor do incremento.#
	#**************************************************#
	ble, $t0, 0, A
	j B
	#--------------------------------------------------#	
	A:
	c.lt.s, $f16, $f2
	bc1t se_do_A
	bc1f senao_do_A
	#--------------------------------------------------#
	se_do_A:
	mov.s $f3, $f16
	mov.s $f25, $f2
	j fimse_geral
	#--------------------------------------------------#
	senao_do_A:
	mov.s $f3, $f2
	mov.s $f25, $f2
	j fimse_geral
	#**************************************************#	
	#teste logico pra saber qual o valor do incremento.#
	#**************************************************#	
	B:
	blt, $t0, 4, Cc		#caso sim va pra Cc
	j D			# caso nao va pra D
	#--------------------------------------------------#	
	Cc:
	c.lt.s, $f16, $f2
	bc1t se_do_Cc
	bc1f senao_do_Cc
	#--------------------------------------------------#
	se_do_Cc:
	sub.s $f3, $f16, $f25
	mov.s $f25, $f2
	j fimse_geral
	#--------------------------------------------------#
	senao_do_Cc:
	sub.s $f3, $f2, $f25
	mov.s $f25, $f2
	j fimse_geral
	#**************************************************#	
	#teste logico pra saber qual o valor do incremento.#
	#**************************************************#	
	D:
	bge, $t0, 4, E
	j fimse_geral
	#--------------------------------------------------#	
	E:
	li.s $f1, 0.275		#aliquota
	c.lt.s, $f16, $f25
	bc1t se_do_E
	bc1f senao_do_E
	#--------------------------------------------------#
	se_do_E:
	li.s $f3, 0.0
	j fimse_geral
	#--------------------------------------------------#
	senao_do_E:
	sub.s $f3, $f16, $f25
	j fimse_geral
 	#**************************************************#	
	#**************************************************#	
	fimse_geral:		#FIM DO DESVIO CONDICIONAL III #
	#**************************************************#
	#**************************************************#
	
	
	#**************************************************#	
	#**************************************************#	
	#               DESVIO CONDICIONAL IV              #
	#**************************************************#
	#**************************************************#	
	li.s $f31, 0.0
	c.lt.s $f3, $f31
	bc1t zeraFaixa
	bc1f nadaMuda
	#--------------------------------------------------#
	zeraFaixa:
	mov.s $f3, $f31
	j fimzeraFaixa
	#--------------------------------------------------#
	nadaMuda:
	mov.s $f3, $f3
	j fimzeraFaixa
	#**************************************************#
	#**************************************************#
	fimzeraFaixa:		#FIM DO DESVIO CONDICIONAL IV  #
	#**************************************************#
	#**************************************************#
	
	
	#**************************************************#
	#Calculos parciais
	mul.s $f9, $f1, $f3 #imposto parcial
	add.s $f10, $f10, $f9 #imposto final
	#**************************************************#	
	
	
	#**************************************************#
	#**************************************************#	
	#    APRESENTACAO DA TABELA DE CALCULOS PARCIAIS.  #
	#**************************************************#
	#**************************************************#
	#pula uma linha
	li $v0, 4
	la $a0, msg13
	syscall
	#**************************************************#
	#Printa a FAIXA
	li $v0, 4
	la $a0, msg7
	syscall
	
	li $v0, 1
	add $a0, $t0, 1
	syscall
	#--------------------------------------------------#	
	li $v0, 4
	la $a0, msg8
	syscall
	#--------------------------------------------------#
	li $v0, 2
	mov.s $f12, $f3
	syscall	
	#**************************************************#
	#Printa a ALIQUOTA
	li $v0, 4
	la $a0, msg9
	syscall
	#--------------------------------------------------#
	li $v0, 2
	mov.s $f12, $f1
	syscall	
	#**************************************************#	
	#Printa o valor do IMPOSTO PARCIAL 	na faixa
	li $v0, 4
	la $a0, msg10
	syscall
	#--------------------------------------------------#	
	li $v0, 2
	mov.s $f12, $f9
	syscall		
	#--------------------------------------------------#
	#pula uma linha
	li $v0, 4
	la $a0, msg13
	syscall	
	#**************************************************##
	li.s $f27, 1.0				#incrementando o indice que atualizara a aliquota da faixa
	add.s $f28, $f28, $f27		#incrementando o contador de acumulo da aliquota
	#**************************************************#
	#Incrementando os registradores dos indices do laco
	move $v0, $t0
	addiu $t0, $t0, 1
	j loop
	#**************************************************#	
	#**************************************************#
	#**************************************************#
	exit:			#FIM DO LOOP
	#**************************************************#
	#**************************************************#	
	#**************************************************#



	#**************************************************#
	#**************************************************#	
	#         APRESENTACAO DOS CALCULOS FINAIS         #
	#**************************************************#
	#**************************************************#	
	#pula uma linha
	li $v0, 4
	la $a0, msg13
	syscall
	#**************************************************#
	#IMPOSTO TOTAL
	li $v0, 4
	la $a0, msg11
	syscall
	#--------------------------------------------------#	
	li $v0, 2
	mov.s $f12, $f10
	syscall	
	#--------------------------------------------------#
	#pula uma linha
	li $v0, 4
	la $a0, msg13
	syscall
	#**************************************************#
	#ALIQUOTA EFETIVA
	li $v0, 4
	la $a0, msg12
	syscall

	li.s $f20, 100.0
	mul.s $f21, $f10, $f20
	div.s $f21, $f21, $f16
	#--------------------------------------------------#	
	li $v0, 2
	mov.s $f12, $f21
	syscall		
	#--------------------------------------------------#
	li $v0, 10
	syscall
	