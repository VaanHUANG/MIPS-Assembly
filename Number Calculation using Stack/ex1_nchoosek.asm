.text
.globl NchooseK
NchooseK:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp

    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame

                                # From now on:
                                #     0($fp) --> $ra's saved value
                                #    -4($fp) --> caller's $fp's saved value
                    

    # Your code here
    #int NchooseK(int n, int k) {
    #  if((k==0) || (n==k))
    #    return 1;
    #  else
    #    return NchooseK(n-1, k-1) + NchooseK(n-1, k);
    #}
body_of_NcK:
	
	beq 	$a0, $a1, endofbody				# if n == k, return 1
	beq	$a1, 0, endofbody				# if k == 0, return 1
	
							# else{
	#============================compute NchooseK(n-1, k-1)=====================================================
	addi    $sp, $sp, -8        				# Make room on stack for saving $a0 and $a1
	sw 	$a0, 4($sp)					# store $a0				$a0 = -8($fp)
	sw 	$a1, 0($sp)					# store $a1				$a1 = -12($fp)
	
	addi 	$a0, $a0, -1					# n = n - 1
	addi 	$a1, $a1, -1					# k = k - 1
	
	jal 	NchooseK					# call NchooseK(n - 1, k - 1)
	
	addi 	$sp, $sp, -4
	sw 	$v0, 0($sp)										#$v0 = -16($fp)
	
	lw 	$a0, -8($fp)					# restore $a0
	lw 	$a1, -12($fp)					# restore $a1
	#===========================================================================================================
	
	#==============================compute NchooseK(n-1, k)=====================================================
	addi 	$sp, $sp, -8					# Make room on stack for saving $a0 and $a1
	sw 	$a0, 4($sp)					# store $a0				$a0 = -20($fp)
	sw 	$a1, 0($sp)					# store $a1				$a1 = -24($fp)
	
	addi 	$a0, $a0, -1					# n = n - 1; k = k
	
	jal 	NchooseK					# call NchooseK(n - 1, k); result in $v0
	
	lw 	$a0, -20($fp)					# restore $a0
	lw 	$a1, -24($fp)					# restore $a1
	
	#===========================================================================================================
	lw 	$v1, -16($fp)	
	
	add 	$v0, $v0, $v1					# return value = NchooseK(n - 1, k - 1) + NchooseK(n - 1, k)
	j return_from_NcK
	
endofbody:
    	
    	li 	$v0, 1
    	
return_from_NcK:

    	addi    $sp, $fp, 4	    				# Restore $sp
    	lw      $ra, 0($fp)     				# Restore $ra
    	lw      $fp, -4($fp)    				# Restore $fp
    	jr      $ra             				# Return from procedure


