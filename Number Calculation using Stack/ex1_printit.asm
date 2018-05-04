.text
.globl print_it
print_it: 			# void print_it(int i) {

  li 	$v0, 1 			# printf("%d\n", i);
  syscall
  li	$v0, 4
  la	$a0, newline
  syscall

				# clobber all temporaries!
  li 	$a0, 1
  li 	$a1, 2
  li 	$a2, 3
  li 	$a3, 4
  li 	$v0, 5
  li 	$v1, 6
  li 	$t0, 0
  li 	$t1, 1
  li 	$t2, 2
  li 	$t3, 3
  li 	$t4, 4
  li 	$t5, 5
  li 	$t6, 6
  li 	$t7, 7
  li 	$t8, 8
  li 	$t9, 9

exit_from_print_it:
  jr	$ra 			# }
end_of_print_it:


