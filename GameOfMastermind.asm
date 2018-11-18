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
	move $s2, $0 #
	li $s3, 500 #Set a counter for the main loop. Will be a forever loop unntil 0000 is inputted or guessed correctly
	
	jal randnum 
	move $s1, $a0 #store result returned in $s1 register
	
	#move $v0, $a0  #Printing out to make sure random number worked
	
	
	
	
	li $v0, 1
	syscall 	
	j loop 


loop:
	beq $s3, 0000, Gdone
	#jal check
	
	#jal hits
	
	la	$a0, test	#Prompt the user to enter a value
	li 	$v0, 4	
	syscall 	
	
	li	$v0, 5
	syscall			#obtain the value from the user	
	
	move $s3,$v0
	move $a0, $s3
	move $a1,$s1
	move $a2,$s0  
	jal check
	#jal hits
	move $s0, $v1 
	#move $a0,$s3
	#move $a1, $s1
	#jal hits 
	
	#move $s4, $v0 
			
	#addi $s1, $s1, 1
			
							
	j loop

	li  $v0, 10             # TTFN
       	syscall      

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
	#li $v0, 1
	#syscall 
	
	move $v0, $a0    #Move our result to v0 
	
	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8	#since we subtracted 8 from the stack add 8 back
	
	
	jr $ra 		#Return home 

check:
	move $t0, $a0 #user input 
	move $t1, $a1 #The random number 
	move $t2, $a2
	
	
	
	beq $t0,$t1, Wdone 
	
	
	addi $t2,$t2,1
	
	
	move $v0, $t0
	move $v1, $t2
	
	
	jr $ra

hits:
	la $s5, 0($a0)
	la $s6, 0($a1) 
	#j loopf
	
	#beq $s5, $s6, fermip 
	
	
	addi $s5, $s5, 4
	addi $s6, $s6, 4

	la $a0, guess #Printing to the screen 
	li $v0, 4
	syscall 
			
	move $t5, $t3
	
	move $a0, $t5
	li $v0, 1 
	syscall 
	jr $ra
	#beq 0($a0), 0($a1), test
	#sw $a0, 0($s5)
	#sw $a1, 0($s6)
	
	#move $t1, $a0
	#move $t2, $a1
	
	#lw $t3, 0($t1)
	#move $t1, $a0 #user guess
	#move $t2, $a1 #rando answer
	
	#move $t1,0($t1)
	#sw $t2,0($t2)
	#lw $t3, 0($t1)
#test: #
#	li $a0, 00000000000000000000111111111#
#	li $v0,1
#	syscall

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
		
		
#fermi: 

#	la $a0, fermi
#	li $v0, 4
#	syscall 
	


#ppico: 
#	la $a0, pico 
#	li $v0, 4
#	syscall 


#pbagel: 
#	la $a0, bagel 
#	li $v0, 4
#	syscall 
	
