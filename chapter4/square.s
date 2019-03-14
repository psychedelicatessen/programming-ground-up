#PURPOSE: Program which receives an argument(5) and squares it
#	  presenting the result(25) to the OS.

# Everything is stored in registers. No data.
.section .data

.section .text

.globl _start
_start:
pushl $5	# push argument
call square	# call the function
addl $4, %esp	# reset the stack

movl $1, %eax	# set up %eax for interrupt
int $0x80	# call system interrupt with $0x80

#PURPOSE: This function takes the argument and squares it.

#INPUT: First argument - the square
#	Second argument - the base


#OUTPUT: Give the squared result of the base.

#VARIABLES:
# %eax - holds the argument
.type square, @function
square:
pushl %ebp	# save the old base pointer
movl %esp, %ebp	# make the stack pointer the base pointer

movl 8(%ebp), %ebx	# move the argument into %ebx
imull 8(%ebp), %ebx	# multiply the argument by itself

end_square:
movl %ebp, %esp	# restore the stack pointer
popl %ebp	# restore hte base pointer
ret		# return the function
