# PURPOSE: This program uses a function to find the maximum#	      number from 3 sets of data items.
#
# VARIABLES: The registers have the following uses for the #	        function:
#
# %edi - Holds the index of the data item being examined
# %eax - Largest data item found in function
# %ebx - Current data item
# %ecx - List location
# %edx - lagest data item found in all
#
# The following memory locaitons are used:
#
# data_items - contains the item data.
# more_data_items - contians more item data.
# even_more_data_items - contains even more item data.
#			 terminates on 0.

.section .data

data_items:	# some numbers
.long 3,76,43,26,87,97,32,35,100,0

more_data_items: # more numbers
.long 7,66,139,57,175,193,76,89,17,0

even_more_data_items: # even more numbers
.long 89,99,200,34,98,90,78,14,69,0

.section .text

.globl _start
.globl maximize

_start:
pushl $data_items
call maximize

addl $4, %esp # reset the stack params
movl %eax, %edx # move the function return into %edx for safe keeping.

pushl $more_data_items # push the second data set to stack
call maximize # find max

addl $4, %esp # reset stack
pushl %eax # push new max to the stack
pushl %edx # push old max to the stack
call compare # compare them

addl $8, %esp # reset stack
movl %eax, %edx # move the result of the function into %ebx

pushl $even_more_data_items
call maximize

addl $4, %esp
pushl %eax
pushl %edx
call compare

addl $8, %esp
movl %eax, %ebx # this time move the result into %ebx for the program end.

movl $1, %eax

int $0x80

# maximize function definition
.type maximize,@function
maximize:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl $0, %edi # move 0 into index
	movl (%ecx,%edi,4), %ebx # move first data item into %ebx
	movl %ebx, %eax # first item is biggest so move into %eax

max_loop:
cmpl $0, %ebx # check for list end
je max_exit
incl %edi # load next value
movl (%ecx,%edi,4), %ebx
cmpl %eax, %ebx
jle max_loop # if new value is less than %eax, loop again

movl %ebx, %eax
jmp max_loop # loop it again

max_exit:
movl %ebp, %esp # equalize base & stack pointers
popl %ebp # pop off the base pointer

ret

# function definition for compare
# compares the old maximum found previously with the
# most recently found maximum and decides which is bigger.
#
.type compare,@function
compare:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	movl 12(%ebp), %ebx
	
cmpl %ebx, %eax # compare the old max with the new max
jge compare_exit # exit if greater
movl %ebx, %eax # otherwise move it into %eax

compare_exit:
movl %ebp, %esp
popl %ebp

ret
