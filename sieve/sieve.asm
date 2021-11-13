### Data Declaration Section ###

.data

primes:		.space  1001            # reserves a block of 1000 bytes in application memory
new_line:	.asciiz "\n"
err_msg:	.asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"

### Executable Code Section ###

.text

main:
# Get input
    	li      $v0,5                   # set system call code to "read integer"
    	syscall                         # read integer from standard input stream to $v0

# Validate input
    	li $t0,1001                	# $t0 = 1001
    	slt $t1,$v0,$t0		       	# $t1 = input < 1001
    	beq $t1,$zero,invalid_input 	# if !(input < 1001), jump to invalid_input
    	nop
    	li  $t0,1                   	# $t0 = 1
    	slt $t1,$t0,$v0		     	# $t1 = 1 < input
    	beq $t1,$zero,invalid_input 	# if !(1 < input), jump to invalid_input
	nop
    
# Initialize primes array
    	la $s0,primes			# $s0 = address of the first element in the array
    	li $t0,0			# Iterator
    	li $t1,1000			# Limit
    	li $t2,1			# 1
    	move $s1,$v0

# Initizlizes array to be all ones (All true)
init_loop:				
	sb $t2,($s0)              	# primes[i] = 1
	addi $s0,$s0,1            	# increment pointer
	addi $t0,$t0,1             	# increment counter
	bne $t0,$t1,init_loop		# loop if counter != 1000

# Initialize values for loop
li $t0,2 				# Initialize counter
la $s0, primes				# Reload primes to point $s0 at the first element.
move $s2, $s0				# Save pointer to first element
addi $s0,$s0,2				# Set the pointer to the third element (which is 2)

##
# Loop registry legend
# $a0 = argument
# $v0 = code for syscall
# *
# $s0 = primes pointer
# $s1 = Input
# *
# $t0 = Iterator 
# $t1 = Iterator squared
# $t2 = Temp storage for promes byte and later temp pointer to primes
##
outer_loop:
	lb $t2, ($s0) #Check if current number is prime
	beq $t2, $zero, skip_loop #If it isn't skip to end of loop
	
	#Print the prime
	move $a0,$t0
	li $v0,1
	syscall
	la $a0, new_line
	li $v0,4
	syscall
	
	#Set up variables for inner loop.
	mul $t1, $t0, $t0 #Current prime squared

	move $t2, $s2 # $t2 is a temporary pointer
	add $t2, $t2, $t1 # Set $t2 ro start at prime squared
inner_loop:
	bgt $t1, $s1, skip_loop # If our inner counter is greater then input break loop
	sb $zero, ($t2) # Not a prime so set it to zero
	add $t1, $t1, $t0 # Increment counter by prime
	add $t2, $t2, $t0 # increment pointer by prime
	j inner_loop 
skip_loop:
	addi $t0, $t0, 1 # Increment counter
	addi $s0, $s0, 1 # Increment pointer
	bgt $t0, $s1, exit_program #If our counter exceeds n exit program
	j outer_loop # Else loop

invalid_input:
    # print error message
    li      $v0, 4                  # set system call code "print string"
    la      $a0, err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message to standard output stream

exit_program:
    # exit program
    li $v0, 10                      # set system call code to "terminate program"
    syscall                         # exit program
