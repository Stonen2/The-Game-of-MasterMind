#		11/11/2018

	.data 
	.align 2
test:	.asciiz "Enter a Value to guess"
guess: .asciiz "The number of guesses you have attempted is"
space: .asciiz "\n"
pico: .asciiz "Pico"
bagel: .asciiz  "bagel"
fermi: .asciiz "Fermi"
win: 	.asciiz "You have guessed the correct number"
givenup: .asciiz "You have given up"

.text
.globl main 

main: 
	li $s0, 9854
	la $t2, 0($s0) 
	
	#addi $t2, $t2, 4
	
	
	
	la $t3, 0($t2)
	
	la $t4, 4($t3)
	#addi $t3, $t3, 4
	li $s0, 10
	li $s1, 100 
	li $s2, 1
	li $s3, 1000
	
	
	div $s4, $t3, $s1
	div $s5, $t3, $s2
	div $s6, $t3, $s3
	#div $s4, $s4, $s1
	
	
	div $t3, $s0 
	mfhi $t6
#	div $t3, $s0 
#	mflo $t3
#	div $t3, $s0 
#	mflo $t6
	
	#div $t1, $t3,$s0



#	move $a0, $t1
#	li $v0,1 
#	syscall 
	
	move $a0, $t6
	li $v0,1 
	syscall 
	
#	move $a0, $s5
#	li $v0,1 
#	syscall 
	
#	move $a0, $s6
#	li $v0,1 
#	syscall 
	
	
	li $v0,10
	syscall 
	
