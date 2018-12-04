#	The Game of MasterMind 
#		Written by Nick Stone 
#		11/11/2018

	
		
	.data 
	.align 2
	
test:	.asciiz "Enter a Value to guess "
guess: .asciiz "The number of guesses you have attempted is "
space: .asciiz "\n"
pico: .asciiz "Pico "
bagel: .asciiz  "bagel "
fermi: .asciiz "Fermi "
win: 	.asciiz "You have guessed the correct number"
givenup: .asciiz "You have given up"
corrections: .asciiz "The correct number was " 
.text
.globl main 

main: 
	move $s0, $0 #Set the variable to track the number of guesses to 0
	move $s1, $0 #store the Random Number generated  here
	move $s2, $0 #Track the number of Picos and Fermis
	li $s3, 500 #Set a counter for the main loop. Will be a forever loop unntil 0000 is inputted or guessed correctly
	move $s5,$0	#set S5 to 0 to be used later in the program 
	#Call the random number generator. Store value in S1
	jal randnum #Call the randnum function this should 
	move $s1, $a0 #store result returned in $s1 register
	#move $v0, $a0  #Printing out to make sure random number worked
	#Print the random number that has been generated
	#li $v0, 1     #Print the value that we have randomly generated
	#syscall 	#the syscall to print the random value 


# THis is the main function of the program
# THis will keep running the games contents until the guess is correct
#Or if the user is to enter 0000

loop:
	move $s2, $0		#set this value to 0 every time. 
	beq $s3, 0000, Gdone #If the user input is 0000 go to the quit sequence 
	
	la	$a0, space	#Formatting purpose add a space
	li 	$v0, 4		#Formatting purpose add a space
	syscall 		#Formatting purpose add a space  
		
	la	$a0, test	#Prompt the user to enter a value
	li 	$v0, 4		#Prompt the user to enter a value 
	syscall 		#Prompt the user to enter a value 
	
	li	$v0, 5		#Obtain the value the user is guessing 
	syscall			#obtain the value from the user	
	
	move $s3,$v0            #Store the value guessed into s3
	
	
	move $a0, $s3		#Loading the value guessed into a parameter
	move $a1,$s1		#Load the actual guess into parameter to be passed
	move $a2,$s0  		#Pass the count variable as a parameter
	
	jal check		#Checks the user input to see if they have guessed the correct nunmber 
	
	move $s0, $v1 		#Store the Value returned into S0 (Track) 
	add $s4, $s3, $0	#Move the value guessed into S4
	move $a0,$s3 		#move the User guess into a parameter to be passed
	move $a1, $s1 		#move the Actual number into aa parameter to be passed
	
	jal hits 		#Now find the Pico Fermi Sequence from the guess
	
	move $s3, $s4		#Reset S3(User Guess) TO be checked if they want to quit 
	
	j loop  #Return to the top of the loop and prompt the user to enter the next guess
	
#This functionis called when the program needs to generate a random number
#This function generates a random number and checks if the number is unique
# Sets the lowest bound to be 1000 and the upper bound to be 9999 (4 digits)
#This function is called multiple times 	
randnum: 	
	addi $sp, $sp, -8	    #add -8 to the stack in order to store our values
        
        sw   $ra, 4($sp)	    #we store the return value on the stack
        sw   $s1, 0($sp)            #Store the value of the number we are generating   
        
	li $v0, 42  #sys call to generate a random number
	li $a1, 9999 #the upper bounds of the random number is 4 digits long 
	li $t2, 1000   #using t2 to make sure our number is greater than 1000 or has 4 digits
	syscall 	#sys call to gen random number
	
	add $s1,$a0,$0	#move the randomly generated number to the s1 reg
	
	blt $s1,$t2,randnum  # if s1 is less than 1000 regenerate a new number
	
	add $s3, $s1, $0  #set the S3 register also equal to the randomly generated number
	move $a0,$0	#Set a0 register to 0 
	add $a0, $s1,$0     #move the s1 register to the parameter we are passing isuniq
	move $a1, $0	  #Move s1 register to be passed to the isunique function
	add $a0,$s1,$0	#set a1 register to 0 
	
	jal isunique	#Call the function to check if the number has 4 unique numebers
	
	move $s1, $v0  #store the number in we generated that is unique back in s1
	move $v0, $s1   #Move our result to v0 
	
	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8	#since we subtracted 8 from the stack add 8 back
	
	jr $ra 		#Return home 
	
#The point of this function is to break down the number into all of its 
#unique individual digits and make sure all digits are the same and unique
#This program if the number is not unqieu recallsd Randnum 
isunique: 
	addi $sp, $sp, -8	    #add -8 to the stack in order to store our values
        sw   $ra, 4($sp)	    #we store the return value on the stack
        sw   $s1, 0($sp)   	    #Store the value S1 onto the stack S
	
	move $s7, $a0 		    #Set the S7 Register to the parameter register(Random num)
	move $s6, $a1		    #Set the s6 register to the random number
	
	li $t1, 10 		#Set t1 to 10 so we can get each individual digit
	div $s7, $t1		#Divide the random num by 10 Works like Modulus Operator 
	mfhi $t5		#Store the overflow (Mod value) IN t5
	div $s7, $s7, $t1	#Divide s7 by 10 to continue getting individual digits. 
	div $s7,$t1		#Use the modulus operator to get the next digit
	mfhi $t6 		#Store the mod value into the t6 register
	div $s7 $s7,$t1		#Dvivde the random number by 10 to continue finding digits
	div $s7,$t1 		#Use the moduluz operator on the new random digit
	mfhi $t7		#Store the mod value in the t7 
	div $s7, $s7,$t1	#Divide by s7 in order to continue finding digit values 
	div $s7,$t1		# Use the modulus operator one last time get the last digit
	mfhi $t8 		#Store off the mod value into the t8 register 
	div $s7, $s7, $t1	#Divide s7 in case we need to use the S7 value 
	
	#Check all of the digits to make sure there unique if not call randnum again 
	beq $t5,$t6, randnum	#Check if the last digit and the 3rd digit
	beq $t5,$t7, randnum	#Check the 4th digit and the 2nd digit
	beq $t5,$t8, randnum	#Check the 4th digit and the 1st digit
	beq $t6,$t5, randnum	#Check the 3rd digit and the 4th digit
	beq $t6,$t7, randnum	#Check the 3rd digit and the 2nd digit
	beq $t6,$t8, randnum	#Check the 3rd digit and the 1st digit 
	beq $t7, $t8, randnum	#CHekc the 2nd digit and the 1st digit
	beq $t7, $t6, randnum	#Check the 2nd digit and the 3rd digit
	beq $t7, $t5, randnum	#Check the 2nd digit and the 4th digit 
	#Finish chekcing all of the digits  
	
	move $v0, $s7 #Load the unique number to be returned by jr ra 
	
	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8	#Reallocate memory onto the stack 
		
	jr $ra			#Return home (Reutn back to function 
	
	
	
#This is the condition that checks if the user guess is equal
# to the random number that has been generated. 
#If they are equal a win condition is met 
#And the game is ended 
check:
	addi $sp, $sp, -4	    #add -8 to the stack in order to store our values
        sw   $ra, 0($sp)	    #Store off the ra from the stack 
	
	move $t0, $a0 #user input stored in the t0 register
	move $t1, $a1 #The random number stored in the t1 register 
	move $t2, $a2 # Store off the count variable in t2
	
	beq $t0,$t1, Wdone #If the guess value is equal to the random number go win 
	
	addi $t2,$t2,1    #increment the count by 1 
	
	move $v0, $t0	  #store off the user input to be returned 
	move $v1, $t2	  #Store off the value to be guessed to be returned 
        
        lw   $ra, 0($sp)	#Restore the stack 
	addi $sp, $sp, 4	    #add -8 to the stack in order to store our values

	jr $ra		#Return home and return the user input and random input 
#This is the win condition. This is called after the user 
#Guesses the correct random number 
#Prints the win to the screen then ends the program
Wdone: 
	la $a0, win	#Load the global you have won 
	li $v0, 4	#Print the win message
	syscall 	#Print the win message 
	
	la	$a0, space	#Add a space to format 
	li 	$v0, 4		#Add formatting changes
	syscall 		#Print a blank space 
	
	la $a0, guess #Printing to the screen the number of guesses 
	li $v0, 4	#Print to the screen the number of guesses
	syscall 	#Print to the screen the number of guesses
	
	la	$a0, space	#Format the page with a space 
	li 	$v0, 4		#Format the page with a space 
	syscall 		#Format the page with a space 
	
	
	move $v0,$0    #Set v0 to be 0 
	move $a0, $s0  #Printing out to make sure random number worked
	
	li $v0, 1	#Print to the screen the random number
	syscall 	#print to the screen the random number 
	
	
	#END OF THE PROGRAM 
	li  $v0, 10             # TTFN
       	syscall      
#This is the given up condition
#This prints what the correct number was and ends the program 
#This is reached when the user enters 0000
Gdone: 
	la $a0, givenup  #Load the you have given up prompt 
	li $v0, 4	#Load the you have given up prompt 
	syscall 	#Load the you have given up prompt 
	
	la	$a0, space	#Format the scren with a blank space
	li 	$v0, 4		#FOrmat the screen with a blank space 
	syscall 		#Format the screen with a blank space 
	
	la $a0, guess #Print to the scren the number of guesses
	li $v0, 4	#Print to the scren the number of guesses
	syscall 	#Print to the scren the number of guesses
	
	la	$a0, space	#Format the scren with a blank space
	li 	$v0, 4		#Format the scren with a blank space
	syscall 		#Format the scren with a blank space
	
	move $v0,$0	#Move the v0 register to have the value 0 
	move $a0, $s0  #Printing out to make sure random number worked
	
	li $v0, 1	#Print the random number to the screen
	syscall		#Print the random number to the screen 
	
	la	$a0, space	#Format the scren with a blank space
	li 	$v0, 4		#Format the scren with a blank space
	syscall 		#Format the scren with a blank space
	
	
	la $a0, corrections 	#THe correct number was
	li $v0, 4		#THe correct number was
	syscall 		#THe correct number was
	
	la	$a0, space	#Format the scren with a blank space
	li 	$v0, 4		#Format the scren with a blank space
	syscall 		#Format the scren with a blank space
	
	move $a0, $s1 #store result returned in $s1 register
	#move $v0, $a0  #Printing out to make sure random number worked
	#Print the random number that has been generated
	
	li $v0, 1	#Print to the screen the random number
	syscall 	#Print to the screen the random number
	
	
	#END OF THE PROGRAM 
	
	li  $v0, 10             # TTFN
       	syscall      
#THis function checks to see the combination of both the number guessed
#and its correlation to the correct random number
#From this is then generates Pico Fermi or Bagel 
hits: 
	addi $sp, $sp, -8	    #add -8 to the stack in order to store our values
        sw   $ra, 4($sp)	    #we store the return value on the stack
        sw   $s1, 0($sp)   	    #Store S1 onto the stack 
	
	move $s6,$0   #	Set the S6 register to the value of 0 
	move $s7, $a0 #User Move the value from a0 to the s7 register User input
	move $s3, $a1 #Actual Move the value from a1 to s3, the actual guess. 
	
	li $t1, 10 #set the value of 10 to the t1 register to get the individual digits

#COmparing each digit to the user obtained answer 	
	div $s7, $t1	#Use modulus to obtian each digit to then compare 
	mfhi $t6	#Save the modulus value into t6
	
	div $s7, $s7, $t1	#Divide s7 by 10 to then run modulus on
	div $s7,$t1		#Mod operate S7 
	mfhi $t7 		#Store the mod valueinto t7 
	
	div $s7 $s7,$t1	#Divide S7 by 10 to continue modulus 
	div $s7,$t1 	#Use modulus to obtian each digit to then compare 
	mfhi $t8	#Save the modulus value into t8
	
	div $s7, $s7,$t1	#Divide s7 by 10 to then run modulus on
	div $s7,$t1	#Use modulus to obtian each digit to then compare 
	mfhi $t9 #Save the modulus value into t9
###############################################################
#THis is comparing all of the digits to the ranom number 

	div $s3, $t1	#Use modulus to obtian each digit to then compare 
	mfhi $t2	#Save the modulus value into t2
	
	div $s3, $s3, $t1 #Divide s3 by 10 to then run modulus on
	div $s3,$t1	#Use modulus to obtian each digit to then compare 
	mfhi $t3 #Save the modulus value into t3

	div $s3 $s3,$t1	#Divide s3 by 10 to then run modulus on
	div $s3,$t1 #Use modulus to obtian each digit to then compare 
	mfhi $t4	#Save the modulus value into t4
	
	div $s3, $s3,$t1#Divide s3 by 10 to then run modulus on
	div $s3,$t1	#Use modulus to obtian each digit to then compare 
	mfhi $t5 	#Save the modulus value into t5
#THis sequence of steps compares each unique individual number a position in 
#THe randomly generated number 
#This will call a function that calls pico or Fermi 
#Then will jump back to continue checking until all numbers have been checked
#Or bagel is printed 
step1:	beq $t9, $t2 check1 #Checks a digit from the user guess to the correct number 
step2:	beq $t9, $t3 check2  #Checks a digit from the user guess to the correct number 
step3:	beq $t9, $t4 check3  #Checks a digit from the user guess to the correct number 
step4:	beq $t9, $t5 check4  #Checks a digit from the user guess to the correct number 
step5:	beq $t8, $t2 check5 #Checks a digit from the user guess to the correct number 
step6:	beq $t8, $t3 check6 #Checks a digit from the user guess to the correct number 
step7:	beq $t8, $t4 check7  #Checks a digit from the user guess to the correct number 
step8:	beq $t8, $t5 check8 #Checks a digit from the user guess to the correct number 
step9:	beq $t7, $t2 check9  #Checks a digit from the user guess to the correct number 
step10:	beq $t7, $t3 check10 #Checks a digit from the user guess to the correct number 
step11:	beq $t7, $t4 check11  #Checks a digit from the user guess to the correct number 
step12:	beq $t7, $t5 check12 #Checks a digit from the user guess to the correct number 
step13:	beq $t6, $t2 check13  #Checks a digit from the user guess to the correct number 
step14:	beq $t6, $t3 check14 #Checks a digit from the user guess to the correct number 
step15:	beq $t6, $t4 check15  #Checks a digit from the user guess to the correct number 
step16:	beq $t6, $t5 check16 #Checks a digit from the user guess to the correct number 
step17: beq $s6,$0, check17 #Checks a digit from the user guess to the correct number 
step18:  # This step leads to returning all values to the stack then returns home 

#############################################################

	lw   $ra, 4($sp)	#need to reallocate memory to the stack 
	lw   $s1, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 8	#reallocate memory to the stack 
	
	jr $ra		#Return Home 
#End the Check Funcciton. This will return to the main 
	
	
	
	
#These functions are called but are not used in the main function of the program.
#All Functions here after are quick function calls that jump back to the function that called them 
###################################################################	


#This function is the case when the first number 
#Equals the first number of the number to guess
#Then prints Pico and jumps to the next check 
check1:
	addi $s6,$s6,1
	jal picoss
	j step2
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check2:
	addi $s6,$s6,1
	jal picoss
	j step3
	
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check3:
	addi $s6,$s6,1
	jal picoss
	j step4

check4:
	addi $s6,$s6,1
	jal fermisss
	j step5
	#First Value Number check over
	#########################
	#
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check5:
	addi $s6,$s6,1
	jal picoss
	j step6
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check6:
	
	addi $s6,$s6,1
	jal picoss 
	j step7 
#THis functions is called by comparing 2 digits
#This scenario is when the digit is at the same position 
#then prints a Fermi to the screen and then goes to the next 
#Check in the sequence. 
check7:	
	addi $s6,$s6,1
	jal fermisss
	j step9 
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check8:
	addi $s6,$s6,1
	jal picoss 
	j step9 
	#Second value number check is over
	########################################
	#
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check9:
	addi $s6,$s6,1
	jal picoss
	j step10
#THis functions is called by comparing 2 digits
#This scenario is when the digit is at the same position 
#then prints a Fermi to the screen and then goes to the next 
#Check in the sequence. 
check10:
	addi $s6,$s6,1
	jal fermisss
	j step13
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check11:
	addi $s6,$s6,1
	jal picoss
	j step12 
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check12:
	addi $s6,$s6,1
	jal picoss
	j step13
	#Third value number check is over
	################################################
	#
#THis functions is called by comparing 2 digits
#This scenario is when the digit is at the same position 
#then prints a Fermi to the screen and then goes to the next 
#Check in the sequence. 
check13:
	addi $s6,$s6,1
	jal fermisss
	j step18
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check14:
	addi $s6,$s6,1
	jal picoss
	j step15
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check15:
	addi $s6,$s6,1
	jal picoss
	j step16
#THis functions is called by comparing 2 digits
#This scenario is when the digit is in the number 
#then prints a pico to the screen and then goes to the next 
#Check in the sequence. 
check16:
	addi $s6,$s6,1
	jal picoss 
	j step18
#THe regist S6 is set to 0 or there are no Picos or fermis 
#Print the Bagel to the screen and return home 
check17: 
	jal bagels 
	j step18
	
	#End the fourth number check
#End the Number check sequence
######################################################################

#This function is responsible for printing the word Fermi to the screen 
#Called Fermisss since fermi holds global fermi 
fermisss: 
	addi $sp, $sp, -4	    #add -8 to the stack in order to store our values
        sw   $ra, 0($sp)	    #we store the return value on the stack
	
	la $a0, fermi	#Loads a0 to print the value of Fermi 
	li $v0, 4	#Prints the value of fermi to the screen 
	syscall 	#Prints Fermi to the screen 
	
	lw   $ra, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 4	#Reallocate all memory back onto the stack 
	
	jr $ra #Return Home 
	
#This function when called prints pico to the screen and returns to the spot it was called 
#Called picoss since picos is label for phrase
picoss:	
	addi $sp, $sp, -4	    #add -8 to the stack in order to store our values
        sw   $ra, 0($sp)	    #we store the return value on the stack
	
	la $a0, pico			#loads a0global  with the word Pico which is a global variable
	li $v0, 4			#This then prints Pico to the screen 
	syscall 		#The syscall that we use to print to the screen 
	
	lw   $ra, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 4	#reallocating memory to the stack 
	
	jr $ra	#Return Home 
	
#This function prints the word "Bagel" to the screen. 
#Called bagels since label bagel prints is 
bagels:
	addi $sp, $sp, -4	    #add -8 to the stack in order to store our values
        sw   $ra, 0($sp)	    #we store the return value on the stack
	
	la $a0, bagel 		#We are loading the register to print bagel to the screen
	li $v0, 4		#Part of printing the word bagel to the screen 
	syscall 		#Sys call to invoke screen printing 
	
	lw   $ra, 0($sp)	#need to reallocate memory to the stack 
	addi $sp, $sp, 4	#Reallocating to the stack
	
	jr $ra #Return Home 
