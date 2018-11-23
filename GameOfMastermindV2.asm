#The Game of MasterMind (A version of it atleast)
#		Written by Nick Stone 
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
	move $s0, $0 #Set the variable to track the number of guesses to 0
	move $s1, $0 #store the Random Number generated  here
	move $s2, $0 #Track the number of Picos and Fermis
	li $s3, 500 #Set a counter for the main loop. Will be a forever loop unntil 0000 is inputted or guessed correctly
	move $s5,$0	
	#Call the random number generator. Store value in S1
	jal randnum 
	move $s1, $a0 #store result returned in $s1 register
	#move $v0, $a0  #Printing out to make sure random number worked
	#Print the random number that has been generated
	li $v0, 1
	syscall 	
	j loop 
loop:
	move $s2, $0
	beq $s3, 0000, Gdone
	#jal check
	#jal hits
	la	$a0, test	#Prompt the user to enter a value
	li 	$v0, 4	
	syscall 	
	li	$v0, 5
	syscall			#obtain the value from the user	
	move $s3,$v0
	#Checks the user input to see if they have guessed the correct nunmber 
	move $a0, $s3
	move $a1,$s1
	move $a2,$s0  
	jal check
	#jal hits
	move $s0, $v1 
	move $a0,$s3 #User guess
	move $a1, $s1 #Actual number
	jal hits 
	
	
	
	
	#jal fermis
	##move $a0,$s3 #User guess
	#move $a1, $s1 #Actual number
	#jal picos
	#beq $s2, $0, bagel
	#move $s4, $v0 
	#addi $s1, $s1, 1							
	j loop
#	li  $v0, 10             # TTFN
       #	syscall      



randnum: 	
	addi $sp, $sp, -8	    #add -8 to the stack in order to store our values
        sw   $ra, 4($sp)	    #we store the return value on the stack
        sw   $s1, 0($sp)            #Store the value of the number we are generating   
	li $v0, 42  #sys call to generate a random number
	li $a1, 9999 #the upper bounds of the random number is 4 digits long 
	li $t2, 1000
	syscall 	#sys call to gen random number
	add $s1,$a0,$0
	
	blt $s1,$t2,randnum 
	add $s3, $s1, $0 
	
	move $a0, $s1
	move $a1, $s1
	jal isunique
	move $s1, $v0
		
	#li $v0, 1
	#syscall 
	move $v0, $s1   #Move our result to v0 
	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8	#since we subtracted 8 from the stack add 8 back
	jr $ra 		#Return home 
	
isunique: 
	addi $sp, $sp, -8	    #add -8 to the stack in order to store our values
        sw   $ra, 4($sp)	    #we store the return value on the stack
        sw   $s1, 0($sp)   
	
	move $s7, $a0 
	move $s6, $a1
	li $t1, 10 
	
	div $s7, $t1
	mfhi $t5
	
	div $s7, $s7, $t1
	
	div $s7,$t1
	mfhi $t6 
#	
	div $s7 $s7,$t1
#	
	div $s7,$t1 
	mfhi $t7
	
	div $s7, $s7,$t1
	
	div $s7,$t1
	mfhi $t8 
	
	div $s7, $s7, $t1
	
#	move $a0, $t5
#	li $v0,1 
#	syscall 
	
#	move $a0, $t6
#	li $v0,1 
#	syscall 
	
	
	
	beq $t5,$t6, randnum
	beq $t5,$t7, randnum
	beq $t5,$t8, randnum

	beq $t6,$t5, randnum
	beq $t6,$t7, randnum
	beq $t6,$t8, randnum
	beq $t7, $t8, randnum#
	beq $t7, $t6, randnum
	beq $t7, $t5, randnum
	
	
	move $v0, $s7 
	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8
	jr $ra
	
	#la $t0, 0($s7) 
	#lw $t0, 0($s7)
	
	#sw $t2, 0($t0) 
	
	move $a0, $t0 
	
	
	
	li $v0,1 
	syscall 
	
	li $v0, 10 
	syscall 
	
	

check:
	move $t0, $a0 #user input 
	move $t1, $a1 #The random number 
	move $t2, $a2
	beq $t0,$t1, Wdone 
	addi $t2,$t2,1
	move $v0, $t0
	move $v1, $t2
	jr $ra
	
	
	
Wdone: 
	la $a0, win
	li $v0, 4
	syscall 
	la	$a0, space	#Prompt the user to enter a value
	li 	$v0, 4	
	syscall 
	la $a0, guess #Printing to the screen 
	li $v0, 4
	syscall 
	la	$a0, space	#Prompt the user to enter a value
	li 	$v0, 4	
	syscall 
	
	move $v0,$0
	
	move $a0, $s0  #Printing out to make sure random number worked
	
	
	li $v0, 1
	syscall 
		
	li  $v0, 10             # TTFN
       	syscall      
Gdone: 
	la $a0, givenup
	li $v0, 4
	syscall 
	la	$a0, space	#Prompt the user to enter a value
	li 	$v0, 4	
	syscall 
	la $a0, guess #Printing to the screen 
	li $v0, 4
	syscall 
	la	$a0, space	#Prompt the user to enter a value
	li 	$v0, 4	
	syscall 
	
	move $v0,$0
	
	move $a0, $s0  #Printing out to make sure random number worked
	
	
	li $v0, 1
	syscall 
		
	li  $v0, 10             # TTFN
       	syscall      
		
hits: 
	addi $sp, $sp, -8	    #add -8 to the stack in order to store our values
        sw   $ra, 4($sp)	    #we store the return value on the stack
        sw   $s1, 0($sp)   


	move $s7, $a0 #User 
	move $s3, $a1 #Actual 
	
	li $t1, 10 
	
	div $s7, $t1
	mfhi $t5
	
	div $s7, $s7, $t1
	
	div $s7,$t1
	mfhi $t6 
#	
	div $s7 $s7,$t1
#	
	div $s7,$t1 
	mfhi $t7
	
	div $s7, $s7,$t1
	
	div $s7,$t1
	mfhi $t8 
	
	div $s7, $s7, $t1
	
###############################################################
	
	
	div $s3, $t1
	mfhi $t1
	
	div $s3, $s3, $t1
	
	div $s3,$t1
	mfhi $t2 
#	
	div $s3 $s3,$t1
#	
	div $s3,$t1 
	mfhi $t3
	
	div $s3, $s3,$t1
	
	div $s3,$t1
	mfhi $t4 
	
	div $s3, $s3, $t1


	beq $t1, $t5 fermisss 
	beq $t1, $t6 picoss
	beq $t1, $t7 picoss 
	beq $t1, $t8 picoss 
	beq $t2, $t5 picoss 
	beq $t2, $t6 fermisss
	beq $t2, $t7 picoss 
	beq $t2, $t8 picoss
	beq $t3, $t5 picoss 
	beq $t3, $t6 picoss
	beq $t3, $t7 fermisss 
	beq $t3, $t8 picoss
	beq $t4, $t5 picoss 
	beq $t4, $t6 picoss
	beq $t4, $t7 picoss 
	beq $t4, $t8 fermisss

#############################################################

	
	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8

	jr $ra


fermisss: 
	la $a0, fermi
	li $v0, 4
	syscall 
	
	jr $ra
picoss:	
	la $a0, pico
	li $v0, 4
	syscall 
	
	jr $ra
	
bagels:
	la $a0, bagel 
	li $v0, 4
	syscall 
	
	jr $ra