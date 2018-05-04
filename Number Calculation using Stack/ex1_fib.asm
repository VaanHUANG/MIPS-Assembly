.text
.globl Fibonacci
Fibonacci:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp

    addi    $fp, $sp, 4         # Set $fp to the start of Fibonacci's stack frame

                                # From now on:
                                #     0($fp) --> $ra's saved value
                                #    -4($fp) --> caller's $fp's saved value

    # Your code here 
	
    #int Fibonacci(int b) {
    #  if((b==0) || (b==1))
    #    return b;
    #  else
    #    return Fibonacci(b-1) + Fibonacci(b-2);
    #}
    
#ManualTest:

	#beq $s7, 1, FibBody
   	#li $v0, 5
	#syscall
	#move $a0, $v0
	#li $s7, 1
FibBody:

	
	beq 	$a0, 0, endofFibbody0				# if b == 0, return 0
	beq	$a0, 1, endofFibbody1				# if b == 1, return 1
	
							# else{
	#============================compute Fibonacci(b-1)=====================================================
	addi    $sp, $sp, -4        				# Make room on stack for saving $a0 and $a1
	sw 	$a0, 0($sp)					# store $a0				$a0 = -8($fp)
	
	addi 	$a0, $a0, -1					# b = b - 1
	
	jal 	Fibonacci					# call Fibonacci(b - 1)
	
	addi 	$sp, $sp, -4
	sw 	$v0, 0($sp)					# store result				#$v0 = -12($fp)
	
	lw 	$a0, -8($fp)					# restore $a0
	#===========================================================================================================
	
	#==============================compute Fibonacci(b-2)=====================================================
	addi 	$sp, $sp, -8					# Make room on stack for saving $a0 and $a1
	sw 	$a0, 4($sp)					# store $a0				$a0 = -16($fp)
	
	addi 	$a0, $a0, -2					# b = b - 2
	
	jal 	Fibonacci					# call Fibonacci(b-2); result in $v0
	
	lw 	$a0, -16($fp)					# restore $a0	
	#===========================================================================================================
	lw 	$v1, -12($fp)	
	
	add 	$v0, $v0, $v1					# return value = Fibonacci(b - 1) + Fibonacci(b - 2)
	
	j return_from_Fib
	
endofFibbody0:
    	
    	li 	$v0, 0
	j 	return_from_Fib
endofFibbody1:

	li 	$v0, 1

return_from_Fib:

    	addi    $sp, $fp, 4	    				# Restore $sp
    	lw      $ra, 0($fp)     				# Restore $ra
    	lw      $fp, -4($fp)    				# Restore $fp
    	jr      $ra             				# Return from procedure
end_of_Fibonacci:
