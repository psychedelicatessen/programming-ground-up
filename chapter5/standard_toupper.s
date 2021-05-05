# Purpose:
#	Take user input from STDIN and
#	push it to STDOUT after capitalizing
#	everything.
#
# Processing:	1) Read from STDIN
# 		2) Convert it into capitals
#		3) Write to STDOUT

.section .data

### CONSTANTS ###

# syscall numbers

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# file descriptors

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call interrupt
.equ LINUX_SYSCALL, 0x80

# EOF return value
.equ END_OF_FILE, 0

### END CONSTANTS ###


.section .bss
# Define the buffer & its size
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# Stack positions
.equ ST_ARGC, 0
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8
.equ ST_ARGV_2, 12

.globl _start
_start:
# initialize stack
movl %esp, %ebp

# begin reading data from STDIN
read_loop_begin:
movl $SYS_READ, %eax
movl $STDIN, %ebx
movl $BUFFER_DATA, %ecx
movl $BUFFER_SIZE, %edx
int $LINUX_SYSCALL

# set up stack for function call
pushl $BUFFER_DATA
pushl %eax
# call converter function
call convert_to_upper
# clean up
popl %eax
addl $4, %esp

# write data from STDIN to STDOUT
movl %eax, %edx
movl $SYS_WRITE, %eax
movl $STDOUT, %ebx
movl $BUFFER_DATA, %ecx
int $LINUX_SYSCALL

# loop it
jmp read_loop_begin

# conditions are never met for this. The user must interrupt manually
end_loop:

movl $SYS_EXIT, %ebx
int $LINUX_SYSCALL

# Purpose: Convert STDIN data into capitals.
#
# Input: Data buffer from STDIN and its length.
#
# Output: Overwrite each section in the buffer w/its capital equivolent.
#
# Variables:
#	%eax - beginning of buffer
#	%ebx - length of buffer
#	%edi - buffer offset
#	%cl - current buffer byte
#

### CONSTANTS ###
.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12
### END CONSTANTS ###

# initialize stack
convert_to_upper:
pushl %ebp
movl %esp, %ebp

# set up indexed addressing params
movl ST_BUFFER(%ebp), %eax
movl ST_BUFFER_LEN(%ebp), %ebx
movl $0, %edi

# check for end of buffer
cmpl $0, %ebx
je end_convert_loop

# do the conversion work
convert_loop:
movb (%eax,%edi,1), %cl

cmpb $LOWERCASE_A, %cl
jl next_byte
cmpb $LOWERCASE_Z, %cl
jg next_byte

addb $UPPER_CONVERSION, %cl
movb %cl, (%eax,%edi,1)
next_byte:
incl %edi
cmpl %edi, %ebx

jne convert_loop

end_convert_loop:
movl %ebp, %esp
popl %ebp
ret
