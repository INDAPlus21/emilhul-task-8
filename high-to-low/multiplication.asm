.global multiply, faculty

##
# Main routine for testing the global routines
# $s0 is used for results
# $s1 is a for multiply and n for faculty
# $s2 is b for multiply and overwritten in faculty
# On line 15 after jal: 
#	multiply runs multiplication
#	faculty gets teh factorial
##
main:
    	# Loads test values
    	li $s1,10
    	li $s2,5 #b
    
    	jal faculty # Jump to specified sub-routine, returns vesults in $s2
    	nop
    
    
    	move $a0,$s0 # Copy the resuls of the multiply function as an argument
    	li $v0,1 # set system call code to "print integer"
    	syscall
            
    	li $v0, 10 # set system call code to "terminate program"
    	syscall    # terminate program

## 
# Multiply giveb factors using addition.
# Takes the balues from $s1 and $s2
# Return the product of the multiplication of the factors a and b in $s0
##
multiply:
    	li $s0,0 #Initialize sum $s0
    	li $t0,0 #Initialize itterator as 0
    	
    	#Starts multiplication loop
    	mul_loop:
        	add $s0,$s0,$s2 # Adds $s2 (B) to $s0 (sum)
        	addi $t0,$t0,1 # Increment the iterator
        	bne $t0,$s1,mul_loop # IF iterator = 0 continue program, otherwise loop 
   
    	jr $ra # Return to parent routine
    	nop

##
# Calculate faculty using addition.
# Takes the value of $s1 
# Return the factorial of n in s$0
##
faculty:
	move $s7,$ra #Save return addres in $s7
    	li $s2,1 #Initialize fac as 1
    	# Loop that runs multply several times.
    	fac_loop:
    		jal multiply #Jump to sub-routine multiply
    		nop
    		
    		# Multiply changes the value of $s0.
    		move $s2, $s0 # Which is copied into $s2
		addi $s1,$s1,-1 # Decrement iterator. Also modifies the value for the next uteratuon of multiply
	        bne $s1, 1,fac_loop # If iterator is = 1 continue prgoram, otherwise loop
     
     	move $ra, $s7 # Get the saved return addres.
     	jr $ra # Return to parent routine.
     	nop
