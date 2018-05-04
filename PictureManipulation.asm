.data 0x0

newline: 	.asciiz "\n"
MagicNumPrompt: .asciiz "P2\n"
jPrompt:	.asciiz	"j\n"
pixels: 	.space 4096					# pixels[64][64], each num represented by one byte
MagicNum: 	.space 5

.text 0x3000

	li $v0, 8		
	la $a0, MagicNum
	li $a1, 5
	syscall							# fgets(magic, 5, stdin)
	
	li $v0, 4
	la $a0, MagicNumPrompt
	syscall							# puts("P2");

	li $v0, 5
	syscall							
	move $s0, $v0						# cols in $s0, rows in $s1
	li $v0, 5
	syscall
	move $s1, $v0						# scanf("%d%d", &cols, &rows);
	
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, newline
	syscall							# print("%d\n", cols);
	li $v0, 1
	move $a0, $s1
	syscall
	li $v0, 4
	la $a0, newline
	syscall							# print("%d\n", rows);
	
	li $v0, 5
	syscall
	move $s2, $v0						# scanf("%d", &ppm_max);
	li $v0, 1
	li $a0, 255
	syscall
	li $v0, 4
	la $a0, newline
	syscall							# printf("%d\n", 255);

	li $t0, 0						# for(i = 0;...
	li $t2, 0
ScanLoop:#TESTED

	bge $t0, 64, endScanLoop				# for(...;i<rows;...)
	
	li $t1, 0						# for(j=0;...)
InnerScanLoop:#TESTED

	bge $t1, 64, endInnerScanLoop				# for(...;j<cols;...
	
	li $v0, 5
	syscall
	li $t4, 64
	divu $t2, $t4
	mflo $t5						# $t5 has i
	mfhi $t6						# $t6 has j
	multu $t6, $t4						# j = j * 64
	mflo $t6
	addi $t6, $t6, 63
	subu $t6, $t6, $t5					# address of rotated = j * 64 + 63 - i
	sb $v0, pixels($t6)					# rotated[j][63-i] = pixels[i][j]
	
	addi $t2, $t2, 1
	addi $t1, $t1, 1					# j++
	
	j InnerScanLoop
	
endInnerScanLoop:		
	
	addi $t0, $t0, 1					# i++
	
	j ScanLoop

endScanLoop:
####################
#	li $t0, 0
#testloop:
#	
#	bge $t0, 4096, end
#	
#	li $v0, 1
#	lb $a0, pixels($t0)
#	bge $a0, 0, testoutput
#	addiu $a0, $a0, 256
#testoutput:
#	syscall
#	li $v0, 4
#	la $a0, newline
#	syscall
#	addi $t0, $t0, 1
#	j testloop
###################
	li $t0, 0						# for(i=0;...
	li $t2, 0
BlurLoop:

	bge $t0, 64, endBlurLoop				# for(...;i<rows;...
	
	li $t1, 0						# for(j=0;...
InnerBlurLoop:
	
	bge $t1, 64, endInnerBlurLoop				# for(...;j<cols;...
	
	beq $t0, 0, if						# if (i == 0 ...
	beq $t0, 63, if						# if (i == 63 ...
	beq $t1, 0, if						# if (j == 0 ...
	beq $t1, 63, if						# if (j == 63 ...
							# else
	addi $t4, $t2, -65					# calculate the address of rotated[i-1][j-1]
	lbu $t5, pixels($t4)					# $t5 = rotated[i-1][j-1]
	lbu $t6, pixels($t2)					# $t6 = rotated[i][j]
	add $t6, $t5, $t6					# $t6 = rotated[i-1][j-1] + rotated[i][j]
	
	addi $t4, $t4, 1
	lbu $t5, pixels($t4)					# $t5 = rotated[i-1][j]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j]
	
	addi $t4, $t4, 1
	lbu $t5, pixels($t4)					# $t5 = rotated[i-1][j+1]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j] + rotated[i-1][j+1]
	
	addi $t4, $t2, -1
	lbu $t5, pixels($t4)					# $t5 = rotated[i][j-1]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j] + rotated[i-1][j+1] + rotated[i][j-1]
	
	addi $t4, $t2, 1
	lbu $t5, pixels($t4)					# $t5 = rotated[i][j+1]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j] + rotated[i-1][j+1] + rotated[i][j-1] + rotated[i][j+1]
	
	addi $t4, $t2, 63
	lbu $t5, pixels($t4)					# $t5 = rotated[i+1][j-1]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j] + rotated[i-1][j+1] + rotated[i][j-1] + rotated[i][j+1] + rotated[i+1][j-1]
	
	addi $t4, $t2, 64
	lbu $t5, pixels($t4)					# $t5 = rotated[i+1][j]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j] + rotated[i-1][j+1] + rotated[i][j-1] + rotated[i][j+1] + rotated[i+1][j-1] + rotated[i+1][j]
	
	addi $t4, $t2, 65
	lbu $t5, pixels($t4)					# $t5 = rotated[i+1][j+1]
	add $t6, $t6, $t5					# rotated[i-1][j-1] + rotated[i-1][j] + rotated[i][j] + rotated[i-1][j+1] + rotated[i][j-1]
	
	div $t6, $t6, 9
	
	li $v0, 1
	move $a0, $t6
	
	bge $a0, 0, output1
	
	#addi $a0, $a0, 256					# force MARS to treat negatives unsigned
	
output1: 
	
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $t2, $t2, 1
	addi $t1, $t1, 1					# j++
	
	j InnerBlurLoop
	
if:	
	lbu $t3, pixels($t2)
	li $v0, 1
	move $a0, $t3
	
	bge $a0, 0, output2					
	
	#addi $a0, $a0, 256					# force MARS to treat negatives unsigned
	
output2:
	syscall
	li $v0, 4
	la $a0, newline
	syscall							# printf("%d\n", rotated[i][j]);	
	
	addi $t2, $t2, 1
	addi $t1, $t1, 1					# j++
	
	j InnerBlurLoop	

endInnerBlurLoop:

	addi $t0, $t0, 1
	
	j BlurLoop

endBlurLoop:

end:

	li $v0, 10
	syscall
