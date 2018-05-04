# MIPS-Assembly

Picture manipulation program aims to rotate and blur a PGM file. The main harship encountered would be the limitation on memory
allocation by MARS the IDE. I have to allocate a single byte for each integer read, which irritated me when it comes to 
debugging due to the automatic sign extension by MIPS.

Number Calculation is a program broken down into five pieces for the ease of debugging. The most difficult part of writing this
program is to use a stack to keep track of the calling history, since functions Fibonacci() and NchooseK() will call themselves
recursively, such that we need to make sure $ra is returned to the correct calling address. 
