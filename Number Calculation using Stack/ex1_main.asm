.data 0x0
msg_read_sreg:	.asciiz "Enter initial values for registers $s0-$s7\n"
msg_enter_ab:	.asciiz "Enter a and b:\n"
msg_print_sreg:	.asciiz "Here are the final values of registers $s0-$s7\n"
.globl newline
newline:	.asciiz "\n"
lastline:	.asciiz ""

	
.text 0x3000
.globl main

	
main:

  ori     $sp, $0, 0x2ffc       # Initialize stack pointer to the top word below .text
                                # The first value on stack will actually go at 0x2ff8
                                #   because $sp is decremented first.
  addi    $fp, $sp, -4          # Set $fp to the start of main's stack frame


  				# printf("Enter initial values for registers $s0-$s7\n");
  li	$v0, 4
  la	$a0, msg_read_sreg
  syscall

  				# read values for registers $s0-$s7 here
  li	$v0, 5
  syscall
  move	$s0, $v0
  li	$v0, 5
  syscall
  move	$s1, $v0
  li	$v0, 5
  syscall
  move	$s2, $v0
  li	$v0, 5
  syscall
  move	$s3, $v0
  li	$v0, 5
  syscall
  move	$s4, $v0
  li	$v0, 5
  syscall
  move	$s5, $v0
  li	$v0, 5
  syscall
  move	$s6, $v0
  li	$v0, 5
  syscall
  move	$s7, $v0  

loop: 				# while (1) {

  li	$v0, 4 			# printf("Enter a and b:\n");
  la	$a0, msg_enter_ab
  syscall
  
  li	$v0, 5  		# scanf("%d", &a);
  syscall
  move	$a0, $v0
  
  beq	$a0, $0, endloop	# if(a==0) break;

  li	$v0, 5  		# scanf("%d", &b);
  syscall
  move	$a1, $v0
  
  jal	do_task			# do_task(a, b);

  j	loop			#   }

endloop:
  				# printf("Here are the final values of registers $s0-$s7\n");
  li	$v0, 4
  la	$a0, msg_print_sreg
  syscall
  				# print final values of registers $s0-$s7 here
  				# they should be the same as the values read in at the top
  li	$v0, 1
  move	$a0, $s0
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s1
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s2
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s3
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s4
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s5
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s6
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall
  li	$v0, 1
  move	$a0, $s7
  syscall
  li	$v0, 4
  la	$a0, lastline
  syscall

exit_from_main:
    ori     $v0, $0, 10     	# System call code 10 for exit
    syscall                 	# Exit the program
end_of_main:
