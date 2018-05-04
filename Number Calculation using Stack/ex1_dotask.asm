.text
.globl do_task
do_task:					# void do_task(int a, int b) {

  addi	$sp, $sp, -8        			# Set up stack
  sw	$ra, 4($sp)											# $ra = 0($fp)
  sw	$fp, 0($sp)											# $fp = -4($fp)
  addi  $fp, $sp, 4             		# Set $fp to the start of do_task's stack frame

  addi $sp, $sp, -8				# Make room for saving $s0, $s1
  sw $s0, 4($sp)				# store $s0						# $s0 = -8($fp)
  sw $s1, 0($sp)				# store $s1						# $s1 = -12($fp)		
  # Your code here
  move $s0, $a0
  move $s1, $a1					# int n, k, result; b in $s1
  add $a0, $s0, $s1				# n = a+b;
  						# k = a;
					# pass $a0, $a1 to NchooseK
  jal NchooseK				# result = NchooseK(n, k); result in $v0 
  move $a0, $v0
  jal print_it				# print_it(result);

  move $a0, $s1				# restore a0 to be b, and pass it to Fibonacci(b)
  jal Fibonacci				# result = Fibonacci(b);
  
  move $a0, $v0
  jal print_it				# print_it(result);
	
  lw $s0, -8($fp)
  lw $s1, -12($fp)
  
exit_from_do_task: 			# }
  addi	$sp, $fp, 4 		# restore $ra, $fp and $sp
  lw	$ra, 0($fp)
  lw	$fp, -4($fp)
  jr	$ra             	# return from procedure
end_of_do_task:
